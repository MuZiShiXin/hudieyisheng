//
//  WaitingSurgeryTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "WaitingSurgeryTableViewCell.h"
#import "GatoBaseHelp.h"

@interface WaitingSurgeryTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * sex;
@property (nonatomic ,strong) UIImageView * jiantou;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * age;
@property (nonatomic ,strong) UILabel * chuanghao;
@property (nonatomic ,strong) UILabel * binganhao;
@property (nonatomic ,strong) UILabel * ruyuanshijian;
@property (nonatomic ,strong) UILabel * ruyuanzhenduan;
@property (nonatomic ,strong) UIButton * yihuangoutong;
@property (nonatomic ,strong) UIButton * chuyuan;
@property (nonatomic ,strong) UIButton * myHZButton;//我的患者 按钮
@property (nonatomic ,strong) UILabel * YLGroupLabel;//医疗组

@end
@implementation WaitingSurgeryTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WaitingSurgeryTableViewCell";
    WaitingSurgeryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WaitingSurgeryTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setValueWithModel:(HospitalizedPatientInfoModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
    if ([model.sex isEqualToString:@"女"]) {
        self.sex.image = [UIImage imageNamed:@"image-text_icon_woman"];
    }else{
        self.sex.image = [UIImage imageNamed:@"image-text_icon_man"];
    }
    self.age.text = [GatoMethods getStringWithLeftStr:model.age WithRightStr:@"岁"];
    self.chuanghao.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
    self.binganhao.text = [GatoMethods getStringWithLeftStr:@"病案号：" WithRightStr:model.caseNo];
    self.ruyuanzhenduan.text = [GatoMethods getStringWithLeftStr:@"入院诊断：" WithRightStr:model.diagnose];
    self.ruyuanshijian.text = [GatoMethods getStringWithLeftStr:@"入院时间：" WithRightStr:model.bedTime];
    if ([model.ismine isEqualToString:@"1"]) {
        [self.myHZButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.myHZButton setBackgroundColor:[UIColor YMAppAllColor]];
        GatoViewBorderRadius(self.myHZButton, 3, 0, [UIColor appTabBarTitleColor]);
        self.myHZButton.hidden = NO;
    }else{
        self.myHZButton.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(5))
    .rightSpaceToView(self,Gato_Width_320_(5))
    .topSpaceToView(self,Gato_Height_548_(5))
    .bottomSpaceToView(self,Gato_Height_548_(0));
    
    GatoViewBorderRadius(self.underView, 3, 1, [UIColor HDViewBackColor]);
    
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
    
    //    医疗组
    self.YLGroupLabel.sd_layout.rightSpaceToView(self.underView, Gato_Width_320_(8))
    .topEqualToView(self.photo)
    .heightIs(Gato_Height_548_(17))
    .widthIs(Gato_Width_320_(78));
    GatoViewBorderRadius(self.YLGroupLabel, 3, 1, Gato_(226, 226, 226));
    
    self.sex.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .widthIs(Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(15));
    
    self.age.sd_layout.leftSpaceToView(self.sex,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .heightIs(Gato_Height_548_(20));
    
    [self.age setSingleLineAutoResizeWithMaxWidth:100];
    
    self.chuanghao.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.name,Gato_Height_548_(5))
    .rightSpaceToView(self.underView,Gato_Width_320_(15))
    .autoHeightRatio(0);
    
    self.binganhao.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.chuanghao,Gato_Height_548_(5))
    .rightSpaceToView(self.underView,Gato_Width_320_(15))
    .autoHeightRatio(0);
    
    self.ruyuanshijian.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.binganhao,Gato_Height_548_(5))
    .rightSpaceToView(self.underView,Gato_Width_320_(15))
    .autoHeightRatio(0);
    
    self.ruyuanzhenduan.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.ruyuanshijian,Gato_Height_548_(5))
    .rightSpaceToView(self.underView,Gato_Width_320_(15))
    .autoHeightRatio(0);
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.underView addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(self.underView,0)
    .topSpaceToView(self.ruyuanzhenduan,Gato_Height_548_(15))
    .heightIs(Gato_Height_548_(1));
    
    self.yihuangoutong.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(7))
    .topSpaceToView(fgx,Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(143))
    .heightIs(Gato_Height_548_(30));
    
    self.chuyuan.sd_layout.leftSpaceToView(self.yihuangoutong,Gato_Width_320_(3))
    .topSpaceToView(fgx,Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(143))
    .heightIs(Gato_Height_548_(30));
    
    GatoViewBorderRadius(self.underView, 3, 1, [UIColor HDViewBackColor]);
    
    self.jiantou.sd_layout.centerYEqualToView(self.binganhao)
    .rightSpaceToView(self.underView, Gato_Width_320_(10))
    .widthIs(Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(20));
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(newInfoButtonDidclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.underView addSubview:button];
    button.sd_layout.rightSpaceToView(self.underView, 0)
    .topSpaceToView(self.underView, 0)
    .bottomEqualToView(fgx)
    .widthIs(Gato_Width_320_(40));
}
#pragma mark - 点击箭头跳转block
-(void)newInfoButtonDidclicked
{
    if (self.newInfo) {
        self.newInfo();
    }
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
        [_chuyuan setTitle:@"出院诊断" forState:UIControlStateNormal];
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

-(UILabel *)binganhao
{
    if (!_binganhao) {
        _binganhao = [[UILabel alloc]init];
        _binganhao.font = FONT(32);
        _binganhao.textColor = [UIColor YMAppAllTitleColor];
        [self.underView addSubview:_binganhao];
    }
    return _binganhao;
}
-(UILabel *)ruyuanshijian
{
    if (!_ruyuanshijian) {
        _ruyuanshijian = [[UILabel alloc]init];
        _ruyuanshijian.font = FONT(32);
        _ruyuanshijian.textColor = [UIColor YMAppAllTitleColor];
        [self.underView addSubview:_ruyuanshijian];
    }
    return _ruyuanshijian;
}
-(UILabel *)ruyuanzhenduan
{
    if (!_ruyuanzhenduan) {
        _ruyuanzhenduan = [[UILabel alloc]init];
        _ruyuanzhenduan.font = FONT(32);
        _ruyuanzhenduan.textColor = [UIColor YMAppAllTitleColor];
        [self.underView addSubview:_ruyuanzhenduan];
    }
    return _ruyuanzhenduan;
}
-(UILabel *)chuanghao
{
    if (!_chuanghao) {
        _chuanghao = [[UILabel alloc]init];
        _chuanghao.font = FONT(32);
        _chuanghao.textColor = [UIColor YMAppAllTitleColor];
        [self.underView addSubview:_chuanghao];
    }
    return _chuanghao;
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
        _age.font = FONT(32);
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
        _jiantou.image = [UIImage imageNamed:@"PushIcon"];
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
