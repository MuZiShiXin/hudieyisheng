//
//  MyTeamMemberModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/23.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MyTeamMemberModel : GatoBaseModel
@property (nonatomic ,copy) NSString * phone;
@property (nonatomic ,copy) NSString * doctorId;
@property (nonatomic ,copy) NSString * photo;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * unreadMessagesCount;//未读消息
@property (nonatomic ,copy) NSString * work;
@property (nonatomic ,copy) NSString * isTeam;
@property (nonatomic ,copy) NSString * hospital;

@end
