//
//  SQXXTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/2.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import "SQXXTableViewCell.h"
#import "GatoBaseHelp.h"
#define imageButtontag 211381
#define key0buttonTag  19940101
#define dicKey @"indexRow"
#define dicText @"text"

@interface SQXXTableViewCell()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIScrollView * imageScrollview;
@property (nonatomic ,strong) UIButton * AddImageButton;
@property (nonatomic ,strong) UIView * key0View;
@property (nonatomic ,strong) NSMutableArray * infoDicArray;
@end

@implementation SQXXTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SQXXTableViewCell";
    SQXXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SQXXTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)addImageButton:(UIButton *)sender
{
    if (self.addImageBlock) {
        self.addImageBlock();
    }
}
//
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
    //    self.imageScrollview.contentSize = CGSizeMake(((Gato_Width / 320 * 77)+15)*(imageArray.count+1)+30, 0);
    if (imageArray.count >= 3) {
        self.imageScrollview.contentOffset = CGPointMake((imageArray.count - 2) * Gato_Width_320_(295)  / 3 - Gato_Width_320_(40), 0);
    }
    for (int i = 0 ; i < imageArray.count ; i ++) {
        UIImageView * image = [[UIImageView alloc]init];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.backgroundColor = [UIColor whiteColor];
        image.tag = i + 5024;
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
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor appAllBackColor];
    self.infoDicArray = [NSMutableArray array];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"0" forKey:dicKey];
    [dic setValue:@"0" forKey:dicText];
    [self.infoDicArray addObject:dic];
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(159));// 之前297
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"sqxx"];
    [self.underView addSubview:image];
    image.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(20));
    
    self.imageScrollview.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(image,0)
    .rightSpaceToView(self.underView,0)
    .heightIs(Gato_Height_548_(109));
    [self.imageScrollview updateLayout];
    [self addOtherViews];
    
}
-(void)addOtherViews
{
    CGFloat topHeight = Gato_Height_548_(297) - Gato_Height_548_(162);
    CGFloat titleHeight = Gato_Height_548_(31);
    UILabel * label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FONT(28);
    label.numberOfLines = 0;
    label.textColor = [UIColor YMAppAllTitleColor];
    label.text = @"BRAF突变";
    [label setBackgroundColor:[UIColor whiteColor]];
    [self.underView addSubview:label];
    label.sd_layout.leftSpaceToView(self.underView,- 1)
    .topSpaceToView(self.underView,topHeight)
    .widthIs(Gato_Width_320_(95))
    .heightIs(titleHeight);
    GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
    
   
    self.key0View.sd_layout.rightSpaceToView(self.underView,-1)
    .topEqualToView(label)
    .leftSpaceToView(label,-1)
    .heightRatioToView(label,1);
    GatoViewBorderRadius(_key0View, 0, 1, [UIColor appAllBackColor]);
    [self.key0View updateLayout];
    
    NSArray * BRAFTitle = @[@"",@"是",@"否",@"未检测"];
    CGFloat viewWidth = Gato_Width - Gato_Width_320_(40) - Gato_Width_320_(95);
    for (int q = 0 ; q < BRAFTitle.count ;q ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:BRAFTitle[q] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(28);
        button.tag = q + key0buttonTag;
        [_key0View addSubview:button];
        if (q == 0) {
            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        }else{
            [button addTarget:self action:@selector(BRAF:) forControlEvents:UIControlEventTouchUpInside];
            button.sd_layout.leftSpaceToView(_key0View,(q - 1) * viewWidth / 3 )
            .topSpaceToView(_key0View,0)
            .widthIs(viewWidth / 3)
            .heightRatioToView(_key0View,1);
            if (q==1)
            {
                button.sd_layout.widthIs(viewWidth / 3-10)
                .leftSpaceToView(_key0View,(q - 1) * viewWidth / 3 +Gato_Width_320_(10));
            }
            else if(q==2)
            {
                button.sd_layout.widthIs(viewWidth / 3-10);
            }
            else{
                button.sd_layout.leftSpaceToView(_key0View,(q - 1) * viewWidth / 3-10);
            }
        }
    }
    
}
-(void)BRAF:(UIButton*)sender
{
    for (UIButton * button in self.key0View.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        }
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    if (![[self.infoDicArray[0] objectForKey:dicText] isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag - key0buttonTag]]) {
        [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    }
    
    [self newInfoDicWithKey:@"0" WithText:[NSString stringWithFormat:@"%ld",sender.tag - key0buttonTag]];
}
-(void)setvaleueBRAFArray:(NSArray *)BRAFArray
{
    for (int i = 0 ; i < BRAFArray.count; i++) {
        NSDictionary * dic = BRAFArray[i];
        UIButton * button = (UIButton *)[self viewWithTag:[[dic objectForKey:@"text"] integerValue] + key0buttonTag];
        [self BRAF:button];
        
    }
}
-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    if (self.imageLookBlock) {
        self.imageLookBlock(tap);
    }
}
-(void)newInfoDicWithKey:(NSString *)key WithText:(NSString * )text
{
    if (!key) {
        return;
    }
    BOOL again = false;//是否重复  如果重复 替换 如果不重复 添加
    NSInteger againIndex = 0;
    for (int i = 0 ; i < self.infoDicArray.count ; i ++) {
        if (![key isEqualToString:[self.infoDicArray[i] objectForKey:dicKey]] ) {
            again = NO;
        }else{
            again = YES;
            againIndex = i;
            break;
        }
    }
    
    if (again == NO) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:key forKey:dicKey];
        [dic setValue:text forKey:dicText];
        [self.infoDicArray addObject:dic];
    }else{
        if ([[self.infoDicArray[againIndex] objectForKey:dicText] isEqualToString:text]) {
            text = @"0";
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:key forKey:dicKey];
        [dic setValue:text forKey:dicText];
        [self.infoDicArray replaceObjectAtIndex:againIndex withObject:dic];
    }
    
    if (self.dicArrayBlock) {
        self.dicArrayBlock(self.infoDicArray);
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
-(UIView * )key0View
{
    if (!_key0View) {
        _key0View = [[UIView alloc]init];
        _key0View.backgroundColor = [UIColor whiteColor];
        
        [self.underView addSubview:_key0View];
    }
    return _key0View;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
