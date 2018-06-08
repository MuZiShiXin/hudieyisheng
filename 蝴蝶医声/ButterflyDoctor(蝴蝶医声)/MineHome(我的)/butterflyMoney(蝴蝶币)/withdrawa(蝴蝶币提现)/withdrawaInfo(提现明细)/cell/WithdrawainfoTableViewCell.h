//
//  WithdrawainfoTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "withdrawaInfoModel.h"
@interface WithdrawainfoTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(withdrawaInfoModel *)model;
@end
