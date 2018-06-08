//
//  pushMessageTitleTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pushMessageTitleModel.h"
@interface pushMessageTitleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setvalueWithModel:(pushMessageTitleModel * )model;
@end
