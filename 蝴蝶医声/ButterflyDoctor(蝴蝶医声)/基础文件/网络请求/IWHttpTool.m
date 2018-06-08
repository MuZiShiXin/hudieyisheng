//
//  IWHttpTool.m
//  传智微博
//
//  Created by teacher on 14-6-16.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWHttpTool.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "GatoBaseHelp.h"
#import "NSArray+CSArray.h"

///
@implementation IWHttpTool

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    ///
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送一个GET请求
    [mgr GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
//    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
//    { // 请求成功后会调用
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//    { // 请求失败后会调用
//        if (failure) {
//            failure(error);
//        }
//    }];
}

+ (void) postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    if (![url isEqualToString:HD_Surgery_Info]&&![url isEqualToString:HD_Home_info_Doctor]&&![url isEqualToString:@"http://api.hudieyisheng.com/v1/home/is-verify"] && ![url isEqualToString:HD_Home_Banner]&& ![url isEqualToString:HD_NewApp]&&![url isEqualToString:HD_NewApp_Down]) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            NSLog(@"时间超过30秒 自动取消网络加载");
//            [SVProgressHUD dismiss];
//        });
    }
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送一个POST请求
    
    
    
    
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 告诉外界(外面):我们请求成功了
        
        
        
        if (success) {
            success(responseObject);
        }
        [SVProgressHUD popActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
        [SVProgressHUD dismiss];
    }];
    
    
    
    
    
    
//
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
//        // 告诉外界(外面):我们请求成功了
//        if (success) {
//            success(responseObject);
//        }
//         [SVProgressHUD dismiss];
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
//        // 告诉外界(外面):我们请求失败了
//        if (failure) {
//            failure(error);
//        }
//         [SVProgressHUD dismiss];
//
//    }];
}


+ (void) postWithURLJSON:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    //    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    if (![url isEqualToString:HD_Surgery_Info]&&![url isEqualToString:HD_Home_info_Doctor]&&![url isEqualToString:@"http://api.hudieyisheng.com/v1/home/is-verify"] && ![url isEqualToString:HD_Home_Banner]&& ![url isEqualToString:HD_NewApp]&&![url isEqualToString:HD_NewApp_Down]) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
    }
    // 2.发送一个POST请求
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];// 请求返回的格式为json
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 告诉外界(外面):我们请求成功了
        
        if (success) {
            success(responseObject);
        }
        [SVProgressHUD popActivity];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
        [SVProgressHUD dismiss];
    }];
}






+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure WithFlash:(BOOL )flashBool
{
    
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    if (![url isEqualToString:HD_Surgery_Info]) {
        if (flashBool == YES) {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD show];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                NSLog(@"时间超过30秒 自动取消网络加载");
//                [SVProgressHUD dismiss];
//            });
        }
    }
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送一个POST请求
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 告诉外界(外面):我们请求成功了
        if (success) {
            success(responseObject);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
        [SVProgressHUD dismiss];
    }];
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
//        // 告诉外界(外面):我们请求成功了
//        if (success) {
//            success(responseObject);
//        }
//        [SVProgressHUD dismiss];
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
//        // 告诉外界(外面):我们请求失败了
//        if (failure) {
//            failure(error);
//        }
//        [SVProgressHUD dismiss];
//
//    }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure Dismiss:(BOOL)dismiss
{
    // 1.获得请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    //manger.responseSerializer = [AFHTTPResponseSerializerserializer];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送一个POST请求
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 告诉外界(外面):我们请求成功了
        if (success) {
            success(responseObject);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
        [SVProgressHUD dismiss];
    }];
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
//        // 告诉外界(外面):我们请求成功了
//        if (success) {
//            success(responseObject);
//        }
//        [SVProgressHUD dismiss];
//
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
//        // 告诉外界(外面):我们请求失败了
//        if (failure) {
//            failure(error);
//        }
//        [SVProgressHUD dismiss];
//
//    }];
}
+ (void)post1WithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //manger.responseSerializer = [AFHTTPResponseSerializerserializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送一个POST请求
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 告诉外界(外面):我们请求成功了
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
    }];
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
//        // 告诉外界(外面):我们请求成功了
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
//        // 告诉外界(外面):我们请求失败了
//        if (failure) {
//            failure(error);
//        }
//    }];
}

