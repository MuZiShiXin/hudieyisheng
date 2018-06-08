//
//  PushMessageViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "patientInfoNoteModel.h"
typedef void(^returnBlock)(NSDictionary * dict);
@interface PushMessageViewController : GatoBaseViewController
@property (nonatomic ,strong)returnBlock returnBlock;
@property (nonatomic ,strong) patientInfoNoteModel * noteModel;//患者全部信息
@property (nonatomic ,strong)NSString * patientCaseId;
@property (nonatomic ,strong)NSString * patientEasemobId;
@property (nonatomic ,strong)NSString * type;//模板类型 模板类型 0：保存信息  1.改变状态
@property (nonatomic ,strong) NSString * chuyuanzhenduan;//为手术出院时使用
@property (nonatomic ,strong)NSString * comeForWhere;//

@end
