//
//  ESLib Project
//  ESPcmPlayer.h
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#ifndef __ESPcmPlayer_H__
#define __ESPcmPlayer_H__

#include "ESType.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct __ESPcmPlayerCallback
{
    ESInt32 (*fillPcmPlayerData)(ESVoid* param, ESChar* data, ESInt32 maxBytesSize);
} ESPcmPlayerCallback;

typedef struct __ESPcmPlayer {
    ESVoid* (*create)(ESInt32 bufBytesSize, ESInt32 sampleRate, ESInt32 bits, ESInt32 channel);

    ESVoid (*setParam)(ESVoid* pThis, const ESVoid* callback, ESVoid* cbParam);

    ESVoid (*start)(ESVoid* pThis);

    ESVoid (*stop)(ESVoid* pThis);

    ESVoid (*destroy)(ESVoid* pThis);

} ESPcmPlayer;
    
#ifdef __cplusplus
}
#endif

#endif /* __ESPcmPlayer_H__ */
