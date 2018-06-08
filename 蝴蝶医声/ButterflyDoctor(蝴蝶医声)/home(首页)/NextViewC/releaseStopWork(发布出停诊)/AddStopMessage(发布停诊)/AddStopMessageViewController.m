//
//  AddStopMessageViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/19.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AddStopMessageViewController.h"
#import "GatoBaseHelp.h"
#import "PellTableViewSelect.h"
#import "SVProgressHUD.h"
#import "XFDaterView.h"
#define yuanyinButtonTag 4190922
#define yuanyinimageTag 4190822
#define overViewButtonTag 4191022
@interface AddStopMessageViewController ()<UITextFieldDelegate,UITextViewDelegate,XFDaterViewDelegate>
{
    XFDaterView * leftDater;
    XFDaterView * rightDater;
    BOOL * XFDaterBool;//define NO
}
@property (nonatomic ,strong) UIScrollView * scrollView;

@property (nonatomic ,strong) UIView * yuanyinView;
@property (nonatomic ,strong) UIView * timeView;
@property (nonatomic ,strong) UIView * beizhuView;
@property (nonatomic ,strong) NSString * yuanyinStr;//记录当前选择原因
@property (nonatomic ,strong) UITextField * leftTF;
@property (nonatomic ,strong) UITextField * rightTF;
@property (nonatomic ,strong) UIButton * leftButton;
@property (nonatomic ,strong) UIButton * righButton;

@property (nonatomic ,strong) UITextView * textview;
@property (nonatomic ,strong) UILabel * textStrLenght;//文字长度显示
@property (nonatomic ,strong) UILabel * textViewPlaceholder;
@property (nonatomic ,strong) UIView * overView;

@end

@implementation AddStopMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appAllBackColor];
    Gato_Return
    self.title = @"发布停诊";
    [self newFrame];
    [self addUnderButton];
    
    if (self.Modify) {
        [self updateOld];
    }
}

-(void)chutingzhenButton:(UIButton *)sender
{
    if (self.yuanyinStr.length < 1) {
        [self showHint:@"请先选择原因"];
        return;
    }
    if (self.leftTF.text.length < 1) {
        [self showHint:@"请先选择停诊开始时间"];
        return;
    }
    if (self.rightTF.text.length < 1) {
        [self showHint:@"请先选择停诊结束时间"];
        return;
    }
    if (self.textview.text.length < 1) {
        [self showHint:@"请输入想要告诉患者的其他信息"];
        return;
    }
    if (self.textview.text.length > 50) {
        [self showHint:@"您输入的备注信息过多，请重新输入"];
        return;
    }
    NSLog(@"确认发布");
    [PellTableViewSelect addPellTableViewSelectWithwithView:self.overView
                                                WindowFrame:CGRectMake(0, 0,Gato_Width_320_(274), Gato_Height_548_(224))
                                              WithViewFrame:CGRectMake(Gato_Width_320_(24), Gato_Height_548_(141), Gato_Width_320_(274), Gato_Height_548_(224))
                                                 selectData:nil
                                                     action:^(NSInteger index) {
                                                         ;
                                                     } animated:YES];
}
#pragma mark - 加载老信息
-(void)updateOld
{
    NSArray * buttonArray = @[@"出差",@"休假",@"临时工作安排",@"其他"];
    for (int i = 0 ; i < buttonArray.count ; i ++) {
        if ([self.model.cause isEqualToString:buttonArray[i]]) {
            UIButton * button = (UIButton *)[self.yuanyinView viewWithTag:i + yuanyinButtonTag];
            [self yuanyinButton:button];
        }
    }
    self.leftTF.text = self.model.beginTime;
    self.rightTF.text = self.model.endTime;
    self.textview.text = self.model.remark;
    self.textViewPlaceholder.hidden = YES;
}
#pragma mark - 发布
-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    
    NSString * url = HD_Home_notice_add;
    if (self.Modify) {
        url = HD_Home_notice_New;
        [self.updateParms setObject:self.model.noticeId forKey:@"noticeId"];
    }
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.yuanyinStr forKey:@"cause"];
    [self.updateParms setObject:self.leftTF.text forKey:@"beginTime"];
    [self.updateParms setObject:self.rightTF.text forKey:@"endTime"];
    [self.updateParms setObject:self.textview.text forKey:@"remark"];
    [IWHttpTool postWithURL:url params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            if (self.Modify) {
                [self showHint:@"修改成功"];
            }else{
                [self showHint:@"发布成功，等待审核"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
       
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 选择日期
- (void)leftButtonText{
    [self.view endEditing:YES]; 
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_XFDate_Type];
    leftDater= [[XFDaterView alloc]initWithFrame:CGRectZero];
    leftDater.delegate=self;
    [leftDater showInView:self.view animated:YES];
    leftDater.backColor = [UIColor HDThemeColor];
} 
- (void)rightButtonText
{
    [self.view endEditing:YES]; 
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_XFDate_Type];
    rightDater= [[XFDaterView alloc]initWithFrame:CGRectZero];
    rightDater.delegate=self;
    [rightDater showInView:self.view animated:YES];
    rightDater.backColor = [UIColor HDThemeColor];
}
- (void)daterViewDidClicked:(XFDaterView *)daterView{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_XFDate_Type];
    if (daterView == leftDater) {
        NSLog(@"dateString=%@ timeString=%@",leftDater.dateString,leftDater.timeString);
        self.leftTF.text = leftDater.dateString;
    }else{
        NSLog(@"dateString=%@ timeString=%@",rightDater.dateString,rightDater.timeString);
        self.rightTF.text = rightDater.dateString;
    }
    
}
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_XFDate_Type];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([GATO_XFData isEqualToString:@"0"]) {
        [rightDater showInView:self.view animated:YES];
        [leftDater showInView:self.view animated:YES];
    }
   
}

