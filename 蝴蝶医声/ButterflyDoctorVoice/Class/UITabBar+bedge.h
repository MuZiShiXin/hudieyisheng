//
//  UITabBar+bedge.h
//  ChatDemo-UI3.0
//
//  Created by 辛书亮 on 2017/6/12.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (bedge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
