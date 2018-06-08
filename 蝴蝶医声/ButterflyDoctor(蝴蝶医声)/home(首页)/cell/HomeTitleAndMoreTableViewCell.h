//
//  HomeTitleAndMoreTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^moreBlock)();
@interface HomeTitleAndMoreTableViewCell : UITableViewCell
@property (nonatomic ,strong) moreBlock moreBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getHetigh;

- (void)setValueWithTitle:(NSString *)str;
@end
