//
//  choosebankTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/19.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseBankSonModel.h"
@interface choosebankTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(ChooseBankSonModel *)model;
@end
