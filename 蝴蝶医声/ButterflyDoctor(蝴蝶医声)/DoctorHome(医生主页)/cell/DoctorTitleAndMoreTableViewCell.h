//
//  DoctorTitleAndMoreTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)();
@interface DoctorTitleAndMoreTableViewCell : UITableViewCell

@property(nonatomic ,strong) buttonBlock buttonBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithImage:(NSString *)imageName WithTitle:(NSString *)titleStr WithMoreStr:(NSString *)moreStr;
@end
