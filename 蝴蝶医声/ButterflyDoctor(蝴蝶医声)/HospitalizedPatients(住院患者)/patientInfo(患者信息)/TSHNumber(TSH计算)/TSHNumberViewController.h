//
//  TSHNumberViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^tshStrBlock)(NSString * tshStr,NSString * topInt,NSString * UnderInt);
@interface TSHNumberViewController : GatoBaseViewController
@property (nonatomic ,strong) tshStrBlock tshStrBlock;
@end
