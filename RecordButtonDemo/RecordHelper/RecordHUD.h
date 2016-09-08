//
//  RecordHUD.h
//  RecordDemo
//
//  Created by HFY on 16/7/23.
//  Copyright © 2016年 snewfly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordHUD : UIView{
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *timeLabel;
}

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

+ (void)show;
+ (void)dismiss;
+ (void)setTitle:(NSString*)title;
+ (void)setTimeTitle:(NSString*)time;
+ (void)setImage:(NSString*)imgName;
+ (void)setTitle:(NSString*)title afterDelay:(NSTimeInterval)delay;

@end
