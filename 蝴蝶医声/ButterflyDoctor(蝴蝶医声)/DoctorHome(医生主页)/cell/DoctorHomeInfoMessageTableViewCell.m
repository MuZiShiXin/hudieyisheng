//
//  DoctorHomeInfoMessageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "DoctorHomeInfoMessageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface DoctorHomeInfoMessageTableViewCell ()
@property (nonatomic ,strong) UILabel * content;
@end
@implementation DoctorHomeInfoMessageTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DoctorHomeInfoMessageTableViewCell";
    DoctorHomeInfoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorHomeInfoMessageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(NSString *)model
{
    self.content.text = ModelNull(model);
    
    [self.content updateLayout];
    self.height = self.content.height + Gato_Height_548_(35);
    if (self.height < Gato_Height_548_(68)) {
        self.height = Gato_Height_548_(68);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    
    UILabel * title = [[UILabel alloc]init];
    title.text = @"医生个人简介";
    title.textColor = [UIColor HDBlackColor];
    title.font = FONT_Bold_(34);
    title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:title];
    title.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,Gato_Height_548_(11))
    .heightIs(Gato_Height_548_(20));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"honor_bg_butterflyTM"];
    [self addSubview:image];
    image.sd_layout.rightSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .widthIs(Gato_Width_320_(85))
    .heightIs(Gato_Height_548_(68));
    
    self.content.sd_layout.leftSpaceToView(self,Gato_Width_320_(14))
    .rightSpaceToView(self,Gato_Width_320_(14))
    .topSpaceToView(title,Gato_Height_548_(5))
    .autoHeightRatio(0);
    
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
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , Gato_Height_548_(0.5)));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)content
{
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.font = FONT(32);
        _content.textAlignment = NSTextAlignmentCenter;
        _content.textColor = [UIColor HDBlackColor];
        _content.numberOfLines = 0;
        [self addSubview:_content];
    }
    return _content;
}
@end
