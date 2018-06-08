//
//  AfterDischargeTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterDischargeModel.h"

typedef void(^ButtonBlock)(NSInteger row);//0医患沟通  1患者信息
@interface AfterDischargeTableViewCell : UITableViewCell
@property (nonatomic ,strong) ButtonBlock ButtonBlock;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(AfterDischargeModel *)model;

@end
