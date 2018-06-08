//
//  patientInfoViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "HospitalizedPatientInfoModel.h"
typedef void(^returnBlock)(NSDictionary * dict);
@interface patientInfoViewController : GatoBaseViewController
@property (nonatomic ,strong)returnBlock returnBlock;
@property (nonatomic ,strong)NSString * type;//模板类型 0：保存信息  1.改变状态
@property (nonatomic ,strong)NSString * comeForWhere;
@property (nonatomic ,strong)NSString * userId;//患者id
@end
