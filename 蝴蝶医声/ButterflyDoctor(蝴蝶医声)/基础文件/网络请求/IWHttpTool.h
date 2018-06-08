//
//  IWHttpTool.h
//  传智微博
//
//  Created by teacher on 14-6-16.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface IWHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调 
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)postWithURLJSON:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post1WithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)post2WithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure WithFlash:(BOOL )flashBool;

//+ (void)post2WithURL:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//dismiss  是否打开 30秒关闭网络请求 默认关闭
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure Dismiss:(BOOL)dismiss;

+ (void)startMultiPartUploadTaskWithURL:(NSString *)url
                            imagesArray:(NSArray *)images
                            ChangeState:(NSString *)changeState
                         parametersDict:(NSDictionary *)parameters
                           succeedBlock:(void (^) (id json))succeedBlock
                            failedBlock:(void (^)(NSError *))failedBlock
                    uploadProgressBlock:(nullable void (^)(float fractionCompleted, long long totalUnitCount, long long completedUnitCount))uploadProgressBlock;

+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;
@end
