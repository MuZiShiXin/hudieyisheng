//
//  MineBankCardViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MineBankCardViewController.h"
#import "GatoBaseHelp.h"
#import "addBankCardViewController.h"

@interface MineBankCardViewController ()
@property (nonatomic ,strong) UIView * cardView;
@property (nonatomic ,strong) UIImageView * cardImage;
@property (nonatomic ,strong) UILabel * cardName;
@property (nonatomic ,strong) UILabel * cardNumber;
@property (nonatomic ,strong) UILabel * shenhe;
@property (nonatomic ,strong) UIButton * right2Button;//右上角
@property (nonatomic ,strong) UILabel * topLabel;//上方提示文字
@end

@implementation MineBankCardViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self update];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appAllBackColor];
    if (self.pushType == 1) {
        GatoReturnButton *returnButton = [[GatoReturnButton alloc] initWithTarget:self IsAccoedingBar:YES WithRootViewControllers:1];\
        self.navigationItem.leftBarButtonItem = returnButton;
    }else{
        Gato_Return
    }
    self.title = @"提现银行卡";
    self.right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(18),Gato_Height_548_(18))];
    [self.right2Button setBackgroundImage:[UIImage imageNamed:@"addBankCard"] forState:UIControlStateNormal];
    self.right2Button.titleLabel.font = FONT(30);
    [self.right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.right2Button addTarget:self action:@selector(searchButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:self.right2Button];
    self.navigationItem.rightBarButtonItems = @[rightItem2];
    
    [self newFrame];
    
    
    
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"为了您的资金安全，不建议更换提现银行卡。\n如遇到特殊情况，请联系医助>>";
    label.textColor = [UIColor HDBlackColor];
    label.numberOfLines = 0;
    label.font = FONT(30);
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(16))
    .topSpaceToView(self.cardView,Gato_Height_548_(10))
    .widthIs(Gato_Width)
    .heightIs(Gato_Height_548_(30));

    [GatoMethods NSMutableAttributedStringWithLabel:label WithAllString:label.text WithColorString:@"联系医助>>" WithColor:[UIColor HDThemeColor]];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(getPhoneWithButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(16))
    .topSpaceToView(self.cardView,Gato_Height_548_(10))
    .widthIs(Gato_Width)
    .heightIs(Gato_Height_548_(30));
}
-(void)getPhoneWithButton
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

-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_Bank params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            // isVerify -1审核失败 0审核 1成功
            self.right2Button.hidden = YES;
            
            NSString * isVer = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"isVerify"];
            if ([isVer isEqualToString:@"-1"]) {
                self.shenhe.text = @"审核失败，请重新添加";
                self.right2Button.hidden = NO;
            }else if ([isVer isEqualToString:@"0"]){
                self.shenhe.text = @"审核中";
                
            }else{
                self.shenhe.text = @"";
                self.navigationItem.rightBarButtonItems = nil;
                self.topLabel.hidden = NO;
            }

