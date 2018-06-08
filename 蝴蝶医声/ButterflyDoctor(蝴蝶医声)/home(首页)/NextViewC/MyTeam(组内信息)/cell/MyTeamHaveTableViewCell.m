//
//  MyTeamHaveTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/21.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyTeamHaveTableViewCell.h"
#import "GatoBaseHelp.h"

@interface MyTeamHaveTableViewCell ()
@property (nonatomic ,strong)UIImageView * photo;//主要头像
@property (nonatomic ,strong) UILabel * titleLabel;//
@property (nonatomic ,strong) UILabel * hospital;//
@property (nonatomic ,strong) UIImageView * backImage;
@property (nonatomic ,strong) UIImageView * jiantou;
@property (nonatomic ,strong) UILabel * redLabel;
@end
@implementation MyTeamHaveTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyTeamHaveTableViewCell";
    MyTeamHaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTeamHaveTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setValueWithTeammembersImageArray:(NSArray *)imageArray
{
    self.hospital.hidden = YES;
    self.backImage.hidden = YES;
    self.jiantou.hidden = NO;
    self.titleLabel.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(11))
    .topEqualToView(self.photo)
    .widthIs(Gato_Width_320_(200))
    .heightIs(Gato_Height_548_(20));
    for (UIImageView * image in self.subviews) {
        if ([image isKindOfClass:[UIImageView class]] && image != self.photo && image != self.jiantou) {
            [image removeFromSuperview];
        }
    }
    for (UILabel  * label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]] && label != self.titleLabel && label != self.redLabel) {
            [label removeFromSuperview];
        }
    }
    for (int i = 0 ; i < imageArray.count ; i ++) {
        if ( i < 7) {
            
            if (i == 6) {
                UILabel * label = [[UILabel alloc]init];
                label.text = @"...";
                label.textColor = [UIColor YMAppAllTitleColor];
                [self addSubview:label];
                label.sd_layout.leftSpaceToView(self,i * Gato_Width_320_(24) + Gato_Width_320_(75))
                .topSpaceToView(self,Gato_Height_548_(43))
                .widthIs(Gato_Width_320_(22))
                .heightIs(Gato_Height_548_(22));
                
            }else{
                UIImageView * image = [[UIImageView alloc]init];
                
                [self addSubview:image];
                image.sd_layout.leftSpaceToView(self,i * Gato_Width_320_(24) + Gato_Width_320_(75))
                .topSpaceToView(self,Gato_Height_548_(43))
                .widthIs(Gato_Width_320_(22))
                .heightIs(Gato_Height_548_(22));
                GatoViewBorderRadius(image, Gato_Width_320_(22) / 2, 0, [UIColor clearColor]);
                [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
            }
        }
        
        
    }
}
-(void)setValueWithPhoto:(NSString *)photo WithTitle:(NSString *)title
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.titleLabel.text = title;
    
}
-(void)setValueWithRedLabelWithNumberstr:(NSString *)numberstr
{
    if ([numberstr isEqualToString:@"0"] || [numberstr isKindOfClass:[NSNull class]] || numberstr.length < 1) {
        self.redLabel.backgroundColor = [UIColor clearColor];
    }else{
        self.redLabel.backgroundColor = [UIColor HDTitleRedColor];
        self.redLabel.text = numberstr;
        if ([numberstr integerValue] > 99) {
            [self.redLabel sizeToFit];
        }
    }
    
}
-(void)setValueWithHospital:(NSString *)hospital
{
    self.hospital.hidden = NO;
    self.backImage.hidden = NO;
    self.jiantou.hidden = YES;
    self.hospital.text = hospital;
    self.titleLabel.sd_layout.topSpaceToView(self,Gato_Height_548_(20));
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.photo.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,Gato_Height_548_(14))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(55) / 2, 0, [UIColor clearColor]);
    
    self.titleLabel.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(11))
    .centerYEqualToView(self.photo)
    .widthIs(Gato_Width_320_(200))
    .heightIs(Gato_Height_548_(20));
    
    self.hospital.sd_layout.leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel,5)
    .heightIs(Gato_Height_548_(20));
    
    self.backImage.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
    
    self.jiantou.sd_layout.rightSpaceToView(self,Gato_Width_320_(11))
    .topSpaceToView(self,Gato_Height_548_(32))
    .widthIs(Gato_Width_320_(7))
    .heightIs(Gato_Height_548_(12));
    
//    self.redLabel.sd_layout.leftSpaceToView(self, Gato_Width_320_(59))
//    .topSpaceToView(self, Gato_Height_548_(9))
//    .widthIs(Gato_Width_320_(16))
//    .heightIs(Gato_Height_548_(16));
    self.redLabel.frame = CGRectMake(Gato_Width_320_(59), Gato_Height_548_(9), Gato_Width_320_(16), Gato_Height_548_(16));
    GatoViewBorderRadius(self.redLabel, Gato_Width_320_(16) / 2, 0, [UIColor clearColor]);
    self.redLabel.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = [UIColor appAllBackColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIImageView * )photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT(34);
        _titleLabel.textColor = [UIColor HDBlackColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)hospital
{
    if (!_hospital) {
        _hospital = [[UILabel alloc]init];
        _hospital.font = FONT(30);
        _hospital.numberOfLines = 0;
        _hospital.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_hospital];
    }
    return _hospital;
}

-(UIImageView * )backImage
{
    if (!_backImage) {
        _backImage = [[UIImageView alloc]init];
        _backImage.backgroundColor = [UIColor blackColor];
        _backImage.alpha = 0.1;
        _backImage.hidden = YES;
        [self addSubview:_backImage];
    }
    return _backImage;
}
-(UIImageView * )jiantou
{
    if (!_jiantou) {
        _jiantou = [[UIImageView alloc]init];
        _jiantou.image = [UIImage imageNamed:@"more"];
        [self addSubview:_jiantou];
    }
    return _jiantou;
}
-(UILabel *)redLabel
{
    if (!_redLabel) {
        _redLabel = [[UILabel alloc]init];
        _redLabel.backgroundColor = [UIColor HDTitleRedColor];
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.font = FONT(26);
        _redLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_redLabel];;
    }
    return _redLabel;
}
@end
