//
//  PayLoginPasswordViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "PayLoginPasswordViewController.h"
#import "GatoBaseHelp.h"
#import "forgetPasswordViewController.h"
#import "PayPasswordViewController.h"
@interface PayLoginPasswordViewController ()
@property (nonatomic ,strong)UIView * textView;
@property (nonatomic ,strong)UITextField * password;
@property (nonatomic ,strong)UIButton * forgetButton;
@property (nonatomic ,strong)UIButton * nextButton;
@end

@implementation PayLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"输入登录密码";
    [self newFrame];
}
-(void)newFrame
{
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    self.textView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(19))
    .rightSpaceToView(self.view,Gato_Width_320_(19))
    .topSpaceToView(self.view,Gato_Height_548_(58))
    .heightIs(Gato_Height_548_(37));
    
    GatoViewBorderRadius(self.textView, 5, 1, [UIColor HDViewBackColor]);
    
    self.password.sd_layout.leftSpaceToView(self.textView,Gato_Width_320_(42))
    .topSpaceToView(self.textView,Gato_Height_548_(0))
    .rightSpaceToView(self.textView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(37));
    
    self.forgetButton.sd_layout.rightSpaceToView(self.view,Gato_Width_320_(19))
    .topSpaceToView(self.textView,Gato_Height_548_(20))
    .widthIs(Gato_Width_320_(100))
    .heightIs(Gato_Height_548_(20));
    
    self.nextButton.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(19))
    .rightSpaceToView(self.view,Gato_Width_320_(19))
    .topSpaceToView(self.view,Gato_Height_548_(169))
    .heightIs(Gato_Height_548_(32));
    
     GatoViewBorderRadius(self.nextButton, 5, 0, [UIColor appAllBackColor]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)forgetButtonDidClicked
{
    forgetPasswordViewController * vc = [[forgetPasswordViewController alloc]init];
    vc.titleStr = @"忘记密码";
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)nextButtonDidClicked
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.password.text forKey:@"password"];
    [IWHttpTool postWithURL:HD_Mine_Password_validation params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            PayPasswordViewController * vc = [[PayPasswordViewController alloc]init];
            vc.loginPassword = self.password.text;
            vc.shezhi = @"1";
            vc.comeWhere = self.comeWhere;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(UIView *)textView
{
    if (!_textView) {
        _textView = [[UIView alloc]init];
        _textView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_textView];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"login_icon_password-1"];
        [self.textView addSubview:image];
        image.sd_layout.leftSpaceToView(self.textView,Gato_Width_320_(15))
        .topSpaceToView(self.textView,Gato_Height_548_(10))
        .widthIs(Gato_Width_320_(15))
        .heightIs(Gato_Height_548_(16));
        
        
    }
    return _textView;
}
-(UITextField *)password
{
    if (!_password) {
        _password = [[UITextField alloc]init];
        _password.placeholder = @"请输入登录密码";
        [_password setSecureTextEntry:YES];
        _password.font = FONT(26);
        [self.textView addSubview:_password];
    }
    return _password;
}

-(UIButton *)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = FONT(26);
        [_forgetButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(forgetButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_forgetButton];
    }
    return _forgetButton;
}
-(UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setBackgroundColor:[UIColor HDThemeColor]];
        [_nextButton addTarget:self action:@selector(nextButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

@end
