//
//  SinVoice Project
//  SinVoiceRecognizer.h
//
//  Created by gujicheng on 14-9-1.
//  Copyright (c) 2014 gujicheng. All rights reserved.
//

#ifndef __SinVoiceRecognizer_H__
#define __SinVoiceRecognizer_H__

#include "ESType.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct __SinVoiceRecognizer SinVoiceRecognizer;

typedef struct __SinVoiceRecognizerCallback
{
    ESVoid (*onSinVoiceRecognizerStart)(ESVoid* cbParam);
    ESVoid (*onSinVoiceRecognizerToken)(ESVoid* cbParam, ESInt32 index);
    ESVoid (*onSinVoiceRecognizerEnd)(ESVoid* cbParam, ESInt32 result);
} SinVoiceRecognizerCallback;

SinVoiceRecognizer* SinVoiceRecognizer_create(const ESChar* companyId, const ESChar* appId, SinVoiceRecognizerCallback* callback, ESVoid* cbParam);

SinVoiceRecognizer* SinVoiceRecognizer_create2(const ESChar* companyId, const ESChar* appId, SinVoiceRecognizerCallback* callback, ESVoid* cbParam, ESVoid* pcmRecorder);

ESVoid SinVoiceRecognizer_start(SinVoiceRecognizer* pThis, ESInt32 tokenCount);

ESVoid SinVoiceRecognizer_stop(SinVoiceRecognizer* pThis);

ESVoid SinVoiceRecognizer_destroy(SinVoiceRecognizer* pThis);

#ifdef __cplusplus
}
#endif

#endif /* __SinVoiceRecognizer_H__ */
