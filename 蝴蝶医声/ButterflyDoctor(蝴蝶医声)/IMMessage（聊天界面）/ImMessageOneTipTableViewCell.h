//
//  ImMessageOneTipTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/8/21.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImMessageOneTipTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setValueWithTitle:(NSString *)titleStr;
@end
