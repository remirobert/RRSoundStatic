//
//  ESLib Project
//  ESPcmPlayer.c
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#include "ESPcmPlayer.h"
#include "ESType.h"
#include <stdlib.h>

#include <AudioToolbox/AudioToolbox.h>
#include <AudioToolbox/AudioSession.h>

#define PCM_PLAY_BUF_COUNT 3

typedef struct __MyPcmPlayerImp
{
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef               mAudioQueue;
    AudioQueueBufferRef         mQueueBuffers[PCM_PLAY_BUF_COUNT];

    ESInt32     mBufLen;
    ESVoid*     mCallbackParam;
    const ESPcmPlayerCallback*    mCallback;
//    FILE* mFile;
} MyPcmPlayerImp;

static ESVoid cbMyOutputCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer)
{
    MyPcmPlayerImp* pThis = (MyPcmPlayerImp*)inUserData;
    if ( ES_NULL != pThis && ES_NULL != pThis->mCallback ) {
        ESInt32 filledSize = pThis->mCallback->fillPcmPlayerData(pThis->mCallbackParam, (ESChar*)buffer->mAudioData, pThis->mBufLen);
//        fwrite((ESChar*)buffer->mAudioData, 1, pThis->mBufLen, pThis->mFile);

        if ( filledSize > 0 ) {
            buffer->mAudioDataByteSize = (ESUint32)filledSize;
            AudioQueueEnqueueBuffer(pThis->mAudioQueue, buffer, 0, NULL);
        } else {
//            ES_LOG_V("get zero filled size");
        }
    } else {
//        ES_LOG_E("param is null");
    }
}

ESVoid* MyPcmPlayerImp_create(ESInt32 bufBytesSize, ESInt32 sampleRate, ESInt32 bits, ESInt32 channel)
{
    MyPcmPlayerImp* pThis = (MyPcmPlayerImp*)malloc(sizeof(MyPcmPlayerImp));

    if ( ES_NULL != pThis ) {
        pThis->mBufLen = bufBytesSize;
//        pThis->mCallback = callback;
//        pThis->mCallbackParam = cbParam;

        if ( bufBytesSize > 0 && sampleRate > 0 && bits > 0 && channel > 0 ) {
            OSStatus staus;
            ESInt32 i;

            ESUint32 category = kAudioSessionCategory_PlayAndRecord;
            ESUint32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;

            staus = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            if ( staus ) {
//                ES_LOG_E("couldn't set audio category!");
            }

//            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);


//            staus = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (audioRouteOverride),&audioRouteOverride);
//            if ( staus ) {
//                ES_LOG_E("couldn't set audio category!");
//            }

//            UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//            AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);

            pThis->mDataFormat.mSampleRate = sampleRate;
            pThis->mDataFormat.mFormatID = kAudioFormatLinearPCM;
            pThis->mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
            pThis->mDataFormat.mFramesPerPacket = 1;
            pThis->mDataFormat.mChannelsPerFrame = channel;
            pThis->mDataFormat.mBitsPerChannel = bits;

            pThis->mDataFormat.mBytesPerFrame = (pThis->mDataFormat.mBitsPerChannel / 8) * pThis->mDataFormat.mChannelsPerFrame;
            pThis->mDataFormat.mBytesPerPacket = pThis->mDataFormat.mBytesPerFrame * pThis->mDataFormat.mFramesPerPacket;

            staus = AudioQueueNewOutput(&pThis->mDataFormat, cbMyOutputCallback, pThis, ES_NULL, ES_NULL, 0, &pThis->mAudioQueue);
//            ES_LOG_V("AudioQueueNewOutput: %d", staus);
            pThis->mBufLen = bufBytesSize;
            for ( i = 0; i < PCM_PLAY_BUF_COUNT; ++i ) {
                OSStatus err = AudioQueueAllocateBuffer(pThis->mAudioQueue, (ESUint32)pThis->mBufLen, &pThis->mQueueBuffers[i]);
                if ( err ) {
//                    ES_LOG_E("allcate audioBuffer error");
                }
            }
        }
    }

    return pThis;
}

ESVoid MyPcmPlayerImp_setParam(ESVoid* pThisImp, const ESPcmPlayerCallback* callback, ESVoid* cbParam)
{
    MyPcmPlayerImp* pThis = (MyPcmPlayerImp*)pThisImp;
    if ( ES_NULL != pThis ) {
        pThis->mCallback = callback;
        pThis->mCallbackParam = cbParam;
    }
}

ESVoid MyPcmPlayerImp_start(ESVoid* pThisImp)
{
    MyPcmPlayerImp* pThis = (MyPcmPlayerImp*)pThisImp;
    if ( ES_NULL != pThis ) {
        OSStatus staus;
        ESInt32 i;
        AudioQueueReset(pThis->mAudioQueue);
        AudioQueueStop(pThis->mAudioQueue, ES_TRUE);

//        pThis->mFile = fopen([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/player.pcm"].UTF8String, "wb");

        for ( i = 0; i < PCM_PLAY_BUF_COUNT; ++i ) {
            pThis->mQueueBuffers[i]->mAudioDataByteSize = 1;
            *((ESInt32*)pThis->mQueueBuffers[i]->mAudioData) = 0;
            staus = AudioQueueEnqueueBuffer(pThis->mAudioQueue, pThis->mQueueBuffers[i], 0, ES_NULL);
        }

        AudioQueueSetParameter(pThis->mAudioQueue, kAudioQueueParam_Volume, 1.5);
       staus = AudioQueueStart(pThis->mAudioQueue, ES_NULL);
    }
}

ESVoid MyPcmPlayerImp_stop(ESVoid* pThisImp)
{
    MyPcmPlayerImp* pThis = (MyPcmPlayerImp*)pThisImp;
    if ( ES_NULL != pThis ) {
        AudioQueueFlush(pThis->mAudioQueue);
    }

//    if ( ES_NULL != pThis->mFile ) {
//        fclose(pThis->mFile);
//    }
}

ESVoid MyPcmPlayerImp_destroy(ESVoid* pThisImp)
{
    MyPcmPlayerImp* pThis = (MyPcmPlayerImp*)pThisImp;
    if ( ES_NULL != pThis ) {
        ESInt32 i;
        AudioQueueReset(pThis->mAudioQueue);
        AudioQueueStop(pThis->mAudioQueue, ES_TRUE);
        for ( i = 0; i < PCM_PLAY_BUF_COUNT; ++i ) {
            AudioQueueFreeBuffer(pThis->mAudioQueue, pThis->mQueueBuffers[i]);
        }

        AudioQueueDispose(pThis->mAudioQueue, ES_TRUE);

        free(pThis);
    }
}
