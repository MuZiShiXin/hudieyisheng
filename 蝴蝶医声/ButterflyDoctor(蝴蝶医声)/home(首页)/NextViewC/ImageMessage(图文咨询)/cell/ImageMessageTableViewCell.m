//
//  ImageMessageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ImageMessageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface ImageMessageTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIImageView * type;
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * sex;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * age;
@property (nonatomic ,strong) UILabel * chuyuanzhenduan;
@property (nonatomic ,strong) UILabel * tshLabel;
@property (nonatomic ,strong) UIButton * bingli;
@property (nonatomic ,strong) UILabel * msgTime;
@property (nonatomic ,strong) UILabel * identityType;// [0患者,1患者家属1,2患者家属2,3患者家属3]
@end
@implementation ImageMessageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ImageMessageTableViewCell";
    ImageMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImageMessageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setValueWithModel:(ImageMessageModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
    self.msgTime.text = model.msgTime;
    if ([model.sex isEqualToString:@"女"]) {
        self.sex.image = [UIImage imageNamed:@"image-text_icon_woman"];
    }else{
        self.sex.image = [UIImage imageNamed:@"image-text_icon_man"];
    }
    self.age.text = [NSString stringWithFormat:@"%@岁",model.age];
    if ([model.isLeave isEqualToString:@"0"]) {
        //未出院
        self.tshLabel.text = @"";
        self.chuyuanzhenduan.text = [GatoMethods getStringWithLeftStr:@"入院诊断：" WithRightStr:model.diagnose];
    }else{
        
        self.chuyuanzhenduan.text = [GatoMethods getStringWithLeftStr:@"出院诊断：" WithRightStr:model.lDiagnose];
    }
    if (model.lTshS.length > 0) {
        self.tshLabel.text = [GatoMethods getStringWithLeftStr:@"TSH：" WithRightStr:model.lTshS];
    }
    if ([model.isMessage isEqualToString:@"0"]) {
        self.type.hidden = YES;
    }else{
        self.type.hidden = NO;
    }
    
    [self.chuyuanzhenduan sizeToFit];
//    NSLog(@"chuyuanzhenduan.height %.2f",self.chuyuanzhenduan.height);
//    if (self.chuyuanzhenduan.height < 20) {
//        self.height = Gato_Height_548_(98);
//    }else{
//        self.height = Gato_Height_548_(150);
//    }
    if ([model.identity isEqualToString:@"0"]) {
        self.identityType.hidden = YES;
    }else{
        self.identityType.hidden = NO;
        self.identityType.text = [NSString stringWithFormat:@"家属%@",model.identity];
    }
    self.underView.height = self.chuyuanzhenduan.height + Gato_Height_548_(37) + Gato_Height_548_(35) + Gato_Height_548_(10);
    self.height = self.underView.height + Gato_Height_548_(8);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(0))
    .rightSpaceToView(self,Gato_Width_320_(0))
    .topSpaceToView(self,Gato_Height_548_(8))
    .heightIs(Gato_Height_548_(90));
    
    self.photo.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(19))
    .topSpaceToView(self.underView,Gato_Height_548_(17))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(55) / 2 , 0, [UIColor clearColor]);
    
    self.identityType.sd_layout.centerXEqualToView(self.photo)
    .topSpaceToView(self.underView, Gato_Height_548_(62))
    .widthIs(Gato_Width_320_(40))
    .heightIs(Gato_Height_548_(20));
    GatoViewBorderRadius(self.identityType, 3, 0, [UIColor redColor]);
    
    
    self.name.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(9))
    .topSpaceToView(self.underView,Gato_Height_548_(17))
    .heightIs(Gato_Height_548_(20));
    
    [self.name setSingleLineAutoResizeWithMaxWidth:100];
    
    self.sex.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .widthIs(Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(15));
    
    self.age.sd_layout.leftSpaceToView(self.sex,Gato_Width_320_(10))
    .topEqualToView(self.sex)
    .heightIs(Gato_Height_548_(20));
    
    [self.age setSingleLineAutoResizeWithMaxWidth:100];
    
