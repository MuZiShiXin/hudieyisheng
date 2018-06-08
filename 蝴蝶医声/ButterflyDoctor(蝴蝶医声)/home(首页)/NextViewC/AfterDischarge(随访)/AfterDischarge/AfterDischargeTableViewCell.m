//
//  AfterDischargeTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AfterDischargeTableViewCell.h"
#import "GatoBaseHelp.h"

@interface AfterDischargeTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * sex;
@property (nonatomic ,strong) UIImageView * jiantou;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * age;
@property (nonatomic ,strong) UILabel * ruyuanshijian;
@property (nonatomic ,strong) UILabel * ruyuanzhenduan;
@property (nonatomic ,strong) UIButton * yihuangoutong;
@property (nonatomic ,strong) UIButton * chuyuan;
@property (nonatomic ,strong) UIButton * zhaohui;
@property (nonatomic ,strong) UIButton * myHZButton;//我的患者 按钮
@property (nonatomic ,strong) UILabel * TSHLabel;//TSH值
@property (nonatomic ,strong) UILabel * YLGroupLabel;//医疗组
@end
@implementation AfterDischargeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AfterDischargeTableViewCell";
    AfterDischargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AfterDischargeTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setValueWithModel:(AfterDischargeModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
    if ([model.sex isEqualToString:@"女"]) {
        self.sex.image = [UIImage imageNamed:@"image-text_icon_woman"];
    }else{
        self.sex.image = [UIImage imageNamed:@"image-text_icon_man"];
    }
    self.age.text = [GatoMethods getStringWithLeftStr:model.age WithRightStr:@"岁"];
//    TSH值
    if (model.lTshS.length > 0)
    {
        self.TSHLabel.text = [GatoMethods getStringWithLeftStr:@"TSH:" WithRightStr:model.lTshS];
    }
    self.TSHLabel.text=@"TSH:<0.1";
    self.ruyuanzhenduan.text = [GatoMethods getStringWithLeftStr:@"出院诊断:" WithRightStr:model.lDiagnose];
//    self.ruyuanzhenduan.text = @"出院时间出院时间出院时间";
    self.ruyuanshijian.text = [GatoMethods getStringWithLeftStr:@"出院时间:" WithRightStr:model.endTime];
    
    [self.ruyuanzhenduan sizeToFit];
    
    if ([model.ismine isEqualToString:@"1"]) {
        [self.myHZButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.myHZButton setBackgroundColor:[UIColor YMAppAllColor]];
        GatoViewBorderRadius(self.myHZButton, 3, 0, [UIColor appTabBarTitleColor]);
        self.myHZButton.hidden = NO;
    }else{
        self.myHZButton.hidden = YES;
    }
    
    CGFloat labelHeight = self.ruyuanzhenduan.height > 17.5 ? self.ruyuanzhenduan.height - 17.5 : 0;
    self.height = Gato_Height_548_(137) + labelHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(5))
    .rightSpaceToView(self,Gato_Width_320_(5))
    .topSpaceToView(self,Gato_Height_548_(5))
    .bottomSpaceToView(self,Gato_Height_548_(0));
    
    
    
    self.photo.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(8))
    .topSpaceToView(self.underView,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(55) / 2 , 0, [UIColor clearColor]);
    
    self.myHZButton.sd_layout.leftEqualToView(self.photo)
    .rightEqualToView(self.photo)
    .topSpaceToView(self.underView, Gato_Height_548_(60))
    .heightIs(Gato_Height_548_(20));
    
    self.name.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(9))
    .topEqualToView(self.photo)
    .heightIs(Gato_Height_548_(20));
    
    [self.name setSingleLineAutoResizeWithMaxWidth:100];
    
    self.sex.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .widthIs(Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(15));
    
    self.age.sd_layout.leftSpaceToView(self.sex,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .heightIs(Gato_Height_548_(20));
    
    [self.age setSingleLineAutoResizeWithMaxWidth:100];
    
    //    医疗组
    self.YLGroupLabel.sd_layout.leftSpaceToView(self.photo, Gato_Width_320_(9))
    .topSpaceToView(self.name, Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(17))
    .widthIs(Gato_Width_320_(75));
    GatoViewBorderRadius(self.YLGroupLabel, 3, 1, Gato_(226, 226, 226));
    
    self.ruyuanshijian.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.YLGroupLabel,Gato_Height_548_(5))
    .rightSpaceToView(self.underView,Gato_Width_320_(15))
    .autoHeightRatio(0);
    
//    self.ruyuanzhenduan.sd_layout.leftEqualToView(self.name)
//    .topSpaceToView(self.ruyuanshijian,Gato_Height_548_(5))
//    .rightSpaceToView(self.underView,Gato_Width_320_(15))
//    .autoHeightRatio(0);

    self.ruyuanzhenduan.frame = CGRectMake(Gato_Width_320_(72), Gato_Height_548_(77), Gato_Width_320_(235), Gato_Height_548_(30));
    
    
    self.TSHLabel.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(16))
    .topEqualToView(self.name)
    .leftSpaceToView(self.underView,Gato_Width_320_(16))
    .heightRatioToView(self.name,1);
    
    
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.underView addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(self.underView,0)
    .topSpaceToView(self.ruyuanzhenduan,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(1));
    
    self.yihuangoutong.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(7))
    .topSpaceToView(fgx,Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(148))
    .heightIs(Gato_Height_548_(30));
    
    self.chuyuan.sd_layout.leftSpaceToView(self.yihuangoutong,Gato_Width_320_(3))
    .topSpaceToView(fgx,Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(148))
    .heightIs(Gato_Height_548_(30));
    
