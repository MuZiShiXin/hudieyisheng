//
//  TopAnyButtonView.m
//  tongxinbao
//
//  Created by 辛书亮 on 2016/12/19.
//  Copyright © 2016年 辛书亮. All rights reserved.
//

#import "TopAnyButtonView.h"
#import "GatoBaseHelp.h"


#define labelTag 12190329
#define ButtonTag 12191329
#define ImageTag 12192329
#define viewtag 12193329 //下方分割线
@interface TopAnyButtonView ()
{
    CGFloat  width;
    CGFloat  height;
}
@property (nonatomic ,strong) NSArray * NoimageArray;
@property (nonatomic ,strong) NSArray * YesimageArray;

@property (nonatomic ,strong) UIView * fgx;
@end
@implementation TopAnyButtonView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)addAllViews
{
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    
    self.fgx = [[UIView alloc]initWithFrame:CGRectMake(0,height - Gato_Height_548_(3), Gato_Width_320_(80),Gato_Height_548_(2))];
    self.fgx.tag = viewtag;
     self.fgx.backgroundColor = [UIColor appTabbarBlueColor];
    [self addSubview:self.fgx];
    
    UIView * underfgx = [[UIView alloc]initWithFrame:CGRectMake(0, height - Gato_Height_548_(1) , width, Gato_Height_548_(1))];
    underfgx.backgroundColor = [UIColor appTabBarTitleColor];
    [self addSubview:underfgx];
}

-(void)setValueWithNoImageArray:(NSArray *)NoArray WithYesImagearray:(NSArray *)yesArray WithLabelArray:(NSArray *)labelArray WithFlag:(NSInteger )flag
{
    if (!flag) {
        flag = 0;
    }
    if (NoArray.count > 0) {
       
        self.NoimageArray = [NSArray array];
        self.YesimageArray = [NSArray array];
        self.NoimageArray = NoArray;
        self.YesimageArray = yesArray;
        for (int i = 0 ; i < NoArray.count; i ++) {
            NSInteger j = NoArray.count;
            
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(width / j * i , 0, width / j, height - Gato_Height_548_(3))];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
           
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(width / j / 2 - Gato_Width_320_(20), height / 2 -  Gato_Height_548_(30),  Gato_Width_320_(40), Gato_Height_548_(40))];
            image.tag = i + ImageTag;
            [view addSubview:image];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + Gato_Height_548_(10), width / j, Gato_Height_548_(30))];
            label.font = FONT(24);
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = i + labelTag;
            label.text = labelArray[i];
            [view addSubview:label];
            
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, width / j, height);
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + ButtonTag;
            [view addSubview:button];
            
            if (i == flag) {
                image.image = [UIImage imageNamed:yesArray[i]];
                label.textColor = [UIColor appTabbarBlueColor];
                CGRect rect = self.fgx.frame;
                rect.origin.x = image.frame.origin.x - Gato_Height_548_(20);
                self.fgx.frame = rect;
            }else{
                image.image = [UIImage imageNamed:NoArray[i]];
                label.textColor = [UIColor appTabBarTitleColor];
    
            }
            
            
        }
    }
}

-(void)buttonDidClicked:(UIButton *)sender
{
    for (int i = 0 ; i < self.YesimageArray.count; i ++) {
        UIImageView * image = (UIImageView *)[self viewWithTag:i + ImageTag];
        image.image = [UIImage imageNamed:self.NoimageArray[i]];
        
        UILabel * label = (UILabel *)[self viewWithTag:i + labelTag];
        label.textColor = [UIColor appTabBarTitleColor];
        
        
    }
    UIImageView * image = (UIImageView *)[self viewWithTag:sender.tag - ButtonTag + ImageTag];
    image.image = [UIImage imageNamed:self.YesimageArray[sender.tag - ButtonTag]];
    
    UILabel * label = [self viewWithTag:sender.tag - ButtonTag + labelTag];
    label.textColor = [UIColor appTabbarBlueColor];
    
    NSInteger j = self.NoimageArray.count;
    
    [UIView animateWithDuration:0.3 // 动画时长
                     animations:^{
                         CGRect rect = self.fgx.frame;
                         rect.origin.x = width / j * (sender.tag - ButtonTag) +  (width / j / 2 - Gato_Width_320_(20)) - Gato_Width_320_(20) ;
                         self.fgx.frame = rect;
                     }];
    
    
    if (self.topBlock) {
        self.topBlock(sender.tag - ButtonTag);
    }
}
@end