//    self.chuyuanzhenduan.sd_layout.leftEqualToView(self.name)
//    .topSpaceToView(self.name,Gato_Height_548_(5))
//    .rightSpaceToView(self.underView,Gato_Width_320_(15))
//    .autoHeightRatio(0);

    self.chuyuanzhenduan.frame = CGRectMake(Gato_Width_320_(83), Gato_Height_548_(42), Gato_Width - Gato_Width_320_(98), Gato_Height_548_(20));
    self.chuyuanzhenduan.numberOfLines = 0;
    
    self.tshLabel.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(16))
    .topEqualToView(self.name)
    .leftSpaceToView(self.underView,Gato_Width_320_(16))
    .heightRatioToView(self.name,1);

    
    self.bingli.sd_layout.leftEqualToView(self.name)
    .bottomSpaceToView(self.underView, Gato_Height_548_(5))
    .widthIs(Gato_Width_320_(81))
    .heightIs(Gato_Height_548_(30));
    
    GatoViewBorderRadius(self.underView, 3, 1, [UIColor appAllBackColor]);
    
    
    self.type.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(9))
    .topSpaceToView(self.underView,0)
    .widthIs(Gato_Width_320_(9))
    .heightIs(Gato_Height_548_(20));

    self.msgTime.sd_layout.rightSpaceToView(self.underView, Gato_Width_320_(10))
    .centerYEqualToView(self.bingli)
    .widthIs(Gato_Width_320_(150))
    .heightRatioToView(self.bingli, 1);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)buttonWithBlock:(UIButton *)sender
{
    if (self.ButtonBlock) {
        self.ButtonBlock();
    }
}
- (UILabel *)identityType
{
    if (!_identityType) {
        _identityType = [[UILabel alloc]init];
        _identityType.font = FONT(28);
        _identityType.textAlignment = NSTextAlignmentCenter;
        _identityType.textColor = [UIColor whiteColor];
        _identityType.backgroundColor = [UIColor orangeColor];
        [self.underView addSubview:_identityType];
    }
    return _identityType;
}
-(UIButton *)bingli
{
    if (!_bingli) {
        _bingli = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bingli setBackgroundImage:[UIImage imageNamed:@"lansebeijing"] forState:UIControlStateNormal];
        [_bingli setTitle:@"患者病例" forState:UIControlStateNormal];
        _bingli.titleLabel.font = FONT(32);
        [_bingli setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bingli addTarget:self action:@selector(buttonWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_bingli];
    }
    return _bingli;
}


-(UILabel *)chuyuanzhenduan
{
    if (!_chuyuanzhenduan) {
        _chuyuanzhenduan = [[UILabel alloc]init];
        _chuyuanzhenduan.font = FONT(30);
        _chuyuanzhenduan.textColor = [UIColor YMAppAllTitleColor];
        [self.underView addSubview:_chuyuanzhenduan];
    }
    return _chuyuanzhenduan;
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT(30);
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
-(UILabel *)msgTime
{
    if (!_msgTime) {
        _msgTime = [[UILabel alloc]init];
        _msgTime.font = FONT(30);
        _msgTime.textColor = [UIColor appTabBarTitleColor];
        _msgTime.textAlignment = NSTextAlignmentRight;
        [self.underView addSubview:_msgTime];
    }
    return _msgTime;
}

-(UIImageView *)sex
{
    if (!_sex) {
        _sex = [[UIImageView alloc]init];
        [self.underView addSubview:_sex];
    }
    return _sex;
}
-(UIImageView *)type
{
    if (!_type) {
        _type = [[UIImageView alloc]init];
        _type.image = [UIImage imageNamed:@"image-text_icon_unread"];
        [self.underView addSubview:_type];
    }
    return _type;
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
-(UILabel *)tshLabel
{
    if (!_tshLabel) {
        _tshLabel = [[UILabel alloc]init];
        _tshLabel.font = FONT(26);
//        _tshLabel.textColor = [UIColor YMAppAllTitleColor];
        _tshLabel.textAlignment = NSTextAlignmentRight;
        [self.underView addSubview:_tshLabel];
    }
    return _tshLabel;
}

@end
