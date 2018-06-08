//
//  releaseStopWorkTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "releaseStopModel.h"
typedef void(^StopBianjiBlock)();
@interface releaseStopWorkTableViewCell : UITableViewCell
@property (nonatomic ,strong) StopBianjiBlock StopBianjiBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithModel:(releaseStopModel *)model;

+(CGFloat)getHeight;
@end
