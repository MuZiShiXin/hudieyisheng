//
//  releaseStopWorkTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "releaseStopWorkTableViewCell.h"
#import "GatoBaseHelp.h"

@interface releaseStopWorkTableViewCell ()
@property (nonatomic ,strong) UILabel * month;
@property (nonatomic ,strong) UILabel * day;
@property (nonatomic ,strong) UILabel * yuanyin;
@property (nonatomic ,strong) UILabel * shijian;
@property (nonatomic ,strong) UILabel * beizhu;
@property (nonatomic ,strong) UILabel * overTime;
@property (nonatomic ,strong) UILabel * shenhe;
@property (nonatomic ,strong) UIButton * bianjiButton;
@end
@implementation releaseStopWorkTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"releaseStopWorkTableViewCell";
    releaseStopWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"releaseStopWorkTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(releaseStopModel *)model
{
    self.month.text = [GatoMethods getButterflyMonthWihtNumberStr:model.dateHead];
    self.day.text = model.dateEnd;
    self.yuanyin.text = [GatoMethods getStringWithLeftStr:@"停诊原因：" WithRightStr:model.cause];
    self.shijian.text = [GatoMethods getStringWithLeftStr:@"停诊时间：" WithRightStr:[NSString stringWithFormat:@"%@ - %@",model.beginTime,model.endTime]];
    self.beizhu.text = [GatoMethods getStringWithLeftStr:@"停诊备注：" WithRightStr:model.remark];
    [self.beizhu updateLayout];
    self.overTime.text = [GatoMethods getStringWithLeftStr:@"展示有限期至" WithRightStr:model.endTime];
    self.shenhe.text = [GatoMethods getStringWithShenheType:model.isVerify];
    if ([model.isVerify isEqualToString:@"1"]) {
        self.bianjiButton.hidden = YES;
    }
    self.height = self.beizhu.height + Gato_Height_548_(105);
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
    return Gato_Height_548_(140);
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
    
    self.yuanyin.sd_layout.leftSpaceToView(self,Gato_Width_320_(55))
    .topSpaceToView(self,Gato_Height_548_(15))
    .rightSpaceToView(self,Gato_Height_548_(15))
    .heightIs(Gato_Height_548_(20));
    
    self.shijian.sd_layout.leftEqualToView(self.yuanyin)
    .topSpaceToView(self.yuanyin,0)
    .rightSpaceToView(self,Gato_Height_548_(15))
    .heightIs(Gato_Height_548_(20));
    
    self.beizhu.sd_layout.leftEqualToView(self.yuanyin)
    .topSpaceToView(self.shijian,0)
    .rightSpaceToView(self,Gato_Height_548_(15))
    .autoHeightRatio(0);
    
    self.overTime.sd_layout.leftEqualToView(self.yuanyin)
    .topSpaceToView(self.beizhu,Gato_Height_548_(10))
    .rightEqualToView(self.yuanyin)
    .heightIs(Gato_Height_548_(20));
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self.overTime,0)
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
    if (self.StopBianjiBlock) {
        self.StopBianjiBlock();
    }
}
-(UIButton *)bianjiButton
{
    if (!_bianjiButton) {
        _bianjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bianjiButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [_bianjiButton setTitle:@"编辑" forState:UIControlStateNormal];
        _bianjiButton.titleLabel.font = FONT(32);
        [_bianjiButton addTarget:self action:@selector(bianjiButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bianjiButton];
    }
    return _bianjiButton;
}
-(UILabel *)shenhe
{
    if (!_shenhe) {
        _shenhe = [[UILabel alloc]init];
        _shenhe.font = FONT(32);
        _shenhe.textColor = [UIColor HDTitleRedColor];
        [self addSubview:_shenhe];
    }
    return _shenhe;
}
-(UILabel *)overTime
{
    if (!_overTime) {
        _overTime = [[UILabel alloc]init];
        _overTime.font = FONT(30);
        _overTime.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_overTime];
    }
    return _overTime;
}
-(UILabel *)shijian
{
    if (!_shijian) {
        _shijian = [[UILabel alloc]init];
        _shijian.font = FONT_Bold_(30);
        _shijian.textColor = [UIColor HDBlackColor];
        [self addSubview:_shijian];
    }
    return _shijian;
}
-(UILabel *)beizhu
{
    if (!_beizhu) {
        _beizhu = [[UILabel alloc]init];
        _beizhu.font = FONT_Bold_(30);
        _beizhu.textColor = [UIColor HDBlackColor];
        [self addSubview:_beizhu];
    }
    return _beizhu;
}
-(UILabel *)yuanyin
{
    if (!_yuanyin) {
        _yuanyin = [[UILabel alloc]init];
        _yuanyin.font = FONT_Bold_(30);
        _yuanyin.textColor = [UIColor HDBlackColor];
        [self addSubview:_yuanyin];
    }
    return _yuanyin;
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
