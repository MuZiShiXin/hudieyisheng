//
//  modifyArticleModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface modifyArticleModel : GatoBaseModel

@property (nonatomic ,strong)NSString * title;
@property (nonatomic ,strong)NSString * time;
@property (nonatomic ,strong)NSString * content;
@property (nonatomic ,strong)NSString * pushId;
@property (nonatomic ,strong)NSArray * articles;//应该是数组
@property (nonatomic ,strong)NSString * picurl;
@end
