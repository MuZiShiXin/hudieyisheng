//
//  lookArticleImageTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "makeArticleModel.h"

typedef void(^buttonImageBlock)(UITapGestureRecognizer * tap);
@interface lookArticleImageTableViewCell : UITableViewCell
@property (nonatomic ,strong) buttonImageBlock buttonImageBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(makeArticleModel *)model;


@end
