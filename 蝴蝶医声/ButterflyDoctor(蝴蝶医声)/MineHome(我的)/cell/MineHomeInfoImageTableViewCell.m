//
//  MineHomeInfoImageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MineHomeInfoImageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface MineHomeInfoImageTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;// 头像
@property (nonatomic ,strong) UILabel * name;//名字
@property (nonatomic ,strong) UILabel * job;//工作
@property (nonatomic ,strong) UILabel * hospital;//
@property (nonatomic ,strong) UILabel * huanzhe;//患者数量
@property (nonatomic ,strong) UILabel * manyi;
@property (nonatomic ,strong) UILabel * dengji; //今日患者
@property (nonatomic ,strong) UILabel * zhuYuanHuanzheZongshuLabel;//住院患者数
@property (nonatomic ,strong) UILabel * zaiXianBangZhuHuanzheLabel;//在线帮助患者
@property (nonatomic ,strong) UILabel * zongHeTuiJianLabel;//综合推荐热度
@property (nonatomic ,strong) UILabel * HotLabel;// 热label
@property (nonatomic ,strong) UILabel * hotLastLabel;//热后面的文字
@property (nonatomic ,strong) UILabel * huanZheManYiDuLabel;//患者满意度


@end
@implementation MineHomeInfoImageTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MineHomeInfoImageTableViewCell";
    MineHomeInfoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineHomeInfoImageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(MineHomeModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"default_Photo"]];
    self.name.text = ModelNull(model.name);
    self.job.text =ModelNull(model.work);
    self.hospital.text = [NSString stringWithFormat:@"%@-%@",ModelNull(model.hospital),ModelNull(model.hospitalDepartment)];
    self.huanzhe.text = [NSString stringWithFormat:@"患者总量：%@",ModelNull(model.patientAllCount)];
//    self.manyi.text = [NSString stringWithFormat:@"满意度：%@",ModelNull(model.satisfied)];
    self.dengji.text = [NSString stringWithFormat:@"今日患者：%@",ModelNull(model.patientTodayCount)];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.photo.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(80));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(40), 0, [UIColor redColor]);
    
    self.name.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,Gato_Width / 2 + Gato_Width_320_(10))
    .topSpaceToView(self.photo,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    self.job.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .heightIs(Gato_Height_548_(8));
    
    [self.job setSingleLineAutoResizeWithMaxWidth:100];
    GatoViewBorderRadius(self.job, 3, 0, [UIColor redColor]);
    
    self.hospital.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self.name,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    self.zhuYuanHuanzheZongshuLabel.sd_layout.topSpaceToView(self.hospital, Gato_Height_548_(0))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(20));
    self.zhuYuanHuanzheZongshuLabel.text=@"住院患者数：1000（近一年）";
    self.zaiXianBangZhuHuanzheLabel.sd_layout.topSpaceToView(self.zhuYuanHuanzheZongshuLabel, Gato_Height_548_(0))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(20));
    self.zaiXianBangZhuHuanzheLabel.text=@"在线帮助患者数";
    
    self.zongHeTuiJianLabel.sd_layout.topSpaceToView(self.zaiXianBangZhuHuanzheLabel, Gato_Height_548_(0))
    .leftSpaceToView(self, Gato_Width_320_(60))
    .heightIs(Gato_Height_548_(20));
    self.zongHeTuiJianLabel.text=@"综合推荐热度：4.5";
    [self.zongHeTuiJianLabel setSingleLineAutoResizeWithMaxWidth:1000];
    [GatoMethods NSMutableAttributedStringWithLabel:self.zongHeTuiJianLabel WithAllString:self.zongHeTuiJianLabel.text WithColorString:@"4.5" WithColor:Gato_(255, 83, 73)];
    
    self.HotLabel.sd_layout
    .leftSpaceToView(self.zongHeTuiJianLabel, 0)
    .heightIs(Gato_Height_548_(15))
    .centerYEqualToView(self.zongHeTuiJianLabel)
    .widthIs(Gato_Width_320_(15));
    self.HotLabel.text=@"热";
//    [self.HotLabel setSingleLineAutoResizeWithMaxWidth:100];
    GatoViewBorderRadius(self.HotLabel, 3, 0, [UIColor redColor]);
    
    self.hotLastLabel.sd_layout.topEqualToView(self.zongHeTuiJianLabel)
    .leftSpaceToView(self.HotLabel, 0)
    .rightSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(20));
    self.hotLastLabel.text=@"(近一年推荐热度)";
    
    self.huanZheManYiDuLabel.sd_layout.topSpaceToView(self.zongHeTuiJianLabel, 0)
    .leftSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(20));
    
    
