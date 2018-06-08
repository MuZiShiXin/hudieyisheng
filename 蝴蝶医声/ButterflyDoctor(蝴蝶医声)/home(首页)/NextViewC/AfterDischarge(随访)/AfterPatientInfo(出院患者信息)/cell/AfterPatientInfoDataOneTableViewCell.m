//
//  AfterPatientInfoDataOneTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AfterPatientInfoDataOneTableViewCell.h"
#import "GatoBaseHelp.h"

@interface AfterPatientInfoDataOneTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * age;
@property (nonatomic ,strong) UILabel * sex;
@property (nonatomic ,strong) UILabel * chuang;
@property (nonatomic ,strong) UILabel * bingan;
@property (nonatomic ,strong) UILabel * beizhu;
@property (nonatomic ,strong) UILabel * ruyuanshijian;//入院时间
@property (nonatomic ,strong) UILabel * fabingshi;//发病史
@property (nonatomic ,strong) UILabel * fenmian;//分娩时间
@property (nonatomic ,strong) UILabel * tizhong;//体重
@property (nonatomic ,strong) UILabel * jianchashi;//检查历史
@end
@implementation AfterPatientInfoDataOneTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AfterPatientInfoDataOneTableViewCell";
    AfterPatientInfoDataOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AfterPatientInfoDataOneTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setValueWithModel:(patientInfoNoteModel *)model
{
    self.name.text = model.name;
    self.sex.text = model.sex;
    self.age.text = [GatoMethods getStringWithLeftStr:model.age WithRightStr:@"岁"];
    self.ruyuanshijian.text = model.bedTime;
    self.fabingshi.text = model.morbidity;
    self.fenmian.text = ModelNull( model.labor);
    if (self.fenmian.text.length < 1) {
        self.fenmian.text = @"无";
    }
    self.tizhong.text = model.bmi;
    self.jianchashi.text = model.rad;
    self.chuang.text = model.bedNumber;
    self.bingan.text = model.caseNo;
    self.beizhu.text = model.remark;
    
//    [self.beizhu updateLayout];
    [self.beizhu sizeToFit];
//    [self.beizhu sizeThatFits:CGSizeMake(Gato_Width_320_(220), MAXFLOAT)];
    self.underView.height = self.beizhu.height + Gato_Height_548_(308);
    self.height = self.beizhu.height + Gato_Height_548_(321);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor appAllBackColor];
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Width_320_(13))
    .heightIs(Gato_Height_548_(328));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_icon_basic-information"];
    [self.underView addSubview:image];
    image.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(20));
    
    [self addOtherViews];
    
    self.chuang.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(56))
    .topSpaceToView(self.underView,Gato_Height_548_(30))
    .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(25));
    
    self.name.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(56))
    .topSpaceToView(self.chuang, 0)
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(25));
    
    self.sex.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(209))
    .topEqualToView(self.name)
    .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(25));
    
    self.age.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.name,0)
    .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(25));
    
    self.bingan.sd_layout.leftEqualToView(self.sex)
    .topSpaceToView(self.sex,0)
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(25));

    self.beizhu.frame = CGRectMake(Gato_Width_320_(56), Gato_Height_548_(110), Gato_Width_320_(220), Gato_Height_548_(30));
//    self.beizhu.sd_layout.leftEqualToView(self.name)
//    .rightSpaceToView(self.underView,Gato_Width_320_(16))
//    .topSpaceToView(self.age,0)
//    .minHeightIs(Gato_Height_548_(25))
//    .autoHeightRatio(0);
}
-(void)addOtherViews
{
    NSArray * labelArray = @[@"床",@"姓名",@"性别",@"年龄",@"病案号",@"备注"];
    for (int i = 0 ; i < labelArray.count ; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.font = FONT(32);
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = labelArray[i];
        [self.underView addSubview:label];
        if (i == 0) {
            label.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(14))
            .topSpaceToView(self.underView,Gato_Height_548_(30))
            .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
            .heightIs(Gato_Height_548_(25));
        }else{
            CGFloat y = (i - 1) / 2;
            label.sd_layout.leftSpaceToView(self.underView,(i - 1)% 2 * Gato_Width / 2 - (i - 1)% 2 * Gato_Width_320_(35) + Gato_Width_320_(14))
            .topSpaceToView(self.underView,y * Gato_Height_548_(25) + Gato_Height_548_(55))
            .widthIs(Gato_Width / 2)
            .heightIs(Gato_Height_548_(25));
        }
        
    }
    
    NSArray * titleArray = @[@"入院时间",@"亲属甲状\n腺癌发病史",@"初次分娩时间",@"体重指数",@"颈部放射\n线检查史"];
    NSArray * WeSelfLabelArray = @[self.ruyuanshijian,self.fabingshi,self.fenmian,self.tizhong,self.jianchashi];
    CGFloat labelHeight = Gato_Height_548_(31);//记录上次高度
    CGFloat labelY = 0;//y
    for (int i = 4 ; i < titleArray.count; i --) {
        if ( i == 1 || i == 4) {
            labelHeight = Gato_Height_548_(45);
        }else{
            labelHeight = Gato_Height_548_(31);
        }
        
        
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(30);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,- 1)
//        .topSpaceToView(self.beizhu,labelY + Gato_Height_548_(20))
        .bottomSpaceToView(self.underView, labelY )
        .widthIs(Gato_Width_320_(95))
        .heightIs(labelHeight);
        
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        
        
        
        UILabel * rightLabel = WeSelfLabelArray[i];
        rightLabel.sd_layout.rightSpaceToView(self.underView,-1)
