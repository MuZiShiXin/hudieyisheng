//
//  TSHNumberTwoTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^twoBlock)(NSInteger row);
@interface TSHNumberTwoTableViewCell : UITableViewCell
@property (nonatomic ,strong )twoBlock twoBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setValueWithNumberButton:(NSInteger )numberType;


@end
