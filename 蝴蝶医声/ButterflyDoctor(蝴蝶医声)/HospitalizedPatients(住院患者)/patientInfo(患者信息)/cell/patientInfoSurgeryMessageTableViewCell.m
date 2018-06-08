//
//  patientInfoSurgeryMessageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "patientInfoSurgeryMessageTableViewCell.h"
#import "GatoBaseHelp.h"
#import "XFDaterView.h"
#define dicKey @"indexRow"
#define dicText @"text"

#define key0buttonTag 424135
#define key1buttonTag 4241350
#define key2buttonTag 42413501
#define key3buttonTag 424135012

#define imageButtontag 4241551
@interface patientInfoSurgeryMessageTableViewCell ()<UIScrollViewDelegate,XFDaterViewDelegate>
{
    XFDaterView* timeDater;
}
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIScrollView * imageScrollview;
@property (nonatomic ,strong) UIButton * AddImageButton;
@property (nonatomic ,strong) NSMutableArray * infoDicArray;
@property (nonatomic ,strong) UIButton * otherButton;
@property (nonatomic ,strong) UIButton* timeSelectButton;//
@property (nonatomic ,strong) UIButton* linbajieMoreBtn;//淋巴节转移

//方便改变view上button状态 分别为 肿瘤位置view，。。。等等
@property (nonatomic ,strong) UIView * key0View;
@property (nonatomic ,strong) UIView * key1View;
@property (nonatomic ,strong) UIView * key2View;
@property (nonatomic ,strong) UIView * key3View;

//UISegmentedControl 选择器
@property (nonatomic ,strong) UISegmentedControl * segmentCon;

@end
@implementation patientInfoSurgeryMessageTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"patientInfoSurgeryMessageTableViewCell";
    patientInfoSurgeryMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"patientInfoSurgeryMessageTableViewCell" owner:nil options:nil] lastObject];
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

-(void)setvalueWithMoryButtonStr:(NSString *)str
{
    if (str.length > 0) {
        [self.otherButton setTitle:str forState:UIControlStateNormal];
    }else{
        [self.otherButton setTitle:@"更多" forState:UIControlStateNormal];
    }
    
}
-(void)setValueWithinfoArray:(NSArray *)infoArray
{
    for (int i = 0 ; i < infoArray.count; i++) {
        NSDictionary * dic = infoArray[i];
        if ([[dic objectForKey:dicKey] isEqualToString:@"0"]) {
            UIButton * button = (UIButton *)[self viewWithTag:[[dic objectForKey:dicText] integerValue] + key0buttonTag];
            [self zhongliuweizhi:button];
        }else if ([[dic objectForKey:dicKey] isEqualToString:@"1"]){
            UIButton * button = (UIButton *)[self viewWithTag:[[dic objectForKey:dicText] integerValue] + key1buttonTag];
            [self key1Button:button];
        }else if ([[dic objectForKey:dicKey] isEqualToString:@"2"]){
            UIButton * button = (UIButton *)[self viewWithTag:[[dic objectForKey:dicText] integerValue] + key2buttonTag];
            [self key2Button:button];
        }else if ([[dic objectForKey:dicKey] isEqualToString:@"3"]){
            UIButton * button = (UIButton *)[self viewWithTag:[[dic objectForKey:dicText] integerValue] + key3buttonTag];
            [self key3Button:button];
        }
    }
    
}

