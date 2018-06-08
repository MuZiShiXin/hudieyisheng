//
//  ModifyArticleDeleteTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheArticleModel.h"
typedef void(^deleteBlock)();
@interface ModifyArticleDeleteTableViewCell : UITableViewCell
@property (nonatomic ,strong) deleteBlock deleteBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(TheArticleModel *)model;

+(CGFloat)getHeight;

@end
