//
//  DoctorHomeGoodTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^zhankaiBlock)();
@interface DoctorHomeGoodTableViewCell : UITableViewCell
@property (nonatomic ,strong) zhankaiBlock zhankaiBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(NSString *)model WithZhankai:(NSString *)zhankai;
@end
