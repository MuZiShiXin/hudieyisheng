//
//  OneMessageExtModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface OneMessageExtModel : GatoBaseModel

@property (nonatomic ,strong) NSString * ChatUserId;
@property (nonatomic ,strong) NSString * ChatUserNick;
@property (nonatomic ,strong) NSString * ChatUserPic;
@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,strong) NSString * url;
@end
