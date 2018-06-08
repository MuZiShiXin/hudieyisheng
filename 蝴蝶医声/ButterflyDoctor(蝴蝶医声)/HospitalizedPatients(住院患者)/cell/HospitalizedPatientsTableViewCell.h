//
//  HospitalizedPatientsTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalizedPatientInfoModel.h"


typedef void(^pushBlock)();
typedef void(^ButtonBlock)(NSInteger row);//0医患沟通  1未手术出院  2等待病理
typedef void(^MyPatientBlock)();
@interface HospitalizedPatientsTableViewCell : UITableViewCell
@property (nonatomic ,strong) ButtonBlock ButtonBlock;
@property (nonatomic ,strong) pushBlock pushBlock;
@property (nonatomic ,strong) MyPatientBlock MyPatientBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(HospitalizedPatientInfoModel *)model;
@end
