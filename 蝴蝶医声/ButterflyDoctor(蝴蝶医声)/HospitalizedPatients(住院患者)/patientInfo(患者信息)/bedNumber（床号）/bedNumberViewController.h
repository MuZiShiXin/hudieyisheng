//
//  bedNumberViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^bedNumberStrBlock)(NSString * betNumber);
@interface bedNumberViewController : GatoBaseViewController
@property (nonatomic ,strong) bedNumberStrBlock bedNumberStrBlock;
@end
