//
//  TeamImageModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface TeamImageModel : GatoBaseModel
@property (nonatomic ,copy) NSString * imageUrl;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * doctorId;
@end
