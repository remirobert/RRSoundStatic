//
//  VoiceListenRecognizer.h
//  app
//
//  Created by Remi Robert on 16/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceListenRecognizer : NSObject {
    @public
    int mResults[100];
    int mResultCount;
    int mMaxEncoderIndex;
}

- (void)onRecogToken:(nonnull VoiceListenRecognizer *)data;
- (void)startRecord:(void (^_Nonnull)(NSString * _Nullable))listenCompletion;
- (void)stopRecord;

@end
