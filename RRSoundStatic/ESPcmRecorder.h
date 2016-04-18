//
//  ESLib Project
//  ESPcmRecorder.h
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#ifndef __ESPcmRecorder_H__
#define __ESPcmRecorder_H__

#include "ESType.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct __ESPcmRecorderCallback
{
    ESVoid (*outputPcmRecorderData)(ESVoid* param, const ESChar* data, ESInt32 bytesSize);
} ESPcmRecorderCallback;

typedef struct __ESPcmRecorder {
    ESVoid* (*create)(ESInt32 bufBytesLen, ESInt32 sampleRate, ESInt32 bits, ESInt32 channel);

    ESVoid (*setParam)(ESVoid* pThis, const ESVoid* callback, ESVoid* cbParam);
    ESVoid (*start)(ESVoid* pThis);
    ESVoid (*stop)(ESVoid* pThis);
    ESVoid (*destroy)(ESVoid* pThis);

} ESPcmRecorder;

#ifdef __cplusplus
}
#endif

#endif /* __ESPcmRecorder_H__ */
