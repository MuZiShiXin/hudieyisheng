//
//  OperationmethodTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationmethodModel.h"


@interface OperationmethodTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(OperationmethodModel *)model;
@end
