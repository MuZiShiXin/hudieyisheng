//
//  withdrawaViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "withdrawaViewController.h"
#import "GatoBaseHelp.h"
#import "withdrawaInfoViewController.h"
#import "MineBankCardViewController.h"
#import "MineHomeViewController.h"

@interface withdrawaViewController ()


@property (nonatomic ,strong) UIView * cardView;
@property (nonatomic ,strong) UIImageView * cardImage;
@property (nonatomic ,strong) UILabel * cardName;
@property (nonatomic ,strong) UILabel * cardNumber;
@property (nonatomic ,strong) UILabel * numberLabel;
@property (nonatomic ,strong) UILabel * moneryLabel;

@property (nonatomic ,strong) UIButton * nextButton;
@property (nonatomic ,strong) NSString * proportion;//兑换比例
@property (nonatomic ,strong) NSString * goldCount;//蝴蝶币提现个数
@property (nonatomic ,strong) NSString * actualAmount;//实际兑换金额
@property (nonatomic ,strong) UILabel * shenhe;
@property (nonatomic ,assign) BOOL yinhangka;//是否有银行卡 如果没有不让提交

@property (nonatomic ,strong) UIButton * pushCardButton;//跳转银行卡
@end

@implementation withdrawaViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateinfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"提现";
    self.view.backgroundColor = [UIColor appAllBackColor];
    [self addOtherView];
    [self newFrame];
    
    self.goldCount = @"0";
    self.actualAmount = @"0";
    self.proportion = @"0";
}
-(void)updateinfo
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_withdrawal_info params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            NSString * isVer = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"isVerify"];
            if ([isVer isEqualToString:@"-1"]) {
                self.shenhe.text = @"审核失败，请重新添加";
            }else if ([isVer isEqualToString:@"0"]){
                self.shenhe.text = @"审核中";
            }else{
                self.shenhe.text = @"";
            }
            
            self.cardImage.image = [UIImage imageNamed:@"jiansheyinhang"];
            self.cardName.text = [[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"bankData"] objectForKey:@"bank"];
            self.cardNumber.text = [[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"bankData"] objectForKey:@"bankNumber"];
            self.proportion = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"proportion"];
            self.yinhangka = YES;
        }else if ([success isEqualToString:@"400"]){
            self.yinhangka = NO;
            self.cardImage.image = [UIImage imageNamed:@"logo"];
            self.cardName.text = @"您还没有绑定银行卡";
            self.cardName.textColor = [UIColor HDTitleRedColor];
            self.cardNumber.text = @"请先绑定银行卡";
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)zhiyedidian
{
    withdrawaInfoViewController * vc = [[withdrawaInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tixianButtonDidClicked
{
    if (self.goldCount.length < 1) {
        [self showHint:@"您还没有选择提现数量"];
        return;
    }
    if (self.actualAmount.length < 1) {
        [self showHint:@"您还没有选择提现数量"];
        return;
    }
    if (self.yinhangka == NO) {
        [self showHint:@"您还未绑定银行卡"];
        return;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.goldCount forKey:@"goldCount"];
    [self.updateParms setObject:self.actualAmount forKey:@"actualAmount"];
    [IWHttpTool postWithURL:HD_Mine_withdrawal params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"提现成功，详情请查看提现明细"];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MineHomeViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)addOtherView
{
    
    
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(zhiyedidian)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    

}
-(void)newFrame
{
    
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    topView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .heightIs(Gato_Height_548_(164));
    
    
    
    
    [topView addSubview:self.cardView];
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"withdrawatitle"];
    [topView addSubview:image];
    image.sd_layout.leftSpaceToView(topView,Gato_Width_320_(115))
    .topSpaceToView(topView,Gato_Height_548_(22))
    .rightSpaceToView(topView,Gato_Width_320_(115))
    .heightIs(Gato_Height_548_(22));
    
    
    self.cardView.sd_layout.leftSpaceToView(topView,Gato_Width_320_(16))
    .topSpaceToView(topView,Gato_Height_548_(70))
    .rightSpaceToView(topView,Gato_Width_320_(16))
    .heightIs(Gato_Height_548_(82));
    
    GatoViewBorderRadius(self.cardView, 5, 1, [UIColor HDViewBackColor]);
    
    [self.cardView addSubview:self.pushCardButton];
    self.pushCardButton.sd_layout.leftSpaceToView(self.cardView, 0)
    .rightSpaceToView(self.cardView, 0)
    .topSpaceToView(self.cardView, 0)
    .heightIs(Gato_Height_548_(82));
    
    
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
    
    
    self.nextButton.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(20))
    .rightSpaceToView(self.view,Gato_Height_548_(20))
    .bottomSpaceToView(self.view,Gato_Height_548_(50))
    .heightIs(Gato_Height_548_(32));
    GatoViewBorderRadius(self.nextButton, 3, 0, [UIColor redColor]);
    
    self.shenhe.sd_layout.rightSpaceToView(self.cardView,Gato_Width_320_(10))
    .leftSpaceToView(self.cardView,Gato_Width_320_(10))
    .topSpaceToView(self.cardView,0)
    .heightIs(Gato_Width_320_(30));
    
    
    UIView * fgx= [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.view addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(topView,Gato_Height_548_(0))
    .heightIs(Gato_Height_548_(10));
    
    UIView * view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    view1.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(fgx,Gato_Height_548_(0))
    .heightIs(Gato_Height_548_(37));
    GatoViewBorderRadius(view1, 0, 1, [UIColor appAllBackColor]);
    [self addTitleViewWithTitle:@"蝴蝶币" WithType:0 WithCenter:self.goldNumber WithView:view1];
    
    UIView * view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    view2.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(view1,Gato_Height_548_(0))
    .heightIs(Gato_Height_548_(37));
    GatoViewBorderRadius(view2, 0, 1, [UIColor appAllBackColor]);
    [self addTitleViewWithTitle:@"提现数量" WithType:1 WithCenter:@"" WithView:view2];
    
    UIView * view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    view3.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(view2,Gato_Height_548_(0))
    .heightIs(Gato_Height_548_(37));
    GatoViewBorderRadius(view3, 0, 1, [UIColor appAllBackColor]);
    [self addTitleViewWithTitle:@"实际获得" WithType:2 WithCenter:@"" WithView:view3];
}

-(void)addTitleViewWithTitle:(NSString *)title
                    WithType:(NSInteger )type
                  WithCenter:(NSString *)center
                    WithView:(UIView * )view
{
    UILabel * label = [[UILabel alloc]init];
    label.font = FONT(30);
    [view addSubview:label];
    label.text = title;
    label.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
    .topSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .widthIs(Gato_Width_320_(200));
    
    if (type == 0) {
        UILabel * label = [[UILabel alloc]init];
        label.font = FONT(30);
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor HDTitleRedColor];
        label.text = [NSString stringWithFormat:@"%@个",center];
        label.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .rightSpaceToView(view,Gato_Width_320_(15));
    }else if (type == 1){
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"withdrawaicon"];
        [view addSubview:image];
        image.sd_layout.rightSpaceToView(view,Gato_Width_320_(15))
        .topSpaceToView(view,Gato_Height_548_(9))
        .bottomSpaceToView(view,Gato_Height_548_(9))
        .widthIs(Gato_Width_320_(60));
        
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rightButton];
        rightButton.sd_layout.rightSpaceToView(view,Gato_Width_320_(0))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .widthIs(Gato_Width_320_(30));
        
        
        UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftbutton addTarget:self action:@selector(leftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:leftbutton];
        leftbutton.sd_layout.rightSpaceToView(rightButton,Gato_Width_320_(30))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .widthIs(Gato_Width_320_(30));
        
        
        [view addSubview:self.numberLabel];
        self.numberLabel.sd_layout.leftSpaceToView(leftbutton,0)
        .rightSpaceToView(rightButton,0)
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0);
    }else{
        [view addSubview:self.moneryLabel];
        self.moneryLabel.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .rightSpaceToView(view,Gato_Width_320_(15));
    }
    
}

