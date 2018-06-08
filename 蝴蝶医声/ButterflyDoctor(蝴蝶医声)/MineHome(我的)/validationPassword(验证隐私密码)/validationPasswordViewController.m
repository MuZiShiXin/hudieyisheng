//
//  validationPasswordViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/24.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "validationPasswordViewController.h"
#import "TXTradePasswordView.h"
#import "GatoBaseHelp.h"
#import <IQKeyboardManager.h>
#import "MineHomeViewController.h"
#import "MyAccountViewController.h"
#import "MyAccountDetailVC.h"
#import "MineBankCardViewController.h"
@interface validationPasswordViewController ()<TXTradePasswordViewDelegate>
{
    TXTradePasswordView *TXView ;
    NSString * payPassword;
}

@end

@implementation validationPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Gato_Return
    self.title = @"验证隐私密码";
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 30,SCREEN_WIDTH, 100) WithTitle:@"请输入隐私密码"];
    TXView.TXTradePasswordDelegate = self;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    //给self.view添加一个手势监测；
    [TXView addGestureRecognizer:singleRecognizer];
    if (![TXView.TF becomeFirstResponder])
    {
        //成为第一响应者。弹出键盘
        [TXView.TF becomeFirstResponder];
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self.view addSubview:TXView];
    
}
-(void)rightButtonDidClicked
{
    if (payPassword.length != 4) {
        [self showHint:@"请输入正确的安全密码"];
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:payPassword forKey:@"safePassword"];
    [IWHttpTool postWithURL:HD_Mine_Other_PayPassword_VA params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            if (self.pushType == 0) {
                MyAccountViewController * vc = [[MyAccountViewController alloc]init];
                vc.pushType = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (self.pushType == 1) {
                MyAccountDetailVC * vc = [[MyAccountDetailVC alloc]init];
                vc.pushType = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (self.pushType == 2){
                MineBankCardViewController * vc = [[MineBankCardViewController alloc]init];
                vc.pushType = 1;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [GatoMethods AleartViewWithMessage:falseMessage];
            self->TXView.TF.text = @"";
            [self->TXView textFieldDidChange:TXView.TF];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    
    [TXView.TF becomeFirstResponder];
    
}


#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    NSLog(@"密码 = %@",Password);
    payPassword = Password;
    
    //    [self showMessage:[NSString stringWithFormat:@"密码为 : %@",Password] duration:3];
}

@end
