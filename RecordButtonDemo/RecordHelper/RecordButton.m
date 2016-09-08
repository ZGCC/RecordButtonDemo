//
//  RecordButton.m
//  RecordDemo
//
//  Created by HFY on 16/7/23.
//  Copyright © 2016年 snewfly. All rights reserved.
//

#import "RecordButton.h"
#import "EncodeAudio.h"


@interface RecordButton (){
    
    int _maxTime;
    int _minTime;
    
    DataType _type;
    
    AVAudioRecorder *_recorder;
    
    double _lowPassResults;
    float _recordTime;
    NSTimer *_timer;
    
}
@end

@implementation RecordButton

- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<RecordButtonDelegate>)delegate MaxTime:(int)maxTime MinTime:(int)minTime Type:(DataType)type{
    
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
        _maxTime = maxTime;
        _minTime = minTime;
        _type = type;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [self addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self addTarget:self action:@selector(remindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(remindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    
}

- (void)startRecord{
    NSLog(@"---%s", __FUNCTION__);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getWAVSound]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self getWAVSound] error:nil];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getAMRSound]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self getAMRSound] error:nil];
    }
    
    [RecordHUD show];
    [RecordHUD setTitle:@"正在录音"];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    NSDictionary *settings = @{
                               AVFormatIDKey : @(kAudioFormatLinearPCM),
                               AVSampleRateKey : @8000.00f,
                               AVLinearPCMBitDepthKey : @16,
                               AVLinearPCMIsNonInterleaved : @NO,
                               AVLinearPCMIsFloatKey : @NO,
                               AVLinearPCMIsBigEndianKey : @NO
                               };
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[self getWAVSound]] settings:settings error:nil];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
    
    _recordTime = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countRecordTime) userInfo:nil repeats:YES];
    
}

- (void)countRecordTime{
    
    if (_recordTime >= _maxTime) {
        [self stopRecord];
    }
    
    _recordTime += 0.1;
    [_recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    _lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * _lowPassResults;
    
    [RecordHUD setImage:[NSString stringWithFormat:@"mic_%.0f.png", (_lowPassResults * 10 > 5) ? 5 : _lowPassResults * 10]];
    [RecordHUD setTimeTitle:[NSString stringWithFormat:@"录音:%.0f s", _recordTime]];
    
}

- (void)stopRecord{
    NSLog(@"---%s", __FUNCTION__);
    
    if (_recordTime < 1) {
        NSLog(@"---less than min time");
        [_recorder stop];
        _recorder = nil;
        
        [_timer invalidate];
        _timer = nil;
        
        NSLog(@"录音时间少于1秒");
        [RecordHUD setTitle:@"录音时间少于1秒" afterDelay:3.0f];
        return;
    }
    
    if (_recorder.isRecording) {
        NSLog(@"---more than min time");
        
        [RecordHUD dismiss];
        
        [_recorder stop];
        _recorder = nil;
        
        [_timer invalidate];
        _timer = nil;
        
        NSData *wavData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[self getWAVSound]]];
        
//        NSData *amrData = [[RCAMRDataConverter sharedAMRDataConverter] encodeWAVEToAMR:wavData channel:1 nBitsPerSample:16];
        
        NSData *amrData = [EncodeAudio convertWavToAmr:wavData];
        [amrData writeToFile:[self getAMRSound] atomically:YES];
        
        if ([_delegate respondsToSelector:@selector(endRecordWithVoiceData:DataPath:)]) {
            if (_type == DataTypeWav) {
                [_delegate endRecordWithVoiceData:wavData DataPath:[self getWAVSound]];
            } else {
                [_delegate endRecordWithVoiceData:amrData DataPath:[self getAMRSound]];
            }
        }
    }
    
}

- (void)cancelRecord{
    NSLog(@"---%s", __FUNCTION__);
    
    [RecordHUD dismiss];
    [RecordHUD setTitle:@"已取消录音"];
    
    if (_recorder.isRecording) {
        [_recorder stop];
        _recorder = nil;
    }
    
    [_timer invalidate];
    _timer = nil;
    
}

- (void)remindDragExit:(UIButton *)sender{
    NSLog(@"---%s", __FUNCTION__);
    [RecordHUD setTitle:@"松手取消录音"];
}

- (void)remindDragEnter:(UIButton *)sender{
    NSLog(@"---%s", __FUNCTION__);
    [RecordHUD setTitle:@"正在录音"];
}

- (NSString *)getWAVSound{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self getDoc] stringByAppendingPathComponent:@"WavSound"]]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[[self getDoc] stringByAppendingPathComponent:@"WavSound"] withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSString *wavPath = [NSString stringWithFormat:@"%@/%@/%@", [self getDoc], @"WavSound", @"sound.wav"];
    
    return wavPath;
}

- (NSString *)getAMRSound{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self getDoc] stringByAppendingPathComponent:@"AmrSound"]]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[[self getDoc] stringByAppendingPathComponent:@"AmrSound"] withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSString *amrPath = [NSString stringWithFormat:@"%@/%@/%@", [self getDoc], @"AmrSound", @"sound.amr"];
    
    return amrPath;
    
}

- (NSString *)getDoc{
    
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [doc objectAtIndex:0];
    
    return docPath;
}

@end
