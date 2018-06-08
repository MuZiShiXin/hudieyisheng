//
//  patientInfoOverTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "patientInfoOverTableViewCell.h"
#import "GatoBaseHelp.h"

#define buttonTag 4241513
#define imageButtontag 42415510
@interface patientInfoOverTableViewCell ()<UIScrollViewDelegate>
{
    NSInteger nowDianButtonRow;//记录当前被点击内容
    UIImageView * image;
}
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIScrollView * imageScrollview;
@property (nonatomic ,strong) UIButton * AddImageButton;
@property (nonatomic ,strong) UIButton * TSHbutton;//TSH值按钮
@property (nonatomic ,strong) UIButton * zhenduanButton;//出院诊断按钮
@property (nonatomic ,strong) UIView * dianButtonView;
@property (nonatomic ,strong) UIButton * ciyaozhenduanButton;//次要诊断Btn
@end
@implementation patientInfoOverTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"patientInfoOverTableViewCell";
    patientInfoOverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"patientInfoOverTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setvalueWithdian131Str:(NSArray *)dianArray
{
    for (int i = 0 ; i < dianArray.count; i++) {
        NSDictionary * dic = dianArray[i];
        UIButton * button = (UIButton *)[self viewWithTag:[[dic objectForKey:@"text"] integerValue] + buttonTag];
        [self dianButton:button];
        
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(230-129));
//    Gato_Height_548_(96) / 3
    
     image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_icon_diagnose"];
    [self.underView addSubview:image];
    image.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(7))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(20));


    
    
   
}
-(void)setSelectStr:(NSString *)selectStr
{
    if([selectStr isEqualToString:@"良性"])
    {
        [self liangxing];
        self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
        .rightSpaceToView(self,Gato_Width_320_(13))
        .topSpaceToView(self,0)
        .heightIs(Gato_Height_548_(230-13));
    }
    else if ([selectStr isEqualToString:@"甲状腺恶性肿瘤"])
    {
        [self jiahzuangxian];
        self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
        .rightSpaceToView(self,Gato_Width_320_(13))
        .topSpaceToView(self,0)
        .heightIs(Gato_Height_548_(262));
    }
    else
    {
        [self feijiazhuangxian];
        self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
        .rightSpaceToView(self,Gato_Width_320_(13))
        .topSpaceToView(self,0)
        .heightIs(Gato_Height_548_(197));
    }
}
-(void)liangxing
{
    [self addOtherViews];
    
    GatoViewBorderRadius(self.ciyaozhenduanButton, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.zhenduanButton, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.TSHbutton, 0, 1, [UIColor appAllBackColor]);
}
-(void)feijiazhuangxian
{
    //    选择图片
    self.imageScrollview.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(image,0)
    .rightSpaceToView(self.underView,0)
    .heightIs(Gato_Height_548_(109));
    NSArray * titleArray = @[@"出院诊断",@"次要诊断"];
    for (int i = 0 ; i < titleArray.count; i ++) {
        
        CGFloat topHeight = Gato_Height_548_(230) - Gato_Height_548_(96);
        CGFloat titleHeight = Gato_Height_548_(96) / 3;
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(28);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,- 1)
        .topSpaceToView(self.underView,i * titleHeight + topHeight-i)
        .widthIs(Gato_Width_320_(95))
        .heightIs(titleHeight);
        
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        UILabel * rightLabel = [[UILabel alloc]init];;
        rightLabel.sd_layout.rightSpaceToView(self.underView,-1)
        .topEqualToView(label)
        .leftSpaceToView(label,0)
        .heightIs(titleHeight);
        GatoViewBorderRadius(rightLabel, 0, 1, [UIColor appAllBackColor]);
        
        if(i==0)
        {
            self.zhenduanButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
            .rightSpaceToView(self.underView, -1)
            .topEqualToView(label)
            .heightIs(titleHeight);
        }
        else
        {
            self.ciyaozhenduanButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
            .rightSpaceToView(self.underView, -1)
            .topEqualToView(label)
            .heightIs(titleHeight);
        }
        
        GatoViewBorderRadius(self.ciyaozhenduanButton, 0, 1, [UIColor appAllBackColor]);
        GatoViewBorderRadius(self.zhenduanButton, 0, 1, [UIColor appAllBackColor]);
    }
}
-(void)jiahzuangxian
{
    //    选择图片
    self.imageScrollview.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(image,0)
    .rightSpaceToView(self.underView,0)
    .heightIs(Gato_Height_548_(109));
    NSArray * titleArray = @[@"碘131治疗",@"TSH抑制目标",@"出院诊断",@"次要诊断"];
    NSArray * otherButtonArray = @[@"",@"是",@"否",@"无"];
    CGFloat titleHeight = Gato_Height_548_(96) / 3;
    for (int i = 0 ; i < titleArray.count; i ++) {
        
        CGFloat topHeight = Gato_Height_548_(230) - Gato_Height_548_(96);
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(28);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,- 1)
        .topSpaceToView(self.underView,i * titleHeight + topHeight-i)
        .widthIs(Gato_Width_320_(95))
        .heightIs(titleHeight);
        
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        UILabel * rightLabel = [[UILabel alloc]init];;
        rightLabel.sd_layout.rightSpaceToView(self.underView,-1)
        .topEqualToView(label)
        .leftSpaceToView(label,0)
        .heightIs(titleHeight);
        GatoViewBorderRadius(rightLabel, 0, 1, [UIColor appAllBackColor]);
        
                if (i == 0) {
        
                    self.dianButtonView = [[UIView alloc]init];
                    self.dianButtonView.backgroundColor = [UIColor whiteColor];
                    [self.underView addSubview:self.dianButtonView];
                    self.dianButtonView.sd_layout.rightSpaceToView(self.underView,-1)
                    .topEqualToView(label)
                    .leftSpaceToView(label,0)
                    .heightRatioToView(label,1);
                    GatoViewBorderRadius(self.dianButtonView, 0, 1, [UIColor appAllBackColor]);
                    CGFloat viewWidth = Gato_Width - Gato_Width_320_(26) - Gato_Width_320_(95);
        
                    for (int q = 0 ; q < otherButtonArray.count ;q ++) {
                        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                        [button setTitle:otherButtonArray[q] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
                        button.titleLabel.font = FONT(28);
        
        
                        [self.dianButtonView addSubview:button];
                        if (q == 0) {
                            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
                        }else{
                            button.tag = q + buttonTag;
                            [button addTarget:self action:@selector(dianButton:) forControlEvents:UIControlEventTouchUpInside];
        
                            button.sd_layout.leftSpaceToView(self.dianButtonView,(q - 1 )* viewWidth / 3)
                            .topSpaceToView(self.dianButtonView,0)
                            .widthIs(viewWidth / 3)
                            .heightRatioToView(self.dianButtonView,1);
                        }
        
                    }
          }
        else if (i==1)
        {
            self.ciyaozhenduanButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
            .rightSpaceToView(self.underView, -1)
            .topEqualToView(label)
            .heightIs(titleHeight);
        }
        else if (i==2)
        {
            self.zhenduanButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
            .rightSpaceToView(self.underView, -1)
           .topEqualToView(label)
            .heightIs(titleHeight);
            
        }
        else if (i==3)
        {
            self.TSHbutton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
            .rightSpaceToView(self.underView,-1)
            .topEqualToView(label)
            .heightIs(titleHeight);
        }
    }
    GatoViewBorderRadius(self.ciyaozhenduanButton, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.zhenduanButton, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.TSHbutton, 0, 1, [UIColor appAllBackColor]);
}

