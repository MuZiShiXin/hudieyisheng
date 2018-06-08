//
//  AfterPatientInfoThreeTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AfterPatientInfoThreeTableViewCell.h"
#import "GatoBaseHelp.h"

#define imageButtonTag 6061459
#define labelTag 1707281351
@interface AfterPatientInfoThreeTableViewCell ()<UIScrollViewDelegate>
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIView * labelView;//方便改变坐标用的view 添加一堆文字信息
@property (nonatomic ,strong) UIScrollView * imageScrollview;
@property (nonatomic ,strong) UILabel * dian;
@property (nonatomic ,strong) UILabel * TSHLabel;
@property (nonatomic ,strong) UILabel * chuyuanzhenduan;
@property (nonatomic ,strong) UILabel * ciyaozhenduan;
@end
@implementation AfterPatientInfoThreeTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AfterPatientInfoThreeTableViewCell";
    AfterPatientInfoThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AfterPatientInfoThreeTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setvalueWithImageArray:(patientInfoNoteModel *)model
{
    if (model.lRadioactiveIodine.length < 1) {
        self.dian.text = @"";
    }else{
        self.dian.text = model.lRadioactiveIodine;
    }
    self.TSHLabel.text = model.lTshS.length > 0 ? model.lTshS : @"";
    self.chuyuanzhenduan.text = model.lDiagnose.length > 0 ? model.lDiagnose : @"";
    self.ciyaozhenduan.text = model.secondarylDiagnose.length > 0 ? model.secondarylDiagnose : @"";
    for (UIImageView * image in self.imageScrollview.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            [image removeFromSuperview];
        }
    }
    
    NSArray * imageArray = model.lImg;
    
    self.imageScrollview.contentSize = CGSizeMake(Gato_Width_320_(295)  / 3 * imageArray.count,0);
    for (int i = 0 ; i < imageArray.count ; i ++) {
        UIImageView * image = [[UIImageView alloc]init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.backgroundColor = [UIColor whiteColor];
        [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
        
        [self.imageScrollview addSubview:image];
        
        image.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + i * Gato_Height_548_(90))
        .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
        .widthIs(Gato_Width_320_(77))
        .heightIs(Gato_Height_548_(77));
        
        UIButton * ImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageScrollview addSubview:ImageButton];
        ImageButton.tag = i + imageButtonTag;
        [ImageButton addTarget:self action:@selector(imageButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
        ImageButton.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + i * Gato_Height_548_(90))
        .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
        .widthIs(Gato_Width_320_(77))
        .heightIs(Gato_Height_548_(77));
        
    }
    [self.chuyuanzhenduan updateLayout];
    
    UILabel * label = (UILabel *)[self viewWithTag:2 + labelTag];
    label.sd_layout.heightIs(self.chuyuanzhenduan.height);

    [self.ciyaozhenduan updateLayout];
    UILabel * label1 = (UILabel *)[self viewWithTag:3 + labelTag];
    label1.sd_layout.heightIs(self.ciyaozhenduan.height);
    
    self.labelView.sd_layout.heightIs(Gato_Height_548_(96) / 3 * 2 + self.chuyuanzhenduan.height + self.ciyaozhenduan.height);
    [self.labelView updateLayout];
    
    if (imageArray.count == 0) {
        self.imageScrollview.hidden = YES;
        self.labelView.sd_layout.topSpaceToView(self.underView,Gato_Height_548_(36));
        self.underView.sd_layout.heightIs(Gato_Height_548_(26) + self.labelView.height + Gato_Height_548_(10));
    }else{
        self.underView.sd_layout.heightIs(Gato_Height_548_(26) + self.labelView.height + Gato_Height_548_(109));
    }
    [self.underView updateLayout];
    self.height = self.underView.height + Gato_Height_548_(40);
}
-(void)imageButtonBlock:(UIButton *)sender
{
    if (self.imageButtonBlock) {
        self.imageButtonBlock(sender.tag - imageButtonTag);
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(262));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_icon_diagnose"];
    [self.underView addSubview:image];
    image.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(20));
    
    self.imageScrollview.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(image,0)
    .rightSpaceToView(self.underView,0)
    .heightIs(Gato_Height_548_(109));
    
    self.labelView.sd_layout.leftEqualToView(self.imageScrollview)
    .rightEqualToView(self.imageScrollview)
    .topSpaceToView(self.imageScrollview,0)
    .heightIs(Gato_Height_548_(96));
    
    [self addOther];
    
    self.dian.sd_layout.rightSpaceToView(self.labelView, - 1 )
    .topSpaceToView(self.labelView,0)
    .widthIs(Gato_Width - Gato_Width_320_(26) - Gato_Width_320_(93))
    .heightIs(Gato_Height_548_(96) / 3);
    
    self.TSHLabel.sd_layout.rightEqualToView(self.dian)
    .topSpaceToView(self.dian,0)
    .widthRatioToView(self.dian,1)
    .heightRatioToView(self.dian,1);
    
    self.chuyuanzhenduan.sd_layout.rightEqualToView(self.TSHLabel)
    .topSpaceToView(self.TSHLabel,0)
    .widthRatioToView(self.TSHLabel,1)
    .autoHeightRatio(0)
    .minHeightIs(Gato_Height_548_(96) / 3);

    self.ciyaozhenduan.sd_layout.rightEqualToView(self.TSHLabel)
    .topSpaceToView(self.chuyuanzhenduan,0)
    .widthRatioToView(self.TSHLabel,1)
    .autoHeightRatio(0)
    .minHeightIs(Gato_Height_548_(96) / 3);
    
    GatoViewBorderRadius(self.dian, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.TSHLabel, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.chuyuanzhenduan, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.ciyaozhenduan, 0, 1, [UIColor appAllBackColor]);
}
-(void)addOther
{
    NSArray * titleArray = @[@"碘131治疗",@"TSH抑制目标",@"出院诊断",@"次要诊断"];
    for (int i = 0 ; i < titleArray.count ; i ++) {
        CGFloat titleHeight = Gato_Height_548_(96) / 3;
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(30);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        label.tag = i + labelTag;
        [self.labelView addSubview:label];
        label.sd_layout.leftSpaceToView(self.labelView,- 1)
        .topSpaceToView(self.labelView,i * titleHeight)
        .widthIs(Gato_Width_320_(95))
        .heightIs(titleHeight);
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(UIScrollView *)imageScrollview
{
    if (!_imageScrollview) {
        _imageScrollview = [[UIScrollView alloc]init];
        _imageScrollview.backgroundColor = [UIColor whiteColor];
        _imageScrollview.delegate = self;
        _imageScrollview.scrollEnabled = YES;
        [self.underView addSubview:_imageScrollview];
    }
    return _imageScrollview;
}

-(UIView * )underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_underView];
    }
    return _underView;
}

