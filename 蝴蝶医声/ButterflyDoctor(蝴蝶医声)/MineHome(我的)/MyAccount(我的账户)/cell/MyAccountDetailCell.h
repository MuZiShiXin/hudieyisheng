//
//  MyAccountDetailCell.h
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "XibBaseCell.h"

@interface MyAccountDetailCell : XibBaseCell

- (void)setValueWithArray:(NSArray *)array;

- (void)setValueWithTime:(NSString *)time;
#pragma mark 获取高度
+ (CGFloat)getHeightWithArray:(NSArray *)dataArray;


@end