-(void)addOtherViews
{
//     NSArray * titleArray = @[@"碘131治疗",@"TSH抑制目标",@"出院诊断",@"次要诊断"];
    NSArray * titleArray = @[@"TSH抑制目标",@"出院诊断",@"次要诊断"];
    NSArray * otherButtonArray = @[@"",@"是",@"否",@"无"];
    for (int i = 0 ; i < titleArray.count; i ++) {
        
        CGFloat topHeight = Gato_Height_548_(230-129) - Gato_Height_548_(96);
        CGFloat titleHeight = Gato_Height_548_(96) / 3;
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(28);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,- 1)
        .topSpaceToView(self.underView,i * titleHeight + topHeight-i)
        .widthIs(Gato_Width_320_(95))
        .heightIs(titleHeight);
        
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        UILabel * rightLabel = [[UILabel alloc]init];;
        rightLabel.sd_layout.rightSpaceToView(self.underView,-1)
        .topEqualToView(label)
        .leftSpaceToView(label,0)
        .heightIs(titleHeight);
        GatoViewBorderRadius(rightLabel, 0, 1, [UIColor appAllBackColor]);
    
        if(i==0)
        {
        self.ciyaozhenduanButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
        .rightSpaceToView(self.underView, -1)
        .topEqualToView(label)
        .heightIs(titleHeight);
        }
        else if (i==1)
        {
        self.zhenduanButton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
        .rightSpaceToView(self.underView, -1)
        .topEqualToView(label)
        .heightIs(titleHeight);
        }
        else
        {
        self.TSHbutton.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(94-1))
        .rightSpaceToView(self.underView,-1)
        .topEqualToView(label)
        .heightIs(titleHeight);
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)TSHButton:(UIButton *)sender
{
    if (self.TSHBlock) {
        self.TSHBlock();
    }
}
-(void)zhenduanButton:(UIButton *)sender
{
    if (self.zhenduanBlock) {
        self.zhenduanBlock();
    }
}
-(void)addImageButton:(UIButton *)sender
{
    if (self.addImageBlock) {
        self.addImageBlock();
    }
}
-(void)ciyaozhenduanButton:(UIButton *)sender
{
    if (self.ciyaozhenduanBlock) {
        self.ciyaozhenduanBlock();
    }
}
-(void)dianButton:(UIButton *)sender
{
    for (UIButton * button in self.dianButtonView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        }
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    if (nowDianButtonRow == sender.tag - buttonTag) {
        nowDianButtonRow = 0;
        if (self.dianBlock) {
            self.dianBlock(0);
        }
    }else{
        nowDianButtonRow = sender.tag - buttonTag;
         [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        if (self.dianBlock) {
            self.dianBlock(sender.tag - buttonTag);
        }
    }
}

-(void)deleteButton:(UIButton *)sender
{
    if (self.deleteButton) {
        self.deleteButton(sender.tag - imageButtontag);
    }
}
-(void)setvalueWithImageArray:(NSArray *)imageArray
{
    for (UIImageView * image in self.imageScrollview.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            [image removeFromSuperview];
        }
    }
    for (UIButton * button in self.imageScrollview.subviews) {
        if ([button isKindOfClass:[UIButton class]] && button != self.AddImageButton) {
            [button removeFromSuperview];
        }
    }
    
    self.imageScrollview.contentSize = CGSizeMake(Gato_Width_320_(295)  / 3 * (imageArray.count + 1),0);
    if (imageArray.count >= 3) {
        self.imageScrollview.contentOffset = CGPointMake((imageArray.count - 2) * Gato_Width_320_(295)  / 3 - Gato_Height_548_(40), 0);
    }
    for (int i = 0 ; i < imageArray.count ; i ++) {
        UIImageView * image = [[UIImageView alloc]init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.backgroundColor = [UIColor whiteColor];
        image.tag = i+6024;
        if ([imageArray[i] isKindOfClass:[UIImage class]]) {
            image.image = imageArray[i];
        }else{
            [image sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
        }
        image.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
        
        [image addGestureRecognizer:tap];
        
        [self.imageScrollview addSubview:image];
        
        image.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + i * Gato_Height_548_(90))
        .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
        .widthIs(Gato_Width_320_(77))
        .heightIs(Gato_Height_548_(77));
        
        UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = i + imageButtontag;
        [self.imageScrollview addSubview:deleteButton];
        deleteButton.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + (i + 1) * Gato_Height_548_(90) - Gato_Width_320_(30))
        .topSpaceToView(self.imageScrollview,Gato_Height_548_(5))
        .widthIs(Gato_Width_320_(25))
        .heightIs(Gato_Width_320_(25));
        
    }
    self.AddImageButton.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + imageArray.count * Gato_Height_548_(90))
    .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(77))
    .heightIs(Gato_Height_548_(77));
    
}
-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    if (self.imageLookBlock) {
        self.imageLookBlock(tap);
    }
}