+ (void)post2WithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //manger.responseSerializer = [AFHTTPResponseSerializerserializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送一个POST请求
    [mgr POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 告诉外界(外面):我们请求成功了
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 告诉外界(外面):我们请求失败了
        if (failure) {
            failure(error);
        }
    }];
//    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) { // 请求成功后会调用
//        // 告诉外界(外面):我们请求成功了
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败后会调用
//        // 告诉外界(外面):我们请求失败了
//        if (failure) {
//            failure(error);
//        }
//    }];
}


+ (void)post2WithURL:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"my.png" mimeType:@"avatar/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
//    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        NSData *data = UIImagePNGRepresentation(image);
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"my.png" mimeType:@"avatar/png"];
//   } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(responseObject);
//   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       failure(error);
//   }];
    
}



/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameters          其他参数字典
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */

+(void)startMultiPartUploadTaskWithURL:(NSString *)url imagesArray:(NSArray *)images ChangeState:(NSString *)changeState parametersDict:(NSDictionary *)parameters succeedBlock:(void (^)(id))succeedBlock failedBlock:(void (^)(NSError *))failedBlock uploadProgressBlock:(void (^)(float, long long, long long))uploadProgressBlock
{
    AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
    operation.responseSerializer = [AFJSONResponseSerializer serializer]; // 申明返回的结果是json类型
    operation.requestSerializer= [AFHTTPRequestSerializer serializer];
//    [operation.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    [operation POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int i = 0; i < images.count; i++) {
                NSArray *Arry = images[i];
                for (int y = 0; y < Arry.count; y++) {
                    @autoreleasepool {
                        if ([Arry[y] isKindOfClass:[NSData class]]) {
//                            UIImage *image = Arry[y];
                            NSData *data = Arry[y];
//                            NSData *data =  [IWHttpTool zipNSDataWithImage:image];
                            if (i == 0){
                                // 上传的参数名，在服务器端保存文件的文件夹名
                                NSString * Name = [NSString stringWithFormat:@"%@%d", @"sImg", y+1];
                                // 上传filename
                                NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
                                [formData appendPartWithFileData:data name:@"sImg[]" fileName:fileName mimeType:@"image/jpeg"];
                            }else{
                                // 上传的参数名，在服务器端保存文件的文件夹名
                                NSString * Name = [NSString stringWithFormat:@"%@%d", @"lImg", y+1];
                                // 上传filename
                                NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
                                [formData appendPartWithFileData:data name:@"lImg[]" fileName:fileName mimeType:@"image/jpeg"];
                            }
                        }else
                        {
                            NSString *Str = Arry[y];
                            NSData *data = [NSData new];
                            if (i == 0){
                                [formData appendPartWithFileData:data name:@"sImg[]" fileName:Str mimeType:@"image/url"];
                            }else{
                                [formData appendPartWithFileData:data name:@"lImg[]" fileName:Str mimeType:@"image/url"];
                            }
                        }
                    }
                }
            }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if ([changeState isEqualToString:@"1"]) {
            int lImgCount =  [[parameters objectForKey:@"lImgCount"] intValue];
            int sImgCount =  [[parameters objectForKey:@"sImgCount"] intValue];
            int imageCont = lImgCount + sImgCount;
            NSString *str = [NSString stringWithFormat:@"%.f%%",uploadProgress.fractionCompleted*100];
            NSString *strcont = [NSString stringWithFormat:@"\n正在上传第 %.f张",imageCont * uploadProgress.fractionCompleted];
            if (imageCont == 0) {
                [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:str];
            }else
            {
                [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[str stringByAppendingString:strcont]];
            }
        }
//        uploadProgressBlock( uploadProgress.fractionCompleted ,uploadProgress.totalUnitCount,uploadProgress.completedUnitCount );
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        failedBlock(error);
    }];
}

+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280) {
        if (width>height) {
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }else{
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }
        //2.高度大于1280
    }else if(height>1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.4);
        }else if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.5);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }
    }
    return data;
}

@end
