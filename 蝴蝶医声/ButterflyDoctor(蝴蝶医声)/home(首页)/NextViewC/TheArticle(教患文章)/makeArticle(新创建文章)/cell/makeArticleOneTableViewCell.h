//
//  makeArticleOneTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "makeArticleModel.h"

typedef void(^textViewText)(NSString * textViewText);
typedef void(^deleteOneBlcok)();
@interface makeArticleOneTableViewCell : UITableViewCell
@property (nonatomic ,strong)textViewText textViewText;
@property (nonatomic ,strong) deleteOneBlcok deleteOneBlcok;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(makeArticleModel *)model;
@end
