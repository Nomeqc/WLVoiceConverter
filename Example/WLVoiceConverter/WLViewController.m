//
//  WLViewController.m
//  WLVoiceConverter
//
//  Created by nomeqc@gmail.com on 06/07/2018.
//  Copyright (c) 2018 nomeqc@gmail.com. All rights reserved.
//

#import "WLViewController.h"
#import "WLVoiceConverter.h"

@interface WLViewController ()

@end

@implementation WLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"bubbles" ofType:@"wav"];
    NSLog(@"soure wav file path:%@",wavPath);
    
    [self test];

}

- (void)test {
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"bubbles" ofType:@"wav"];
    
    NSString *amrPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bubbles.amr"];
    
    [WLVoiceConverter convertWav:wavPath toAmr:amrPath successHandler:^(NSString *amrFilePath) {
        NSLog(@"转换完成，amr file path:%@",amrFilePath);
        NSString *wavTempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"bubbles.wav"];
        [WLVoiceConverter convertAmr:amrFilePath toWav:wavTempPath successHandler:^(NSString *wavFilePath) {
            NSLog(@"转换成功 wav file path:%@",wavFilePath);
        } errorHandler:^{
            NSLog(@"amr to wav 失败");
        }];
    } errorHandler:^{
        NSLog(@"转换失败");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