//        .topSpaceToView(self.beizhu,labelY + Gato_Height_548_(20))
        .bottomSpaceToView(self.underView, labelY )
        .leftSpaceToView(label,0)
        .heightIs(labelHeight);
        GatoViewBorderRadius(rightLabel, 0, 1, [UIColor appAllBackColor]);
        
        
        
        labelY += labelHeight - 1;
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
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
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor HDBlackColor];
        _name.font = FONT(30);
        [self.underView addSubview:_name];
    }
    return _name;
}
-(UILabel *)age
{
    if (!_age) {
        _age = [[UILabel alloc]init];
        _age.textColor = [UIColor HDBlackColor];
        _age.font = FONT(30);
        [self.underView addSubview:_age];
    }
    return _age;
}
-(UILabel *)sex
{
    if (!_sex) {
        _sex = [[UILabel alloc]init];
        _sex.textColor = [UIColor HDBlackColor];
        _sex.font = FONT(30);
        [self.underView addSubview:_sex];
    }
    return _sex;
}
-(UILabel *)chuang
{
    if (!_chuang) {
        _chuang = [[UILabel alloc]init];
        _chuang.textColor = [UIColor HDBlackColor];
        _chuang.font = FONT(30);
        [self.underView addSubview:_chuang];
    }
    return _chuang;
}
-(UILabel *)bingan
{
    if (!_bingan) {
        _bingan = [[UILabel alloc]init];
        _bingan.textColor = [UIColor HDBlackColor];
        _bingan.font = FONT(30);
        [self.underView addSubview:_bingan];
    }
    return _bingan;
}
-(UILabel *)beizhu
{
    if (!_beizhu) {
        _beizhu = [[UILabel alloc]init];
        _beizhu.textColor = [UIColor HDBlackColor];
        _beizhu.font = FONT(30);
        _beizhu.numberOfLines = 0;
        [self.underView addSubview:_beizhu];
    }
    return _beizhu;
}

-(UILabel *)ruyuanshijian
{
    if (!_ruyuanshijian) {
        _ruyuanshijian = [[UILabel alloc]init];
        _ruyuanshijian.font = FONT(30);
        _ruyuanshijian.textColor = [UIColor HDBlackColor];
        _ruyuanshijian.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_ruyuanshijian];
    }
    return _ruyuanshijian;
}
-(UILabel *)fabingshi
{
    if (!_fabingshi) {
        _fabingshi = [[UILabel alloc]init];
        _fabingshi.font = FONT(30);
        _fabingshi.textColor = [UIColor HDBlackColor];
        _fabingshi.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_fabingshi];
    }
    return _fabingshi;
}
-(UILabel *)fenmian
{
    if (!_fenmian) {
        _fenmian = [[UILabel alloc]init];
        _fenmian.font = FONT(30);
        _fenmian.textColor = [UIColor HDBlackColor];
        _fenmian.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_fenmian];
    }
    return _fenmian;
}
-(UILabel *)tizhong
{
    if (!_tizhong) {
        _tizhong = [[UILabel alloc]init];
        _tizhong.font = FONT(30);
        _tizhong.textColor = [UIColor HDBlackColor];
        _tizhong.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_tizhong];
    }
    return _tizhong;
}
-(UILabel *)jianchashi
{
    if (!_jianchashi) {
        _jianchashi = [[UILabel alloc]init];
        _jianchashi.font = FONT(30);
        _jianchashi.textColor = [UIColor HDBlackColor];
        _jianchashi.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_jianchashi];
    }
    return _jianchashi;
}


@end
