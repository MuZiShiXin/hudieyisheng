//
//  ModifyArticleViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

@interface ModifyArticleViewController : GatoBaseViewController

@property (nonatomic ,strong)NSString * type;//模板类型 0：不改变状态 1：改变状态
@property (nonatomic ,strong)NSString * comeForWhere;// 0从住院患者进入  1从等待病理进入
@end
