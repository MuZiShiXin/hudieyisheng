//
//  forgetPasswordViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "forgetPasswordViewController.h"
#import "GatoBaseHelp.h"
#import "UIButton+CountDown.h"
#import "SVProgressHUD.h"

#define navHeight 64
#define TextFieldTag 4171546
@interface forgetPasswordViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,strong) UIButton * yanzhengma;
@property (nonatomic ,strong) UIButton * xieyi;
@property (nonatomic ,strong) UIButton * zhuce;
@property (nonatomic ,assign) BOOL NextButtonSelect;//是否填写完整信息
@end

@implementation forgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    [self newFrame];
    [self addLabel];
}
-(void)newFrame
{
    
    [self.view addSubview:self.navView];
    self.navView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(64);
    
    self.yanzhengma.sd_layout.rightSpaceToView(self.view,Gato_Width_320_(20))
    .topSpaceToView(self.view,Gato_Height_548_(32) + navHeight)
    .widthIs(Gato_Width_320_(91))
    .heightIs(Gato_Height_548_(37));
    
    
    
    self.zhuce.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(20))
    .rightSpaceToView(self.view,Gato_Width_320_(20))
    .topSpaceToView(self.view, 5 * Gato_Height_548_(69) + navHeight)
    .heightIs(Gato_Height_548_(32));
    
    self.xieyi.sd_layout.rightSpaceToView(self.view,Gato_Width_320_(20))
    .topSpaceToView(self.zhuce,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(150))
    .heightIs(Gato_Height_548_(30));
    
    GatoViewBorderRadius(self.yanzhengma, 5, 0, [UIColor redColor]);
    GatoViewBorderRadius(self.zhuce, 5, 0, [UIColor redColor]);
}
#pragma mark - 验证码
-(void)yanzhengmaButton:(UIButton *)sender
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:[self getTextFieldWithTag:0] forKey:@"phone"];
    [IWHttpTool postWithURL:HD_NewPassword_Code params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.yanzhengma startWithTime:59 title:@"重新发送" countDownTitle:@"s" mainColor:[UIColor HDThemeColor] countColor:[UIColor YMAppAllTitleColor]];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 联系助理
-(void)lianxizhuliButton:(UIButton *)sender
{
    [self getPhone];
}
#pragma mark - 给客服打电话
-(void)getPhone
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [IWHttpTool postWithURL:HD_Get_Phone params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSString * phone = [[dic objectForKey:@"data"] objectForKey:@"info"];
            UIWebView * callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phone]]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 下一步
