//
//  withdrawaInfoModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface withdrawaInfoModel : GatoBaseModel


@property (nonatomic ,copy) NSString *beginTime;//申请时间
@property (nonatomic ,copy) NSString *endTime;//到账时间( 判断审核通过后显示 )
@property (nonatomic ,copy) NSString *goldCount;//申请的蝴蝶币数
@property (nonatomic ,copy) NSString *actualAmount;//兑现的实际金额
@property (nonatomic ,copy) NSString *isVerify;//审核
@end
