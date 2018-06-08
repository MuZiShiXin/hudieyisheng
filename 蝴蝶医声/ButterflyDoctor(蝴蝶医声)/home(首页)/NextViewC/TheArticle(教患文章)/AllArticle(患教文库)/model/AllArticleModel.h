//
//  AllArticleModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/17.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface AllArticleModel : GatoBaseModel

@property (nonatomic ,strong)NSString * author;
@property (nonatomic ,strong)NSString * title;
@property (nonatomic ,strong)NSString * hospitalDepartment;
@property (nonatomic ,strong)NSString * quoteCount;
@property (nonatomic ,strong)NSString * isOwner;
@property (nonatomic ,strong)NSString * articleId;
@property (nonatomic ,strong)NSString * click;
@property (nonatomic ,strong)NSString * time;
@end