#pragma mark - 选择原因
-(void)yuanyinButton:(UIButton *)sender
{
    for (UIButton * button in self.yuanyinView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
            GatoViewBorderRadius(button, 3, 1, [UIColor appAllBackColor]);
        }
    }
    for (UIImageView * image in self.yuanyinView.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            image.hidden = YES;
        }
    }
    
    UIImageView * image = [self.yuanyinView viewWithTag:sender.tag - yuanyinButtonTag + yuanyinimageTag];
    image.hidden = NO;
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(sender, 3, 1, [UIColor HDThemeColor]);
    self.yuanyinStr = sender.titleLabel.text;
}
#pragma mark - 确认发布提示
-(void)overButton:(UIButton *)sender
{
    if (sender.tag - overViewButtonTag == 0) {
        NSLog(@"修改");
    }else{
        NSLog(@"发布");
        [self update];
    }
    [PellTableViewSelect hiden];
}

-(void)newFrame
{
    self.scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, Gato_Width, Gato_Height - Gato_Height_548_(47))];
    self.scrollView.backgroundColor = [UIColor appAllBackColor];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - Gato_Height_548_(47));
    [self.view addSubview: self.scrollView];
    
    
    self.yuanyinView.sd_layout.leftSpaceToView(self.scrollView,-1)
    .rightSpaceToView(self.scrollView,-1)
    .topSpaceToView(self.scrollView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(123));
    
    GatoViewBorderRadius(self.yuanyinView, 0, 1, [UIColor appAllBackColor]);
    
    self.timeView.sd_layout.leftSpaceToView(self.scrollView,-1)
    .rightSpaceToView(self.scrollView,-1)
    .topSpaceToView(self.yuanyinView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(86));
    
    GatoViewBorderRadius(self.timeView, 0, 1, [UIColor appAllBackColor]);
    
    self.beizhuView.sd_layout.leftSpaceToView(self.scrollView,-1)
    .rightSpaceToView(self.scrollView,-1)
    .topSpaceToView(self.timeView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(120));
    
    GatoViewBorderRadius(self.beizhuView, 0, 1, [UIColor appAllBackColor]);
    
    [self addYuanyin];
    [self addTime];
    [self addBeizhu];
}
-(void)addYuanyin
{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"停诊原因 *";
    label.font = FONT(34);
    label.textColor = [UIColor HDBlackColor];
    [self.yuanyinView addSubview:label];
    label.sd_layout.leftSpaceToView(self.yuanyinView,Gato_Width_320_(17))
    .topSpaceToView(self.yuanyinView,Gato_Width_320_(16))
    .rightSpaceToView(self.yuanyinView,Gato_Width_320_(17))
    .heightIs(Gato_Height_548_(20));
    
    [GatoMethods NSMutableAttributedStringWithLabel:label WithAllString:label.text WithColorString:@"*" WithColor:[UIColor redColor]];
    
    NSArray * buttonArray = @[@"出差",@"休假",@"临时工作安排",@"其他"];
    for (int i = 0  ;i < buttonArray.count  ; i ++) {
        UIButton * button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.tag = yuanyinButtonTag + i;
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(34);
        [button addTarget:self action:@selector(yuanyinButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.yuanyinView addSubview:button];
        
        button.sd_layout.leftSpaceToView(self.yuanyinView,i % 3 * Gato_Width_320_(76) + Gato_Width_320_(16))
        .topSpaceToView(self.yuanyinView,i / 3 * Gato_Height_548_(37) + Gato_Height_548_(42))
        .widthIs(Gato_Width_320_(70))
        .heightIs(Gato_Height_548_(26));
        
        if (i == 2) {
            button.sd_layout.widthIs(Gato_Width_320_(116));
        }
        
        GatoViewBorderRadius(button, 3, 1, [UIColor appAllBackColor]);
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"buttonSelect"];
        [self.yuanyinView addSubview:image];
        image.tag = i + yuanyinimageTag;
        image.hidden = YES;
        image.sd_layout.rightEqualToView(button)
        .bottomEqualToView(button)
        .widthIs(Gato_Width_320_(15))
        .heightIs(Gato_Height_548_(15));
        
        if (i == 0) {
            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
            GatoViewBorderRadius(button, 3, 1, [UIColor HDThemeColor]);
            image.hidden = NO;
            self.yuanyinStr = button.titleLabel.text;
        }
    }
}
-(void)addTime
{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"停诊时间 *";
    label.font = FONT(34);
    label.textColor = [UIColor HDBlackColor];
    [self.timeView addSubview:label];
    label.sd_layout.leftSpaceToView(self.timeView,Gato_Width_320_(17))
    .topSpaceToView(self.timeView,Gato_Width_320_(16))
    .rightSpaceToView(self.timeView,Gato_Width_320_(17))
    .heightIs(Gato_Height_548_(20));
    
    [GatoMethods NSMutableAttributedStringWithLabel:label WithAllString:label.text WithColorString:@"*" WithColor:[UIColor redColor]];
    
    self.leftTF = [[UITextField alloc]init];
    self.leftTF.textAlignment = NSTextAlignmentCenter;
    self.leftTF.textColor = [UIColor HDBlackColor];
    self.leftTF.placeholder = @"选择开始日期";
    self.leftTF.font = FONT(34);
    self.leftTF.delegate = self;
    [self.timeView addSubview:self.leftTF];
    
    self.leftTF.sd_layout.leftSpaceToView(self.timeView,Gato_Width_320_(16))
    .topSpaceToView(self.timeView,Gato_Width_320_(42))
    .widthIs(Gato_Width_320_(133))
    .heightIs(Gato_Height_548_(26));
    
    GatoViewBorderRadius(self.leftTF, 3, 1, [UIColor appAllBackColor]);
    
    
    self.rightTF = [[UITextField alloc]init];
    self.rightTF.textAlignment = NSTextAlignmentCenter;
    self.rightTF.textColor = [UIColor HDBlackColor];
    self.rightTF.placeholder = @"选择结束日期";
    self.rightTF.font = FONT(34);
    self.rightTF.delegate = self;
    [self.timeView addSubview:self.rightTF];
    
    self.rightTF.sd_layout.rightSpaceToView(self.timeView,Gato_Width_320_(16))
    .topSpaceToView(self.timeView,Gato_Width_320_(42))
    .widthIs(Gato_Width_320_(133))
    .heightIs(Gato_Height_548_(26));
    
    GatoViewBorderRadius(self.rightTF, 3, 1, [UIColor appAllBackColor]);
    
    
    self.leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.leftButton addTarget:self action:@selector(leftButtonText) forControlEvents:UIControlEventTouchUpInside];
    [self.timeView addSubview:self.leftButton];
    self.leftButton.sd_layout.leftSpaceToView(self.timeView,Gato_Width_320_(16))
    .topSpaceToView(self.timeView,Gato_Width_320_(42))
    .widthIs(Gato_Width_320_(133))
    .heightIs(Gato_Height_548_(26));
    
    
    self.righButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.righButton addTarget:self action:@selector(rightButtonText) forControlEvents:UIControlEventTouchUpInside];
    [self.timeView addSubview:self.righButton];
    self.righButton.sd_layout.rightSpaceToView(self.timeView,Gato_Width_320_(16))
    .topSpaceToView(self.timeView,Gato_Width_320_(42))
    .widthIs(Gato_Width_320_(133))
    .heightIs(Gato_Height_548_(26));
    
    
    
    UILabel * and = [[UILabel alloc]init];
    and.text = @"至";
    and.textColor = [UIColor YMAppAllTitleColor];
    and.textAlignment = NSTextAlignmentCenter;
    and.font = FONT(34);
    [self.timeView addSubview:and];
    
    and.sd_layout.leftSpaceToView(self.leftTF,0)
    .rightSpaceToView(self.rightTF,0)
    .topSpaceToView(self.timeView,Gato_Width_320_(42))
    .heightIs(Gato_Height_548_(26));
}


