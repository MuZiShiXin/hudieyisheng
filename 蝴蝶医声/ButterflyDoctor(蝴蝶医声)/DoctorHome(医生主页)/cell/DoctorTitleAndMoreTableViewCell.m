//
//  DoctorTitleAndMoreTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "DoctorTitleAndMoreTableViewCell.h"
#import "GatoBaseHelp.h"

@interface DoctorTitleAndMoreTableViewCell ()
@property (nonatomic ,strong) UIImageView * image;
@property (nonatomic ,strong) UILabel * title;
@property (nonatomic ,strong) UILabel * moreLabel;

@end
@implementation DoctorTitleAndMoreTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DoctorTitleAndMoreTableViewCell";
    DoctorTitleAndMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorTitleAndMoreTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithImage:(NSString *)imageName WithTitle:(NSString *)titleStr WithMoreStr:(NSString *)moreStr
{
    self.image.image = [UIImage imageNamed:imageName];
    self.title.text = titleStr;
    self.moreLabel.text = moreStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self,-1)
    .rightSpaceToView(self,-1)
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(10));
    
    GatoViewBorderRadius(fgx, 0, Gato_Height_548_(0.5), [UIColor HDViewBackColor]);
    
    
    
    self.image.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(fgx,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(11))
    .heightIs(Gato_Height_548_(11));
    
    self.title.sd_layout.leftSpaceToView(self.image,Gato_Width_320_(5))
    .topSpaceToView(fgx,0)
    .widthIs(Gato_Width)
    .heightIs(Gato_Height_548_(41));
    
    self.moreLabel.sd_layout.rightSpaceToView(self,Gato_Width_320_(22))
    .topSpaceToView(fgx,0)
    .widthIs(Gato_Width)
    .heightIs(Gato_Height_548_(41));
    
    UIImageView * jiantou = [[UIImageView alloc]init];
    jiantou.image = [UIImage imageNamed:@"more"];
    [self addSubview:jiantou];
    jiantou.sd_layout.rightSpaceToView(self,Gato_Width_320_(8))
    .centerYEqualToView(self.moreLabel)
    .widthIs(Gato_Width_320_(6))
    .heightIs(Gato_Width_320_(11));
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(fgx,0)
    .heightIs(Gato_Height_548_(41));
    
//    UIView * fgx2 = [[UIView alloc]init];
//    fgx2.backgroundColor = [UIColor HDViewBackColor];
//    [self addSubview:fgx2];
//    fgx2.sd_layout.leftSpaceToView(self,-1)
//    .rightSpaceToView(self,-1)
//    .bottomEqualToView(self)
//    .heightIs(Gato_Height_548_(0.5));
}



-(void)buttonDidClicked
{
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)moreLabel
{
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc]init];
        _moreLabel.font = FONT(30);
        _moreLabel.textAlignment = NSTextAlignmentRight;
        _moreLabel.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_moreLabel];
    }
    return _moreLabel;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT_Bold_(30);
        _title.textColor = [UIColor HDBlackColor];
        [self addSubview:_title];
    }
    return _title;
}
-(UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [self addSubview:_image];
    }
    return _image;
}
@end
