//
//  NullLabelTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/20.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NulllabelModel.h"
@interface NullLabelTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(NulllabelModel *)model;

+ (CGFloat )getHeightWithNullCellWithTableview:(UITableView *)tableview;
@end