//    self.zhaohui.sd_layout.leftSpaceToView(self.chuyuan,Gato_Width_320_(3))
//    .topSpaceToView(fgx,Gato_Height_548_(0))
//    .widthIs(Gato_Width_320_(97))
//    .heightIs(Gato_Height_548_(30));
    
    GatoViewBorderRadius(self.underView, 3, 1, [UIColor HDViewBackColor]);


    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 三个按钮点击block回调方法
-(void)buttonWithBlock:(UIButton *)sender
{
    NSInteger row = 0;
    if (sender == self.yihuangoutong) {
        row = 0;
    }else if (sender == self.chuyuan){
        row = 1;
    }else if (sender == self.zhaohui){
        row = 2;
    }
    if (self.ButtonBlock) {
        self.ButtonBlock(row);
    }
}
- (void)myhuanzheWithBlock:(UIButton *)sender
{
    NSLog(@"点击了我的患者按钮");
}
- (UIButton *)myHZButton
{
    if (!_myHZButton) {
        _myHZButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myHZButton setTitle:@"我的患者" forState:UIControlStateNormal];
        [_myHZButton setTitleColor:[UIColor appTabBarTitleColor] forState:UIControlStateNormal];
        _myHZButton.titleLabel.font = FONT(28);
        [_myHZButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myHZButton addTarget:self action:@selector(myhuanzheWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_myHZButton];
    }
    return _myHZButton;
}

-(UIButton *)chuyuan
{
    if (!_chuyuan) {
        _chuyuan = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chuyuan setBackgroundImage:[UIImage imageNamed:@"lansebeijing"] forState:UIControlStateNormal];
        [_chuyuan setTitle:@"患者信息" forState:UIControlStateNormal];
        _chuyuan.titleLabel.font = FONT(32);
        [_chuyuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chuyuan addTarget:self action:@selector(buttonWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_chuyuan];
    }
    return _chuyuan;
}
-(UIButton *)yihuangoutong
{
    if (!_yihuangoutong) {
        _yihuangoutong = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yihuangoutong setBackgroundImage:[UIImage imageNamed:@"zisebeijing"] forState:UIControlStateNormal];
        [_yihuangoutong setTitle:@"医患沟通" forState:UIControlStateNormal];
        _yihuangoutong.titleLabel.font = FONT(32);
        [_yihuangoutong setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yihuangoutong addTarget:self action:@selector(buttonWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_yihuangoutong];
    }
    return _yihuangoutong;
}
-(UIButton *)zhaohui
{
    if (!_zhaohui) {
        _zhaohui = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhaohui setBackgroundImage:[UIImage imageNamed:@"lansebeijing"] forState:UIControlStateNormal];
        [_zhaohui setTitle:@"召回患者" forState:UIControlStateNormal];
        _zhaohui.titleLabel.font = FONT(32);
        [_zhaohui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zhaohui addTarget:self action:@selector(buttonWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_zhaohui];
    }
    return _zhaohui;
}
-(UILabel *)ruyuanshijian
{
    if (!_ruyuanshijian) {
        _ruyuanshijian = [[UILabel alloc]init];
        _ruyuanshijian.font = FONT(30);
        _ruyuanshijian.textColor = [UIColor YMAppAllTitleColor];
        [self.underView addSubview:_ruyuanshijian];
    }
    return _ruyuanshijian;
}
-(UILabel *)ruyuanzhenduan
{
    if (!_ruyuanzhenduan) {
        _ruyuanzhenduan = [[UILabel alloc]init];
        _ruyuanzhenduan.font = FONT(30);
        _ruyuanzhenduan.textColor = [UIColor YMAppAllTitleColor];
        _ruyuanzhenduan.numberOfLines = 0;
        [self.underView addSubview:_ruyuanzhenduan];
    }
    return _ruyuanzhenduan;
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT(32);
        _name.textColor = [UIColor HDBlackColor];
        [self.underView addSubview:_name];
    }
    return _name;
}
-(UILabel *)age
{
    if (!_age) {
        _age = [[UILabel alloc]init];
        _age.font = FONT(30);
        _age.textColor = [UIColor HDBlackColor];
        [self.underView addSubview:_age];
    }
    return _age;
}
-(UIImageView *)sex
{
    if (!_sex) {
        _sex = [[UIImageView alloc]init];
        [self.underView addSubview:_sex];
    }
    return _sex;
}
-(UIImageView *)jiantou
{
    if (!_jiantou) {
        _jiantou = [[UIImageView alloc]init];
        _jiantou.image = [UIImage imageNamed:@"more"];
        [self.underView addSubview:_jiantou];
    }
    return _jiantou;
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self.underView addSubview:_photo];
    }
    return _photo;
}
-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_underView];
    }
    return _underView;
}
-(UILabel *)TSHLabel
{
    if (!_TSHLabel) {
        _TSHLabel = [[UILabel alloc]init];
        _TSHLabel.font = FONT(30);
//        _tshLabel.textColor = [UIColor YMAppAllTitleColor];
        _TSHLabel.textAlignment = NSTextAlignmentRight;
        [self.underView addSubview:_TSHLabel];
    }
    return _TSHLabel;
}
-(UILabel *)YLGroupLabel
{
    if (!_YLGroupLabel) {
        _YLGroupLabel = [[UILabel alloc]init];
        _YLGroupLabel.font = FONT(20);
        _YLGroupLabel.textColor = [UIColor HDBlackColor];
        _YLGroupLabel.text=@"秦华东医疗组";
        _YLGroupLabel.textAlignment=NSTextAlignmentCenter;
        [self.underView addSubview:_YLGroupLabel];
    }
    return _YLGroupLabel;
}
@end
