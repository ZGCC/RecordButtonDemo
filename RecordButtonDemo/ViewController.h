//
//  ViewController.h
//  RecordButtonDemo
//
//  Created by HFY on 16/9/8.
//  Copyright © 2016年 zgcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordButton.h"


@interface ViewController : UIViewController<RecordButtonDelegate>

@property (nonatomic, strong) RecordButton *recordBtn;

@end

