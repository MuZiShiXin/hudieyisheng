//
//  GatoBaseModel.h
//  meiqi
//
//  Created by 辛书亮 on 2016/11/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GatoBaseModel : NSObject

+(instancetype)modelWithDic:(NSDictionary *)dic;
/*
 *  转换为字典
 */
-(NSDictionary *)convertToDictionary;
#pragma mark 把所有属性置空
-(void)setValueWithNull;


@end
