//
//  releaseWorkTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "releaseStopModel.h"

typedef void(^workBianjiBlock)();
@interface releaseWorkTableViewCell : UITableViewCell
@property (nonatomic ,strong) workBianjiBlock workBianjiBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(releaseStopModel *)model;

+(CGFloat)getHeight;
@end