-(UILabel *)dian
{
    if (!_dian) {
        _dian = [[UILabel alloc]init];
        _dian.textColor = [UIColor HDBlackColor];
        _dian.font = FONT(30);
        _dian.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_dian];
    }
    return _dian;
}
-(UILabel *)TSHLabel
{
    if (!_TSHLabel) {
        _TSHLabel = [[UILabel alloc]init];
        _TSHLabel.textColor = [UIColor HDBlackColor];
        _TSHLabel.font = FONT(30);
        _TSHLabel.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_TSHLabel];
    }
    return _TSHLabel;
}
-(UILabel *)chuyuanzhenduan
{
    if (!_chuyuanzhenduan) {
        _chuyuanzhenduan = [[UILabel alloc]init];
        _chuyuanzhenduan.textColor = [UIColor HDBlackColor];
        _chuyuanzhenduan.font = FONT(30);
        _chuyuanzhenduan.textAlignment = NSTextAlignmentCenter;
        _chuyuanzhenduan.numberOfLines = 0;
        [self.labelView addSubview:_chuyuanzhenduan];
    }
    return _chuyuanzhenduan;
}
-(UILabel *)ciyaozhenduan
{
    if (!_ciyaozhenduan) {
        _ciyaozhenduan = [[UILabel alloc]init];
        _ciyaozhenduan.textColor = [UIColor HDBlackColor];
        _ciyaozhenduan.font = FONT(30);
        _ciyaozhenduan.textAlignment = NSTextAlignmentCenter;
        _ciyaozhenduan.numberOfLines = 0;
        [self.labelView addSubview:_ciyaozhenduan];
    }
    return _ciyaozhenduan;
}
-(UIView *)labelView
{
    if (!_labelView) {
        _labelView = [[UIView alloc]init];
        _labelView.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:_labelView];
    }
    return _labelView;
}
@end