-(void)nextButton:(UIButton *)sender
{
    
    NSMutableDictionary * TFDic = [NSMutableDictionary dictionary];
    [TFDic setObject:[self getTextFieldWithTag:0] forKey:@"phone"];
    [TFDic setObject:[self getTextFieldWithTag:1] forKey:@"yanzhengma"];
    [TFDic setObject:[self getTextFieldWithTag:2] forKey:@"password"];
    [TFDic setObject:[self getTextFieldWithTag:3] forKey:@"againPassword"];
    
    if (![[self getTextFieldWithTag:2] isEqualToString:[self getTextFieldWithTag:3]]) {
        [self showHint:@"两次输入密码不一致，请重新输入！"];
        return;
    }
    for (int i = 0 ; i < 4; i ++) {
        if ([self getTextFieldWithTag:i].length > 0) {
            self.NextButtonSelect = YES;
        } else{
            self.NextButtonSelect = NO;
            break;
        }
    }
    NSLog(@"TFDic %@",TFDic);
    
    
    if (self.NextButtonSelect == NO) {
        [self showHint:@"请输入完整信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    if ([self getTextFieldWithTag:2].length < 8) {
        [self showHint:@"密码不能少于8位"];
        return;
    }
    
//    NSArray * zimu = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
//    NSArray * shuzi = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
//    BOOL passwordZM = NO;
//    for (int i = 0 ; i < zimu.count ; i ++) {
//        if ([[self getTextFieldWithTag:3] rangeOfString:zimu[i]].location != NSNotFound) {
//            passwordZM = YES;
//            break;
//        }else
//        {
//            passwordZM = NO;
//            //条件为假，表示不包含要检查的字符串
//        }
//    }
//    if (passwordZM == YES) {
//        for (int i = 0 ; i < shuzi.count ; i ++) {
//            if ([[self getTextFieldWithTag:3] rangeOfString:shuzi[i]].location != NSNotFound) {
//                passwordZM = YES;
//                break;
//            }else
//            {
//                passwordZM = NO;
//                //条件为假，表示不包含要检查的字符串
//            }
//        }
//    }
//    if (passwordZM == NO) {
//        [self showHint:@"为了您的账号安全，密码设置需要字母+数字。"];
//        return;
//    }

    [self updata];
    
    
}
#pragma mark - 设置新密码
-(void)updata
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:[self getTextFieldWithTag:0] forKey:@"phone"];
    [self.updateParms setObject:[self getTextFieldWithTag:1] forKey:@"code"];
    [self.updateParms setObject:[self getTextFieldWithTag:2] forKey:@"password"];
    [IWHttpTool postWithURL:HD_NewPassword params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            if (self.navigationController) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
#pragma mark - 懒加载

-(void)addLabel
{
    NSArray * labelArray = @[@"输入注册时填写的手机号",@"输入验证码",@"输入新密码",@"再次输入新密码"];
    NSArray * imageArray = @[@"regsiter_icon_phone",@"regsiter_icon_auth-code",@"regsiter_icon_password",@"regsiter_icon_password1"];
    NSArray * textFieldArray = @[@"请输入手机号码",@"请输入验证码",@"请输入新密码",@"请再次输入新密码"];
    for (int i = 0 ; i < labelArray.count; i ++) {
        UILabel * label = [[UILabel alloc]init];
        label.text = labelArray[i];
        label.font = FONT(30);
        label.textColor = [UIColor HDBlackColor];
        [self.view addSubview:label];
        label.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(30))
        .rightSpaceToView(self.view,30)
        .heightIs(Gato_Height_548_(32))
        .topSpaceToView(self.view,i * Gato_Height_548_(69) + navHeight);
        
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        GatoViewBorderRadius(view, 5, 1, [UIColor HDViewBackColor]);
        view.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(20))
        .rightSpaceToView(self.view,Gato_Width_320_(20))
        .topSpaceToView(label,0)
        .heightIs(Gato_Height_548_(37));
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:image];
        
        CGFloat imageWidth = Gato_Width_320_(15);
        CGFloat imageHeight = Gato_Height_548_(21);
        switch (i) {
            case 0:
            {
                imageWidth = Gato_Width_320_(15);
                imageHeight = Gato_Height_548_(21);
            }
                break;
            case 1:
            {
                imageWidth = Gato_Width_320_(17);
                imageHeight = Gato_Height_548_(16);
            }
                break;
            case 2:
            {
                imageWidth = Gato_Width_320_(16);
                imageHeight = Gato_Height_548_(18);
            }
                break;
            case 3:
            {
                imageWidth = Gato_Width_320_(16);
                imageHeight = Gato_Height_548_(16);
            }
                break;
            default:
                break;
        }
        
        image.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
        .topSpaceToView(view,Gato_Height_548_(8))
        .widthIs(imageWidth)
        .heightIs(imageHeight);
        
        if (i == 0) {
            view.sd_layout.rightSpaceToView(self.view,Gato_Width_320_(118));
            image.sd_layout.topSpaceToView(view,Gato_Height_548_(10))
            .widthIs(Gato_Width_320_(17))
            .heightIs(Gato_Height_548_(16));
        }else if (i == 1){
            image.sd_layout.widthIs(Gato_Width_320_(16))
            .heightIs(Gato_Height_548_(18));
        }
        
        UITextField * textfield = [[UITextField alloc]init];
        textfield.tag = TextFieldTag + i;
        textfield.delegate = self;
        textfield.placeholder = textFieldArray[i];
        textfield.font = FONT(30);
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        [view addSubview:textfield];
        
        
        textfield.sd_layout.leftSpaceToView(view,Gato_Width_320_(42))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .rightSpaceToView(view,Gato_Width_320_(5));

        
        if (i == 2 || i == 3) {
            textfield.keyboardType = UIKeyboardTypeDefault;
            textfield.selected = YES;
            [textfield setSecureTextEntry:YES];
        }
        
    }
}

-(void)buttonDidClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"]) //按会车可以改变
    {
        return YES;
    }
    UITextField * textfield = (UITextField *)[self.view viewWithTag:0 + TextFieldTag];
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

-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 64)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(60), 64);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Gato_Width_320_(16), Gato_Height_548_(25),Gato_Width_320_(11), Gato_Height_548_(18))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];
        
        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, 63, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Gato_Width, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(40);
        if (self.titleStr) {
            label.text = self.titleStr;
        }else{
            label.text = @"忘记密码";
        }
        label.textColor = [UIColor whiteColor];
        [self.navView addSubview:label];
        [self.navView addSubview:button];
        
        
        image.sd_layout.centerYEqualToView(label);
        
    }
    return _navView;
}
-(UIButton *)zhuce
{
    if (!_zhuce) {
        _zhuce = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhuce setTitle:@"下一步" forState:UIControlStateNormal];
        [_zhuce setBackgroundColor:[UIColor HDThemeColor]];
        _zhuce.titleLabel.font = FONT(30);
        [_zhuce setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zhuce addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_zhuce];
    }
    return _zhuce;
}
-(UIButton * )xieyi
{
    if (!_xieyi) {
        _xieyi = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xieyi setTitle:@"遇到问题，联系医助" forState:UIControlStateNormal];
        _xieyi.titleLabel.font = FONT(24);
        [_xieyi setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [_xieyi addTarget:self action:@selector(lianxizhuliButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_xieyi];
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
        [self.view addSubview:_yanzhengma];
    }
    return _yanzhengma;
}

@end
