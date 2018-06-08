//
//  releaseStopModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/17.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface releaseStopModel : GatoBaseModel
//------------停诊---------／／
@property (nonatomic ,strong) NSString * remark;
@property (nonatomic ,strong) NSString * noticeId;
@property (nonatomic ,strong) NSString * dateEnd;
@property (nonatomic ,strong) NSString * beginTime;
@property (nonatomic ,strong) NSString * dateHead;
@property (nonatomic ,strong) NSString * endTime;
@property (nonatomic ,strong) NSString * isVerify;
@property (nonatomic ,strong) NSString * cause;
//------------停诊END---------／／


//------------出诊---------／／
@property (nonatomic ,strong) NSString * content;
@property (nonatomic ,strong) NSString * outId;
//------------出诊END---------／／
@end
