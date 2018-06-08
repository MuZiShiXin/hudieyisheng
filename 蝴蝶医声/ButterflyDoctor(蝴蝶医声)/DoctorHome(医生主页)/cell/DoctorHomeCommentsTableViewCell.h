//
//  DoctorHomeCommentsTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorHomePingjiaModel.h"
@interface DoctorHomeCommentsTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(DoctorHomePingjiaModel *)model;
@end
