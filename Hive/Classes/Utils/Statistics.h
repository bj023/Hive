//
//  Statistics.h
//  ZhiCai
//
//  Created by BaoJun on 15/3/24.
//  Copyright (c) 2015年 zhicai. All rights reserved.
//

#ifndef ZhiCai_Statistics_h
#define ZhiCai_Statistics_h

/**
 *  DEBUG 调试
 */
#define DebugLog debugLog
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#endif