-(void)zhongliuweizhi:(UIButton *)sender
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
-(void)key1Button:(UIButton *)sender
{
    for (UIButton * button in self.key1View.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        }
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    if (![[self.infoDicArray[1] objectForKey:dicText] isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag - key1buttonTag]]) {
        [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    }
    [self newInfoDicWithKey:@"1" WithText:[NSString stringWithFormat:@"%ld",sender.tag - key1buttonTag]];
}
-(void)key2Button:(UIButton *)sender
{
    for (UIButton * button in self.key2View.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        }
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    if (![[self.infoDicArray[2] objectForKey:dicText] isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag - key2buttonTag]]) {
        [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    }
    [self newInfoDicWithKey:@"2" WithText:[NSString stringWithFormat:@"%ld",sender.tag - key2buttonTag]];
}
-(void)key3Button:(UIButton *)sender
{
    for (UIButton * button in self.key3View.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        }
    }
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    if (![[self.infoDicArray[3] objectForKey:dicText] isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag - key3buttonTag]]) {
        [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    }
    [self newInfoDicWithKey:@"3" WithText:[NSString stringWithFormat:@"%ld",sender.tag - key3buttonTag]];
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

-(void)gengduoButton:(UIButton *)sender
{
    if (self.MoerButton) {
        self.MoerButton();
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
-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    if (self.imageLookBlock) {
        self.imageLookBlock(tap);
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhongliu) name:@"zhongliu" object:nil];
    self.backgroundColor = [UIColor appAllBackColor];
    self.infoDicArray = [NSMutableArray array];
    for (int i = 0 ; i < 4; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:dicKey];
        [dic setValue:@"0" forKey:dicText];
        [self.infoDicArray addObject:dic];
    }
    
    self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(198));

    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"inpatient_icon_intraoperative"];
    [self.underView addSubview:image];
    image.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(20));
    NSArray *segArray = [[NSArray alloc] initWithObjects:@"良性",@"恶性" ,nil];
    
    self.segmentCon = [[UISegmentedControl alloc] initWithItems:segArray];
    self.segmentCon.selectedSegmentIndex=0;
    [self.segmentCon addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    [self.underView addSubview:self.segmentCon];
    
    self.segmentCon.sd_layout.topSpaceToView(self.underView, Gato_Height_548_(10))
    .leftSpaceToView(image, Gato_Width_320_(20))
    .rightSpaceToView(self.underView, Gato_Width_320_(20))
    .heightIs(Gato_Height_548_(20));
    self.segmentCon.tintColor = Gato_(121, 190, 255);
    GatoViewBorderRadius(self.segmentCon, Gato_Height_548_(20)/2, 1, Gato_(121, 190, 255));
    
    self.imageScrollview.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(image,Gato_Width_320_(6))
    .rightSpaceToView(self.underView,0)
    .heightIs(Gato_Height_548_(109));
    [self.imageScrollview updateLayout];
    
}
-(void)zhongliu
{
    self.segmentCon.selectedSegmentIndex=0;
}
- (void)selectItem:(UISegmentedControl *)sender {
    
//    NSLog(@"%@",self.selectStr);
    if (sender.selectedSegmentIndex == 0)
    {
//     良性
        NSLog(@"良性");
        if (self.selectSegmented) {
            self.selectSegmented(@"良性");
        }
    } else {
//     恶性
        if (self.selectSegmented) {
            self.selectSegmented(@"恶性");
        }
    }
}
-(void)setSelectStr:(NSString *)selectStr
{
    NSLog(@"%@",selectStr);
    if ([selectStr isEqualToString:@"良性"]) {
        //    良性状态
        [self liangxingViews];
        self.segmentCon.selectedSegmentIndex=0;
        self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
        .rightSpaceToView(self,Gato_Width_320_(13))
        .topSpaceToView(self,0)
        .heightIs(Gato_Height_548_(198));
    }else
    {
//        恶性
        [self addOtherViews];
         self.segmentCon.selectedSegmentIndex=1;
        self.underView.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
        .rightSpaceToView(self,Gato_Width_320_(13))
        .topSpaceToView(self,0)
        .heightIs(Gato_Height_548_(378));
    }

}
 //    良性状态
