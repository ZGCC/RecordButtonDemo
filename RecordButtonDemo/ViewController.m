//
//  ViewController.m
//  RecordButtonDemo
//
//  Created by HFY on 16/9/8.
//  Copyright © 2016年 zgcc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
}

- (void)setupView{
    
    _recordBtn = [[RecordButton alloc] initWithFrame:CGRectMake(0, 0, 150, 60)
                                            Delegate:self
                                             MaxTime:5
                                             MinTime:1
                                                Type:DataTypeWav];
    _recordBtn.center = self.view.center;
    [_recordBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _recordBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_recordBtn];
    
}

- (void)endRecordWithVoiceData:(NSData *)voiceData DataPath:(NSString *)dataPath{
    NSLog(@"---%s  DataLength[%lu]  DataPath:%@", __FUNCTION__, (unsigned long)voiceData.length, dataPath);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
