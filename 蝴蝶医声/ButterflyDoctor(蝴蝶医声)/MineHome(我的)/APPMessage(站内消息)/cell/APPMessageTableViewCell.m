//
//  APPMessageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "APPMessageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface APPMessageTableViewCell ()
@property (nonatomic ,strong) UIImageView * image;
@property (nonatomic ,strong) UILabel * message;
@end
@implementation APPMessageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"APPMessageTableViewCell";
    APPMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"APPMessageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(AppMessageModel *)model
{
    if ([model.isRead isEqualToString:@"0"]) {
        self.message.textColor = [UIColor HDThemeColor];
    }
    self.message.text = model.message;
//    [self.message updateLayout];

    [self.message sizeToFit];
    
    self.height = self.message.height + Gato_Height_548_(20);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.sd_layout.centerYEqualToView(self)
    .leftSpaceToView(self,Gato_Width_320_(16))
    .widthIs(Gato_Width_320_(6))
    .heightIs(Gato_Height_548_(6));
    
//    self.message.sd_layout.leftSpaceToView(self.image,Gato_Width_320_(15))
//    .rightSpaceToView(self,Gato_Width_320_(15))
//    .topSpaceToView(self,Gato_Height_548_(10))
//    .autoHeightRatio(0);
    
    self.message.frame = CGRectMake(Gato_Width_320_(37), Gato_Height_548_(10), Gato_Width - Gato_Width_320_(52), Gato_Height_548_(20));
    
    
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

-(UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        _image.backgroundColor = [UIColor HDThemeColor];
        [self addSubview:_image];
        GatoViewBorderRadius(self.image, Gato_Width_320_(3), 0, [UIColor redColor]);
    }
    return _image;
}
-(UILabel *)message
{
    if (!_message) {
        _message = [[UILabel alloc]init];
        _message.font = FONT(34);
        _message.numberOfLines = 0;
        [self addSubview:_message];
    }
    return _message;
}

@end
