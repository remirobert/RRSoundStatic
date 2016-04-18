//
//  ESLib Project
//  ESPcmRecorder.h
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#ifndef __MyPcmRecorderImp_H__
#define __MyPcmRecorderImp_H__

#include "ESType.h"

#ifdef __cplusplus
extern "C" {
#endif

ESVoid* MyPcmRecorderImp_create(ESInt32 bufBytesLen, ESInt32 sampleRate, ESInt32 bits, ESInt32 channel);
ESVoid MyPcmRecorderImp_setParam(ESVoid* pThis, const ESVoid* callback, ESVoid* cbParam);
ESVoid MyPcmRecorderImp_start(ESVoid* pThis);
ESVoid MyPcmRecorderImp_stop(ESVoid* pThis);
ESVoid MyPcmRecorderImp_destroy(ESVoid* pThis);

#ifdef __cplusplus
}
#endif

#endif /* __MyPcmRecorderImp_H__ */
