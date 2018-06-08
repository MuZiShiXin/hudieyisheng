//
//  newPayNumberViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/2.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^payPriceBlock)(NSString * payPrice,NSString * notDisturbStr);
@interface newPayNumberViewController : GatoBaseViewController
@property (nonatomic ,strong) payPriceBlock payPriceBlock;



@end
