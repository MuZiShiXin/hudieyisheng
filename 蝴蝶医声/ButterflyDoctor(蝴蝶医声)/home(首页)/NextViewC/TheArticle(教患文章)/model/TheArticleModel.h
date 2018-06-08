//
//  TheArticleModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface TheArticleModel : GatoBaseModel

@property (nonatomic ,strong)NSString * type;
@property (nonatomic ,strong)NSString * title;
@property (nonatomic ,strong)NSString * time;
@property (nonatomic ,strong)NSString * yinyong;
@property (nonatomic ,strong)NSString * yuedu;
@property (nonatomic ,strong)NSString * zhiding;//1置顶

@property (nonatomic ,strong)NSString * classify;//分类
@property (nonatomic ,strong)NSString * quoteCount;//引用数
@property (nonatomic ,strong)NSString * click;//点击数
@property (nonatomic ,strong)NSString * articleId;//ID
@property (nonatomic ,strong)NSString * isOwner;//本人是1
@property (nonatomic ,strong)NSString * isTop;//1置顶
@property (nonatomic ,strong)NSString * images;//负责引用聊天时显示的介绍

@property (nonatomic ,strong)NSString * isVerify;//0 待审核  1审核通过 -1 驳回
@end
