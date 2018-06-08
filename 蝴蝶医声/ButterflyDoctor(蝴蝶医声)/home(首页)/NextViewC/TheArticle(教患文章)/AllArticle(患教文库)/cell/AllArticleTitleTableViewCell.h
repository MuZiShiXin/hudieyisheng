//
//  AllArticleTitleTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllArticleModel.h"
@interface AllArticleTitleTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(AllArticleModel *)model WithNowType:(NSInteger )nowType;

+(CGFloat)getHeight;
@end
