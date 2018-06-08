//
//  MyTeamHaveTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/21.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamHaveTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithTeammembersImageArray:(NSArray *)imageArray;
-(void)setValueWithPhoto:(NSString *)photo WithTitle:(NSString *)title;

-(void)setValueWithHospital:(NSString *)hospital;//等待审核

-(void)setValueWithRedLabelWithNumberstr:(NSString *)numberstr;//小红标记

-(void)setValueWithJob:(NSString *)job;

@end
