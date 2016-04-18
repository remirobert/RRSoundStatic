//
//  ESLib Project
//  ESPcmRecorder.c
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#include "ESPcmRecorder.h"
#include <stdio.h>

#include <AudioToolbox/AudioToolbox.h>

#define PCM_RECORDER_BUF_COUNT 3

typedef struct __MyPcmRecorderImp
{
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef               mAudioQueue;
    AudioQueueBufferRef         mQueueBuffers[PCM_RECORDER_BUF_COUNT];

    ESInt32     mBufLen;
    ESVoid*     mCallbackParam;
    const ESPcmRecorderCallback*    mCallback;
//    FILE*   mFile;
} MyPcmRecorderImp;

static void cbAQInputCallback (ESVoid * inUserData, AudioQueueRef inAudioQueue, AudioQueueBufferRef inBuffer, const AudioTimeStamp* inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription * inPacketDesc)
{
    MyPcmRecorderImp* pThis = (MyPcmRecorderImp*)inUserData;
    if ( ES_NULL != pThis && ES_NULL != pThis->mCallback ) {
        pThis->mCallback->outputPcmRecorderData(pThis->mCallbackParam, (const ESChar*)inBuffer->mAudioData, inBuffer->mAudioDataByteSize);

//        fwrite(inBuffer->mAudioData, 1, inBuffer->mAudioDataByteSize, pThis->mFile);
        AudioQueueEnqueueBuffer(pThis->mAudioQueue, inBuffer, 0, ES_NULL);
    } else {
//        ES_LOG_E("param is null");
    }
}

ESVoid* MyPcmRecorderImp_create(ESInt32 bufBytesSize, ESInt32 sampleRate, ESInt32 bits, ESInt32 channel)
{
    MyPcmRecorderImp* pThis = (MyPcmRecorderImp*)malloc(sizeof(MyPcmRecorderImp));

    if ( ES_NULL != pThis ) {
        pThis->mBufLen = bufBytesSize;

        if ( bufBytesSize > 0 && sampleRate > 0 && bits > 0 && channel > 0 ) {
            OSStatus staus;
            ESInt32 i;

            ESUint32 category = kAudioSessionCategory_PlayAndRecord;
            ESUint32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;

            staus = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            if ( staus ) {
//                ES_LOG_E("couldn't set audio category!");
            }

            staus = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (audioRouteOverride),&audioRouteOverride);
            if ( staus ) {
//                ES_LOG_E("couldn't set audio category!");
            }

            pThis->mDataFormat.mSampleRate = sampleRate;
            pThis->mDataFormat.mFormatID = kAudioFormatLinearPCM;
            pThis->mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
            pThis->mDataFormat.mFramesPerPacket = 1;
            pThis->mDataFormat.mChannelsPerFrame = channel;
            pThis->mDataFormat.mBitsPerChannel = bits;

            pThis->mDataFormat.mBytesPerFrame = (pThis->mDataFormat.mBitsPerChannel / 8) * pThis->mDataFormat.mChannelsPerFrame;
            pThis->mDataFormat.mBytesPerPacket = pThis->mDataFormat.mBytesPerFrame * pThis->mDataFormat.mFramesPerPacket;

            staus = AudioQueueNewInput(&pThis->mDataFormat, cbAQInputCallback, pThis, ES_NULL, ES_NULL, 0, &pThis->mAudioQueue);
            pThis->mBufLen = bufBytesSize;
//            ES_LOG_V("AudioQueueNewInput: %d", staus);
            for ( i = 0; i < PCM_RECORDER_BUF_COUNT; ++i ) {
                OSStatus err = AudioQueueAllocateBuffer(pThis->mAudioQueue, (ESUint32)pThis->mBufLen, &pThis->mQueueBuffers[i]);
                if ( err ) {
//                    ES_LOG_E("allcate audioBuffer error");
                }
            }
        } else {
//            ES_LOG_E("param is invalidate");
        }

    }

    return pThis;
}

ESVoid MyPcmRecorderImp_setParam(ESVoid* p, const ESVoid* callback, ESVoid* cbParam) {
    MyPcmRecorderImp* pThis = (MyPcmRecorderImp*)p;
    if ( ES_NULL != pThis ) {
        pThis->mCallback = (ESPcmRecorderCallback*)callback;
        pThis->mCallbackParam = cbParam;
    }
}

ESVoid MyPcmRecorderImp_start(ESVoid* p)
{
    MyPcmRecorderImp* pThis = (MyPcmRecorderImp*)p;
    if ( ES_NULL != pThis ) {
        ESInt32 i;

//        pThis->mFile = fopen([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record.pcm"].UTF8String, "wb");
        for ( i = 0; i< PCM_RECORDER_BUF_COUNT; ++i ) {
            AudioQueueEnqueueBuffer(pThis->mAudioQueue, pThis->mQueueBuffers[i], 0, ES_NULL);
        }

        AudioQueueStart(pThis->mAudioQueue, ES_NULL);
    }
}

ESVoid MyPcmRecorderImp_stop(ESVoid* p)
{
    MyPcmRecorderImp* pThis = (MyPcmRecorderImp*)p;
    if ( ES_NULL != pThis ) {
        AudioQueueReset(pThis->mAudioQueue);
        AudioQueueStop(pThis->mAudioQueue, ES_TRUE);

//        if ( ES_NULL != pThis->mFile ) {
//            fclose(pThis->mFile);
//        }
    }
}

ESVoid MyPcmRecorderImp_destroy(ESPcmRecorder* p)
{
    MyPcmRecorderImp* pThis = (MyPcmRecorderImp*)p;
    if ( ES_NULL != pThis ) {
        ESInt32 i;
        for ( i = 0; i < PCM_RECORDER_BUF_COUNT; ++i ) {
            AudioQueueFreeBuffer(pThis->mAudioQueue, pThis->mQueueBuffers[i]);
        }

        AudioQueueDispose(pThis->mAudioQueue, ES_TRUE);

        free(pThis);
    }
}
