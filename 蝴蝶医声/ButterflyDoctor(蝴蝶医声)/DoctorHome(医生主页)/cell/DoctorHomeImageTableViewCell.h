//
//  DoctorHomeImageTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorHomeInfoDataModel.h"

@interface DoctorHomeImageTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(DoctorHomeInfoDataModel *)model;
@end
