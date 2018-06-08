//
//  InfoDataPhotoTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "InfoDataPhotoTableViewCell.h"
#import "GatoBaseHelp.h"

@interface InfoDataPhotoTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * image;
@property (nonatomic ,strong) UILabel * title;
@property (nonatomic ,strong) UIImageView * jiantou;
@end
@implementation InfoDataPhotoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"InfoDataPhotoTableViewCell";
    InfoDataPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoDataPhotoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithImage:(NSString *)imageStr WithTitle:(NSString *)titleStr
{
    self.image.image = [UIImage imageNamed:imageStr];
    self.title.text = titleStr;
}

-(void)setvalueWithPhoto:(UIImage *)photoImage
{
    if (photoImage) {
        self.photo.image = photoImage;
    }else{
        self.photo.image = [UIImage imageNamed:@"mine_bg_default-avatar"];
    }
}
-(void)setvalueWithPhotoUrl:(NSString *)photoImageUrl
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:photoImageUrl] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.height = Gato_Height_548_(69);
    
    self.image.sd_layout.leftSpaceToView(self,Gato_Width_320_(19))
    .centerYEqualToView(self)
    .widthIs(Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(10));
    
    self.title.sd_layout.leftSpaceToView(self.image,Gato_Width_320_(18))
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .widthIs(Gato_Width_320_(200));
    
    
    self.jiantou.sd_layout.rightSpaceToView(self,Gato_Width_320_(10))
    .centerYEqualToView(self)
    .widthIs(Gato_Width_320_(7))
    .heightIs(Gato_Height_548_(12));
    
    self.photo.sd_layout.rightSpaceToView(self,Gato_Width_320_(29))
    .topSpaceToView(self,Gato_Height_548_(9))
    .widthIs(Gato_Width_320_(50))
    .heightIs(Gato_Height_548_(50));
    
    GatoViewBorderRadius(self.photo, Gato_Height_548_(25), 0, [UIColor redColor]);
    
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = Gato_(240,240,240);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}
-(UIImageView *)jiantou
{
    if (!_jiantou) {
        _jiantou = [[UIImageView alloc]init];
        _jiantou.image = [UIImage imageNamed:@"more"];
        [self addSubview:_jiantou];
    }
    return _jiantou;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT(30);
        _title.textColor = [UIColor HDBlackColor];
        [self addSubview:_title];
    }
    return _title;
}
-(UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [self addSubview:_image];
    }
    return _image;
}

@end
