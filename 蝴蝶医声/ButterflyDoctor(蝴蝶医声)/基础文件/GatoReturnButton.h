//
//  GatoReturnButton.h
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GatoReturnButton : UIBarButtonItem
- (instancetype)initWithTarget:(id)target;//不是跟页面
- (instancetype)initWithTarget:(id)target IsAccoedingBar:(BOOL)flag; //跟页面  flag赋值 yes
- (instancetype)initWithTarget:(id)target IsAccoedingBar:(BOOL)flag WithRootViewControllers:(NSInteger )row;//跳转置顶rootview 页面

@end
