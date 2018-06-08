//
//  DoctorHomeCommentsTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "DoctorHomeCommentsTableViewCell.h"
#import "GatoBaseHelp.h"





@interface DoctorHomeCommentsTableViewCell ()

@property (nonatomic ,strong) UILabel * phoneLabel;
@property (nonatomic ,strong) UILabel * time;
@property (nonatomic ,strong) UILabel * bingyin;
@property (nonatomic ,strong) UILabel * xunzhang;
@property (nonatomic ,strong) UILabel * centerLabel;
@property (nonatomic ,strong) UIImageView * taidu;
@property (nonatomic ,strong) UIImageView * xiaoguo;
@end
@implementation DoctorHomeCommentsTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DoctorHomeCommentsTableViewCell";
    DoctorHomeCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorHomeCommentsTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = [UIColor HDViewBackColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , Gato_Height_548_(0.5)));
}

-(void)setValueWithModel:(DoctorHomePingjiaModel *)model
{
    if ([model isKindOfClass:[DoctorHomePingjiaModel class]]) {
        
        self.phoneLabel.text = [NSString stringWithFormat:@"%@(评论)",model.patientId];
        self.time.text = model.time;
        self.bingyin.text = [NSString stringWithFormat:@"所患疾病：%@",model.diagnose];
//        self.xunzhang.text = [NSString stringWithFormat:@"赠送勋章：%@", ModelNull(model.medalLevel)];
        if ([model.serviceAttitude isEqualToString:@"1"]) {
            self.taidu.image = [UIImage imageNamed:@"doctor_ stars_1"];
        }else if ([model.serviceAttitude isEqualToString:@"2"]){
            self.taidu.image = [UIImage imageNamed:@"doctor_ stars_2"];
        }else if ([model.serviceAttitude isEqualToString:@"3"]){
            self.taidu.image = [UIImage imageNamed:@"doctor_ stars_3"];
        }else if ([model.serviceAttitude isEqualToString:@"4"]){
            self.taidu.image = [UIImage imageNamed:@"doctor_ stars_4"];
        }else if ([model.serviceAttitude isEqualToString:@"5"]){
            self.taidu.image = [UIImage imageNamed:@"doctor_ stars_5"];
        }
        
        if ([model.therapeuticEffect isEqualToString:@"1"]) {
            self.xiaoguo.image = [UIImage imageNamed:@"doctor_ stars_1"];
        }else if ([model.therapeuticEffect isEqualToString:@"2"]){
            self.xiaoguo.image = [UIImage imageNamed:@"doctor_ stars_2"];
        }else if ([model.therapeuticEffect isEqualToString:@"3"]){
            self.xiaoguo.image = [UIImage imageNamed:@"doctor_ stars_3"];
        }else if ([model.therapeuticEffect isEqualToString:@"4"]){
            self.xiaoguo.image = [UIImage imageNamed:@"doctor_ stars_4"];
        }else if ([model.therapeuticEffect isEqualToString:@"5"]){
            self.xiaoguo.image = [UIImage imageNamed:@"doctor_ stars_5"];
        }
        
        self.centerLabel.text = ModelNull(model.content);

    }
    if (self.bingyin.text.length > 5) {
        [GatoMethods NSMutableAttributedStringWithLabel:self.bingyin WithAllString:self.bingyin.text WithColorString:@"所患疾病：" WithColor:[UIColor YMAppAllTitleColor]];
    }
    [self.centerLabel updateLayout];
    self.height = self.centerLabel.height + Gato_Height_548_(95);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.phoneLabel.sd_layout.leftSpaceToView(self,Gato_Height_548_(10))
    .topSpaceToView(self,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(200))
    .heightIs(Gato_Height_548_(20));
    
    
    self.time.sd_layout.rightSpaceToView(self,Gato_Width_320_(10))
    .centerYEqualToView(self.phoneLabel)
    .widthIs(Gato_Width_320_(200))
    .heightIs(Gato_Height_548_(20));
    
    self.bingyin.sd_layout.leftEqualToView(self.phoneLabel)
    .topSpaceToView(self.phoneLabel,Gato_Height_548_(5))
    .widthIs(Gato_Width)
    .heightIs(Gato_Height_548_(20));
    
   
    
    UILabel * taiduL = [[UILabel alloc]init];
    taiduL.text = @"医生态度";
    taiduL.textColor = [UIColor HDTitleRedColor];
    taiduL.font = FONT(28);
    [self addSubview:taiduL];
    taiduL.sd_layout.leftEqualToView(self.phoneLabel)
    .topSpaceToView(self.bingyin,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    [taiduL setSingleLineAutoResizeWithMaxWidth:100];
    
    self.taidu.sd_layout.leftSpaceToView(taiduL,Gato_Width_320_(5))
    .centerYEqualToView(taiduL)
    .widthIs(Gato_Width_320_(34))
    .heightIs(Gato_Height_548_(7));
    
    UILabel * xiaoguoL = [[UILabel alloc]init];
    xiaoguoL.text = @"治疗效果";
    xiaoguoL.textColor = [UIColor HDTitleRedColor];
    xiaoguoL.font = FONT(28);
    [self addSubview:xiaoguoL];
    xiaoguoL.sd_layout.leftSpaceToView(self,Gato_Width_320_(110))
    .topSpaceToView(self.bingyin,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    [xiaoguoL setSingleLineAutoResizeWithMaxWidth:100];
    
    self.xiaoguo.sd_layout.leftSpaceToView(xiaoguoL,Gato_Width_320_(5))
    .centerYEqualToView(xiaoguoL)
    .widthIs(Gato_Width_320_(34))
    .heightIs(Gato_Height_548_(7));
    
    
    self.xunzhang.sd_layout.rightSpaceToView(self,Gato_Width_320_(10))
    .topEqualToView(xiaoguoL)
    .widthIs(Gato_Width_320_(200))
    .heightIs(Gato_Height_548_(20));
    
    
    self.centerLabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(10))
    .rightSpaceToView(self,Gato_Width_320_(10))
    .topSpaceToView(self.xunzhang,Gato_Height_548_(5))
    .autoHeightRatio(0);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)xiaoguo
{
    if (!_xiaoguo) {
        _xiaoguo = [[UIImageView alloc]init];
        [self addSubview:_xiaoguo];
    }
    return _xiaoguo;
}

-(UIImageView *)taidu
{
    if (!_taidu) {
        _taidu = [[UIImageView alloc]init];
        [self addSubview:_taidu];
    }
    return _taidu;
}

-(UILabel * )xunzhang
{
    if (!_xunzhang) {
        _xunzhang = [[UILabel alloc]init];
        _xunzhang.font = FONT(28);
        _xunzhang.textColor = [UIColor HDTitleRedColor];
        _xunzhang.textAlignment = NSTextAlignmentRight;
        [self addSubview:_xunzhang];
    }
    return _xunzhang;
}
-(UILabel * )centerLabel
{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.font = FONT(28);
        _centerLabel.textColor = [UIColor HDBlackColor];
        _centerLabel.numberOfLines = 0;
        [self addSubview:_centerLabel];
    }
    return _centerLabel;
}
-(UILabel * )bingyin
{
    if (!_bingyin) {
        _bingyin = [[UILabel alloc]init];
        _bingyin.font = FONT(30);
        _bingyin.textColor = [UIColor HDBlackColor];
        [self addSubview:_bingyin];
    }
    return _bingyin;
}

-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.font = FONT(28);
        _time.textAlignment = NSTextAlignmentRight;
        _time.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_time];
    }
    return _time;
}
-(UILabel * )phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.font = FONT_Bold_(30);
        _phoneLabel.textColor = [UIColor HDBlackColor];
        [self addSubview:_phoneLabel];
    }
    return _phoneLabel;
}



@end
