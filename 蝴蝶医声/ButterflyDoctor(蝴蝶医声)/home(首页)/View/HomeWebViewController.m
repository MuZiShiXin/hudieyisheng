//
//  HomeWebViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/9.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "HomeWebViewController.h"
#import "GatoBaseHelp.h"
#import "PellTableViewSelect.h"
#import <UShareUI/UShareUI.h>

@interface HomeWebViewController ()<UIWebViewDelegate,UMSocialShareMenuViewDelegate>
@property (nonatomic ,strong) UIWebView * webView;
@property (nonatomic ,strong) NSString * webString;

@end

@implementation HomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Gato_Return
    self.title = @"蝴蝶医声";
    if (self.pushUrl) {
        [self updata];
    }else if (self.ContentId){
        [self updateContent];
    }
    


}

-(void)updata
{
    if (!self.pushUrl) {
        self.pushUrl = @"www.net5008.com";
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.pushUrl]];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    
}
-(void)updateContent
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.ContentId forKey:@"id"];
    [IWHttpTool post1WithURL:HD_Home_Banner_Content_ID params:params success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            self.webString = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"content"];
            self.webString = [NSString stringWithFormat:@"<html> \n"
                                    "<head> \n"
                                    "<style type=\"text/css\"> \n"
                                    "body {font-size:15px;}\n"
                                    "</style> \n"
                                    "</head> \n"
                                    "<body>"
                                    "<script type='text/javascript'>"
                                    "window.onload = function(){\n"
                                    "var $img = document.getElementsByTagName('img');\n"
                                    "for(var p in  $img){\n"
                                    " $img[p].style.width = '100%%';\n"
                                    "$img[p].style.height ='auto'\n"
                                    "}\n"
                                    "}"
                                    "</script>%@"
                                    "</body>"
                                    "</html>",self.webString];

            self.title = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"title"];
            [self setValue];
        }else{
            NSString * falseMessage = [[[dic objectForKey:@"data"] objectForKey:@"info"]objectForKey:@"message"];
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        //        [self hideProgressHUD];
    }];

}
-(void )setValue
{
    [self.webView loadHTMLString:self.webString baseURL:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
