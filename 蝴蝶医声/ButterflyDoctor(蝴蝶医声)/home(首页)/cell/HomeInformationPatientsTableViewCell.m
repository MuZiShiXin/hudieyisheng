//
//  HomeInformationPatientsTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/4.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import "HomeInformationPatientsTableViewCell.h"
#import "GatoBaseHelp.h"
#import "GatoWorkLabel.h"
#import "GatoMethods.h"
@interface HomeInformationPatientsTableViewCell ()
{
    CGFloat labelHeight;
}
@property (nonatomic,strong)UILabel* allPeopleLable;// 患者总量
@property (nonatomic, strong)UILabel* todayPatientsLabel;//今日患者
@property (nonatomic, strong)UIButton* openButton;//按钮
@property (nonatomic,strong)UILabel* ZYPatientsLabel;//住院患者
@property (nonatomic,strong)UILabel* MXPatientsLabl; //门诊患者
@property (nonatomic,strong)UILabel* todayZYPatientsLabel;//今日住院患者
@property (nonatomic,strong)UILabel* todayMXPatientsLabl; //今日门诊患者


@end;
@implementation HomeInformationPatientsTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"HomeInformationPatientsTableViewCell";
    HomeInformationPatientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeInformationPatientsTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    labelHeight=16;
    self.allPeopleLable.sd_layout.topSpaceToView(self, Gato_Height_548_(5))
    .leftSpaceToView(self, Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(20));
    self.allPeopleLable.text=@"患者总量：104";
     [self.allPeopleLable setSingleLineAutoResizeWithMaxWidth:100];
    
    [GatoMethods NSMutableAttributedStringWithLabel:self.allPeopleLable WithAllString:self.allPeopleLable.text WithColorString:@"104" WithColor:Gato_(89, 174, 255)];
    
    self.todayPatientsLabel.sd_layout.topSpaceToView(self,  Gato_Height_548_(5))
    .rightSpaceToView(self, Gato_Width_320_(50))
    .heightRatioToView(self.allPeopleLable, 1);
    self.todayPatientsLabel.text=@"今日患者：58";
    [self.todayPatientsLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [GatoMethods NSMutableAttributedStringWithLabel:self.todayPatientsLabel WithAllString:self.todayPatientsLabel.text WithColorString:@"58" WithColor:Gato_(89, 174, 255)];
    
    self.openButton.sd_layout.topSpaceToView(self, Gato_Height_548_(13))
    .widthIs(Gato_Width_320_(8))
    .heightIs(Gato_Height_548_(6))
    .leftSpaceToView(self.todayPatientsLabel, Gato_Width_320_(10));
    self.openButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}
