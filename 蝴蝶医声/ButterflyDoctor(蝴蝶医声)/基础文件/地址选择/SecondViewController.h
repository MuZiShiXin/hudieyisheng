//
//  SecondViewController.h
//  地址选择器
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 sigxui-001. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^addressBlock)(NSDictionary * ,NSInteger shengRow ,NSInteger shiRow);
@interface SecondViewController : UIViewController
@property (nonatomic, copy) addressBlock blockAddress;

@property (nonatomic ,assign) NSInteger  sheng;
@property (nonatomic ,assign) NSInteger  shi;
@end
