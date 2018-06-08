//
//  AllTitleWebViewController.m
//  meirunanian
//
//  Created by 辛书亮 on 2017/4/14.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllTitleWebViewController.h"
#import "GatoBaseHelp.h"


@interface AllTitleWebViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,strong) UIWebView * webView;
@property (nonatomic ,strong) NSString * webString;
@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) NSString * Url;
@end

@implementation AllTitleWebViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    

    if (self.WebType == 0) {
        self.titleLabel.text = @"关于我们";
        self.Url = HD_Guanyuwomen;
    }else if (self.WebType == 1){
        self.Url = HD_Fuwutiaokuan;
        self.titleLabel.text = @"用户服务条款";
    }else if(self.WebType == 2){
        self.Url = HD_Fuwutiaokuan_ZC;
        self.titleLabel.text = @"注册服务条款";
    }
    
    [self newFrame];
    [self Updata];
}
-(void)newFrame
{
    self.navView.sd_layout.leftSpaceToView(self.view , 0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(64);
    
    self.titleLabel.sd_layout.leftSpaceToView(self.navView,0)
    .rightSpaceToView(self.navView,0)
    .topSpaceToView(self.navView,20)
    .heightIs(44);
}
-(void )setValue
{
    [self.webView loadHTMLString:self.webString baseURL:nil];
}



#pragma mark 获取用户协议
-(void)Updata
{
    if (self.Url.length < 1) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [IWHttpTool post1WithURL:self.Url params:params success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.webString = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"content"];
            [self setValue];
        }else{
            NSString * falseMessage = [[[dic objectForKey:@"data"] objectForKey:@"info"]objectForKey:@"message"];
            
        }
       
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        //        [self hideProgressHUD];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buttonDidClicked
{
    if (self.navigationController != nil)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 64)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(70), 64);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Gato_Width_320_(16), Gato_Height_548_(25),Gato_Width_320_(11), Gato_Height_548_(18))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];

        
        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, 63, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];
        [self.navView addSubview:button];
        
    }
    return _navView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT(36);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.navView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 64, Gato_Width, Gato_Height - 64)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        
    }
    return _webView;
}


@end
