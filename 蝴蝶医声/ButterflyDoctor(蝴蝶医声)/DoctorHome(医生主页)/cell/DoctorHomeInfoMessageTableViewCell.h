//
//  DoctorHomeInfoMessageTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorHomeInfoMessageTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(NSString *)model;
@end
