//
//  WLVoiceConverter.m
//  RecordingTranscoding
//
//  Created by 白冰 on 15/1/3.
//  Copyright © 2015年 lezhixing. All rights reserved.
//

#import "WLVoiceConverter.h"
#import "amrFileCodec.h"


@implementation WLVoiceConverter

+ (dispatch_queue_t)sharedQueue{
    static dispatch_once_t onceToken;
    static dispatch_queue_t queue;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("top.fallrainy.voiceConverter", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

+ (void)convertAmr:(NSString *)amrFilePath toWav:(NSString *)wavFilePath successHandler:(void (^) (NSString *wavFilePath))successHandler errorHandler:(dispatch_block_t)errorHandler {
    dispatch_async([self sharedQueue], ^{
        NSInteger frameCount = [self amrToWav:amrFilePath wavSavePath:wavFilePath];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (frameCount == 0) {
                if (errorHandler) {
                    errorHandler();
                }
            } else {
                if (successHandler) {
                    successHandler(wavFilePath);
                }
            }
        });
    });
}

+ (void)convertWav:(NSString *)wavFilePath toAmr:(NSString *)amrFilePath successHandler:(void (^) (NSString *amrFilePath))successHandler errorHandler:(dispatch_block_t)errorHandler {
    dispatch_async([self sharedQueue], ^{
        BOOL frameCount = [self wavToAmr:wavFilePath amrSavePath:amrFilePath];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (frameCount == 0) {
                if (errorHandler) {
                    errorHandler();
                }
            } else {
                if (successHandler) {
                    successHandler(amrFilePath);
                }
            }
        });
    });
}

///返回转换完成的帧数
+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath {
    return DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding]);
}

///返回转换完成的帧数
+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath {
    return EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16);
}

+ (int)changeStatus
{
    return changeState();
}

+(void)mixMusic:(NSString*)wavPath1 andPath:(NSString*)wavePath2 toPath:(NSString *)outpath
{
    mix([wavPath1 cStringUsingEncoding:NSASCIIStringEncoding], [wavePath2 cStringUsingEncoding:NSASCIIStringEncoding],[outpath cStringUsingEncoding:NSASCIIStringEncoding]);
}

void mix(const char* FileName1, const char* Filename2,const char* output)
{
    unsigned int temp;
    
    FILE *fin1,*fin2,*fout;
    fin1 = fopen( FileName1, "rb" );
    fin2 = fopen( Filename2, "rb" );
    fout = fopen( output, "wb" );
    fseek(fin1,0,SEEK_SET);
    fseek(fin2,0,SEEK_SET);

    int length=0;
    WriteWAVEFileHeader(fout,length);
    SkipToPCMAudioData(fin2);//到数据区
    fread(&temp, 4, 1, fin2);
    length ++;
    while(!feof(fin2))//复制第一个文件
    {
        fwrite(&temp, 4, 1, fout);
        fread(&temp, 4, 1, fin2);
        length ++;
    }
    fclose(fin2);
    
    SkipToPCMAudioData(fin1);//到数据区
    fread(&temp,4,1,fin1);//读取
    length++;
    while(!feof(fin1))//复制第二个文件
    {
        fwrite(&temp,4,1,fout);
        fread(&temp,4,1,fin1);
        length++;
    }
    fclose(fin1);
    fclose(fout);
    fout = fopen(output, "r+");
    WriteWAVEFileHeader(fout,length);
    fclose(fout);
}
+(void)mixAmr:(NSString *)amrPath1 andPath:(NSString *)amrPath2
{
    WriteTwoAMRFileToOneAMRFile([amrPath1 cStringUsingEncoding:NSASCIIStringEncoding], [amrPath2 cStringUsingEncoding:NSASCIIStringEncoding]);
}
void WriteTwoAMRFileToOneAMRFile(const char* AMROneFileNameA,const char* AMROneFileNameB) {
    FILE *fpamrA;
    FILE *fpamrB;
    char magic[8];
    unsigned char amrFrame[MAX_AMR_FRAME_SIZE];
	fpamrA = fopen(AMROneFileNameA, "ab+");
    if (fpamrA == NULL) {
        return;
    }
	fpamrB = fopen(AMROneFileNameB, "rb");
    if (fpamrB == NULL) {
        return;
    }
    // 检查amr文件头
	fread(magic, sizeof(char), strlen(AMR_MAGIC_NUMBER), fpamrB);
	if (strncmp(magic, AMR_MAGIC_NUMBER, strlen(AMR_MAGIC_NUMBER)))
	{
		fclose(fpamrB);
        return;
	}
    fseek(fpamrB, 6L, 0);
    while (1) {
        long i = (long)fread(amrFrame, sizeof(char), strlen(AMR_MAGIC_NUMBER), fpamrB);
        if (i) {
            fwrite(amrFrame, sizeof (unsigned char), strlen(AMR_MAGIC_NUMBER), fpamrA);
        }
        else break;
    }
    fclose(fpamrA);
    fclose(fpamrB);
}
@end
