//
//  ELEncodeAudio.h
//  ELEncodeAudio
//
//  Created by YouLin on 15/7/29.
//  Copyright (c) 2015年 YouLin. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface EncodeAudio : NSObject

/**
 *  amr转wav文件
 *
 *  @param amrData amr数据
 *
 *  @return wav数据
 */
+ (NSData *)convertAmrToWavFile:(NSData *)amrData;

/**
 *  wav转amr文件
 *
 *  @param wavData wav数据
 *
 *  @return amr数据
 */
+ (NSData *)convertWavToAmrFile:(NSData *)wavData;

/**
 *  amr转wav
 *
 *  @param amrData amr数据
 *
 *  @return wav数据
 */
+ (NSData *)convertAmrToWav:(NSData *)amrData;

/**
 *  wav转amr
 *
 *  @param wavData wav数据
 *
 *  @return amr数据
 */
+ (NSData *)convertWavToAmr:(NSData *)wavData;

@end
