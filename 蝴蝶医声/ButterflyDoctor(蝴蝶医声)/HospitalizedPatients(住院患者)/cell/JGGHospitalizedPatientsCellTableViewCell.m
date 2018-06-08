//
//  JGGHospitalizedPatientsCellTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/5/30.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import "JGGHospitalizedPatientsCellTableViewCell.h"
#import "GatoBaseHelp.h"
#import "HospitalizedPatientInfoModel.h"
#import "AfterDischargeModel.h"
@interface JGGHospitalizedPatientsCellTableViewCell()
@property(nonatomic,weak)UIView* firestView;//第一个view
@property(nonatomic,weak)UIView* secondView;//第二个view
@property(nonatomic,weak)UIView* thirdView;// 第三个view
@property(nonatomic,weak)UIImageView* photoImg1;//头像1
@property(nonatomic,weak)UIImageView* photoImg2;//头像2
@property(nonatomic,weak)UIImageView* photoImg3;//头像3
@property(nonatomic,weak)UILabel* nameLabel1;//名字
@property(nonatomic,weak)UILabel* nameLabel2;
@property(nonatomic,weak)UILabel* nameLabel3;

@property(nonatomic,weak)UIImageView* sexImg1;//性别
@property(nonatomic,weak)UIImageView* sexImg2;
@property(nonatomic,weak)UIImageView* sexImg3;

@property(nonatomic,weak)UILabel* ageLabel1;//年龄
@property(nonatomic,weak)UILabel* ageLabel2;
@property(nonatomic,weak)UILabel* ageLabel3;

@property(nonatomic,weak)UILabel* YLgroup1;//医疗组
@property(nonatomic,weak)UILabel* YLgroup2;
@property(nonatomic,weak)UILabel* YLgroup3;

@property(nonatomic,weak)UILabel* myPatient1;//我的患者
@property(nonatomic,weak)UILabel* myPatient2;
@property(nonatomic,weak)UILabel* myPatient3;

@property(nonatomic,weak)UILabel*BCHLabel1;//病床号
@property(nonatomic,weak)UILabel*BCHLabel2;
@property(nonatomic,weak)UILabel*BCHLabel3;

@end
@implementation JGGHospitalizedPatientsCellTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JGGHospitalizedPatientsCellTableViewCell";
    JGGHospitalizedPatientsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGGHospitalizedPatientsCellTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
     self.backgroundColor = [UIColor appAllBackColor];
//    第一个view
    self.firestView.sd_layout.leftSpaceToView(self, Gato_Width_320_(5))
    .widthIs((Gato_Width-4*Gato_Width_320_(5))/3)
    .topSpaceToView(self,Gato_Height_548_(5))
    .bottomSpaceToView(self,Gato_Height_548_(0));
    GatoViewBorderRadius(self.firestView, 5 , 1, [UIColor HDViewBackColor]);
//    第二个view
    self.secondView.sd_layout.leftSpaceToView(self.firestView, Gato_Width_320_(5))
    .widthIs((Gato_Width-4*Gato_Width_320_(5))/3)
    .topSpaceToView(self,Gato_Height_548_(5))
    .bottomSpaceToView(self,Gato_Height_548_(0));
    GatoViewBorderRadius(self.secondView, 5 , 1, [UIColor HDViewBackColor]);
//    第三个view
    self.thirdView.sd_layout.leftSpaceToView(self.secondView, Gato_Width_320_(5))
    .widthIs((Gato_Width-4*Gato_Width_320_(5))/3)
    .topSpaceToView(self,Gato_Height_548_(5))
    .bottomSpaceToView(self,Gato_Height_548_(0));
    GatoViewBorderRadius(self.thirdView, 5 , 1, [UIColor HDViewBackColor]);
    
//    第一个头像
     self.photoImg1.sd_layout.leftSpaceToView(self.firestView, Gato_Width_320_(2))
    .topSpaceToView(self.firestView, Gato_Height_548_(3))
    .widthIs(Gato_Width_320_(47))
    .heightIs(Gato_Width_320_(47));
     GatoViewBorderRadius(self.photoImg1, Gato_Width_320_(45) / 2 , 0, Gato_(198, 198, 198));
    //    第二个头像
    self.photoImg2.sd_layout.leftSpaceToView(self.secondView, Gato_Width_320_(2))
    .topSpaceToView(self.secondView, Gato_Height_548_(3))
    .widthIs(Gato_Width_320_(47))
    .heightIs(Gato_Width_320_(47));
     GatoViewBorderRadius(self.photoImg2, Gato_Width_320_(45) / 2 , 0, Gato_(198, 198, 198));
    //    第三个头像
    self.photoImg3.sd_layout.leftSpaceToView(self.thirdView, Gato_Width_320_(2))
    .topSpaceToView(self.thirdView, Gato_Height_548_(3))
    .widthIs(Gato_Width_320_(47))
    .heightIs(Gato_Width_320_(47));
     GatoViewBorderRadius(self.photoImg3, Gato_Width_320_(45) / 2 , 0, Gato_(198, 198, 198));
    

