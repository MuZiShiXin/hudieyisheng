//
//  releaseWorkTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "releaseWorkTableViewCell.h"
#import "GatoBaseHelp.h"

@interface releaseWorkTableViewCell ()
@property (nonatomic ,strong) UILabel * month;
@property (nonatomic ,strong) UILabel * day;
@property (nonatomic ,strong) UILabel * centerLabel;
@property (nonatomic ,strong) UILabel * shenhe;
@property (nonatomic ,strong) UIButton * bianjiButton;
@end
@implementation releaseWorkTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"releaseWorkTableViewCell";
    releaseWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"releaseWorkTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(releaseStopModel *)model
{
    self.month.text = [GatoMethods getButterflyMonthWihtNumberStr:model.beginTime];
    self.day.text = model.endTime;
    self.centerLabel.text = model.content;
    self.shenhe.text = [GatoMethods getStringWithShenheType:model.isVerify];
    self.height = self.centerLabel.height + Gato_Height_548_(52);
    if ([model.isVerify isEqualToString:@"1"]) {
        self.bianjiButton.hidden = YES;
    }
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
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , 0.5));
}
+(CGFloat)getHeight
{
    return Gato_Height_548_(95);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.month.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(35))
    .heightIs(Gato_Height_548_(20));
    
    self.day.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self.month,0)
    .widthIs(Gato_Width_320_(25))
    .heightIs(Gato_Height_548_(20));
    
    self.centerLabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(55))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self,Gato_Height_548_(15))
    .autoHeightRatio(0)
    .maxHeightIs(Gato_Height_548_(40));
    
    [self.centerLabel updateLayout];
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self,Gato_Height_548_(60))
    .heightIs(1);
    
    self.shenhe.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(fgx,0)
    .heightIs(Gato_Height_548_(32))
    .widthIs(Gato_Width_320_(150));
    
    self.bianjiButton.sd_layout.rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(fgx,Gato_Height_548_(5))
    .widthIs(Gato_Width_320_(46))
    .heightIs(Gato_Height_548_(21));
    
    GatoViewBorderRadius(self.bianjiButton, 0, 1, [UIColor HDThemeColor]);
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)bianjiButton:(UIButton *)sender
{
    if (self.workBianjiBlock) {
        self.workBianjiBlock();
    }
}
-(UIButton *)bianjiButton
{
    if (!_bianjiButton) {
        _bianjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bianjiButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [_bianjiButton setTitle:@"编辑" forState:UIControlStateNormal];
        _bianjiButton.titleLabel.font = FONT(30);
        [_bianjiButton addTarget:self action:@selector(bianjiButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bianjiButton];
    }
    return _bianjiButton;
}
-(UILabel *)shenhe
{
    if (!_shenhe) {
        _shenhe = [[UILabel alloc]init];
        _shenhe.font = FONT(30);
        _shenhe.textColor = [UIColor HDTitleRedColor];
        [self addSubview:_shenhe];
    }
    return _shenhe;
}
-(UILabel *)centerLabel
{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.font = FONT_Bold_(30);
        _centerLabel.numberOfLines = 0;
        _centerLabel.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_centerLabel];
    }
    return _centerLabel;
}

-(UILabel *)day
{
    if (!_day) {
        _day = [[UILabel alloc]init];
        _day.textColor = [UIColor HDBlackColor];
        _day.font = FONT(22);
        [self addSubview:_day];
    }
    return _day;
}
-(UILabel *)month
{
    if (!_month) {
        _month = [[UILabel alloc]init];
        _month.textColor = [UIColor HDBlackColor];
        _month.font = FONT(22);
        [self addSubview:_month];
    }
    return _month;
}
@end