-(void)addBeizhu
{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"备注";
    label.font = FONT(34);
    label.textColor = [UIColor HDBlackColor];
    [self.beizhuView addSubview:label];
    label.sd_layout.leftSpaceToView(self.beizhuView,Gato_Width_320_(17))
    .topSpaceToView(self.beizhuView,Gato_Width_320_(16))
    .rightSpaceToView(self.beizhuView,Gato_Width_320_(17))
    .heightIs(Gato_Height_548_(20));
    
    self.textview = [[UITextView alloc]init];
    self.textview.font = FONT(34);
    self.textview.delegate = self;
    [self.beizhuView addSubview:self.textview];
    self.textview.sd_layout.leftSpaceToView(self.beizhuView,Gato_Width_320_(16))
    .rightSpaceToView(self.beizhuView,Gato_Width_320_(16))
    .topSpaceToView(self.beizhuView,Gato_Height_548_(38))
    .heightIs(Gato_Height_548_(65));
    
    self.textStrLenght = [[UILabel alloc]init];
    self.textStrLenght.text = @"0/50字";
    self.textStrLenght.textColor = [UIColor YMAppAllTitleColor];
    self.textStrLenght.font = FONT(34);
    self.textStrLenght.textAlignment = NSTextAlignmentRight;
    [self.beizhuView addSubview:self.textStrLenght];
    
    self.textStrLenght.sd_layout.rightSpaceToView(self.beizhuView,Gato_Width_320_(18))
    .bottomEqualToView(self.textview)
    .widthIs(Gato_Width_320_(100))
    .heightIs(Gato_Height_548_(20));
    
    GatoViewBorderRadius(self.textview, 3, 1, [UIColor appAllBackColor]);
    
    self.textViewPlaceholder = [[UILabel alloc]init];
    self.textViewPlaceholder.font = FONT(34);
    self.textViewPlaceholder.textColor = [UIColor YMAppAllTitleColor];
    self.textViewPlaceholder.text = @"请输入想要告诉患者的其他信息...";
    [self.beizhuView addSubview:self.textViewPlaceholder];
    self.textViewPlaceholder.sd_layout.leftSpaceToView(self.beizhuView,Gato_Width_320_(18))
    .rightSpaceToView(self.beizhuView,Gato_Width_320_(18))
    .topSpaceToView(self.beizhuView,Gato_Height_548_(40))
    .heightIs(Gato_Height_548_(25));
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == self.leftTF) {
        NSLog(@"leftTF %@",self.leftTF.text);
        return YES;
    }else if (textField == self.rightTF) {
        NSLog(@"leftTF %@",self.rightTF.text);
        return YES;
    }
    
    return NO;
}
#pragma mark - 控制textview长度 和 textview 代理方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];//得到输入框的内容
    if (self.textview == textView)  //判断是否时我们想要限定的那个输入框
    {
        self.textStrLenght.text = [NSString stringWithFormat:@"%ld/50字",toBeString.length];
        
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewPlaceholder.hidden = YES;
    return YES;
}
//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.textViewPlaceholder.hidden = YES;
    }else{
        self.textViewPlaceholder.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)yuanyinView
{
    if (!_yuanyinView) {
        _yuanyinView = [[UIView alloc]init];
        _yuanyinView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_yuanyinView];
    }
    return _yuanyinView;
}
-(UIView *)timeView
{
    if (!_timeView) {
        _timeView = [[UIView alloc]init];
        _timeView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_timeView];
    }
    return _timeView;
}
-(UIView *)beizhuView
{
    if (!_beizhuView) {
        _beizhuView = [[UIView alloc]init];
        _beizhuView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_beizhuView];
    }
    return _beizhuView;
}