//name
    self.nameLabel1.sd_layout.leftSpaceToView(self.photoImg1, Gato_Width_320_(5))
    .topSpaceToView(self.firestView, Gato_Height_548_(10))
    .heightIs(Gato_Width_320_(20));
    [self.nameLabel1 setSingleLineAutoResizeWithMaxWidth:100];
    
    self.nameLabel2.sd_layout.leftSpaceToView(self.photoImg2, Gato_Width_320_(5))
    .topSpaceToView(self.secondView, Gato_Height_548_(10))
    .heightIs(Gato_Width_320_(20));
    [self.nameLabel2 setSingleLineAutoResizeWithMaxWidth:100];

    self.nameLabel3.sd_layout.leftSpaceToView(self.photoImg3, Gato_Width_320_(5))
    .topSpaceToView(self.thirdView, Gato_Height_548_(10))
    .heightIs(Gato_Width_320_(20));
    [self.nameLabel3 setSingleLineAutoResizeWithMaxWidth:100];

//    性别
     self.sexImg1.sd_layout.leftSpaceToView(self.photoImg1, Gato_Width_320_(5))
     .topSpaceToView(self.nameLabel1, Gato_Width_320_(2))
     .widthIs(Gato_Width_320_(10))
     .heightIs(Gato_Height_548_(10));
    
    self.sexImg2.sd_layout.leftSpaceToView(self.photoImg2, Gato_Width_320_(5))
    .topSpaceToView(self.nameLabel2, Gato_Width_320_(2))
    .widthIs(Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(10));
    
    self.sexImg3.sd_layout.leftSpaceToView(self.photoImg3, Gato_Width_320_(5))
    .topSpaceToView(self.nameLabel3, Gato_Width_320_(2))
    .widthIs(Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(10));
    
//    年龄
    self.ageLabel1.sd_layout.leftSpaceToView(self.sexImg1, Gato_Width_320_(2))
    .centerYEqualToView(self.sexImg1)
    .heightIs(Gato_Height_548_(20));
    [self.ageLabel1 setSingleLineAutoResizeWithMaxWidth:100];
    
    self.ageLabel2.sd_layout.leftSpaceToView(self.sexImg2, Gato_Width_320_(2))
    .centerYEqualToView(self.sexImg2)
    .heightIs(Gato_Height_548_(20));
    [self.ageLabel2 setSingleLineAutoResizeWithMaxWidth:100];
    
    self.ageLabel3.sd_layout.leftSpaceToView(self.sexImg3, Gato_Width_320_(2))
    .centerYEqualToView(self.sexImg3)
    .heightIs(Gato_Height_548_(20));
    [self.ageLabel3 setSingleLineAutoResizeWithMaxWidth:100];
    
//    病床号
    self.BCHLabel1.sd_layout.topSpaceToView(self.ageLabel1, Gato_Width_320_(2))
    .leftSpaceToView(self.photoImg1, Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(20));
    [self.BCHLabel1 setSingleLineAutoResizeWithMaxWidth:100];
    
    self.BCHLabel2.sd_layout.topSpaceToView(self.ageLabel2, Gato_Width_320_(2))
    .leftSpaceToView(self.photoImg2, Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(20));
    [self.BCHLabel2 setSingleLineAutoResizeWithMaxWidth:100];

    
    self.BCHLabel3.sd_layout.topSpaceToView(self.ageLabel3, Gato_Width_320_(2))
    .leftSpaceToView(self.photoImg3, Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(20));
    [self.BCHLabel3 setSingleLineAutoResizeWithMaxWidth:100];


