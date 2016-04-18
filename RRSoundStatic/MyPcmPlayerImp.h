//
//  ESLib Project
//  ESPcmPlayer.h
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#ifndef __MyPcmPlayerImp_H__
#define __MyPcmPlayerImp_H__

#include "ESType.h"

#ifdef __cplusplus
extern "C" {
#endif

ESVoid* MyPcmPlayerImp_create(ESInt32 bufBytesSize, ESInt32 sampleRate, ESInt32 bits, ESInt32 channel);

ESVoid MyPcmPlayerImp_setParam(ESVoid* pThis, const ESVoid* callback, ESVoid* cbParam);

ESVoid MyPcmPlayerImp_start(ESVoid* pThis);

ESVoid MyPcmPlayerImp_stop(ESVoid* pThis);

ESVoid MyPcmPlayerImp_destroy(ESVoid* pThis);

#ifdef __cplusplus
}
#endif

#endif /* __MyPcmPlayerImp_H__ */
