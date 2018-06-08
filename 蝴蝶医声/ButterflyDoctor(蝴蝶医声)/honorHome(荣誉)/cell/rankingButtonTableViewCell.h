//
//  rankingButtonTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HonorHomeModel.h"

typedef void(^rankingBlcok)(NSInteger row);
@interface rankingButtonTableViewCell : UITableViewCell
@property (nonatomic ,strong )rankingBlcok rankingBlcok;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithRank:(NSString *)rank;


@end
