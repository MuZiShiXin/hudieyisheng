//
//  SUIFANGTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/5.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterDischargeModel.h"
typedef void(^ButtonBlock)(NSInteger row);//0医患沟通  1患者信息
@interface SUIFANGTableViewCell : UITableViewCell
@property (nonatomic ,strong) ButtonBlock ButtonBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(AfterDischargeModel *)model;
@end
