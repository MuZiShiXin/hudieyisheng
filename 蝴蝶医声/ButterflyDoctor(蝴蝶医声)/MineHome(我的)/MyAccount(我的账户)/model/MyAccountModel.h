//
//  MyAccountModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/18.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MyAccountModel : GatoBaseModel
@property (nonatomic ,copy)NSString * costType;
@property (nonatomic ,copy)NSString * money;
@property (nonatomic ,copy)NSString * businessType;
@property (nonatomic ,copy)NSString * day;
@end
