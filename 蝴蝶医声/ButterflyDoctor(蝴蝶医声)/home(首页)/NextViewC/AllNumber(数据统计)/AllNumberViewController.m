//
//  AllNumberViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllNumberViewController.h"
#import "GatoBaseHelp.h"
#import "AllNumberTitleModel.h"
#import "PellTableViewSelect.h"
@interface AllNumberViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong) UIButton * AllNumber;
@property (nonatomic ,strong) UIButton * oneNumber;
@property (nonatomic ,strong) UIView * underFgx;
@property (nonatomic ,strong) UIImageView * AllImage;
@property (nonatomic ,strong) UIImageView * OneImage;
@property (nonatomic ,strong) UIWebView * webView;
@property (nonatomic ,strong) NSString * Url;
@end

@implementation AllNumberViewController


-(void)oneNumberButton:(UIButton *)sender
{
    
    NSMutableArray * titleArray = [NSMutableArray array];
    for (int i = 0 ; i < self.updataArray.count; i ++) {
        AllNumberTitleModel * model = [[AllNumberTitleModel alloc]init];
        model = self.updataArray[i];
        [titleArray addObject:model.name];
    }
    if (titleArray.count < 1) {
        [self showHint:@"您还没有加入分组，无法查看单科数据"];
        return;
    }
    UIAlertController * classSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            AllNumberTitleModel * model = [[AllNumberTitleModel alloc]init];
            model = self.updataArray[i];
            self.Url = [NSString stringWithFormat:@"%@?doctorId=%@",HD_Home_Web_statistics_One,model.doctorId];
            [self webViewUpdate];
            [self.oneNumber setTitle:titleArray[i] forState:UIControlStateNormal];
            [self.AllNumber setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
            [self.oneNumber setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.3 // 动画时长
                             animations:^{
                                 self.underFgx.x = sender.x;
                             }];

        }];
        [classSheet addAction:action];
    }
    UIAlertAction * quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [classSheet addAction:quxiao];
    [self presentViewController:classSheet animated:YES completion:nil];
    
//    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(0, Gato_Height_548_(39) + NAV_BAR_HEIGHT, Gato_Width, Gato_Height_548_(150)) selectData:titleArray action:^(NSInteger index) {
//        AllNumberTitleModel * model = [[AllNumberTitleModel alloc]init];
//        model = self.updataArray[index];
//        NSLog(@"点击了 %@",model.name);
//        self.Url = [NSString stringWithFormat:@"%@?doctorId=%@",HD_Home_Web_statistics_One,model.doctorId];
//        [self webViewUpdate];
//        [self.oneNumber setTitle:model.name forState:UIControlStateNormal];
//        [self.AllNumber setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
//        [self.oneNumber setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.3 // 动画时长
//                         animations:^{
//                             self.underFgx.x = sender.x;
//                         }];
//    } animated:YES];
    
    
}
-(void)AllNumberButton:(UIButton *)sender
{
    [self.AllNumber setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    [self.oneNumber setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 // 动画时长
                     animations:^{
                         self.underFgx.x = sender.x;
                     }];
     self.Url = [NSString stringWithFormat:@"%@?doctorId=%@",HD_Home_Web_statistics,TOKEN];
     [self webViewUpdate];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appAllBackColor];
    Gato_Return
    self.title = @"数据统计";
//    self.Url = HD_Home_Web_statistics;
    self.Url = [NSString stringWithFormat:@"%@?doctorId=%@",HD_Home_Web_statistics,TOKEN];
    [self updata];
    [self newFrame];
    [self webViewUpdate];
   
    
}
-(void)updata
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Home_NumberImage_AllTeam params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                AllNumberTitleModel * model = [[AllNumberTitleModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];

}

-(void)webViewUpdate
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.Url]];
        // 2. 把URL告诉给服务器,请求,从m.baidu.com请求数据
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        // 3. 发送请求给服务器
        [self.webView loadRequest:request];
    });
   

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
-(void)newFrame
{
    self.AllNumber.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(39));
    
    self.oneNumber.sd_layout.leftSpaceToView(self.AllNumber,0)
    .topEqualToView(self.AllNumber)
    .rightSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(39));
    
    self.AllImage.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(14))
    .widthIs(Gato_Width_320_(11))
    .topSpaceToView(self.view,Gato_Width_320_(12) );
    
    self.OneImage.sd_layout.leftSpaceToView(self.view,Gato_Width / 2 + Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(14))
    .widthIs(Gato_Width_320_(11))
    .topSpaceToView(self.view,Gato_Width_320_(12) );
    
    self.underFgx.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,Gato_Height_548_(37) )
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(2));
 
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.view addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.view, Gato_Width / 2)
    .topSpaceToView(self.view, Gato_Height_548_(5))
    .widthIs(Gato_Width_320_(1))
    .heightIs(Gato_Height_548_(29));
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)underFgx
{
    if (!_underFgx) {
        _underFgx = [[UIView alloc]init];
        _underFgx.backgroundColor = [UIColor HDThemeColor];
        [self.view addSubview:_underFgx];
    }
    return _underFgx;
}
-(UIImageView *)OneImage
{
    if (!_OneImage) {
        _OneImage = [[UIImageView alloc]init];
        _OneImage.image = [UIImage imageNamed:@"home_icon_data-statistics1"];
        [self.view addSubview:_OneImage];
    }
    return _OneImage;
}
-(UIImageView *)AllImage
{
    if (!_AllImage) {
        _AllImage = [[UIImageView alloc]init];
        _AllImage.image = [UIImage imageNamed:@"home_icon_data-statistics"];
        [self.view addSubview:_AllImage];
    }
    return _AllImage;
}
-(UIButton *)oneNumber
{
    if (!_oneNumber) {
        _oneNumber = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneNumber setTitle:@"医疗组数据" forState:UIControlStateNormal];
        [_oneNumber setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        [_oneNumber setBackgroundColor:[UIColor whiteColor]];
        _oneNumber.titleLabel.font = FONT(26);
        [_oneNumber addTarget:self action:@selector(oneNumberButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_oneNumber];
    }
    return _oneNumber;
}
-(UIButton *)AllNumber
{
    if (!_AllNumber) {
        _AllNumber = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AllNumber setTitle:@"全科数据" forState:UIControlStateNormal];
        [_AllNumber setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [_AllNumber setBackgroundColor:[UIColor whiteColor]];
        _AllNumber.titleLabel.font = FONT(26);
        [_AllNumber addTarget:self action:@selector(AllNumberButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_AllNumber];
    }
    return _AllNumber;
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, Gato_Height_548_(40), Gato_Width, Gato_Height - Gato_Height_548_(39) - NAV_BAR_HEIGHT)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)dealloc
{
    NSLog(@"释放了");
}

@end
