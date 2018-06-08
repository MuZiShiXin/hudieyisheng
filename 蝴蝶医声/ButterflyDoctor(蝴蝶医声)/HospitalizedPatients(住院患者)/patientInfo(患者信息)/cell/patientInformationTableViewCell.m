//
//  patientInformationTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "patientInformationTableViewCell.h"
#import "GatoBaseHelp.h"

@interface patientInformationTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * age;
@property (nonatomic ,strong) UILabel * sex;
@property (nonatomic ,strong) UILabel * ruyuanshijian;//入院时间
@property (nonatomic ,strong) UILabel * fabingshi;//发病史
@property (nonatomic ,strong) UILabel * fenmian;//分娩时间
@property (nonatomic ,strong) UILabel * tizhong;//体重
@property (nonatomic ,strong) UILabel * jianchashi;//检查历史

@end
@implementation patientInformationTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"patientInformationTableViewCell";
    patientInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"patientInformationTableViewCell" owner:nil options:nil] lastObject];
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
//    ModelNull(model.morbidity)
    self.fabingshi.text = @"";
    self.fenmian.text = ModelNull(model.labor);
    if (self.fenmian.text.length < 1) {
        self.fenmian.text = @"无";
    }
    self.tizhong.text = model.bmi;
    self.jianchashi.text = model.rad;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor appAllBackColor];
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Width_320_(13))
    .heightIs(Gato_Height_548_(210));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_icon_basic-information"];
    [self.underView addSubview:image];
    image.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(20));
    
    [self addOtherViews];
    
    self.name.sd_layout.rightSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(45))
    .widthIs(Gato_Width / 2 - Gato_Width_320_(20) )
    .heightIs(Gato_Height_548_(25));
    
    self.sex.sd_layout.rightSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(70))
    .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(25));
    
    self.age.sd_layout.rightSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(95))
    .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(25));
    
}
-(void)addOtherViews
{
    NSArray * labelArray = @[@"姓名",@"性别",@"年龄"];
    for (int i = 0 ; i < labelArray.count ; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentRight;
        label.font = FONT(28);
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = labelArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,0)
        .topSpaceToView(self.underView,i * Gato_Height_548_(25) + Gato_Height_548_(45))
        .widthIs(Gato_Width / 2 - Gato_Width_320_(20))
        .heightIs(Gato_Height_548_(25));
    }
//    @[@"入院时间",@"亲属甲状\n腺癌发病史",@"初次分娩时间",@"体重指数",@"颈部放射\n线检查史"];
    NSArray * titleArray = @[@"入院时间",@"入院诊断"];
//    @[self.ruyuanshijian,self.fabingshi,self.fenmian,self.tizhong,self.jianchashi]
    NSArray * WeSelfLabelArray = @[self.ruyuanshijian,self.fabingshi];
    CGFloat labelHeight = Gato_Height_548_(31);//记录上次高度
    CGFloat labelY = 0;//y
    for (int i = 0 ; i < titleArray.count; i ++) {
//        if ( i == 1 || i == 4) {
//            labelHeight = Gato_Height_548_(45);
//        }else{
            labelHeight = Gato_Height_548_(31);
//        }
        
        
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(28);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,- 1)
        .topSpaceToView(self.underView,labelY + Gato_Height_548_(150))
        .widthIs(Gato_Width_320_(95))
        .heightIs(labelHeight);
        
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        
        
        
        UILabel * rightLabel = WeSelfLabelArray[i];
        rightLabel.sd_layout.rightSpaceToView(self.underView,-1)
        .topSpaceToView(self.underView,labelY + Gato_Height_548_(150))
        .leftSpaceToView(label,-1)
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
        _name.textColor =Gato_(115, 115, 115);
        _name.font = FONT(28);
        [self.underView addSubview:_name];
    }
    return _name;
}
-(UILabel *)age
{
    if (!_age) {
        _age = [[UILabel alloc]init];
        _age.textColor = Gato_(115, 115, 115);
        _age.font = FONT(28);
        [self.underView addSubview:_age];
    }
    return _age;
}
-(UILabel *)sex
{
    if (!_sex) {
        _sex = [[UILabel alloc]init];
        _sex.textColor =  Gato_(115, 115, 115);
        _sex.font = FONT(28);
        [self.underView addSubview:_sex];
    }
    return _sex;
}
-(UILabel *)ruyuanshijian
{
    if (!_ruyuanshijian)
    {
        _ruyuanshijian = [[UILabel alloc]init];
        _ruyuanshijian.font = FONT(28);
        _ruyuanshijian.textColor =  Gato_(121, 120, 120);
        _ruyuanshijian.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_ruyuanshijian];
    }
    return _ruyuanshijian;
}
-(UILabel *)fabingshi
{
    if (!_fabingshi) {
        _fabingshi = [[UILabel alloc]init];
        _fabingshi.font = FONT(28);
        _fabingshi.textColor = Gato_(121, 120, 120);
        _fabingshi.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_fabingshi];
    }
    return _fabingshi;
}
-(UILabel *)fenmian
{
    if (!_fenmian) {
        _fenmian = [[UILabel alloc]init];
        _fenmian.font = FONT(32);
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
        _tizhong.font = FONT(32);
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
        _jianchashi.font = FONT(32);
        _jianchashi.textColor = [UIColor HDBlackColor];
        _jianchashi.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:_jianchashi];
    }
    return _jianchashi;
}



@end
