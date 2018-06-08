//
//  MineInfoDataViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^updateInfo)();
@interface MineInfoDataViewController : GatoBaseViewController
@property (nonatomic ,strong) updateInfo updateInfo;

+ (void)TabSelectedIndex;
@end
