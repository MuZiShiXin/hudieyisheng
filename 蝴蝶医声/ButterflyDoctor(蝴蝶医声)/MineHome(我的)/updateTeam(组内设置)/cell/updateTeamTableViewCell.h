//
//  updateTeamTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamMemberModel.h"

@interface updateTeamTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(MyTeamMemberModel *)model WithGodPhone:(NSString *)phone;

@end
