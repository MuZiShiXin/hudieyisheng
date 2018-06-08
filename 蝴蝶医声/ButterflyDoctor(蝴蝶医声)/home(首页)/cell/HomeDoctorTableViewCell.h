//
//  HomeDoctorTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HonorHomeModel.h"

@interface HomeDoctorTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getHetigh;

- (void)setValueWithTitle:(NSInteger )row;

-(void)setValueWithModel:(HonorHomeModel *)model WithTitle:(NSInteger )row;

@end
