//
//  HttpManager.m
//  zigbee
//
//  Created by luokan on 14/11/4.
//  Copyright (c) 2014年 sengled. All rights reserved.
//

#import "HttpManager.h"
#import "AFHTTPRequestOperationManager.h"

@implementation HttpManager


#pragma get
+ (void)getRequestWithBaseUrl:(NSString *)baseUrl params:(NSMutableDictionary *)params success:(HttpSuccBlcok) succB  Fail:(HttpFailBlcok) failB
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer             = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
//    NSLog(@"url===%@",[NSMutableString stringWithFormat:@"%@%@",Base_Url,baseUrl]);
    [manager GET:baseUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        succB(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        failB(error);
    }];
}


/**
 *  post 请求
 *  @param baseUrl url的拼接地址
 *  @param params  参数
 *  @param succB   成功返回的block
 *  @param failB   失败返回的block
 */
+ (void)postRequestWithBaseUrl:(NSString *)baseUrl params:(NSMutableDictionary *)params success:(HttpSuccBlcok) succB  Fail:(HttpFailBlcok) failB
{    
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer                         = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer                        = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates   = YES;
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSLog(@"请求数据 %@->%@",baseUrl,params);
    
    [manager POST:baseUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", operation.responseString);
        succB(operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"error: %@",error);
        failB(error);
    }];
}

+ (void)postFormDataRequestWithBaseUrl:(NSString *)baseUrl params:(NSMutableDictionary *)params success:(HttpSuccBlcok) succB  Fail:(HttpFailBlcok) failB
{
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer                        = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates   = YES;
    [manager POST:baseUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithHeaders:params body:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        succB(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error);
        failB(error);
    }];
}

+ (void)postFormDataRequestWithBaseUrl:(NSString *)baseUrl
                                params:(NSMutableDictionary *)params
                             ImageData:(NSData *)imgData
                               success:(HttpSuccBlcok)succB
                                  Fail:(HttpFailBlcok) failB
{
    NSLog(@"请求数据 %@->%@",baseUrl,params);
    
    AFHTTPRequestOperationManager *manager            = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates   = YES;
    [manager POST:baseUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFormData:imgData name:@"data"];
        [formData appendPartWithFileData:imgData name:@"imagefile" fileName:@"img.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        succB(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error);
        failB(error);
    }];

}
@end

