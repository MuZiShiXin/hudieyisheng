//
//  CitiesView.h
//  CitySelected
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 sigxui-001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cityBlock)(NSDictionary * , NSInteger shengRow);

@interface CitiesView : UIView
@property (nonatomic, copy) cityBlock blockCity;
-(void)getCities:(NSArray *)cities;

@property (nonatomic, assign)BOOL navController;//默认0  如果1 高度+64
-(void)navControllerWithHeight:(BOOL )navController;//默认0  如果1 高度+64

@property (nonatomic ,assign) NSInteger shengRow;
@end
