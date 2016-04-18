//
//  VoiceListenRecognizer.m
//  app
//
//  Created by Remi Robert on 16/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

#import "VoiceListenRecognizer.h"
#import "SinVoiceRecognizer.h"
#import "MyPcmPlayerImp.h"
#import "MyPcmRecorderImp.h"
#import "MyPcmPlayerImp.h"
#import "MyPcmRecorderImp.h"
#include "ESPcmRecorder.h"

static const char* const CODE_BOOK = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@_";
#define TOKEN_COUNT 24

@interface VoiceListenRecognizer ()
@property (nonnull, nonatomic, assign) SinVoiceRecognizer *mSinVoiceRecorder;
@property (nonnull, nonatomic, assign) FILE *mFile;
@property (nonatomic, copy) void (^listenCompletion)(NSString *string);
@end

ESVoid onSinVoiceRecognizerStart(ESVoid* cbParam) {
    VoiceListenRecognizer *vc = (__bridge VoiceListenRecognizer *)cbParam;
    vc->mResultCount = 0;
}

ESVoid onSinVoiceRecognizerToken(ESVoid* cbParam, ESInt32 index) {
    VoiceListenRecognizer *vc = (__bridge VoiceListenRecognizer *)cbParam;
    vc->mResults[vc->mResultCount++] = index;
}

ESVoid onSinVoiceRecognizerEnd(ESVoid* cbParam, ESInt32 result) {
    VoiceListenRecognizer *vc = (__bridge VoiceListenRecognizer *)cbParam;
    [vc onRecogToken:vc];
}

SinVoiceRecognizerCallback gSinVoiceRecognizerCallback = {onSinVoiceRecognizerStart, onSinVoiceRecognizerToken, onSinVoiceRecognizerEnd};

@implementation VoiceListenRecognizer {
    ESPcmRecorder       mPcmRecorder;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        mPcmRecorder.create = MyPcmRecorderImp_create;
        mPcmRecorder.start = MyPcmRecorderImp_start;
        mPcmRecorder.stop = MyPcmRecorderImp_stop;
        mPcmRecorder.setParam = MyPcmRecorderImp_setParam;
        mPcmRecorder.destroy = MyPcmRecorderImp_destroy;
        self.mSinVoiceRecorder = SinVoiceRecognizer_create2("com.sinvoice.demo",
                                                            "SinVoiceDemo",
                                                            &gSinVoiceRecognizerCallback,
                                                            (__bridge ESVoid *)(self),
                                                            &mPcmRecorder);
    }
    return self;
}

- (void)onRecogToken:(nonnull VoiceListenRecognizer *)data {
    NSString *recognizedString;
    
    if (mMaxEncoderIndex < 255) {
        NSMutableString* str = [[NSMutableString alloc]init];
        for (int i = 0; i < mResultCount; ++i) {
            [str appendFormat:@"%c", CODE_BOOK[data->mResults[i]]];
        }
        recognizedString = str;
    }
    else {
        char ch[100] = { 0 };
        for (int i = 0; i < mResultCount; ++i) {
            ch[i] = (char)data->mResults[i];
        }
        recognizedString = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
    }
    [self stopRecord];
    if (self.listenCompletion) {
        self.listenCompletion(recognizedString);
    }
}

- (void)startRecord:(void (^)(NSString *))listenCompletion {
    self.listenCompletion = listenCompletion;
    SinVoiceRecognizer_start(self.mSinVoiceRecorder, TOKEN_COUNT);
    self.mFile = fopen([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record1.pcm"].UTF8String, "wb");
}

- (void)stopRecord {
    SinVoiceRecognizer_stop(self.mSinVoiceRecorder);
}

@end
