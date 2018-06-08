//
//  HomeTopButtonTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^buttonBlock)(NSInteger row);
@interface HomeTopButtonTableViewCell : UITableViewCell
@property (nonatomic ,strong) buttonBlock buttonBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)getHeight;

-(void)setValueWithImageMessageCount:(NSString *)count;
@end
