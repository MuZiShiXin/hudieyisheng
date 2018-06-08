//
//  ModifyArticleTextTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "modifyArticleModel.h"


typedef void(^textBlock)(NSString * text,NSInteger row);//text 输入内容 row 0标题 1消息
typedef void(^MoerButton)();
@interface ModifyArticleTextTableViewCell : UITableViewCell
@property (nonatomic ,strong) textBlock textBlock;
@property (nonatomic ,strong) MoerButton MoerButton;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(modifyArticleModel *)model;

+(CGFloat)getheight;
@end