-(void)setValueWithTSHStr:(NSString * )tsh WithZhenduan:(NSString *)zhenduan WithCiyaozhenduan:(NSString *)ciyaozhenduan
{
    if (tsh.length > 0) {
        [self.TSHbutton setTitle:tsh forState:UIControlStateNormal];
    }else{
        [self.TSHbutton setTitle:@"更多" forState:UIControlStateNormal];
    }
    if (zhenduan.length > 0) {
        [self.zhenduanButton setTitle:zhenduan forState:UIControlStateNormal];
    }else{
        [self.zhenduanButton setTitle:@"更多" forState:UIControlStateNormal];
    }
    if (ciyaozhenduan.length > 0) {
        [self.ciyaozhenduanButton setTitle:ciyaozhenduan forState:UIControlStateNormal];
    }else{
        [self.ciyaozhenduanButton setTitle:@"更多" forState:UIControlStateNormal];
    }
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
-(UIButton *)AddImageButton
{
    if (!_AddImageButton) {
        _AddImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AddImageButton addTarget:self action:@selector(addImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [_AddImageButton setBackgroundColor:[UIColor appAllBackColor]];
        [_AddImageButton setBackgroundImage:[UIImage imageNamed:@"group_btn_picture"] forState:UIControlStateNormal];
        [self.imageScrollview addSubview:_AddImageButton];
    }
    return _AddImageButton;
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
-(UIButton * )TSHbutton
{
    if (!_TSHbutton) {
        _TSHbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_TSHbutton setTitle:@"更多" forState:UIControlStateNormal];
        [_TSHbutton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _TSHbutton.titleLabel.font = FONT(28);
        [_TSHbutton addTarget:self action:@selector(TSHButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_TSHbutton];
    }
    return _TSHbutton;
}
-(UIButton * )zhenduanButton
{
    if (!_zhenduanButton) {
        _zhenduanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhenduanButton setTitle:@"更多" forState:UIControlStateNormal];
        [_zhenduanButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _zhenduanButton.titleLabel.font = FONT(28);
        _zhenduanButton.titleLabel.numberOfLines = 2;
        [_zhenduanButton addTarget:self action:@selector(zhenduanButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_zhenduanButton];
    }
    return _zhenduanButton;
}
-(UIButton * )ciyaozhenduanButton
{
    if (!_ciyaozhenduanButton) {
        _ciyaozhenduanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ciyaozhenduanButton setTitle:@"更多" forState:UIControlStateNormal];
        [_ciyaozhenduanButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _ciyaozhenduanButton.titleLabel.font = FONT(28);
        _ciyaozhenduanButton.titleLabel.numberOfLines = 2;
        [_ciyaozhenduanButton addTarget:self action:@selector(ciyaozhenduanButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_ciyaozhenduanButton];
    }
    return _ciyaozhenduanButton;
}
@end
