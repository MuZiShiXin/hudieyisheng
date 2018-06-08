//
//  PushPhoneTitleViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/7.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef  void(^titleBlock)(NSString * title);
@interface PushPhoneTitleViewController : GatoBaseViewController
@property (nonatomic ,strong) titleBlock titleBlock;
@end
