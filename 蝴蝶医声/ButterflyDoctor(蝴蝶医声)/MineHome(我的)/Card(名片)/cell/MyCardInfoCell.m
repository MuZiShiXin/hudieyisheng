//
//  MyCardInfoCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyCardInfoCell.h"
#import "GatoBaseHelp.h"

@interface MyCardInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *underView;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *work;
@property (weak, nonatomic) IBOutlet UILabel *keshi;
@property (strong, nonatomic) UILabel *hospital;
@property (weak, nonatomic) IBOutlet UILabel *shanchang;
@property (strong, nonatomic)  UILabel *huanzhe;
@property (strong, nonatomic)  UILabel *manyi;
@property (strong, nonatomic)  UILabel *dengji;
@property (weak, nonatomic) IBOutlet UIImageView *erweima;
@property (nonatomic ,strong) UILabel * job;
@property (nonatomic ,strong) UILabel * otherLabel;
@end
@implementation MyCardInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    self.huanzhe.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(10))
    .topSpaceToView(self.shanchang,Gato_Height_548_(10))
    .rightSpaceToView(self.underView,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(20));
    
    self.manyi.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(10))
    .topSpaceToView(self.shanchang,Gato_Height_548_(10))
    .rightSpaceToView(self.underView,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(20));
    
    self.dengji.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(10))
    .topSpaceToView(self.shanchang,Gato_Height_548_(10))
    .rightSpaceToView(self.underView,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(20));
    
    self.erweima.sd_layout.centerXEqualToView(self.underView)
    .topSpaceToView(self.huanzhe,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(170))
    .heightIs(Gato_Height_548_(170));
    
    self.otherLabel.sd_layout.leftSpaceToView(self.underView, Gato_Width_320_(15))
    .rightSpaceToView(self.underView, Gato_Width_320_(15))
    .topSpaceToView(self.erweima, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(80));
    
    self.job.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(20))
    .topEqualToView(self.name)
    .heightRatioToView(self.name, 1);
    
    [self.job setSingleLineAutoResizeWithMaxWidth:100];
    GatoViewBorderRadius(self.job, 3, 0, [UIColor redColor]);
    
    self.hospital.sd_layout.leftEqualToView(self.name)
    .rightSpaceToView(self.underView, Gato_Width_320_(10))
    .topSpaceToView(self.name, Gato_Height_548_(5))
    .autoHeightRatio(0);
    
    GatoViewBorderRadius(self.photo, 3, 0, [UIColor redColor]);
    self.backgroundColor = [UIColor appAllBackColor];
}

-(void)setValueWithModel:(MyCardModel *)model
{
    if(model){
        [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        self.name.text = ModelNull(model.name) ;
//        self.work.text = ModelNull(model.work);
        //    self.keshi.text = [NSString stringWithFormat:@"%@\n%@",model.hospitalDepartment,model.hospital];
        self.hospital.text = [NSString stringWithFormat:@"%@\n%@",ModelNull(model.hospital),ModelNull(model.hospitalDepartment)];
        self.shanchang.text = ModelNull(model.speciality) ;
        self.huanzhe.text = [NSString stringWithFormat:@"患者量:%@人",ModelNull(model.patientAllCount)];
//        self.manyi.text = [NSString stringWithFormat:@"满意度:%@",ModelNull(model.satisfied)];
        self.dengji.text = [NSString stringWithFormat:@"今日患者:%@",ModelNull(model.patientTodayCount)];
        [self.erweima sd_setImageWithURL:[NSURL URLWithString:model.qrCode] placeholderImage:[UIImage imageNamed:@""]];
        self.otherLabel.text = @"郑重提示：每位患者或者是代表您的家属仅能扫描一次医疗组二维码，重复扫描成为无权限患者产生付费问题无法完成退费。";
        self.job.text = model.work;
        [self.shanchang sizeToFit];
        
        self.height = Gato_Height - Gato_Height_548_(30) - 64;
    }
    
    
}
+ (CGFloat)getHeightForCell {
    return 417.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)job
{
    if (!_job) {
        _job = [[UILabel alloc]init];
        _job.textColor = [UIColor whiteColor];
        _job.font = FONT(32);
        _job.backgroundColor = [UIColor HDTitleRedColor];
        [self.underView addSubview:_job];
    }
    return _job;
}
-(UILabel *)huanzhe
{
    if (!_huanzhe) {
        _huanzhe = [[UILabel alloc]init];
        _huanzhe.textColor = [UIColor HDTitleRedColor];
        _huanzhe.font = FONT(32);
        
        [self.underView addSubview:_huanzhe];
    }
    return _huanzhe;
}
-(UILabel *)manyi
{
    if (!_manyi) {
        _manyi = [[UILabel alloc]init];
        _manyi.textColor = [UIColor HDTitleRedColor];
        _manyi.font = FONT(32);
        _manyi.textAlignment = NSTextAlignmentCenter;
        
        [self.underView addSubview:_manyi];
    }
    return _manyi;
}
-(UILabel *)otherLabel
{
    if (!_otherLabel) {
        _otherLabel = [[UILabel alloc]init];
        _otherLabel.textColor = [UIColor HDBlackColor];
        _otherLabel.numberOfLines = 0;
        _otherLabel.font = FONT(32);
//        _otherLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.underView addSubview:_otherLabel];
    }
    return _otherLabel;
}
-(UILabel *)dengji
{
    if (!_dengji) {
        _dengji = [[UILabel alloc]init];
        _dengji.textColor = [UIColor HDTitleRedColor];
        _dengji.font = FONT(32);
        _dengji.textAlignment = NSTextAlignmentRight;
        [self.underView addSubview:_dengji];
    }
    return _dengji;
}
-(UILabel *)hospital
{
    if (!_hospital) {
        _hospital = [[UILabel alloc]init];
        _hospital.textColor = [UIColor HDBlackColor];
        _hospital.font = FONT(34);
        _hospital.numberOfLines = 0;
        [self.underView addSubview:_hospital];
    }
    return _hospital;
}

@end
