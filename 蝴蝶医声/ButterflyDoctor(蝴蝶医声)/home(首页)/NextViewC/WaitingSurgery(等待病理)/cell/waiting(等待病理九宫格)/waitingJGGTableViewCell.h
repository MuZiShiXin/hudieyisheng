//
//  waitingJGGTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/5.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalizedPatientInfoModel.h"

typedef void(^newInfo)();//修改患者信息
typedef void(^ButtonBlock)(NSInteger row);//0医患沟通  1出院诊断
@interface waitingJGGTableViewCell : UITableViewCell
@property (nonatomic ,strong) ButtonBlock ButtonBlock;
@property (nonatomic ,strong) newInfo newInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(HospitalizedPatientInfoModel *)model;
@end
