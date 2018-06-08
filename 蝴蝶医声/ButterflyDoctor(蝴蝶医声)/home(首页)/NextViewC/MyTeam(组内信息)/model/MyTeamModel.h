//
//  MyTeamModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/23.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface MyTeamModel : GatoBaseModel

@property (nonatomic ,copy) NSString * phone;//群主电话
@property (nonatomic ,copy) NSString * owner;//拥有者
@property (nonatomic ,strong) NSArray * members;//群成员信息
@property (nonatomic ,copy) NSString * noticeContent;//群公告
@property (nonatomic ,copy) NSString * doctorId;//群主id
@property (nonatomic ,copy) NSString * groupName;//群名字
@property (nonatomic ,copy) NSString * photo;//群主头像
@property (nonatomic ,copy) NSString * groupId;//组id
@property (nonatomic ,strong) NSArray * memberImages;//组员头像
@property (nonatomic ,copy) NSString * unreadMessagesCount;//
@end
