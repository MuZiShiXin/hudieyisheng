//
//  ImageMessageModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/24.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface ImageMessageModel : GatoBaseModel
@property (nonatomic ,copy) NSString *age;//45;
@property (nonatomic ,copy) NSString *diagnose;//"\U5176\U4ed6";
@property (nonatomic ,copy) NSString *isLeave;//0;
@property (nonatomic ,copy) NSString *lDiagnose;//"\U5176\U4ed6";
@property (nonatomic ,copy) NSString *lTshS;//"";
@property (nonatomic ,copy) NSString *name;//"\U738b\U6bc51";
@property (nonatomic ,copy) NSString *patientCaseId;//1;
@property (nonatomic ,copy) NSString *patientEasemobId;//2017052212270001;
@property (nonatomic ,copy) NSString *photo;//"";
@property (nonatomic ,copy) NSString *sex;//"\U7537";
@property (nonatomic ,copy) NSString *isMessage;//0没有消息 其他有消息
@property (nonatomic ,copy) NSString *msgTime;
@property (nonatomic ,copy) NSString *identity;//身份 [0患者,1患者家属1,2患者家属2,3患者家属3]
@end
