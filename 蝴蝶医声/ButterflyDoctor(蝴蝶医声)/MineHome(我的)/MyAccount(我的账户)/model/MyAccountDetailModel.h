//
//  MyAccountDetailModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/18.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MyAccountDetailModel : GatoBaseModel
@property (nonatomic ,copy)NSString *preTaxIncome;//税前总收入
@property (nonatomic ,copy)NSString *businessIncome;//业务收入
@property (nonatomic ,copy)NSString *payIncomeTax;//缴纳所得税
@property (nonatomic ,copy)NSString *actualIncome;//实际收入

@end
