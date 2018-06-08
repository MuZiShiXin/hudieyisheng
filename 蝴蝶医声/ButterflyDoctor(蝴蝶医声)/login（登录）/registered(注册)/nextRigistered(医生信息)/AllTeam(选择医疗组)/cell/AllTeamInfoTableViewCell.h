//
//  AllTeamInfoTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamVerifyModel.h"
@interface AllTeamInfoTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(MyTeamVerifyModel *)model;
@end
