//
//  ImageMessageTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageMessageModel.h"

typedef void(^ButtonBlock)();//
@interface ImageMessageTableViewCell : UITableViewCell
@property (nonatomic ,strong) ButtonBlock ButtonBlock;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(ImageMessageModel *)model;
@end