-(void)addUnderButton
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    GatoViewBorderRadius( view, 0, 1, [UIColor appAllBackColor]);
    view.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(47));
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.Modify) {
        [button setTitle:@"确认修改" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"确认发布" forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor HDThemeColor]];
    [button addTarget:self action:@selector(chutingzhenButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FONT(30);
    [view addSubview:button];
    button.sd_layout.leftSpaceToView(view,Gato_Width_320_(65))
    .topSpaceToView(view,Gato_Height_548_(7))
    .rightSpaceToView(view,Gato_Width_320_(65))
    .bottomSpaceToView(view,Gato_Height_548_(7));
    
    GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
}

-(UIView *)overView
{
    if (!_overView) {
        _overView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width_320_(274), Gato_Height_548_(224))];
        _overView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_overView];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"公告内容";
        titleLabel.font = FONT(36);
        titleLabel.textColor = [UIColor redColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.overView addSubview:titleLabel];
        
        [GatoMethods TheNSUnderlineStyleAttributeNameWithLabel:titleLabel];
        
        titleLabel.sd_layout.leftSpaceToView(self.overView,0)
        .rightSpaceToView(self.overView,0)
        .topSpaceToView(self.overView,Gato_Height_548_(20))
        .heightIs(Gato_Height_548_(25));
        
        NSArray * MessageArray = @[[NSString stringWithFormat:@"停诊原因：%@",self.yuanyinStr]
                                   ,[NSString stringWithFormat:@"停诊时间：%@至%@",self.leftTF.text,self.rightTF.text]
                                   ,[NSString stringWithFormat:@"停诊备注：%@",self.textview.text]];
        for (int i = 0 ; i < MessageArray.count; i ++) {
            UILabel * label = [[UILabel alloc]init];
            label.text = MessageArray[i];
            label.textColor = [UIColor HDBlackColor];
            label.font = FONT_Bold_(30);
            [self.overView addSubview:label];
            label.sd_layout.leftSpaceToView(self.overView,Gato_Width_320_(18))
            .rightSpaceToView(self.overView,Gato_Width_320_(18))
            .topSpaceToView(self.overView,Gato_Height_548_(60) + i * Gato_Height_548_(25))
            .minHeightIs(Gato_Height_548_(25))
            .autoHeightRatio(0);
        }
        
        UILabel * timeLabel = [[UILabel alloc]init];
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        timeLabel.text = [NSString stringWithFormat:@"%@由医生本人发布",dateString];
        timeLabel.font = FONT(30);
        timeLabel.textColor = [UIColor YMAppAllTitleColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.overView addSubview:timeLabel];
        timeLabel.sd_layout.rightSpaceToView(self.overView,Gato_Width_320_(15))
        .topSpaceToView(self.overView,Gato_Height_548_(155))
        .leftSpaceToView(self.overView,Gato_Width_320_(15))
        .heightIs(Gato_Height_548_(15));
        
        for (int i = 0 ;i < 2; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = FONT(32);
            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
            button.tag = i + overViewButtonTag;
            [button addTarget:self action:@selector(overButton:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [button setTitle:@"返回修改" forState:UIControlStateNormal];
            }else{
                if (self.Modify) {
                    [button setTitle:@"确认修改" forState:UIControlStateNormal];
                }else{
                    [button setTitle:@"确认发布" forState:UIControlStateNormal];
                }
            }
            [self.overView addSubview:button];
            button.sd_layout.leftSpaceToView(self.overView,i * self.overView.width / 2 )
            .bottomSpaceToView(self.overView,0)
            .widthIs(self.overView.width / 2 )
            .heightIs(Gato_Height_548_(45));
            
            GatoViewBorderRadius(button, 0, 1, [UIColor appAllBackColor]);
        }
        
        GatoViewBorderRadius(self.overView, 5, 0, [UIColor redColor]);
    }
    return _overView;
}

@end
