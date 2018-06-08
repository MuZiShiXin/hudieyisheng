//
//  TeamImageView.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "TeamImageView.h"
#import "GatoBaseHelp.h"

@interface TeamImageView ()
{
    TeamImageModel * blockModel;
}
@property (nonatomic ,strong)UIImageView * image;
@property (nonatomic ,strong)UILabel * name;
@property (nonatomic ,strong)UIButton * button;
@end
@implementation TeamImageView

-(void)setValueWithModel:(TeamImageModel * )model
{
    blockModel = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
    
    self.image.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(42))
    .heightIs(Gato_Height_548_(42));
    GatoViewBorderRadius(self.image, Gato_Width_320_(42) / 2, 0, [UIColor redColor]);
    
    self.name.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self.image,0)
    .heightIs(Gato_Height_548_(20));
    
    self.button.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
}

-(void)buttonDidClicked
{
    if (self.imageBlock) {
        self.imageBlock(blockModel);
    }
}
-(UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [self addSubview:_image];
    }
    return _image;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = [UIColor HDBlackColor];
        _name.font = FONT(24);
        [self addSubview:_name];
    }
    return _name;
}
-(UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

@end
