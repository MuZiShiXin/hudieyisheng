//
//  TSHNumberTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TSHNumberTableViewCell.h"
#import "GatoBaseHelp.h"
#import "UIButton+AICategory.h"

#define imageTag 4270940

@interface TSHNumberTableViewCell ()
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIButton * diButton;
@property (nonatomic ,strong) UIButton * zhongButton;
@property (nonatomic ,strong) UIButton * gaoButton;
@property (nonatomic ,strong) UIImageView * yesImage;
@end

@implementation TSHNumberTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TSHNumberTableViewCell";
    TSHNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TSHNumberTableViewCell" owner:nil options:nil] lastObject];
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
    [topImageButton setTitle:@"TSH抑制治疗的副作用风险分层" forState:UIControlStateNormal];
    [topImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topImageButton.titleLabel.font = FONT(30);
    [self.underView addSubview:topImageButton];
    topImageButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(35))
    .topSpaceToView(self.underView,Gato_Height_548_(11))
    .rightSpaceToView(self.underView,Gato_Width_320_(35))
    .heightIs(Gato_Height_548_(20));
    
    
    
    NSArray * titleArray = @[@"TSH抑制治疗的 副作用风险分层",@"适合人群"];
    NSArray * centerArray = @[@"\n符合下述所有情况： （1）中青年；（2）无症状者；（3）无心脑血管 疾病；(4)无心律失常；（5）无肾上腺素能受体激 动的症状或体征；（6）无心血管疾病危险因素； （7）无合并疾病；（8）绝经前妇女；（9）骨密 度正常；（10）无OP的危险因素\n",@"\n符合下述任一情况： （1）中年；（2）高血压；（3）有肾上腺素能受 体激动的症状或体征；(4)吸烟；（5）存在心血管 疾病危险因素或糖尿病；（6）围绝经期妇女；（7） 骨量减少；（8）存在OP的危险因素\n",@"\n符合下述任一情况： （1）临床心脏病；（2）老年；（3）绝经后妇女； (4)伴发其他严重疾病\n"];
     
    for (int i = 0 ; i < titleArray.count; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.text = titleArray[i];
        label.font = FONT_Bold_(28);
        label.numberOfLines =0;
        label.textAlignment = NSTextAlignmentCenter;
        [self.underView addSubview:label];
        if (i == 0) {
            label.sd_layout.leftSpaceToView(self.underView,i * Gato_Width_320_(75))
            .topSpaceToView(self.underView,Gato_Height_548_(38))
            .widthIs(Gato_Width_320_(75))
            .heightIs(Gato_Height_548_(60));
        }else{
            label.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(75))
            .topSpaceToView(self.underView,Gato_Height_548_(38))
            .rightSpaceToView(self.underView,0)
            .heightIs(Gato_Height_548_(60));
        }
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
    }
    
    CGFloat centerLabelY = Gato_Height_548_(98);
    
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
    [self.diButton setTitle:@"低危" forState:UIControlStateNormal];
    [self.diButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    self.diButton.titleLabel.font = FONT(32);
    self.diButton.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(label,0)
    .topEqualToView(label)
    .heightRatioToView(label,1);
    
    GatoViewBorderRadius(self.diButton, 0, 1, [UIColor appAllBackColor]);
    
    [self.zhongButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.zhongButton setTitle:@"中危" forState:UIControlStateNormal];
    [self.zhongButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    self.zhongButton.titleLabel.font = FONT(32);
    self.zhongButton.sd_layout.leftSpaceToView(self.underView,0)
    .rightSpaceToView(label1,0)
    .topEqualToView(label1)
    .heightRatioToView(label1,1);
    GatoViewBorderRadius(self.zhongButton, 0, 1, [UIColor appAllBackColor]);
    
    [self.gaoButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
    [self.gaoButton setTitle:@"高危" forState:UIControlStateNormal];
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
//    [self.underView setupAutoHeightWithBottomView:label2 bottomMargin:10];

    self.height = centerLabelY + label.height + label1.height + label2.height  + Gato_Height_548_(16);
//    self.height = self.underView.height;
    
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
    if (self.oneBlock) {
        self.oneBlock(blockInt);
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
    }else{
        [self.diButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
        [self.zhongButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
        [self.gaoButton setImage:[UIImage imageNamed:@"kongbaikuang"] forState:UIControlStateNormal];
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
