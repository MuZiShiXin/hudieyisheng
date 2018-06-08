//
//  bedNumberRightTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellBedNumberStrBlock)(NSString * betNumber);
@interface bedNumberRightTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setValueWithNameArray:(NSArray *)nameArray;

@property (nonatomic ,strong) CellBedNumberStrBlock CellBedNumberStrBlock;
@end
