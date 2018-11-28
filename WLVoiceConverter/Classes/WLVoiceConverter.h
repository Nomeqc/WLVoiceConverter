//
//  WLVoiceConverter.h
//  RecordingTranscoding
//
//  Created by 白冰 on 15/1/3.
//  Copyright © 2015年 lezhixing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLVoiceConverter : NSObject

///AMR 转 WAV
+ (void)convertAmr:(NSString *)amrFilePath toWav:(NSString *)wavFilePath successHandler:(void (^) (NSString *wavFilePath))successHandler errorHandler:(dispatch_block_t)errorHandler;

///WAV 转 AMR
+ (void)convertWav:(NSString *)wavFilePath toAmr:(NSString *)amrFilePath successHandler:(void (^) (NSString *amrFilePath))successHandler errorHandler:(dispatch_block_t)errorHandler;

+ (void)mixMusic:(NSString*)wavPath1 andPath:(NSString*)wavePath2 toPath:(NSString *)outpath;

+ (void)mixAmr:(NSString *)amrPath1 andPath:(NSString *)amrPath2;


@end
