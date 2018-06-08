//
//  WebArticleViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/2.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "WebArticlePushViewController.h"
#import "GatoBaseHelp.h"
@interface WebArticlePushViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIWebView * webView;

@end

@implementation WebArticlePushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Gato_Return
    self.title = @"文章详情";
    
    [self updata];
    
}

-(void)updata
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.pushURL]];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void )setValue
{
    [self.webView loadHTMLString:self.pushURL baseURL:nil];
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, Gato_Width, Gato_Height - 64)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        
    }
    return _webView;
}

@end
