//
//  LYNetConn.m
//  MaoProduct
//
//  Created by 丰华财经 on 2016/12/15.
//  Copyright © 2016年 com.fenghuacaijing. All rights reserved.
//

#import "LYNetConn.h"




@interface LYNetConn ()

@end

@implementation LYNetConn


+(void)connectionWithURL:(NSString *)function withDic:(NSDictionary *)dic withBlock:(BlockConn)block{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(dispatch_group_create(), queue, ^{

        //第一步，创建URL
        NSURL *urlQ = [NSURL URLWithString:function];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlQ cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str ;//设置参数
        for (NSString *key in dic) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, dic[key]]];
        }
        
        str = [str substringFromIndex:1];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *tast = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!error) {
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    block(result);
                }
                
            });
            
        }];
        
        [tast resume];
    });
    
}


@end
