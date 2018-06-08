//
//  ChooseBankInfoModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface ChooseBankInfoModel : GatoBaseModel
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * bankId;
@property (nonatomic ,strong) NSArray * son;
@end
