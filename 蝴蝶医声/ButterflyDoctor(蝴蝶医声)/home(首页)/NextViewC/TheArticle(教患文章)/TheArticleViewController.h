//
//  TheArticleViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "TheArticleModel.h"
typedef void(^addArticleBlock)(TheArticleModel * model);
@interface TheArticleViewController : GatoBaseViewController
@property (nonatomic ,strong)addArticleBlock addArticleBlock;

@property (nonatomic ,assign) BOOL comeForPushMessage;//是否从模版消息进入 默认no
@end
