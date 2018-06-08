//
//  AppMessageModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/10.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface AppMessageModel : GatoBaseModel

@property (nonatomic ,strong) NSString * messageId;//站内消息ID
/*
 180130改
 0 我的里面->我的小组
 1 住院患者
 2 提现明细 (需要输入隐私密码)
 */
@property (nonatomic ,strong) NSString * recordType;//目标资源标识类型
@property (nonatomic ,strong) NSString * recordId;//目标资源标识ID
@property (nonatomic ,strong) NSString * message;//消息内容
@property (nonatomic ,strong) NSString * isRead;//是否阅读

@end
