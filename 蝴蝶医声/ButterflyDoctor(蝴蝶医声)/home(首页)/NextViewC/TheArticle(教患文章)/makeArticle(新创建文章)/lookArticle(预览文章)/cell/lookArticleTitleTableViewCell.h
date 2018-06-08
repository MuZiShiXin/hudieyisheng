//
//  lookArticleTitleTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "makeArticleModel.h"
@interface lookArticleTitleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(makeArticleModel *)model;

-(void)setValueWithTitle:(NSString *)titleStr;
@end