-(void)pushCardButtonDidClicked
{
    if (self.yinhangka == NO) {
        MineBankCardViewController * vc = [[MineBankCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)rightButtonDidClicked
{
    NSInteger number = [self.numberLabel.text integerValue];
    if (number + 10 < [self.goldNumber integerValue]) {
        number += 10;
    }else{
        [self showHint:@"蝴蝶币不足"];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    self.moneryLabel.text = [NSString stringWithFormat:@"¥：%.2f",number * [self.proportion floatValue]];
    self.goldCount = self.numberLabel.text;
    self.actualAmount = [NSString stringWithFormat:@"%.2f",number * [self.proportion floatValue]];
}
-(void)leftButtonDidClicked
{
    NSInteger number = [self.numberLabel.text integerValue];
    if (number > 10) {
        number -= 10;
    }else{
        number = 0;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    self.moneryLabel.text = [NSString stringWithFormat:@"¥：%.2f",number * [self.proportion floatValue]];
    self.goldCount = self.numberLabel.text;
    self.actualAmount = [NSString stringWithFormat:@"%.2f",number * [self.proportion floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)cardView
{
    if (!_cardView) {
        _cardView = [[UIView alloc]init];
        _cardView.backgroundColor = [UIColor whiteColor];
        
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"我的提现银行卡";
        label.textColor = [UIColor HDBlackColor];
        label.font = FONT(30);
        [self.cardView addSubview:label];
        label.sd_layout.leftSpaceToView(self.cardView,Gato_Width_320_(22))
        .topSpaceToView(self.cardView,0)
        .widthIs(Gato_Width)
        .heightIs(Gato_Height_548_(30));
        
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
        _cardName.font = FONT(30);
        _cardName.textColor = [UIColor HDBlackColor];
        [self.cardView addSubview:_cardName];
    }
    return _cardName;
}
-(UILabel *)cardNumber
{
    if (!_cardNumber) {
        _cardNumber = [[UILabel alloc]init];
        _cardNumber.font = FONT(30);
        _cardNumber.textColor = [UIColor HDBlackColor];
        [self.cardView addSubview:_cardNumber];
    }
    return _cardNumber;
}
-(UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = FONT(30);
        _numberLabel.text = @"0";
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}
-(UILabel *)moneryLabel
{
    if (!_moneryLabel) {
        _moneryLabel = [[UILabel alloc]init];
        _moneryLabel.font = FONT(30);
        _moneryLabel.text = @"¥：0.00";
        _moneryLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneryLabel;
}
-(UILabel *)shenhe
{
    if (!_shenhe) {
        _shenhe = [[UILabel alloc]init];
        _shenhe.font = FONT(30);
        _shenhe.textColor = [UIColor HDTitleRedColor];
        _shenhe.textAlignment = NSTextAlignmentRight;
        [self.cardView addSubview:_shenhe];
    }
    return _shenhe;
}
-(UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setBackgroundColor:[UIColor HDThemeColor]];
        [_nextButton setTitle:@"提 现" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = FONT(34);
        [_nextButton addTarget:self action:@selector(tixianButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
        UILabel * label = [[UILabel alloc]init];
        label.text = @"说明：提现后将清空您的蝴蝶币，随之蝴蝶等级将会下降，请确认后进行操作。";
        label.numberOfLines =0;
        label.textColor = [UIColor YMAppAllTitleColor];
        label.font = FONT(30);
        [self.view addSubview:label];
        label.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(15))
        .rightSpaceToView(self.view,Gato_Width_320_(15))
        .topSpaceToView(self.nextButton,Gato_Height_548_(10))
        .autoHeightRatio(0);
    }
    return _nextButton;
}

-(UIButton *)pushCardButton
{
    if (!_pushCardButton) {
        _pushCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushCardButton addTarget:self action:@selector(pushCardButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pushCardButton;
}
@end
