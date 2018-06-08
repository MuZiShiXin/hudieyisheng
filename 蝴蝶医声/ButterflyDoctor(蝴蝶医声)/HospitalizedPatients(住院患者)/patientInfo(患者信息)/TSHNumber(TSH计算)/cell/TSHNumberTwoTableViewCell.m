//
//  TSHNumberTwoTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TSHNumberTwoTableViewCell.h"

#import "GatoBaseHelp.h"

#define imageTag 4270940

@interface TSHNumberTwoTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIButton * diButton;
@property (nonatomic ,strong) UIButton * zhongButton;
@property (nonatomic ,strong) UIButton * gaoButton;
@property (nonatomic ,strong) UIImageView * yesImage;
@end

@implementation TSHNumberTwoTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TSHNumberTwoTableViewCell";
    TSHNumberTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TSHNumberTwoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self newFrame];
}
-(void)newFrame
{
    self.backgroundColor = [UIColor appAllBackColor];
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,Gato_Height_548_(16))
    .rightSpaceToView(self,Gato_Width_320_(12))
    .bottomSpaceToView(self,0);
    
    GatoViewBorderRadius(self.underView, 3, 1, [UIColor HDViewBackColor]);
    
    UIButton * topImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topImageButton setBackgroundImage:[UIImage imageNamed:@"pathology_seg"] forState:UIControlStateNormal];
    [topImageButton setTitle:@"分化型甲状腺癌（DTC）的复发危险度分层" forState:UIControlStateNormal];
    [topImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topImageButton.titleLabel.font = FONT(30);
    [self.underView addSubview:topImageButton];
    topImageButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(5))
    .topSpaceToView(self.underView,Gato_Height_548_(11))
    .rightSpaceToView(self.underView,Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(20));
    
    
    
    NSArray * titleArray = @[@"复发危险度组别",@"符合条件"];
    NSArray * centerArray = @[@"\n符合以下全部条件者 \n-无局部或远处转移 \n-所有肉眼可见的肿瘤均被彻底消除 \n-肿瘤没有侵犯周围组织 \n-肿瘤不是侵袭型的组织学亚型，并且没有血管侵犯 \n-如果该患者清甲后行全身碘显像，甲状腺床以外 没有发现碘摄取\n",@"\n符合以下任一条件者 \n-初次手术后病理检查可在镜下发现肿瘤有甲状腺 周围软组织侵犯 \n-有颈淋巴结转移或清甲后行全身 I显像发现有异 常放射性摄取 \n-肿瘤为侵袭型的组织学类型，或有血管侵犯\n",@"\n符合以下任一条件者 \n-肉眼下可见肿瘤侵犯组织周围或器官 \n-肿瘤未能完整切除，术中有残留 \n-伴有远处转移 \n-全甲状腺切除后，血清Tg水平仍较高 \n-有甲状腺癌家族史\n"];
    
    for (int i = 0 ; i < titleArray.count; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.text = titleArray[i];
        label.font = FONT_Bold_(32);
        label.numberOfLines =0;
        label.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:label];
        if (i == 0) {
            label.sd_layout.leftSpaceToView(self.underView,i * Gato_Width_320_(75))
            .topSpaceToView(self.underView,Gato_Height_548_(38))
            .widthIs(Gato_Width_320_(75))
            .heightIs(Gato_Height_548_(40));
        }else{
            label.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(75))
            .topSpaceToView(self.underView,Gato_Height_548_(38))
            .rightSpaceToView(self.underView,0)
            .heightIs(Gato_Height_548_(40));
        }
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
    }
    
    CGFloat centerLabelY = Gato_Height_548_(78);
    UILabel * label = [[UILabel alloc]init];
    label.text = centerArray[0];
    label.font = FONT(30);
    label.textColor = [UIColor YMAppAllTitleColor];
    [self.underView addSubview:label];
    label.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(75))
    .widthIs(Gato_Width - Gato_Width_320_(99))
    .topSpaceToView(self.underView,centerLabelY)
    .autoHeightRatio(0);
    GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = centerArray[1];
    label1.font = FONT(30);
    label1.textColor = [UIColor YMAppAllTitleColor];
    [self.underView addSubview:label1];
    label1.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(75))
    .widthRatioToView(label,1)
    .topSpaceToView(label,0)
    .autoHeightRatio(0);
    GatoViewBorderRadius(label1, 0, 1, [UIColor appAllBackColor]);
    
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = centerArray[2];
    label2.font = FONT(30);
    label2.textColor = [UIColor YMAppAllTitleColor];
    [self.underView addSubview:label2];
    label2.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(75))
    .widthRatioToView(label,1)
    .topSpaceToView(label1,0)
    .autoHeightRatio(0);
    GatoViewBorderRadius(label2, 0, 1, [UIColor appAllBackColor]);
    
    
    
    [self.diButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.diButton setTitle:@"低危组" forState:UIControlStateNormal];
    [self.diButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    self.diButton.titleLabel.font = FONT(32);
    self.diButton.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(label,0)
    .topEqualToView(label)
    .heightRatioToView(label,1);
    
    GatoViewBorderRadius(self.diButton, 0, 1, [UIColor appAllBackColor]);
    
    [self.zhongButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.zhongButton setTitle:@"中危组" forState:UIControlStateNormal];
    [self.zhongButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    self.zhongButton.titleLabel.font = FONT(32);
    self.zhongButton.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightRatioToView(label1,1);
    GatoViewBorderRadius(self.zhongButton, 0, 1, [UIColor appAllBackColor]);
    
    [self.gaoButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.gaoButton setTitle:@"高危组" forState:UIControlStateNormal];
    [self.gaoButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    self.gaoButton.titleLabel.font = FONT(32);
    self.gaoButton.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(label2,0)
    .topEqualToView(label2)
    .heightRatioToView(label2,1);
    GatoViewBorderRadius(self.gaoButton, 0, 1, [UIColor appAllBackColor]);
    
    
    [label updateLayout];
    [label1 updateLayout];
    [label2 updateLayout];
    self.height = centerLabelY + label.height + label1.height + label2.height + Gato_Height_548_(16);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)TypeButton:(UIButton *)sender
{
    [self.diButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.zhongButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.gaoButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"duigoukuang"] forState:UIControlStateNormal];
    NSInteger  blockInt = 0;
    if (sender == self.diButton) {
        blockInt = 0;
    }else if (sender == self.zhongButton){
        blockInt = 1;
    }else{
        blockInt = 2;
    }
    if (self.twoBlock) {
        self.twoBlock(blockInt);
    }
}
- (void)setValueWithNumberButton:(NSInteger )numberType
{
    if (numberType == 0) {
        [self.diButton setImage:[UIImage imageNamed:@"duigoukuang"] forState:UIControlStateNormal];
        [self.zhongButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
        [self.gaoButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    }else if (numberType == 1){
        [self.diButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
        [self.zhongButton setImage:[UIImage imageNamed:@"duigoukuang"] forState:UIControlStateNormal];
        [self.gaoButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    }else if (numberType == 2){
        [self.diButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
        [self.zhongButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
        [self.gaoButton setImage:[UIImage imageNamed:@"duigoukuang"] forState:UIControlStateNormal];
    }
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
-(UIButton *)diButton
{
    if (!_diButton) {
        _diButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_diButton addTarget:self action:@selector(TypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_diButton];
    }
    return _diButton;
}
-(UIButton *)zhongButton
{
    if (!_zhongButton) {
        _zhongButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhongButton addTarget:self action:@selector(TypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_zhongButton];
    }
    return _zhongButton;
}
-(UIButton *)gaoButton
{
    if (!_gaoButton) {
        _gaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gaoButton addTarget:self action:@selector(TypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_gaoButton];
    }
    return _gaoButton;
}
-(UIImageView * )yesImage
{
    if (!_yesImage) {
        _yesImage = [[UIImageView alloc]init];
        _yesImage.image = [UIImage imageNamed:@"pathology_selected"];
        [self.underView addSubview:_yesImage];
    }
    return _yesImage;
}

@end
