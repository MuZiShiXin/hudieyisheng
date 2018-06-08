//
//  WebArticleViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "WebArticleViewController.h"
#import "GatoBaseHelp.h"
#import "PellTableViewSelect.h"
#import <UShareUI/UShareUI.h>
#import "YBPopupMenu.h"

static NSString* const UMS_THUMB_IMAGE = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496457088&di=2e245b0d4d6a892a4bfb0264623eebaf&imgtype=jpg&er=1&src=http%3A%2F%2Fpic3.16pic.com%2F00%2F46%2F60%2F16pic_4660163_b.jpg";
static NSString* const UMS_WebLink = @"http://www.net5008.com";

@interface WebArticleViewController ()<UIWebViewDelegate,UMSocialShareMenuViewDelegate,YBPopupMenuDelegate>
{
    UIImageView * logoImage;
}
@property (nonatomic ,strong) UIWebView * webView;
@property (nonatomic ,strong) NSString * webString;

@property (nonatomic ,strong) NSString * UM_URL;
@end

@implementation WebArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Gato_Return
    self.title = @"文章详情";
    [self addUnderButton];
    [self updata];
    UIButton*right1Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(5))];
    [right1Button setBackgroundImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    right1Button.titleLabel.font = FONT(30);
    [right1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right1Button addTarget:self action:@selector(mobanButton:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:right1Button];
    self.navigationItem.rightBarButtonItem = rightItem1;
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
//                                               @(UMSocialPlatformType_Sina),
                                               ]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];

    logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    logoImage.image = [UIImage imageNamed:@"180x180"];
    [self.view addSubview:logoImage];
    
}
-(void)updata
{
    self.UM_URL = [NSString stringWithFormat:@"%@?articleId=%@",HD_Article_Web_Center,self.articleId];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?articleId=%@",HD_Article_Web_Center,self.articleId]];
    
    // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. 发送请求给服务器
    [self.webView loadRequest:request];
    [self webViewDidFinishLoad:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 360;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     //     "var httpP = \"http://webapi.houno.cn\"+imageArr[i].getAttribute(\"src\");"
     //     "imageArr[i].setAttribute(\"src\",httpP);"  // 遇到返回图片路径不是全路径的情况拼接，但没有成功！估计是加载先后顺序问题导致，这个方法走的时候已经加载完成。
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}


-(void)mobanButton:(UIButton *)sender
{
    NSArray * array ;
    NSArray * imageArray ;
    if ([self.isOwner isEqualToString:@"1"]) {
        array = @[@"分享",@"删除"];
        imageArray = @[@"fenxiangicon",@"shanchuicon"];
    }else{
        array = @[@"分享"];
        imageArray = @[@"fenxiangicon"];
    }
    
    [YBPopupMenu showRelyOnView:sender titles:array icons:imageArray menuWidth:120 delegate:self];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index == 0) {
        [self showBottomCircleView];
    }else{
        [self deleteArticle];
    }
}


-(void)deleteArticle
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.articleId forKey:@"articleId"];
    [IWHttpTool postWithURL:HD_Home_info_Article_Delete params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 分享
- (void)showBottomCircleView
{
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  UMS_THUMB_IMAGE;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"蝴蝶医声" descr:self.titleStr thumImage:logoImage.image];
    //设置网页地址
    shareObject.webpageUrl = self.UM_URL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    

        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {

            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
            NSString *result = nil;
            if (!error) {
                result = [NSString stringWithFormat:@"Share succeed"];
            }
            else{
                NSMutableString *str = [NSMutableString string];
                if (error.userInfo) {
                    for (NSString *key in error.userInfo) {
                        [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
                    }
                }
                if (error) {
                    result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
                }
                else{
                    result = [NSString stringWithFormat:@"Share fail"];
                }
            }

            [GatoMethods AleartViewWithMessage:result];
            
        }];
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
    [button setTitle:@"引用文章" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor HDThemeColor]];
    [button addTarget:self action:@selector(yinyongButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FONT(30);
    [view addSubview:button];
    button.sd_layout.leftSpaceToView(view,Gato_Width_320_(65))
    .topSpaceToView(view,Gato_Height_548_(7))
    .rightSpaceToView(view,Gato_Width_320_(65))
    .bottomSpaceToView(view,Gato_Height_548_(7));
    
    GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);

}
#pragma makr - 文章引用
-(void)yinyongButton:(UIButton *)sender
{
//
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.articleId forKey:@"articleId"];
    [IWHttpTool postWithURL:HD_Article_Quote params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"已引用，请在我的文章列表查看"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void )setValue
{
    [self.webView loadHTMLString:self.webString baseURL:nil];
}


-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, Gato_Width, Gato_Height - 64 - Gato_Height_548_(47))];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        
    }
    return _webView;
}

@end