//    医疗组
    self.YLgroup1.sd_layout.leftSpaceToView(self.firestView, Gato_Width_320_(5))
    .rightSpaceToView(self.firestView, Gato_Width_320_(5))
    .topSpaceToView(self.photoImg1, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(17));
    GatoViewBorderRadius(self.YLgroup1, 5 , 1, Gato_(227, 227, 227));
    
    self.YLgroup2.sd_layout.leftSpaceToView(self.secondView, Gato_Width_320_(5))
    .rightSpaceToView(self.secondView, Gato_Width_320_(5))
    .topSpaceToView(self.photoImg2, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(17));
    GatoViewBorderRadius(self.YLgroup2, 5 , 1, Gato_(227, 227, 227));
    
    self.YLgroup3.sd_layout.leftSpaceToView(self.thirdView, Gato_Width_320_(5))
    .rightSpaceToView(self.thirdView, Gato_Width_320_(5))
    .topSpaceToView(self.photoImg3, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(17));
    GatoViewBorderRadius(self.YLgroup3, 5 , 1, Gato_(227, 227, 227));
    
//    我的患者
    self.myPatient1.sd_layout.topSpaceToView(self.YLgroup1, Gato_Width_320_(5))
    .rightSpaceToView(self.firestView, Gato_Width_320_(5))
    .leftSpaceToView(self.firestView, Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(22));
    GatoViewBorderRadius(self.myPatient1, 5 , 1, Gato_(213, 213, 213));
    
    self.myPatient2.sd_layout.topSpaceToView(self.YLgroup2, Gato_Width_320_(5))
    .rightSpaceToView(self.secondView, Gato_Width_320_(5))
    .leftSpaceToView(self.secondView, Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(22));
    GatoViewBorderRadius(self.myPatient2, 5 , 1, Gato_(213, 213, 213));
    
    self.myPatient3.sd_layout.topSpaceToView(self.YLgroup3, Gato_Width_320_(5))
    .rightSpaceToView(self.thirdView, Gato_Width_320_(5))
    .leftSpaceToView(self.thirdView, Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(22));
    GatoViewBorderRadius(self.myPatient3, 5 , 1, Gato_(213, 213, 213));
    
    
}
-(void)setValueWithArray:(NSMutableArray *)modelArray andIndex:(NSIndexPath *)indexPath
{
    HospitalizedPatientInfoModel* model=[[HospitalizedPatientInfoModel alloc]init];
    if (modelArray.count>indexPath.row*3)
    {
        model=[modelArray objectAtIndex:indexPath.row*3];
        self.nameLabel1.text=model.name;
        [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        if ([model.sex isEqualToString:@"女"]) {
            self.sexImg1.image = [UIImage imageNamed:@"image-text_icon_woman"];
        }else{
            self.sexImg1.image = [UIImage imageNamed:@"image-text_icon_man"];
        }
        self.ageLabel1.text = [NSString stringWithFormat:@"%@岁",model.age];
        self.BCHLabel1.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
        self.YLgroup1.text=@"秦华东医疗组";
        self.myPatient1.text=@"我的患者";
        if ([model.ismine isEqualToString:@"1"]) {
            [self.myPatient1 setBackgroundColor:[UIColor YMAppAllColor]];
            self.myPatient1.textColor=[UIColor whiteColor];
           
            GatoViewBorderRadius(self.myPatient1, 5 , 0, [UIColor clearColor]);
        }else{
            [self.myPatient1 setBackgroundColor:[UIColor whiteColor]];
            self.myPatient1.textColor=[UIColor appTabBarTitleColor];

             GatoViewBorderRadius(self.myPatient1, 5 , 1, Gato_(213, 213, 213));
        }
        self.firestView.tag=indexPath.row*3+123456789;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topview:)];
        [self.firestView addGestureRecognizer:tap];
    }
    else
    {
        self.firestView.hidden=YES;
    }
    if (modelArray.count>indexPath.row*3+1) {
        model=[modelArray objectAtIndex:indexPath.row*3+1];
        self.nameLabel2.text=model.name;
        [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        if ([model.sex isEqualToString:@"女"]) {
            self.sexImg2.image = [UIImage imageNamed:@"image-text_icon_woman"];
        }else{
            self.sexImg2.image = [UIImage imageNamed:@"image-text_icon_man"];
        }
        self.ageLabel2.text = [NSString stringWithFormat:@"%@岁",model.age];
        self.BCHLabel2.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
        self.YLgroup2.text=@"秦华东医疗组";
        self.myPatient2.text=@"我的患者";
        if ([model.ismine isEqualToString:@"1"]) {
            [self.myPatient2 setBackgroundColor:[UIColor YMAppAllColor]];
            self.myPatient2.textColor=[UIColor whiteColor];
          
             GatoViewBorderRadius(self.myPatient2, 5 , 0, [UIColor clearColor]);
        }else{
            [self.myPatient2 setBackgroundColor:[UIColor whiteColor]];
            self.myPatient2.textColor=[UIColor appTabBarTitleColor];
            
                GatoViewBorderRadius(self.myPatient2, 5 , 1, Gato_(213, 213, 213));
        }
        self.secondView.tag=indexPath.row*3+1+123456789;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topview:)];
        [self.secondView addGestureRecognizer:tap];
    }
    else
    {
        self.secondView.hidden=YES;
    }
    if (modelArray.count>indexPath.row*3+2)
    {
        model=[modelArray objectAtIndex:indexPath.row*3+2];
        self.nameLabel3.text=model.name;
        [self.photoImg3 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        if ([model.sex isEqualToString:@"女"]) {
            self.sexImg3.image = [UIImage imageNamed:@"image-text_icon_woman"];
        }else{
            self.sexImg3.image = [UIImage imageNamed:@"image-text_icon_man"];
        }
        self.ageLabel3.text = [NSString stringWithFormat:@"%@岁",model.age];
        self.BCHLabel3.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
        self.YLgroup3.text=@"秦华东医疗组";
        self.myPatient3.text=@"我的患者";
        if ([model.ismine isEqualToString:@"1"])
        {
            [self.myPatient3 setBackgroundColor:[UIColor YMAppAllColor]];
            self.myPatient3.textColor=[UIColor whiteColor];
              GatoViewBorderRadius(self.myPatient3, 5 , 0, [UIColor clearColor]);
        }else
        {
            [self.myPatient3 setBackgroundColor:[UIColor whiteColor]];
            self.myPatient3.textColor=[UIColor appTabBarTitleColor];
           
              GatoViewBorderRadius(self.myPatient3, 5 , 1, Gato_(213, 213, 213));
        }
        self.thirdView.tag=indexPath.row*3+2+123456789;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topview:)];
        [self.thirdView addGestureRecognizer:tap];
    }
    else
    {
        self.thirdView.hidden=YES;
    }
    
}
//随访页面进入这个方法
-(void)setValueWithSuiFangArray:(NSMutableArray *)modelArray andIndex:(NSIndexPath *)indexPath
{
    AfterDischargeModel* model=[[AfterDischargeModel alloc]init];
    if (modelArray.count>indexPath.row*3)
    {
        model=[modelArray objectAtIndex:indexPath.row*3];
        self.nameLabel1.text=model.name;
        [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        if ([model.sex isEqualToString:@"女"]) {
            self.sexImg1.image = [UIImage imageNamed:@"image-text_icon_woman"];
        }else{
            self.sexImg1.image = [UIImage imageNamed:@"image-text_icon_man"];
        }
        self.ageLabel1.text = [NSString stringWithFormat:@"%@岁",model.age];
        self.BCHLabel1.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
        self.YLgroup1.text=@"秦华东医疗组";
        self.myPatient1.text=@"我的患者";
        if ([model.ismine isEqualToString:@"1"]) {
            [self.myPatient1 setBackgroundColor:[UIColor YMAppAllColor]];
            self.myPatient1.textColor=[UIColor whiteColor];
            
            GatoViewBorderRadius(self.myPatient1, 5 , 0, [UIColor clearColor]);
        }else{
            [self.myPatient1 setBackgroundColor:[UIColor whiteColor]];
            self.myPatient1.textColor=[UIColor appTabBarTitleColor];
            
            GatoViewBorderRadius(self.myPatient1, 5 , 1, Gato_(213, 213, 213));
        }
        self.firestView.tag=indexPath.row*3+123456789;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topview:)];
        [self.firestView addGestureRecognizer:tap];
    }
    else
    {
        self.firestView.hidden=YES;
    }
    if (modelArray.count>indexPath.row*3+1) {
        model=[modelArray objectAtIndex:indexPath.row*3+1];
        self.nameLabel2.text=model.name;
        [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        if ([model.sex isEqualToString:@"女"]) {
            self.sexImg2.image = [UIImage imageNamed:@"image-text_icon_woman"];
        }else{
            self.sexImg2.image = [UIImage imageNamed:@"image-text_icon_man"];
        }
        self.ageLabel2.text = [NSString stringWithFormat:@"%@岁",model.age];
        self.BCHLabel2.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
        self.YLgroup2.text=@"秦华东医疗组";
        self.myPatient2.text=@"我的患者";
        if ([model.ismine isEqualToString:@"1"]) {
            [self.myPatient2 setBackgroundColor:[UIColor YMAppAllColor]];
            self.myPatient2.textColor=[UIColor whiteColor];
            
            GatoViewBorderRadius(self.myPatient2, 5 , 0, [UIColor clearColor]);
        }else{
            [self.myPatient2 setBackgroundColor:[UIColor whiteColor]];
            self.myPatient2.textColor=[UIColor appTabBarTitleColor];
            
            GatoViewBorderRadius(self.myPatient2, 5 , 1, Gato_(213, 213, 213));
        }
        self.secondView.tag=indexPath.row*3+1+123456789;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topview:)];
        [self.secondView addGestureRecognizer:tap];
    }
    else
    {
        self.secondView.hidden=YES;
    }
    if (modelArray.count>indexPath.row*3+2)
    {
        model=[modelArray objectAtIndex:indexPath.row*3+2];
        self.nameLabel3.text=model.name;
        [self.photoImg3 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        if ([model.sex isEqualToString:@"女"]) {
            self.sexImg3.image = [UIImage imageNamed:@"image-text_icon_woman"];
        }else{
            self.sexImg3.image = [UIImage imageNamed:@"image-text_icon_man"];
        }
        self.ageLabel3.text = [NSString stringWithFormat:@"%@岁",model.age];
        self.BCHLabel3.text = [NSString stringWithFormat:@"病床：%@",model.bedNumber];
        self.YLgroup3.text=@"秦华东医疗组";
        self.myPatient3.text=@"我的患者";
        if ([model.ismine isEqualToString:@"1"])
        {
            [self.myPatient3 setBackgroundColor:[UIColor YMAppAllColor]];
            self.myPatient3.textColor=[UIColor whiteColor];
            GatoViewBorderRadius(self.myPatient3, 5 , 0, [UIColor clearColor]);
        }else
        {
            [self.myPatient3 setBackgroundColor:[UIColor whiteColor]];
            self.myPatient3.textColor=[UIColor appTabBarTitleColor];
            
            GatoViewBorderRadius(self.myPatient3, 5 , 1, Gato_(213, 213, 213));
        }
        self.thirdView.tag=indexPath.row*3+2+123456789;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topview:)];
        [self.thirdView addGestureRecognizer:tap];
    }
    else
    {
        self.thirdView.hidden=YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)topview:(UITapGestureRecognizer*)tap
{
    if (self.tapPush) {
        self.tapPush(tap.view.tag-123456789);
    }
}
-(UIView *)firestView
{
    if (!_firestView) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        _firestView=view;
    }
    return _firestView;
}
-(UIView *)secondView
{
    if (!_secondView) {
        UIView* view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        _secondView=view;
    }
    return _secondView;
}
-(UIView*)thirdView
{
    if (!_thirdView) {
        UIView* view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        [self addSubview:view];
        _thirdView=view;
    }
    return _thirdView;
}

