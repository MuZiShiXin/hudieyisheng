//
//  consultingInfoViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "MineInfoDataModel.h"

typedef void(^payPriceBlock)(NSString * payPrice,NSString * notDisturbStr);
@interface consultingInfoViewController : GatoBaseViewController
@property (nonatomic ,strong) payPriceBlock payPriceBlock;

@property (nonatomic ,strong) MineInfoDataModel * model;
@end
