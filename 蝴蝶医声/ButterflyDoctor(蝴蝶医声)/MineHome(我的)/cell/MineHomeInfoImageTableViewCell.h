//
//  MineHomeInfoImageTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineHomeModel.h"
@interface MineHomeInfoImageTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(MineHomeModel *)model;

@end
