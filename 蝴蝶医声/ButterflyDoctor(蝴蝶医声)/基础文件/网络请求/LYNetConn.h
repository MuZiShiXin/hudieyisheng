//
//  LYNetConn.h
//  MaoProduct
//
//  Created by 丰华财经 on 2016/12/15.
//  Copyright © 2016年 com.fenghuacaijing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BlockConn) (id result);
@interface LYNetConn : NSObject
+(void)connectionWithURL:(NSString *)function withDic:(NSDictionary *)dic withBlock:(BlockConn)block;
@end
