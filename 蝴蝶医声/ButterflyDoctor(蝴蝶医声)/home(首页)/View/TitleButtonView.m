//
//  TitleButtonView.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TitleButtonView.h"

#import "GatoBaseHelp.h"

#define buttonTag 1702241500

@interface TitleButtonView ()
{
    NSInteger nowType;
}
@property (nonatomic ,strong) UIView * underView;
@end

@implementation TitleButtonView

+ (TitleButtonView *)instanceTextView  {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TitleButtonView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)setTitleWithArray:(NSArray *)titleArray
{
    for (int i = 0 ; i < titleArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * Gato_Width / titleArray.count, 0, Gato_Width / titleArray.count, Gato_Height_548_(39));
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(28);
        
        [button addTarget:self action:@selector(buttonWithType:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = buttonTag + i;
        if (i == nowType) {
            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor appTabBarTitleColor] forState:UIControlStateNormal];
        }
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        
        
    }
    self.underView.frame = CGRectMake(0, Gato_Height_548_(39) - 2, Gato_Width / titleArray.count, 2);
}
- (void)buttonType:(NSInteger )type
{
    
    UIButton * button = (UIButton *)[self viewWithTag:type + buttonTag];
    [self buttonWithType:button];
}

-(void)buttonWithType:(UIButton *)sender
{
    for (UIButton * button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor appTabBarTitleColor] forState:UIControlStateNormal];
        }
    }
    nowType = sender.tag - buttonTag;
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 // 动画时长
                     animations:^{
                         self.underView.x = sender.x;
                     }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerBtnClicked:)]) {
        [self.delegate headerBtnClicked:sender.tag - buttonTag];
    }
}
- (IBAction)btnClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerBtnClicked:)]) {
        [self.delegate headerBtnClicked:sender.tag];
    }
}

-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor HDThemeColor];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, Gato_Height_548_(39) - 1, Gato_Width, 1)];
        view.backgroundColor = [UIColor appAllBackColor];
        [self addSubview:view];
        [self addSubview:_underView];
        nowType = 0;
    }
    return _underView;
}


@end
