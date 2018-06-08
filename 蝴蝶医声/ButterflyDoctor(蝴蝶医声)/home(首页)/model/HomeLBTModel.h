//
//  HomeLBTModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface HomeLBTModel : GatoBaseModel
@property (nonatomic ,strong) NSString * picUrl;
@property (nonatomic ,strong) NSString * pageId;//主页类型
@property (nonatomic ,strong) NSString * boyId;
@property (nonatomic ,strong) NSString * linkurl;//跳转链接
@property (nonatomic ,strong) NSString * WebId;//根据id请求内容
@end
