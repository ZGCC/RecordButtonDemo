//
//  RecordButton.h
//  RecordDemo
//
//  Created by HFY on 16/7/23.
//  Copyright © 2016年 snewfly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioSession.h>
#import "RecordHUD.h"

typedef enum {
    DataTypeWav,
    DataTypeAmr,
}DataType;

@protocol RecordButtonDelegate <NSObject>

- (void)endRecordWithVoiceData:(NSData *)voiceData DataPath:(NSString *)dataPath;

@end

@interface RecordButton : UIButton<AVAudioRecorderDelegate>

@property (weak, nonatomic) id<RecordButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame Delegate:(id<RecordButtonDelegate>)delegate MaxTime:(int)maxTime MinTime:(int)minTime Type:(DataType)type;

- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