-(void)setCellH:(CGFloat)cellH
{
    NSLog(@"%f",cellH);
    
    if (cellH==25) {
        for (int i=0; i<2; i++) {
            UILabel* label=(UILabel*)[self viewWithTag:i+10086];
            [label removeFromSuperview];
            UILabel* lael1=(UILabel*)[self viewWithTag:i+100860];
            [lael1 removeFromSuperview];
        }
       [self.openButton setBackgroundImage:[UIImage imageNamed:@"ups"] forState:UIControlStateNormal];
    }
    else
    {
        [self.openButton setBackgroundImage:[UIImage imageNamed:@"down1"] forState:UIControlStateNormal];
        self.ZYPatientsLabel.sd_layout.topSpaceToView(self.allPeopleLable, Gato_Height_548_(5))
        .leftEqualToView(self.allPeopleLable)
         .heightIs(Gato_Height_548_(labelHeight));
         self.ZYPatientsLabel.text=@"住院患者总量：89";
        [self.ZYPatientsLabel setSingleLineAutoResizeWithMaxWidth:1000];
       
        [GatoMethods NSMutableAttributedStringWithLabel:self.ZYPatientsLabel WithAllString:self.ZYPatientsLabel.text WithColorString:@"89" WithColor:Gato_(89, 174, 255)];
        
        self.todayZYPatientsLabel.sd_layout.topSpaceToView(self.todayPatientsLabel, Gato_Height_548_(5))
        .leftEqualToView(self.todayPatientsLabel)
        .heightIs(Gato_Height_548_(labelHeight));
        self.todayZYPatientsLabel.text=@"今日住院患者总量：89";
        [self.todayZYPatientsLabel setSingleLineAutoResizeWithMaxWidth:1000];
        [GatoMethods NSMutableAttributedStringWithLabel:self.todayZYPatientsLabel WithAllString:self.todayZYPatientsLabel.text WithColorString:@"89" WithColor:Gato_(89, 174, 255)];
        
        [self addLeftUI];
        [self rightUI];
    }
}
-(void)addLeftUI
{
    NSArray* dataArray=@[@"- 秦华东医疗组：80",@"- 张伟峰医疗组：80"];
    if (dataArray==0) {
        self.MXPatientsLabl.sd_layout.topSpaceToView(self.ZYPatientsLabel, Gato_Height_548_(5))
        .leftEqualToView(self.ZYPatientsLabel)
         .heightIs(Gato_Height_548_(labelHeight));
        self.MXPatientsLabl.text=@"门诊患者总量：10";
        [self.MXPatientsLabl setSingleLineAutoResizeWithMaxWidth:1000];
        [GatoMethods NSMutableAttributedStringWithLabel:self.ZYPatientsLabel WithAllString:self.MXPatientsLabl.text WithColorString:@"10" WithColor:Gato_(89, 174, 255)];
    }
    else
    {
        for (int i=0; i<dataArray.count; i++)
        {
            UILabel * label = [[UILabel alloc]init];
            label.font = FONT(26);
            label.numberOfLines = 0;
            label.textColor = [UIColor YMAppAllTitleColor];
            label.text = dataArray[i];
            label.tag=i+10086;
            [self addSubview:label];

            label.sd_layout.topSpaceToView(self.ZYPatientsLabel, i * Gato_Height_548_(labelHeight))
            .leftEqualToView(self.allPeopleLable)
           .heightIs(Gato_Height_548_(labelHeight));
            [label setSingleLineAutoResizeWithMaxWidth:1000];
            [GatoMethods NSMutableAttributedStringWithLabel:label WithAllString:label.text WithColorString:@"80" WithColor:Gato_(89, 174, 255)];
        }
        self.MXPatientsLabl.sd_layout.topSpaceToView(self.ZYPatientsLabel, dataArray.count*Gato_Height_548_(labelHeight))
        .leftEqualToView(self.ZYPatientsLabel)
        .heightIs(Gato_Height_548_(labelHeight));
        self.MXPatientsLabl.text=@"门诊患者总量：10";
        [self.MXPatientsLabl setSingleLineAutoResizeWithMaxWidth:1000];
        [GatoMethods NSMutableAttributedStringWithLabel:self.MXPatientsLabl WithAllString:self.MXPatientsLabl.text WithColorString:@"10" WithColor:Gato_(89, 174, 255)];
    }
}
-(void)rightUI
{
    NSArray* dataArray=@[@"- 秦华东医疗组：80",@"- 张伟峰医疗组：80"];
    if (dataArray==0) {
        self.todayMXPatientsLabl.sd_layout.topSpaceToView(self.todayZYPatientsLabel, Gato_Height_548_(5))
        .leftEqualToView(self.todayZYPatientsLabel)
        .heightIs(Gato_Height_548_(labelHeight));
         self.todayMXPatientsLabl.text=@"今日门诊患者总量：10";
        [self.todayMXPatientsLabl setSingleLineAutoResizeWithMaxWidth:1000];
       
        [GatoMethods NSMutableAttributedStringWithLabel:self.todayMXPatientsLabl WithAllString:self.todayMXPatientsLabl.text WithColorString:@"10" WithColor:Gato_(89, 174, 255)];
    }
    else
    {
        for (int i=0; i<dataArray.count; i++)
        {
            UILabel * label = [[UILabel alloc]init];
            label.font = FONT(26);
            label.numberOfLines = 0;
            label.textColor = [UIColor YMAppAllTitleColor];
            label.text = dataArray[i];
            label.tag=i+100860;
            [self addSubview:label];
            
            label.sd_layout.topSpaceToView(self.todayZYPatientsLabel, i * Gato_Height_548_(labelHeight))
            .leftEqualToView(self.todayZYPatientsLabel)
            .heightIs(Gato_Height_548_(labelHeight));
            [label setSingleLineAutoResizeWithMaxWidth:1000];
            [GatoMethods NSMutableAttributedStringWithLabel:label WithAllString:label.text WithColorString:@"80" WithColor:Gato_(89, 174, 255)];
        }
        self.todayMXPatientsLabl.sd_layout.topSpaceToView(self.todayZYPatientsLabel, dataArray.count*Gato_Height_548_(labelHeight))
        .leftEqualToView(self.todayZYPatientsLabel)
        .heightIs(Gato_Height_548_(labelHeight));
         self.todayMXPatientsLabl.text=@"今日门诊患者总量：10";
        
        [self.todayMXPatientsLabl setSingleLineAutoResizeWithMaxWidth:1000];
       
        [GatoMethods NSMutableAttributedStringWithLabel:self.todayMXPatientsLabl WithAllString:self.todayMXPatientsLabl.text WithColorString:@"10" WithColor:Gato_(89, 174, 255)];
    }
}
-(void)openButton:(UIButton*)sender
{
   
    if (self.upcell) {
        self.upcell();
    }
    
}
-(UILabel*)allPeopleLable
{
    if (!_allPeopleLable) {
        _allPeopleLable = [[UILabel alloc]init];
        _allPeopleLable.font = FONT(26);
        [self addSubview:_allPeopleLable];
    }
    return _allPeopleLable;
}
-(UILabel*)todayPatientsLabel
{
    if (!_todayPatientsLabel) {
        _todayPatientsLabel = [[UILabel alloc]init];
        _todayPatientsLabel.font = FONT(26);
        [self addSubview:_todayPatientsLabel];
    }
    return _todayPatientsLabel;
}
- (UIButton *)openButton
{
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setBackgroundImage:[UIImage imageNamed:@"ups"] forState:UIControlStateNormal];
        [_openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_openButton];
    }
    return _openButton;
}
-(UILabel*)ZYPatientsLabel
{
    if (!_ZYPatientsLabel) {
        _ZYPatientsLabel = [[UILabel alloc]init];
        _ZYPatientsLabel.font = FONT(26);
        [self addSubview:_ZYPatientsLabel];
    }
    return _ZYPatientsLabel;
}
-(UILabel*)MXPatientsLabl
{
    if (!_MXPatientsLabl) {
        _MXPatientsLabl = [[UILabel alloc]init];
        _MXPatientsLabl.font = FONT(26);
        [self addSubview:_MXPatientsLabl];
    }
    return _MXPatientsLabl;
}
-(UILabel*)todayZYPatientsLabel
{
    if (!_todayZYPatientsLabel) {
        _todayZYPatientsLabel = [[UILabel alloc]init];
        _todayZYPatientsLabel.font = FONT(26);
        [self addSubview:_todayZYPatientsLabel];
    }
    return _todayZYPatientsLabel;
}
-(UILabel*)todayMXPatientsLabl
{
    if (!_todayMXPatientsLabl) {
        _todayMXPatientsLabl = [[UILabel alloc]init];
        _todayMXPatientsLabl.font = FONT(26);
        [self addSubview:_todayMXPatientsLabl];
    }
    return _todayMXPatientsLabl;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
