//
//  TeamInfoMessageTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^switchBlock)(BOOL isButtonOn);
@interface TeamInfoMessageTableViewCell : UITableViewCell
@property (nonatomic ,strong)switchBlock switchBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithTitle:(NSString *)title WithType:(NSInteger )type WithCenter:(NSString *)centerlabel ;

-(void)setValueWithGroupPush:(BOOL)groupPushBOOL;
@end
