//
//  HttpManager.h
//  zigbee
//
//  Created by luokan on 14/11/4.
//  Copyright (c) 2014年 sengled. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *   自定义 Http 请求类
 */

@interface HttpManager : NSObject

typedef void (^HttpSuccBlcok)(id response);

typedef void (^HttpFailBlcok)(NSError *error);

+(void)getRequestWithBaseUrl:(NSString *)baseUrl
                      params:(NSMutableDictionary *)params
                     success:(HttpSuccBlcok) succB
                        Fail:(HttpFailBlcok) failB;

+(void)postRequestWithBaseUrl:(NSString *)baseUrl
                       params:(NSMutableDictionary *)params
                      success:(HttpSuccBlcok) succB
                         Fail:(HttpFailBlcok) failB;

+ (void)postFormDataRequestWithBaseUrl:(NSString *)baseUrl
                                params:(NSMutableDictionary *)params
                               success:(HttpSuccBlcok) succB
                                  Fail:(HttpFailBlcok) failB;

+ (void)postFormDataRequestWithBaseUrl:(NSString *)baseUrl
                                params:(NSMutableDictionary *)params
                             ImageData:(NSData *)imgData
                               success:(HttpSuccBlcok)succB
                                  Fail:(HttpFailBlcok) failB;
@end
