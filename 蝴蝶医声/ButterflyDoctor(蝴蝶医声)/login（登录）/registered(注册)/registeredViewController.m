//
//  registeredViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "registeredViewController.h"
#import "GatoBaseHelp.h"
#import "UIButton+CountDown.h"
#import "nextRigisteredViewController.h"

#import <Hyphenate/Hyphenate.h>
#import "AllTitleWebViewController.h"
#define TextFieldTag 4171522
#define navHeight 64
#define ViewTag 18032414
@interface registeredViewController ()<UITextFieldDelegate ,UIScrollViewDelegate>
{
    BOOL yanzhengmaSelect;//验证码开关 默认关闭
    int tupianCount;//图片验证
}
@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,strong) UIButton * yanzhengma;
@property (nonatomic ,strong) UIButton * tupianyanzhengma;
@property (nonatomic ,strong) UIButton * xieyi;
@property (nonatomic ,strong) UIButton * zhuce;
@property (nonatomic ,assign) BOOL NextButtonSelect;//是否填写完整信息

@property (nonatomic ,strong) UIScrollView * underView;
@end

@implementation registeredViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    yanzhengmaSelect = NO;
    
    [self newFrame];
    [self addLabel];
}
-(void)newFrame
{
    self.underView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Gato_Width , Gato_Height)];
    self.underView.delegate = self;
    [self.view addSubview:self.underView];
    self.underView.contentSize = CGSizeMake(Gato_Width, 5 * Gato_Height_548_(69) + navHeight + 20 + Gato_Height_548_(92));
    
    [self.view addSubview:self.navView];
    self.navView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(64 + Gato_iPhoneXHeight);
    
    tupianCount = 10+(arc4random() % 90);
    int BackR = 200 + (arc4random() % 56) ;
    int BackG = 200 + (arc4random() % 56) ;
    int BackB = 200 + (arc4random() % 56) ;
    int TitleR = (arc4random() % 256) ;
    int TitleG = 0;
    int TitleB = (arc4random() % 256) ;
    int TitleR1 = (arc4random() % 256) ;
    int TitleG1 = 0;
    int TitleB1 = (arc4random() % 256) ;
    [self.tupianyanzhengma setBackgroundColor: Gato_(BackR, BackG, BackB)];
    NSString*str = [NSString stringWithFormat:@"%d",tupianCount];
    NSMutableString *targerStr = [[NSMutableString alloc] initWithString:str ];
    [targerStr insertString:@" " atIndex:1];
    str = targerStr;
    NSMutableAttributedString* attributedString1 = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:Gato_(TitleR1, TitleG1, TitleB1) range:NSMakeRange(0,1)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:Gato_(TitleR, TitleG, TitleB) range:NSMakeRange(1,1)];