//    self.huanzhe.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
//    .rightSpaceToView(self,Gato_Width_320_(15))
//    .topSpaceToView(self.hospital,Gato_Height_548_(5))
//    .heightIs(Gato_Height_548_(20));
//
//    self.manyi.sd_layout.leftEqualToView(self.huanzhe)
//    .rightEqualToView(self.huanzhe)
//    .topSpaceToView(self.hospital,Gato_Height_548_(5))
//    .heightIs(Gato_Height_548_(20));
//
//    self.dengji.sd_layout.leftEqualToView(self.huanzhe)
//    .rightEqualToView(self.huanzhe)
//    .topSpaceToView(self.hospital,Gato_Height_548_(5))
//    .heightIs(Gato_Height_548_(20));
//
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)hospital
{
    if (!_hospital) {
        _hospital = [[UILabel alloc]init];
        _hospital.textColor = [UIColor HDBlackColor];
        _hospital.font = FONT(28);
        _hospital.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_hospital];
    }
    return _hospital;
}
-(UILabel *)huanzhe
{
    if (!_huanzhe) {
        _huanzhe = [[UILabel alloc]init];
        _huanzhe.textColor = [UIColor HDTitleRedColor];
        _huanzhe.font = FONT(30);
        
        [self addSubview:_huanzhe];
    }
    return _huanzhe;
}
-(UILabel *)manyi
{
    if (!_manyi) {
        _manyi = [[UILabel alloc]init];
        _manyi.textColor = [UIColor HDTitleRedColor];
        _manyi.font = FONT(30);
        _manyi.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_manyi];
    }
    return _manyi;
}
-(UILabel *)dengji
{
    if (!_dengji) {
        _dengji = [[UILabel alloc]init];
        _dengji.textColor = [UIColor HDTitleRedColor];
        _dengji.font = FONT(30);
        _dengji.textAlignment = NSTextAlignmentRight;
        [self addSubview:_dengji];
    }
    return _dengji;
}
-(UILabel *)job
{
    if (!_job) {
        _job = [[UILabel alloc]init];
        _job.textColor = [UIColor whiteColor];
        _job.font = FONT(32);
        _job.backgroundColor = [UIColor HDTitleRedColor];
        [self addSubview:_job];
    }
    return _job;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor HDBlackColor];
        _name.textAlignment = NSTextAlignmentRight;
        _name.font = FONT_Bold_(34);
        [self addSubview:_name];
    }
    return _name;
}

-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}
-(UILabel*)zhuYuanHuanzheZongshuLabel
{
    if (!_zhuYuanHuanzheZongshuLabel) {
        _zhuYuanHuanzheZongshuLabel=[[UILabel alloc]init];
        _zhuYuanHuanzheZongshuLabel.font=FONT(28);
        _zhuYuanHuanzheZongshuLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_zhuYuanHuanzheZongshuLabel];
    }
    return _zhuYuanHuanzheZongshuLabel;
}
-(UILabel*)zaiXianBangZhuHuanzheLabel
{
    if (!_zaiXianBangZhuHuanzheLabel)
    {
        _zaiXianBangZhuHuanzheLabel=[[UILabel alloc]init];
        _zaiXianBangZhuHuanzheLabel.font=FONT(28);
        _zaiXianBangZhuHuanzheLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_zaiXianBangZhuHuanzheLabel];
    }
    return _zaiXianBangZhuHuanzheLabel;
}
-(UILabel*)zongHeTuiJianLabel
{
    if (!_zongHeTuiJianLabel) {
        _zongHeTuiJianLabel=[[UILabel alloc]init];
        _zongHeTuiJianLabel.font=FONT(28);
        _zongHeTuiJianLabel.textColor=Gato_(65, 65, 65);
        _zongHeTuiJianLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:_zongHeTuiJianLabel];
    }
    return _zongHeTuiJianLabel;
}
-(UILabel*)HotLabel
{
    if (!_HotLabel) {
        _HotLabel=[[UILabel alloc]init];
        _HotLabel.font=FONT(28);
        [_HotLabel setBackgroundColor:[UIColor redColor]];
        _HotLabel.textColor=[UIColor whiteColor];
        _HotLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_HotLabel];
    }
    return _HotLabel;
}
-(UILabel*)hotLastLabel
{
    if (!_hotLastLabel) {
        _hotLastLabel=[[UILabel alloc]init];
        _hotLastLabel.font=FONT(28);
        _hotLastLabel.textAlignment=NSTextAlignmentLeft;
        _hotLastLabel.textColor=Gato_(65, 65, 65);
        [self addSubview:_hotLastLabel];
    }
    return _hotLastLabel;
}
-(UILabel*)huanZheManYiDuLabel
{
    if (!_huanZheManYiDuLabel) {
        _huanZheManYiDuLabel=[[UILabel alloc]init];
        _huanZheManYiDuLabel.textColor=Gato_(65, 65, 65);
        _huanZheManYiDuLabel.font=FONT(28);
        _huanZheManYiDuLabel.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_huanZheManYiDuLabel];
    }
    return _huanZheManYiDuLabel;
}
@end