#warning 这里没有给返回银行卡图标
            [self.cardImage sd_setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@""]];
            self.cardName.text = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"bank"];
            self.cardNumber.text = [self getBankNumberWithString:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"bankNumber"]];
            
        }else if ([success isEqualToString:@"400"]){
            
            self.cardImage.image = [UIImage imageNamed:@"logo"];
            self.cardName.text = @"您还没有绑定银行卡";
            self.cardName.textColor = [UIColor HDTitleRedColor];
            self.cardNumber.text = @"请点击右上角绑定银行卡";
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)searchButton
{
    addBankCardViewController * vc = [[addBankCardViewController alloc]init];
    vc.AddOrModify = @"1";
    if ([self.shenhe.text isEqualToString: @"审核失败，请重新添加"]) {
        vc.AddOrModify = @"2";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)newFrame
{
    
    self.topLabel.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(16))
    .rightSpaceToView(self.view, Gato_Width_320_(16))
    .topSpaceToView(self.view, Gato_Height_548_(15))
    .heightIs(Gato_Height_548_(40));
    
    self.cardView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(16))
    .topSpaceToView(self.topLabel,Gato_Height_548_(16))
    .rightSpaceToView(self.view,Gato_Width_320_(16))
    .heightIs(Gato_Height_548_(82));
    
    GatoViewBorderRadius(self.cardView, 5, 1, [UIColor HDViewBackColor]);
    
    
    self.cardImage.sd_layout.leftSpaceToView(self.cardView,Gato_Width_320_(22))
    .topSpaceToView(self.cardView,Gato_Height_548_(35))
    .widthIs(Gato_Width_320_(32))
    .heightIs(Gato_Height_548_(32));
    
    self.cardName.sd_layout.leftSpaceToView(self.cardImage,Gato_Width_320_(16))
    .topEqualToView(self.cardImage)
    .rightSpaceToView(self.cardView,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(16));
    
    self.cardNumber.sd_layout.leftSpaceToView(self.cardImage,Gato_Width_320_(16))
    .topSpaceToView(self.cardName,0)
    .rightSpaceToView(self.cardView,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(16));
    
    
    self.shenhe.sd_layout.rightSpaceToView(self.cardView,Gato_Width_320_(10))
    .leftSpaceToView(self.cardView,Gato_Width_320_(10))
    .topSpaceToView(self.cardView,0)
    .heightIs(Gato_Width_320_(30));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getBankNumberWithString:(NSString *)banknumber
{
    NSString * getNumber = @"";
    if (banknumber.length > 11) {
        NSString*bStr = [banknumber substringWithRange:NSMakeRange(banknumber.length - 6,6)];
        for (int i = 0 ; i < banknumber.length - 6; i ++) {
            if (i == 0) {
                getNumber = @"*";
            }else{
                getNumber = [NSString stringWithFormat:@"%@*",getNumber];
            }
        }
        getNumber = [NSString stringWithFormat:@"%@%@",getNumber,bStr];
    }
//    NSMutableString * overNumber = [[NSMutableString alloc]initWithString:getNumber];
//    overNumber = getNumber;
    NSString * overNumber = @"";
    for (int i = 0 ; i < getNumber.length ; i ++) {
        NSMutableString* str8=[[NSMutableString alloc]initWithString:getNumber];
        NSRange ange={i,1};
        NSString* str9=[str8 substringWithRange:ange];
        if (i % 4 == 0) {
            overNumber = [NSString stringWithFormat:@"%@ %@",overNumber,str9];
        }else{
            overNumber = [NSString stringWithFormat:@"%@%@",overNumber,str9];
        }
    }
    return overNumber;
}
-(UIView *)cardView
{
    if (!_cardView) {
        _cardView = [[UIView alloc]init];
        _cardView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_cardView];
        
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"我的提现银行卡";
        label.textColor = [UIColor HDBlackColor];
        label.font = FONT_Bold_(32);
        [self.cardView addSubview:label];
        label.sd_layout.leftSpaceToView(self.cardView,Gato_Width_320_(22))
        .topSpaceToView(self.cardView,0)
        .widthIs(Gato_Width)
        .heightIs(Gato_Height_548_(30));
        
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor HDViewBackColor];
        [self.cardView addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(self.cardView, Gato_Width_320_(22))
        .rightSpaceToView(self.cardView, 0)
        .topSpaceToView(label, 0)
        .heightIs(Gato_Height_548_(1));
        
    }
    return _cardView;
}

-(UIImageView *)cardImage
{
    if (!_cardImage) {
        _cardImage = [[UIImageView alloc]init];
        [self.cardView addSubview:_cardImage];
    }
    return _cardImage;
}
-(UILabel *)cardName
{
    if (!_cardName) {
        _cardName = [[UILabel alloc]init];
        _cardName.font = FONT_Bold_(32);
        _cardName.textColor = [UIColor HDBlackColor];
        [self.cardView addSubview:_cardName];
    }
    return _cardName;
}
-(UILabel *)cardNumber
{
    if (!_cardNumber) {
        _cardNumber = [[UILabel alloc]init];
        _cardNumber.font = FONT_Bold_(32);
        _cardNumber.textColor = [UIColor HDBlackColor];
        _cardNumber.numberOfLines = 0 ;
        [self.cardView addSubview:_cardNumber];
    }
    return _cardNumber;
}
-(UILabel *)shenhe
{
    if (!_shenhe) {
        _shenhe = [[UILabel alloc]init];
        _shenhe.font = FONT_Bold_(32);
        _shenhe.textColor = [UIColor HDTitleRedColor];
        _shenhe.textAlignment = NSTextAlignmentRight;
        [self.cardView addSubview:_shenhe];
    }
    return _shenhe;
}
-(UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]init];
        _topLabel.numberOfLines = 0;
        _topLabel.hidden = YES;
        _topLabel.text = @"您已设置提现银行卡，我们会在每月10日自动为您提现上月的收入和补贴，请注意查收。";
        _topLabel.font = FONT_Bold_(32);
        [self.view addSubview:_topLabel];
    }
    return _topLabel;
}
@end