-(UILabel*)nameLabel1
{
    if (!_nameLabel1) {
        UILabel* label=[[UILabel alloc]init];
        label.font = FONT(20);
        label.textColor = [UIColor HDBlackColor];
        [self.firestView addSubview:label];
        _nameLabel1=label;
    }
    return _nameLabel1;
}
-(UILabel*)nameLabel2
{
    if (!_nameLabel2) {
        UILabel* label=[[UILabel alloc]init];
        label.font = FONT(20);
        label.textColor = [UIColor HDBlackColor];
        [self.secondView addSubview:label];
        _nameLabel2=label;
    }
    return _nameLabel2;
}
-(UILabel*)nameLabel3
{
    if (!_nameLabel3)
    {
        UILabel* label=[[UILabel alloc]init];
        label.font = FONT(20);
        label.textColor = [UIColor HDBlackColor];
        [self.thirdView addSubview:label];
        _nameLabel3=label;
    }
    return _nameLabel3;
}
-(UIImageView*)photoImg1
{
    if (!_photoImg1) {
        UIImageView* image=[[UIImageView alloc]init];
        [self.firestView addSubview:image];
        _photoImg1=image;
    }
    return _photoImg1;
}

-(UIImageView*)photoImg2{
    if (!_photoImg2) {
        UIImageView* image=[[UIImageView alloc]init];
        [self.secondView addSubview:image];
        _photoImg2=image;
    }
    return _photoImg2;
}

