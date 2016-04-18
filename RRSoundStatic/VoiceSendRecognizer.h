//
//  VoiceRecognizer.h
//  app
//
//  Created by Remi Robert on 16/04/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceSendRecognizer : NSObject {
    @public
    int mRates[100];
    int mPlayCount;
    int mMaxEncoderIndex;
}

- (void)onPlayData:(nonnull VoiceSendRecognizer *)data;
- (void)startPlay:(nonnull NSString *)string completion:(void (^ _Nonnull)(void))sendingCompletion;
- (void)stopPlay;
- (void)completed;

@end
