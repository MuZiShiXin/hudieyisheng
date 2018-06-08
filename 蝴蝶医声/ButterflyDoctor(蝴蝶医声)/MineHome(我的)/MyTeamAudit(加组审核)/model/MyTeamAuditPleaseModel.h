//
//  MyTeamAuditPleaseModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/13.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MyTeamAuditPleaseModel : GatoBaseModel
@property (nonatomic ,copy) NSString *doctorId;//医生ID
@property (nonatomic ,copy) NSString *photo;//头像
@property (nonatomic ,copy) NSString *name;//姓名
@property (nonatomic ,copy) NSString *work;//职位
@property (nonatomic ,copy) NSString *time;//申请时间
@property (nonatomic ,copy) NSString *isTeam;//是否是组长


@end
