//
//  InfoDataTitleTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "InfoDataTitleTableViewCell.h"
#import "GatoBaseHelp.h"

@interface InfoDataTitleTableViewCell ()
@property (nonatomic ,strong) UIImageView * image;
@property (nonatomic ,strong) UILabel * title;
@property (nonatomic ,strong) UIImageView * jiantou;
@property (nonatomic ,strong) UILabel * centerLabel;
@end
@implementation InfoDataTitleTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"InfoDataTitleTableViewCell";
    InfoDataTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InfoDataTitleTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithImage:(NSString *)imageStr WithTitle:(NSString *)titleStr
{
    self.image.image = [UIImage imageNamed:imageStr];
    self.title.text = titleStr;
    if (!imageStr) {
        self.title.sd_layout.leftSpaceToView(self,Gato_Width_320_(15));
    }
    if ([titleStr isEqualToString:@"姓名"]) {
        self.jiantou.hidden = YES;
    }
}

-(void)setValueWithCenter:(NSString *)center
{
    self.centerLabel.text = center;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    self.height = Gato_Height_548_(43);
    
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
    
    self.centerLabel.sd_layout.rightSpaceToView(self.jiantou,Gato_Width_320_(10))
    .topSpaceToView(self,Gato_Height_548_(0))
    .bottomSpaceToView(self,Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(180));
}
-(void)jiantouHidden
{
    self.jiantou.hidden = YES;
    self.centerLabel.sd_layout.rightSpaceToView(self,Gato_Width_320_(15));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
-(UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.font = FONT(30);
        _centerLabel.textColor = [UIColor YMAppAllTitleColor];
        _centerLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_centerLabel];
    }
    return _centerLabel;
}
@end