-(UIImageView*)photoImg3{
    if (!_photoImg3) {
        UIImageView* image=[[UIImageView alloc]init];
        [self.thirdView addSubview:image];
        _photoImg3=image;
    }
    return _photoImg3;
}
-(UIImageView*)sexImg1
{
    if (!_sexImg1)
    {
        UIImageView* image=[[UIImageView alloc]init];
        [self.firestView addSubview:image];
        _sexImg1=image;
    }
    return _sexImg1;
}
-(UIImageView*)sexImg2
{
    if (!_sexImg2)
    {
        UIImageView* image=[[UIImageView alloc]init];
        [self.secondView addSubview:image];
        _sexImg2=image;
    }
    return _sexImg2;
}
-(UIImageView*)sexImg3
{
    if (!_sexImg3)
    {
        UIImageView* image=[[UIImageView alloc]init];
        [self.thirdView addSubview:image];
        _sexImg3=image;
    }
    return _sexImg3;
}

-(UILabel *)ageLabel1
{
    if (!_ageLabel1) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textColor = [UIColor HDBlackColor];
        [self.firestView addSubview:age];
        _ageLabel1=age;
    }
    return _ageLabel1;
}
-(UILabel *)ageLabel2
{
    if (!_ageLabel2) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textColor = [UIColor HDBlackColor];
        [self.secondView addSubview:age];
        _ageLabel2=age;
    }
    return _ageLabel2;
}
-(UILabel *)ageLabel3
{
    if (!_ageLabel3) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textColor = [UIColor HDBlackColor];
        [self.thirdView addSubview:age];
        _ageLabel3=age;
    }
    return _ageLabel3;
}