-(void)liangxingViews
{
    NSArray * titleArray = @[@"手术时间",@"手术方式"];
    
    for (int i = 0 ; i < titleArray.count; i ++)
    {
        
        CGFloat topHeight = Gato_Height_548_(297) - Gato_Height_548_(162);
        CGFloat titleHeight = Gato_Height_548_(162) / 5;
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(28);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,- 1)
        .topSpaceToView(self.underView,i * titleHeight + topHeight)
        .widthIs(Gato_Width_320_(95))
        .heightIs(titleHeight);
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        if (i==1) {
            label.sd_layout
            .topSpaceToView(self.underView,i * titleHeight + topHeight-1);
            self.otherButton.sd_layout.leftSpaceToView(label,-1)
            .rightSpaceToView(self.underView, -1)
            .topEqualToView(label)
            .heightRatioToView(label, 1);
            GatoViewBorderRadius(self.otherButton, 0, 1, [UIColor appAllBackColor]);
        }
        else
        {
            self.timeSelectButton.sd_layout.leftSpaceToView(label,-1)
            .rightSpaceToView(self.underView, -1)
            .topEqualToView(label)
            .heightRatioToView(label, 1);
            GatoViewBorderRadius(self.timeSelectButton, 0, 1, [UIColor appAllBackColor]);
        }
    }
}
//    恶性状态
-(void)addOtherViews
{
//    NSArray * titleArray = @[@"肿瘤位置",@"被膜侵及",@"腺外侵及",@"多发病灶",@"手术方式"];
     NSArray * titleArray = @[@"多发病灶",@"肿瘤直径\n\n(最大直径)", @"被膜侵及",@"腺外侵及",@"淋巴结转移",@"手术时间",@"手术方式"];
//    NSArray * zhongliuButtonArray = @[@"",@"上极",@"中极",@"下极"];
      NSArray * duofabingzaoButtonArray = @[@"",@"是",@"否",@"无"];
      NSArray * otherButtonArray = @[@"",@"是",@"否",@"无"];
      NSArray * zhongliuzhijingArray=@[@"",@"≤1cm",@">1cm",@"无"];
     CGFloat labelY = 0;//y
    for (int i = 0 ; i < titleArray.count; i ++) {

        CGFloat topHeight = Gato_Height_548_(297) - Gato_Height_548_(162);
//        CGFloat titleHeight = Gato_Height_548_(162) / 5;
        CGFloat titleHeight = Gato_Height_548_(31);
        labelY=topHeight;
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(28);
        label.numberOfLines = 0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.text = titleArray[i];
        [self.underView addSubview:label];
        
        if(i==0)
        {
            label.sd_layout.leftSpaceToView(self.underView,- 1)
            .topSpaceToView(self.underView,labelY)
            .widthIs(Gato_Width_320_(95))
            .heightIs(titleHeight);
        }
         else if (i==1)
         {
             label.sd_layout.leftSpaceToView(self.underView,- 1)
             .topSpaceToView(self.underView,i * titleHeight + topHeight-1)
             .widthIs(Gato_Width_320_(95))
             .heightIs(titleHeight*2);
         }
        else
        {
            label.sd_layout.leftSpaceToView(self.underView,- 1)
            .topSpaceToView(self.underView,(i +1)* titleHeight  + topHeight-i)
            .widthIs(Gato_Width_320_(95))
            .heightIs(titleHeight);
        }
     
        GatoViewBorderRadius(label, 0, 1, [UIColor appAllBackColor]);
        

        
        if (i < 4) {
            NSArray * ViewArray = @[self.key0View,self.key1View,self.key2View,self.key3View];
            UIView * view = ViewArray[i];
            view.sd_layout.rightSpaceToView(self.underView,-1)
            .topEqualToView(label)
            .leftSpaceToView(label,-1)
            .heightRatioToView(label,1);
            GatoViewBorderRadius(view, 0, 1, [UIColor appAllBackColor]);
            [view updateLayout];

            CGFloat viewWidth = Gato_Width - Gato_Width_320_(26) - Gato_Width_320_(95);
            if ( i == 0)
            {
                for (int q = 0 ; q < duofabingzaoButtonArray.count ;q ++) {
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setTitle:duofabingzaoButtonArray[q] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
                    button.titleLabel.font = FONT(28);

                    button.tag = q + key0buttonTag;
                    [view addSubview:button];
                    if (q == 0)
                    {
                        [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button addTarget:self action:@selector(zhongliuweizhi:) forControlEvents:UIControlEventTouchUpInside];
                        button.sd_layout.leftSpaceToView(view,(q - 1) * viewWidth / 3)
                        .topSpaceToView(view,0)
                        .widthIs(viewWidth / 3)
                        .heightRatioToView(view,1);
                    }

                }
            }
            else if (i==1)
            {
                for (int q = 0 ; q < zhongliuzhijingArray.count ;q ++) {
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setTitle:zhongliuzhijingArray[q] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
                    button.titleLabel.font = FONT(28);

                    button.tag = q + key1buttonTag;
                    [view addSubview:button];
                    if (q == 0)
                    {
                        [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [button addTarget:self action:@selector(key1Button:) forControlEvents:UIControlEventTouchUpInside];
                        button.sd_layout.leftSpaceToView(view,(q - 1) * viewWidth / 3)
                        .topSpaceToView(view,0)
                        .widthIs(viewWidth / 3)
                        .heightRatioToView(view,1);
                    }

                }
            }
            else
            {
                for (int q = 0 ; q < otherButtonArray.count ;q ++) {
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setTitle:otherButtonArray[q] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];

                    button.titleLabel.font = FONT(28);
                    [view addSubview:button];
                    if (q == 0) {
                        [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
                    }else{
                         if (i == 2){
                            [button addTarget:self action:@selector(key2Button:) forControlEvents:UIControlEventTouchUpInside];
                            button.tag = q + key2buttonTag;
                        }else if (i == 3){
                            [button addTarget:self action:@selector(key3Button:) forControlEvents:UIControlEventTouchUpInside];
                            button.tag = q + key3buttonTag;
                        }
                        button.sd_layout.leftSpaceToView(view,(q - 1) * viewWidth / 3)
                        .topSpaceToView(view,0)
                        .widthIs(viewWidth / 3)
                        .heightRatioToView(view,1);
                    }
                }
            }
        }
        else
        {
            if (i==4) {
                //    更多按钮  淋巴结转移
                CGFloat titleHeight = Gato_Height_548_(31);
                self.linbajieMoreBtn.sd_layout.leftSpaceToView(label,-1)
                .rightSpaceToView(self.underView, -1)
                .topEqualToView(label)
                .heightIs(titleHeight);
                GatoViewBorderRadius(self.linbajieMoreBtn, 0, 1, [UIColor appAllBackColor]);
            }
            else if (i==5)
            {
                CGFloat titleHeight = Gato_Height_548_(31);
                self.timeSelectButton.sd_layout.leftSpaceToView(label,-1)
                .rightSpaceToView(self.underView, -1)
                .topEqualToView(label)
                .heightIs(titleHeight);
                GatoViewBorderRadius(self.timeSelectButton, 0, 1, [UIColor appAllBackColor]);
            }
            else
            {

                //    更多按钮  手术方式
                        CGFloat titleHeight = Gato_Height_548_(31);
                        self.otherButton.sd_layout.leftSpaceToView(label,-1)
                        .rightSpaceToView(self.underView, -1)
                        .topEqualToView(label)
                        .heightIs(titleHeight);
                        GatoViewBorderRadius(self.otherButton, 0, 1, [UIColor appAllBackColor]);
            }

        }
    }

}
//弹出时间选择器
-(void)timeselectBtn:(UIButton*)sender
{
    [self endEditing:YES];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_XFDate_Type];
    timeDater= [[XFDaterView alloc]initWithFrame:CGRectZero];
    timeDater.delegate=self;
    [timeDater showInView:win animated:YES];
    timeDater.backColor = [UIColor HDThemeColor];
}
- (void)daterViewDidClicked:(XFDaterView *)daterView{
//    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_XFDate_Type];
    if (daterView == timeDater)
    {
        NSLog(@"dateString=%@ timeString=%@",timeDater.dateString,timeDater.timeString);
        [self.timeSelectButton setTitle:timeDater.dateString forState:UIControlStateNormal];
    }
}

