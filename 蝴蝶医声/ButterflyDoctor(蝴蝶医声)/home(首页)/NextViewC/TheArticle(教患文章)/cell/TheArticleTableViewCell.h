//
//  TheArticleTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheArticleModel.h"
@interface TheArticleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(TheArticleModel *)model;

+(CGFloat)getHeight;
@end
