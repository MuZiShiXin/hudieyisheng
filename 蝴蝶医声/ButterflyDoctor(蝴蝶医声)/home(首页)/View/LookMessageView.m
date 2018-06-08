//
//  LookMessageView.m
//  TIMChat
//
//  Created by 辛书亮 on 2017/12/23.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "LookMessageView.h"
#import "UIButton+CountDown.h"
@implementation LookMessageView


- (void)setValueWithNumber:(NSString *)number WithContent:(NSString * )content
{
    self.titleNumber.text = number;
    self.titleNumber.frame = CGRectMake(Gato_Width_320_(20), Gato_Height_548_(110), Gato_Width_320_(210), Gato_Height_548_(30));
    
    self.contentLabel.text = content;
    self.contentLabel.frame = CGRectMake(Gato_Width_320_(20), Gato_Height_548_(150), Gato_Width_320_(210), Gato_Height_548_(30));
    [GatoMethods setLineSpaceWithString:self.contentLabel WithSpacing:3];
    [self.contentLabel sizeToFit];
    
    self.returnButton.sd_layout.widthIs(Gato_Width_320_(125))
    .leftSpaceToView(self.underView, Gato_Width_320_(0))
    .topSpaceToView(self.contentLabel, Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(40));
//    GatoViewBorderRadius(self.returnButton, 0, 1, [UIColor appAllBackColor]);
    self.okButton.sd_layout.widthIs(Gato_Width_320_(125))
    .rightSpaceToView(self.underView, Gato_Width_320_(0))
    .topSpaceToView(self.contentLabel, Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(40));
//    GatoViewBorderRadius(self.okButton, 0, 1, [UIColor appAllBackColor]);
    
    
    UIView * widthFGX = [[UIView alloc]init];
    widthFGX.backgroundColor = [UIColor appAllBackColor];
    [self.underView addSubview:widthFGX];
    widthFGX.sd_layout.leftSpaceToView(self.underView, 0)
    .rightSpaceToView(self.underView, 0)
    .topEqualToView(self.returnButton)
    .heightIs(1);
    
    UIView * heightFGX = [[UIView alloc]init];
    heightFGX.backgroundColor = [UIColor appAllBackColor];
    [self.underView addSubview:heightFGX];
    heightFGX.sd_layout.leftEqualToView(self.okButton)
    .topEqualToView(widthFGX)
    .heightIs(Gato_Height_548_(40))
    .widthIs(1);
    
    
    self.underView.sd_layout.leftSpaceToView(self, Gato_Width_320_(35))
    .centerYEqualToView(self)
    .rightSpaceToView(self, Gato_Width_320_(35))
    .heightIs(self.contentLabel.height + Gato_Height_548_(210));
    GatoViewBorderRadius(self.underView, 5, 0, [UIColor redColor]);
}

- (void)okBUttonDidClicked
{
    if (self.okButtonBlock) {
        self.okButtonBlock();
    }
}
- (void)returnBUttonDidClicked
{
    exit(0);
}
- (UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_underView];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"updateImageIcon"];
        [self.underView addSubview:image];
        image.sd_layout.centerXEqualToView(self.underView)
        .topSpaceToView(self.underView, Gato_Height_548_(20))
        .widthIs(Gato_Width_320_(189 / 2))
        .heightIs(Gato_Height_548_(122 / 2));
        
        UILabel * name = [[UILabel alloc]init];
        name.text = @"版本更新";
        name.textColor = [UIColor blackColor];
        name.textAlignment =NSTextAlignmentCenter;
        name.font = FONT(40);
        [self.underView addSubview:name];
        name.sd_layout.leftSpaceToView(self.underView, 0)
        .topSpaceToView(image, 0)
        .rightSpaceToView(self.underView, 0)
        .heightIs(Gato_Height_548_(40));
        

        
    }
    return _underView;
}
- (UILabel *)titleNumber
{
    if (!_titleNumber){
        _titleNumber =[[UILabel alloc]init];
        _titleNumber.font = FONT(30);
        _titleNumber.textColor = Gato_(255,138,0);
        _titleNumber.textAlignment = NSTextAlignmentCenter;
        _titleNumber.numberOfLines = 0;
        [self.underView addSubview:_titleNumber];
    }
    return _titleNumber;
}
- (UILabel * )contentLabel
{
    if (!_contentLabel){
        _contentLabel =[[UILabel alloc]init];
        _contentLabel.font = FONT(34);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor HDBlackColor];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self.underView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIButton *)okButton
{
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_okButton setBackgroundColor:Gato_(22, 139, 235)];
        [_okButton setTitleColor:Gato_(22, 139, 235)  forState:UIControlStateNormal];
        [_okButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _okButton.titleLabel.font = FONT(30);
        [_okButton addTarget:self action:@selector(okBUttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_okButton];
    }
    return _okButton;
}
- (UIButton *)returnButton
{
    if (!_returnButton) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_returnButton setBackgroundColor:[UIColor HDBlackColor]];
        [_returnButton setTitleColor:[UIColor HDBlackColor]  forState:UIControlStateNormal];
        [_returnButton setTitle:@"退出" forState:UIControlStateNormal];
        _returnButton.titleLabel.font = FONT(30);
        [_returnButton addTarget:self action:@selector(returnBUttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_returnButton];
    }
    return _returnButton;
}
@end