//    [self.tupianyanzhengma setTitle:attributedString1 forState:UIControlStateNormal];
    [self.tupianyanzhengma setAttributedTitle:attributedString1 forState:UIControlStateNormal];
    
    
   
    
    self.xieyi.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(20))
    .topSpaceToView(self.underView,Gato_Height_548_(470))
    .widthIs(Gato_Width_320_(180))
    .heightIs(Gato_Height_548_(20));
    
    [self.xieyi setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    
    self.zhuce.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(20))
    .rightSpaceToView(self.underView,Gato_Width_320_(20))
    .bottomSpaceToView(self.underView,Gato_Height_548_(20) + Gato_iPhoneXHeight * 2)
    .heightIs(Gato_Height_548_(32));
    
    GatoViewBorderRadius(self.yanzhengma, 5, 0, [UIColor redColor]);
    GatoViewBorderRadius(self.zhuce, 5, 0, [UIColor redColor]);
}
-(void)tupianyanzhengmaButtonDid:(UIButton *)sender
{
    tupianCount = 10+(arc4random() % 90);
    int BackR = 200 + (arc4random() % 56) ;
    int BackG = 200 + (arc4random() % 56) ;
    int BackB = 200 + (arc4random() % 56) ;
    int TitleR = (arc4random() % 256) ;
    int TitleG = 0;
    int TitleB = (arc4random() % 256) ;
    int TitleR1 = (arc4random() % 256) ;
    int TitleG1 = 0;
    int TitleB1 = (arc4random() % 256) ;
    [self.tupianyanzhengma setBackgroundColor: Gato_(BackR, BackG, BackB)];
    NSString*str = [NSString stringWithFormat:@"%d",tupianCount];
    NSMutableString *targerStr = [[NSMutableString alloc] initWithString:str ];
    [targerStr insertString:@" " atIndex:1];
    str = targerStr;
    NSMutableAttributedString* attributedString1 = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:Gato_(TitleR1, TitleG1, TitleB1) range:NSMakeRange(0,1)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:Gato_(TitleR, TitleG, TitleB) range:NSMakeRange(1,1)];
    //    [self.tupianyanzhengma setTitle:attributedString1 forState:UIControlStateNormal];
    
    [self.tupianyanzhengma setAttributedTitle:attributedString1 forState:UIControlStateNormal];
}
#pragma mark - 验证码
-(void)yanzhengmaButton:(UIButton *)sender
{
    if ([self getTextFieldWithTag:1].length != 11) {
        [self showHint:@"请输入正确手机号"];
        return;
    }
    
    if ([self getTextFieldWithTag:2].length != 2) {
        [self showHint:@"请输入正确图片验证码"];
        return;
    }
    if ([[self getTextFieldWithTag:2] isEqualToString:[NSString stringWithFormat:@"%d",tupianCount]]) {
        yanzhengmaSelect = YES;
    }else{
        yanzhengmaSelect = NO;
    }
    if (yanzhengmaSelect == NO) {
        [self showHint:@"请先验证图片验证码"];
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:[self getTextFieldWithTag:1] forKey:@"phone"];
    [IWHttpTool postWithURL:HD_ZhuCe_CODE params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.yanzhengma startWithTime:59 title:@"重新发送" countDownTitle:@"s" mainColor:[UIColor HDThemeColor] countColor:[UIColor YMAppAllTitleColor]];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
#pragma mark - 协议
-(void)xieyiButton:(UIButton *)sender
{
    AllTitleWebViewController * vc = [[AllTitleWebViewController alloc]init];
    vc.WebType = 2;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 注册
-(void)zhuceButton:(UIButton *)sender
{
    
    if ([self getTextFieldWithTag:0].length < 1) {
        [self showHint:@"请输入用户姓名"];
        return;
    }
    if ([self getTextFieldWithTag:1].length < 1) {
        [self showHint:@"请输入用户手机号"];
        return;
    }
    if ([self getTextFieldWithTag:3].length < 1) {
        [self showHint:@"请输入验证码"];
        return;
    }
    if ([self getTextFieldWithTag:4].length < 1) {
        [self showHint:@"请输入密码"];
        return;
    }
    if (![[self getTextFieldWithTag:5] isEqualToString:[self getTextFieldWithTag:4]]) {
        [self showHint:@"两次输入密码不相同，请重新输入"];
        return;
    }
    if ([self getTextFieldWithTag:4].length < 8) {
        [self showHint:@"密码不能少于8位"];
        return;
    }
    
    
    NSMutableDictionary * TFDic = [NSMutableDictionary dictionary];
    [TFDic setObject:[self getTextFieldWithTag:0] forKey:@"name"];
    [TFDic setObject:[self getTextFieldWithTag:1] forKey:@"phone"];
    [TFDic setObject:[self getTextFieldWithTag:3] forKey:@"yanzhengma"];
    [TFDic setObject:[self getTextFieldWithTag:4] forKey:@"password"];
    [TFDic setObject:[self getTextFieldWithTag:5] forKey:@"againPassword"];
    
    for (int i = 0 ; i < 6; i ++) {
        if ([self getTextFieldWithTag:i].length > 0) {
            self.NextButtonSelect = YES;
        } else{
            self.NextButtonSelect = NO;
            break;
        }
    }
    NSLog(@"TFDic %@",TFDic);
    
//#warning 方便更改下一个页面先关了 以后再开
    if (self.NextButtonSelect == NO) {
        [self showHint:@"请输入完整注册信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:[self getTextFieldWithTag:1] forKey:@"phone"];
    [self.updateParms setObject:[self getTextFieldWithTag:3] forKey:@"code"];
    [IWHttpTool postWithURL:HD_ZhuCe_CODE_CHECK params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
//             [self huanxinzhuce];
//            [self dengluhuanxin];
            nextRigisteredViewController * vc = [[nextRigisteredViewController alloc]init];
            vc.phone = [self getTextFieldWithTag:1];
            vc.name = [self getTextFieldWithTag:0];
            vc.password = [self getTextFieldWithTag:4];
            vc.code = [self getTextFieldWithTag:3];
            [self presentViewController:vc animated:YES completion:nil];
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
   
    
}
#pragma mark - 环信注册 并且登录
-(void)huanxinzhuce
{
    [[NSUserDefaults standardUserDefaults] setObject:[self getTextFieldWithTag:1] forKey:GET_HYP_PHOTO];
    [[NSUserDefaults standardUserDefaults] setObject:[self getTextFieldWithTag:4] forKey:GET_HYP_PASSWORD];
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:GATO_PHOTO password:GATO_PASSWORD];
    if (error==nil) {
        NSLog(@"注册成功");
    }
    
    [[EMClient sharedClient] registerWithUsername:GATO_PHOTO password:GATO_PASSWORD completion:^(NSString *aUsername, EMError *aError) {
        
        if (!aError) {
            [self dengluhuanxin];
        }else{
            switch (aError.code) {
                case EMErrorServerNotReachable:
                    [self alertMessage:(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"))];
                    break;
                case EMErrorUserAlreadyExist:
//                    [self alertMessage:(NSLocalizedString(@"register.repeat", @"You registered user already exists!"))];
                    [self dengluhuanxin];
                    break;
                case EMErrorNetworkUnavailable:
                    [self alertMessage:(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"))];
                    break;
                case EMErrorServerTimeout:
                    [self alertMessage:(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"))];
                    break;
                case EMErrorServerServingForbidden:
                    [self alertMessage:(NSLocalizedString(@"servingIsBanned", @"Serving is banned"))];
                    break;
                default:
                    [self alertMessage:(NSLocalizedString(@"register.fail", @"Registration failed"))];
                    break;
            }
        }
    }];
}
-(void)dengluhuanxin
{
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (!isAutoLogin) {
        [[EMClient sharedClient] loginWithUsername:GATO_PHOTO
                                          password:GATO_PASSWORD
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                nextRigisteredViewController * vc = [[nextRigisteredViewController alloc]init];
                                                vc.phone = [self getTextFieldWithTag:1];
                                                vc.name = [self getTextFieldWithTag:0];
                                                vc.password = [self getTextFieldWithTag:4];
                                                vc.code = [self getTextFieldWithTag:3];
                                                [self presentViewController:vc animated:YES completion:nil];
                                            } else {
                                                NSLog(@"登录失败");
                                            }
                                        }];
    }else{
        nextRigisteredViewController * vc = [[nextRigisteredViewController alloc]init];
        vc.phone = [self getTextFieldWithTag:1];
        vc.name = [self getTextFieldWithTag:0];
        [self presentViewController:vc animated:YES completion:nil];
    }
   

    
}
-(void)alertMessage:(NSString * )message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(NSString * )getTextFieldWithTag:(NSInteger )tag
{
    UITextField * textfield = (UITextField *)[self.view viewWithTag:tag + TextFieldTag];
    if (textfield.text.length > 0) {
        return textfield.text;
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buttonDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    
    if ([string isEqualToString:@"\n"]) //按会车可以改变
    {
        return YES;
    }
    UITextField * textfield = (UITextField *)[self.view viewWithTag:1 + TextFieldTag];
    if (textField == textfield) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
        NSInteger toInteger = 11;//限制长途
        
        if ([toBeString length] > toInteger) { //如果输入框内容大于20则弹出警告
            textField.text = [toBeString substringToIndex:toInteger];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"只能输入11位手机号！" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 懒加载

-(void)addLabel
{
    NSArray * labelArray = @[@"输入真实姓名",@"输入手机号码",@"输入图片验证码",@"输入短信验证码",@"输入密码",@"请重输入密码"];
    NSArray * imageArray = @[@"regsiter_icon_name",@"regsiter_icon_phone",@"tupianyanzhengma",@"regsiter_icon_auth-code",@"regsiter_icon_password",@"regsiter_icon_password1"];
    NSArray * textFieldArray = @[@"输入真实姓名",@"输入手机号码",@"输入图片验证码",@"输入短信验证码",@"输入密码",@"请重输入密码"];
    for (int i = 0 ; i < labelArray.count; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.text = labelArray[i];
        label.font = FONT(30);
        label.textColor = [UIColor HDBlackColor];
        [self.underView addSubview:label];
        label.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(30))
        .rightSpaceToView(self.underView,30)
        .heightIs(Gato_Height_548_(32))
        .topSpaceToView(self.underView,i * Gato_Height_548_(69) + navHeight);
        
        UIView * view = [[UIView alloc]init];
        view.tag = i + ViewTag;
        view.backgroundColor = [UIColor whiteColor];
        [self.underView addSubview:view];
        GatoViewBorderRadius(view, 5, 1, [UIColor appAllBackColor]);
        view.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(20))
        .rightSpaceToView(self.underView,Gato_Width_320_(20))
        .topSpaceToView(label,0)
        .heightIs(Gato_Height_548_(37));
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:image];
        
        image.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
        .topSpaceToView(view,Gato_Height_548_(8))
        .widthIs(Gato_Width_320_(15))
        .heightIs(Gato_Height_548_(21));
        
        if (i == 2 || i == 3) {
            view.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(118));
            image.sd_layout.topSpaceToView(view,Gato_Height_548_(10))
            .widthIs(Gato_Width_320_(17))
            .heightIs(Gato_Height_548_(16));
        }else if (i == 4){
            image.sd_layout.widthIs(Gato_Width_320_(16))
            .heightIs(Gato_Height_548_(18));
        }else if (i == 5){
            image.sd_layout.widthIs(Gato_Width_320_(16))
            .heightIs(Gato_Height_548_(18));
        }
        
        UITextField * textfield = [[UITextField alloc]init];
        textfield.tag = TextFieldTag + i;
        textfield.delegate = self;
        textfield.placeholder = textFieldArray[i];
        textfield.textColor = [UIColor HDBlackColor];
        textfield.font = FONT(30);
        [view addSubview:textfield];
        
        textfield.sd_layout.leftSpaceToView(view,Gato_Width_320_(42))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .rightSpaceToView(view,Gato_Width_320_(5));
        
        if (i == 1 || i == 2 || i == 3) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 5 || i == 4){
            [textfield setSecureTextEntry:YES];
        }
        
        
//        if ( i == 2) {
//            self.yanzhengma.sd_layout.bottomEqualToView(view);
//        }else if (i == 4){
//            self.xieyi.sd_layout.topSpaceToView(view, Gato_Height_548_(0));
//        }
    }
    
    UIView * tupianView = (UIView *)[self.view viewWithTag:2 + ViewTag];
    self.tupianyanzhengma.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(20))
    .centerYEqualToView(tupianView)
    .widthIs(Gato_Width_320_(91))
    .heightIs(Gato_Height_548_(37));
    GatoViewBorderRadius(self.tupianyanzhengma, 5, 0, [UIColor redColor]);
    
    
    UIView * yanzhengView = (UIView *)[self.view viewWithTag:3 + ViewTag];
    self.yanzhengma.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(20))
    .centerYEqualToView(yanzhengView)
    .widthIs(Gato_Width_320_(91))
    .heightIs(Gato_Height_548_(37));
}


-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 64 + Gato_iPhoneXHeight)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(60), 64);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, 63 + Gato_iPhoneXHeight, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 + Gato_iPhoneXHeight, Gato_Width, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(40);
        label.text = @"注册";
        label.textColor = [UIColor whiteColor];
        [self.navView addSubview:label];
        [self.navView addSubview:button];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Gato_Width_320_(16), Gato_Height_548_(25) + Gato_iPhoneXHeight,Gato_Width_320_(11), Gato_Height_548_(18))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];
        
        image.sd_layout.centerYEqualToView(label);
        

    }
    return _navView;
}

