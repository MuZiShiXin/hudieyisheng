//
//  addTypeViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^addTypeBlock)(NSString * type);
@interface addTypeViewController : GatoBaseViewController
@property (nonatomic ,strong) addTypeBlock addTypeBlock;
@end
