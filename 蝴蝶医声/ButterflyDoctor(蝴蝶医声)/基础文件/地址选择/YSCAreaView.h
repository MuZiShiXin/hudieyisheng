//
//  AreaView.h
//  CitySelected
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 sigxui-001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^areaBlock)(NSDictionary *);

@interface YSCAreaView : UIView
@property (nonatomic, copy) areaBlock block;
-(void)getArea:(NSArray *)areas;
@property (nonatomic, assign)BOOL navController;//默认0  如果1 高度+64

-(void)navControllerWithHeight:(BOOL )navController;//默认0  如果1 高度+64
@end
