//
//  MyCardShareView.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyCardShareView.h"
#import "GatoBaseHelp.h"
#import <Masonry.h>

@interface MyCardShareView ()
@property (strong, nonatomic)  UIImageView *img;
@property (strong, nonatomic)  UILabel *text;
@property (strong, nonatomic)  UIButton * blockButton;
@end

@implementation MyCardShareView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void)setUp {
    self.img = [[UIImageView alloc] init];
    [self addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.offset(0);
    }];
    
    self.text = [[UILabel alloc] init];
    self.text.font = FONT(20);
    
    [self addSubview:self.text];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.img.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.img.mas_centerX);
    }];
    
    self.blockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.blockButton addTarget:self action:@selector(blockButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.blockButton];
    self.blockButton.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
}

- (void)setValueWithImg:(NSString *)img withText:(NSString *)text {
    self.text.text = text;
    self.img.image = [UIImage imageNamed:img];
    [self.text sizeToFit];
}

-(void)blockButtonDidClicked
{
    if (self.UMBlock) {
        self.UMBlock();
    }
}

@end