-(UIButton *)zhuce
{
    if (!_zhuce) {
        _zhuce = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhuce setTitle:@"确认注册" forState:UIControlStateNormal];
        [_zhuce setBackgroundColor:[UIColor HDThemeColor]];
        _zhuce.titleLabel.font = FONT(30);
        [_zhuce setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zhuce addTarget:self action:@selector(zhuceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_zhuce];
    }
    return _zhuce;
}
-(UIButton * )xieyi
{
    if (!_xieyi) {
        _xieyi = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xieyi setTitle:@"《蝴蝶医声注册服务条款》" forState:UIControlStateNormal];
        _xieyi.titleLabel.font = FONT(24);
        [_xieyi setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [_xieyi addTarget:self action:@selector(xieyiButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_xieyi];
    }
    return _xieyi;
}

-(UIButton *)yanzhengma
{
    if (!_yanzhengma) {
        _yanzhengma = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yanzhengma setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_yanzhengma setBackgroundColor:[UIColor HDThemeColor]];
        _yanzhengma.titleLabel.font = FONT(30);
        [_yanzhengma setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yanzhengma addTarget:self action:@selector(yanzhengmaButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_yanzhengma];
    }
    return _yanzhengma;
}
- (UIButton * )tupianyanzhengma
{
    if (!_tupianyanzhengma) {
        _tupianyanzhengma = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tupianyanzhengma setBackgroundColor:[UIColor HDThemeColor]];
        _tupianyanzhengma.titleLabel.font = FONT(50);
        [_tupianyanzhengma setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tupianyanzhengma addTarget:self action:@selector(tupianyanzhengmaButtonDid:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_tupianyanzhengma];
    }
    return _tupianyanzhengma;
}


@end
