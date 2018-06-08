//
//  AfterPatientInfoTwoTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AfterPatientInfoTwoTableViewCell.h"
#import "GatoBaseHelp.h"

#define imageButtonTag 6071459
@interface AfterPatientInfoTwoTableViewCell ()<UIScrollViewDelegate>
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIView * labelView;//方便改变坐标用的view 添加一堆文字信息
@property (nonatomic ,strong) UIScrollView * imageScrollview;
@property (nonatomic ,strong) UILabel * zhongliuweizhi;
@property (nonatomic ,strong) UILabel * beimoqinji;
@property (nonatomic ,strong) UILabel * xianwaiqinji;
@property (nonatomic ,strong) UILabel * duofabingzao;
@property (nonatomic ,strong) UILabel * shoushufangshi;

@end
@implementation AfterPatientInfoTwoTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AfterPatientInfoTwoTableViewCell";
    AfterPatientInfoTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AfterPatientInfoTwoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setvalueWithImageArray:(patientInfoNoteModel *)model;
{
    
    self.zhongliuweizhi.text = model.sTumourLocation.length > 0 ? model.sTumourLocation : @"";
    self.beimoqinji.text = model.sTunica.length > 0 ? model.sTunica : @"";
    self.xianwaiqinji.text = model.sThyroid.length > 0 ? model.sThyroid : @"";
    self.duofabingzao.text = model.sMultiFoci.length > 0 ? model.sMultiFoci : @"";
    self.shoushufangshi.text = model.sWay.length > 0 ? model.sWay : @"";
    
    for (UIImageView * image in self.imageScrollview.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            [image removeFromSuperview];
        }
    }
    
    NSArray * imageArray = model.sImg;
    
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
    [self.labelView updateLayout];
    if (imageArray.count == 0) {
        self.imageScrollview.hidden = YES;
        self.labelView.sd_layout.topSpaceToView(self.underView,Gato_Height_548_(40));
        self.underView.sd_layout.heightIs(Gato_Height_548_(26) + self.labelView.height + Gato_Height_548_(10) - Gato_Height_548_(162) / 5);
    }
    
    [self.underView updateLayout];
    
    self.height = self.underView.height + Gato_Height_548_(10) + Gato_Height_548_(162) / 5 ;
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
    .heightIs(Gato_Height_548_(297));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_icon_intraoperative"];
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
    .heightIs(Gato_Height_548_(162) + Gato_Height_548_(162) / 5);
    
    [self addOther];
    
    self.zhongliuweizhi.sd_layout.rightSpaceToView(self.labelView, - 1 )
    .topSpaceToView(self.labelView,0)
    .widthIs(Gato_Width - Gato_Width_320_(26) - Gato_Width_320_(93))
    .heightIs(Gato_Height_548_(162) / 5);
    
    self.beimoqinji.sd_layout.rightEqualToView(self.zhongliuweizhi)
    .topSpaceToView(self.zhongliuweizhi,0)
    .widthRatioToView(self.zhongliuweizhi,1)
    .heightRatioToView(self.zhongliuweizhi,1);
    
    self.xianwaiqinji.sd_layout.rightEqualToView(self.zhongliuweizhi)
    .topSpaceToView(self.beimoqinji,0)
    .widthRatioToView(self.beimoqinji,1)
    .heightRatioToView(self.beimoqinji,1);
    
    self.duofabingzao.sd_layout.rightEqualToView(self.zhongliuweizhi)
    .topSpaceToView(self.xianwaiqinji,0)
    .widthRatioToView(self.xianwaiqinji,1)
    .heightRatioToView(self.xianwaiqinji,1);
    
    self.shoushufangshi.sd_layout.rightEqualToView(self.zhongliuweizhi)
    .topSpaceToView(self.duofabingzao,0)
    .widthRatioToView(self.duofabingzao,1)
    .heightIs(Gato_Height_548_(162) / 5 * 2);
    
    GatoViewBorderRadius(self.zhongliuweizhi, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.beimoqinji, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.xianwaiqinji, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.duofabingzao, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.shoushufangshi, 0, 1, [UIColor appAllBackColor]);
}
-(void)addOther
{
    NSArray * titleArray = @[@"肿瘤位置",@"被膜侵及",@"腺外侵及",@"多发病灶",@"手术方式"];
    for (int i = 0 ; i < titleArray.count ; i ++) {
        CGFloat titleHeight = Gato_Height_548_(162) / 5;
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(32);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.labelView addSubview:label];
        label.sd_layout.leftSpaceToView(self.labelView,- 1)
        .topSpaceToView(self.labelView,i * titleHeight)
        .widthIs(Gato_Width_320_(95))
        .heightIs(titleHeight);
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        
        if (i == 4) {
            titleHeight = Gato_Height_548_(162) / 5 * 2;
            label.sd_layout.heightIs(titleHeight);
        }
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
-(UILabel *)zhongliuweizhi
{
    if (!_zhongliuweizhi) {
        _zhongliuweizhi = [[UILabel alloc]init];
        _zhongliuweizhi.textColor = [UIColor HDBlackColor];
        _zhongliuweizhi.font = FONT(30);
        _zhongliuweizhi.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_zhongliuweizhi];
    }
    return _zhongliuweizhi;
}
-(UILabel *)beimoqinji
{
    if (!_beimoqinji) {
        _beimoqinji = [[UILabel alloc]init];
        _beimoqinji.textColor = [UIColor HDBlackColor];
        _beimoqinji.font = FONT(30);
        _beimoqinji.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_beimoqinji];
    }
    return _beimoqinji;
}
-(UILabel *)xianwaiqinji
{
    if (!_xianwaiqinji) {
        _xianwaiqinji = [[UILabel alloc]init];
        _xianwaiqinji.textColor = [UIColor HDBlackColor];
        _xianwaiqinji.font = FONT(30);
        _xianwaiqinji.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_xianwaiqinji];
    }
    return _xianwaiqinji;
}
-(UILabel *)duofabingzao
{
    if (!_duofabingzao) {
        _duofabingzao = [[UILabel alloc]init];
        _duofabingzao.textColor = [UIColor HDBlackColor];
        _duofabingzao.font = FONT(30);
        _duofabingzao.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_duofabingzao];
    }
    return _duofabingzao;
}
-(UILabel *)shoushufangshi
{
    if (!_shoushufangshi) {
        _shoushufangshi = [[UILabel alloc]init];
        _shoushufangshi.textColor = [UIColor HDBlackColor];
        _shoushufangshi.font = FONT(30);
        _shoushufangshi.numberOfLines = 0;
        _shoushufangshi.textAlignment = NSTextAlignmentCenter;
        [self.labelView addSubview:_shoushufangshi];
    }
    return _shoushufangshi;
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
