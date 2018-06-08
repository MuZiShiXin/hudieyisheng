//
//  MyCardShareView.h
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UMBlock)();
@interface MyCardShareView : UIView
@property (nonatomic ,strong) UMBlock UMBlock;

- (void)setValueWithImg:(NSString *)img withText:(NSString *)text;

@end
