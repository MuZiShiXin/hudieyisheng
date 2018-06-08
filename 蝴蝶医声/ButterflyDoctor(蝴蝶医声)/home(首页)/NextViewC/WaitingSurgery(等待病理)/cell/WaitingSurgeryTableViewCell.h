//
//  WaitingSurgeryTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalizedPatientInfoModel.h"

typedef void(^newInfo)();//修改患者信息
typedef void(^ButtonBlock)(NSInteger row);//0医患沟通  1出院诊断
@interface WaitingSurgeryTableViewCell : UITableViewCell
@property (nonatomic ,strong) ButtonBlock ButtonBlock;
@property (nonatomic ,strong) newInfo newInfo;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(HospitalizedPatientInfoModel *)model;


@end
