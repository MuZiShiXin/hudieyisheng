//
//  MyTeamAuditTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/6.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTeamAuditPleaseModel.h"

typedef void(^tongyiBlock)();
typedef void(^bohuiBlock)();
@interface MyTeamAuditTableViewCell : UITableViewCell
@property (nonatomic ,strong) tongyiBlock tongyiBlock;
@property (nonatomic ,strong) bohuiBlock bohuiBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(MyTeamAuditPleaseModel *)model;
@end