-(UILabel *)YLgroup1
{
    if (!_YLgroup1) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textColor = [UIColor HDBlackColor];
        age.textAlignment=NSTextAlignmentCenter;
        [self.firestView addSubview:age];
        _YLgroup1=age;
    }
    return _YLgroup1;
}
-(UILabel *)YLgroup2
{
    if (!_YLgroup2) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
        age.textColor = [UIColor HDBlackColor];
        age.textAlignment=NSTextAlignmentCenter;
        [self.secondView addSubview:age];
        _YLgroup2=age;
    }
    return _YLgroup2;
}
-(UILabel *)YLgroup3
{
    if (!_YLgroup3) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
        age.textColor = [UIColor HDBlackColor];
        [self.thirdView addSubview:age];
        _YLgroup3=age;
    }
    return _YLgroup3;
}
-(UILabel *)myPatient1
{
    if (!_myPatient1) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
           age.textColor = Gato_(165, 165, 165);
           [age setBackgroundColor:[UIColor appYLAlltitleViewColor]];
        [self.firestView addSubview:age];
        _myPatient1=age;
    }
    return _myPatient1;
}
-(UILabel *)myPatient2
{
    if (!_myPatient2) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
        age.textColor = Gato_(165, 165, 165);
        [age setBackgroundColor:[UIColor appYLAlltitleViewColor]];
        [self.secondView addSubview:age];
        _myPatient2=age;
    }
    return _myPatient2;
}
-(UILabel *)myPatient3
{
    if (!_myPatient3) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
        [age setBackgroundColor:[UIColor appYLAlltitleViewColor]];
        age.textColor = Gato_(165, 165, 165);
        [self.thirdView addSubview:age];
        _myPatient3=age;
    }
    return _myPatient3;
}
-(UILabel *)BCHLabel1
{
    if (!_BCHLabel1) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
//        age.textAlignment=NSTextAlignmentCenter;
        age.textColor = [UIColor HDBlackColor];
        [self.firestView addSubview:age];
        _BCHLabel1=age;
    }
    return _BCHLabel1;
}
-(UILabel *)BCHLabel2
{
    if (!_BCHLabel2) {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
        age.textColor = [UIColor HDBlackColor];
        [self.secondView addSubview:age];
        _BCHLabel2=age;
    }
    return _BCHLabel2;
}
-(UILabel *)BCHLabel3
{
    if (!_BCHLabel3)
    {
        UILabel* age = [[UILabel alloc]init];
        age.font = FONT(20);
        age.textAlignment=NSTextAlignmentCenter;
        age.textColor = [UIColor HDBlackColor];
        [self.thirdView addSubview:age];
        _BCHLabel3=age;
    }
    return _BCHLabel3;
}
@end
