//
//  DLTabBar.m
//  DLTabBarControllerDemo
//
//  Created by FT_David on 16/5/27.
//  Copyright © 2016年 FT_David. All rights reserved.
//

#import "DLTabBar.h"
#import "UIView+MJExtension.h"
#import "UIView+Frame.h"
@interface DLTabBar()

@property (nonatomic, weak) UIButton *centerButton;

@end

@implementation DLTabBar

@dynamic delegate;


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            UIButton *centerButton = [[UIButton alloc] init];
        [centerButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [centerButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [centerButton setImage:[UIImage imageNamed:@"icon26"] forState:UIControlStateNormal];
        [centerButton setImage:[UIImage imageNamed:@"icon26"] forState:UIControlStateHighlighted];
        centerButton.size = CGSizeMake(70, 60);
        [centerButton addTarget:self action:@selector(centerButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:centerButton];
        self.centerButton = centerButton;
        
        
    }
    return self;
}


- (void)centerButtonAction
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarDidClickAtCenterButton:)]) {
        [self.delegate tabBarDidClickAtCenterButton:self];
    }
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    

    self.centerButton.centerX = self.width * 0.5;
    self.centerButton.centerY = self.height * 0.2;

    CGFloat tabbarButtonW = self.width / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
          
            child.width = tabbarButtonW;
          
            child.x = tabbarButtonIndex * tabbarButtonW;
    
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}


- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
            animation.duration = 1;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

@end