//淋巴结转移
-(void)linbajieMoreBtn:(UIButton*)sender
{
    if (self.linbajiezhuanyiBlock) {
        self.linbajiezhuanyiBlock();
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [timeDater showInView:self animated:YES];
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
-(UIButton * )otherButton
{
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherButton setTitle:@"更多" forState:UIControlStateNormal];
        [_otherButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _otherButton.titleLabel.font = FONT(28);
        _otherButton.titleLabel.numberOfLines = 2;
        [_otherButton addTarget:self action:@selector(gengduoButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_otherButton];
    }
    return _otherButton;
}
-(UIButton * )linbajieMoreBtn
{
    if (!_linbajieMoreBtn) {
        _linbajieMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_linbajieMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_linbajieMoreBtn setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _linbajieMoreBtn.titleLabel.font = FONT(28);
        _linbajieMoreBtn.titleLabel.numberOfLines = 2;
        [_linbajieMoreBtn addTarget:self action:@selector(linbajieMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_linbajieMoreBtn];
    }
    return _linbajieMoreBtn;
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
-(UIView * )key1View
{
    if (!_key1View) {
        _key1View = [[UIView alloc]init];
        _key1View.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:_key1View];
    }
    return _key1View;
}
-(UIView * )key2View
{
    if (!_key2View) {
        _key2View = [[UIView alloc]init];
        _key2View.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:_key2View];
    }
    return _key2View;
}
-(UIView * )key3View
{
    if (!_key3View) {
        _key3View = [[UIView alloc]init];
        _key3View.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:_key3View];
    }
    return _key3View;
}
-(UIButton*)timeSelectButton
{
    if (!_timeSelectButton) {
        _timeSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeSelectButton setTitle:@"选择时间" forState:UIControlStateNormal];
        [_timeSelectButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        _timeSelectButton.titleLabel.font = FONT(28);
        _timeSelectButton.titleLabel.numberOfLines = 2;
        [_timeSelectButton addTarget:self action:@selector(timeselectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_timeSelectButton];
    }
    return _timeSelectButton;
}


@end
