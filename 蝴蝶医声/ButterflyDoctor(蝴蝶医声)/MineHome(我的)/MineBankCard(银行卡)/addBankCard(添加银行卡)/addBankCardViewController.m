//
//  addBankCardViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "addBankCardViewController.h"
#import "GatoBaseHelp.h"
#import "chooseBankViewController.h"
#import "SecondViewController.h"
#import "ChooseBankSonModel.h"
#import "MineHomeViewController.h"
#define textfieldTag 5041342

#define BankCardGet @"http://detectionBankCard.api.juhe.cn/bankCard?key=275a897867d91471700c89fffe72d776&cardid="
@interface addBankCardViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong) UIButton * addButton;
@property (nonatomic ,copy) NSString * cityName;
@property (nonatomic ,copy) NSString * bankId;
@property (nonatomic ,assign) NSInteger  sheng;
@property (nonatomic ,assign) NSInteger  shi;
@end

@implementation addBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.view.backgroundColor = [UIColor appAllBackColor];
    self.title = @"添加银行卡";
    
    [self addViews];
    
    
    self.addButton.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(19))
    .rightSpaceToView(self.view,Gato_Width_320_(19))
    .bottomSpaceToView(self.view,Gato_Height_548_(67))
    .heightIs(Gato_Height_548_(32));
    
    GatoViewBorderRadius(self.addButton, 5, 0, [UIColor redColor]);
}


-(void)addViews
{
    NSArray * labelArray = @[@"银行:",@"开户行支行名:",@"开户行所在地:",@"银行卡号:",@"开户人姓名:"];
    NSArray * textFArray = @[@"请选择银行",@"请输入开户行支行名",@"请选择开户城市",@"请输入银行卡号",@"请输入开户人姓名"];
    CGFloat addHeight = Gato_Height_548_(10);
    for (int i = 0 ; i < labelArray.count ; i ++) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        view.sd_layout.leftSpaceToView(self.view,0)
        .rightSpaceToView(self.view,0)
        .topSpaceToView(self.view,i * Gato_Height_548_(37) + addHeight)
        .heightIs(Gato_Height_548_(37));
    
        if (i == 2) {
            addHeight += Gato_Height_548_(10);
        }
        
        UILabel * label = [[UILabel alloc]init];
        label.font = FONT(30);
        label.textColor = [UIColor HDBlackColor];
        label.text = labelArray[i];
        [view addSubview:label];
        label.sd_layout.leftSpaceToView(view,Gato_Width_320_(10))
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .widthIs(Gato_Width_320_(100));
        
        
        UITextField * textfield = [[UITextField alloc]init];
        textfield.placeholder = textFArray[i];
        textfield.font = FONT(30);
        textfield.delegate = self;
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.tag = i + textfieldTag;
        [view addSubview:textfield];
        textfield.sd_layout.leftSpaceToView(label,Gato_Width_320_(10))
        .topEqualToView(label)
        .bottomEqualToView(label)
        .rightSpaceToView(view,Gato_Width_320_(10));
        
        if (i == 0 || i == 2) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(addressname:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i + 1127;
            [view addSubview:button];
            button.sd_layout.leftSpaceToView(label,Gato_Width_320_(10))
            .topEqualToView(label)
            .bottomEqualToView(label)
            .rightSpaceToView(view,Gato_Width_320_(10));
        }
        if ( i == 3) {
            textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor HDViewBackColor];
        [view addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(view, 0)
        .rightSpaceToView(view, 0)
        .bottomSpaceToView(view, 0)
        .heightIs(0.5);
        
        if (i == 0) {
            UIView * fgx1 = [[UIView alloc]init];
            fgx1.backgroundColor = [UIColor HDViewBackColor];
            [view addSubview:fgx1];
            fgx1.sd_layout.leftSpaceToView(view, 0)
            .rightSpaceToView(view, 0)
            .topSpaceToView(view, 0)
            .heightIs(0.5);
        }
        if (i == 3) {
            UIView * fgx1 = [[UIView alloc]init];
            fgx1.backgroundColor = [UIColor HDViewBackColor];
            [view addSubview:fgx1];
            fgx1.sd_layout.leftSpaceToView(view, 0)
            .rightSpaceToView(view, 0)
            .topSpaceToView(view, 0)
            .heightIs(0.5);
        }
    }
    
    UILabel * querenLabel = [[UILabel alloc]init];
    querenLabel.text = @"请确保姓名，身份证号，银行卡开户人为同一人";
    querenLabel.font = FONT(30);
    querenLabel.numberOfLines = 0;
    querenLabel.textColor = [UIColor HDTitleRedColor];
    [self.view addSubview:querenLabel];
    querenLabel.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(10))
    .rightSpaceToView(self.view,Gato_Width_320_(10))
    .topSpaceToView(self.view, 5 * Gato_Height_548_(37) + Gato_Height_548_(30))
    .autoHeightRatio(0);
    
}

-(void)addressname:(UIButton *)sender
{
    if (sender.tag - 1127 == 0) {
        UITextField * textfield = (UITextField *)[self.view viewWithTag:textfieldTag];
//        if (self.cityName.length < 1) {
//            [self showHint: @"请选择开户城市"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
//            return;
//        }
        chooseBankViewController * vc = [[chooseBankViewController alloc]init];
        vc.cityname = self.cityName;
        vc.bankName = ^(ChooseBankSonModel * model){
            textfield.text = model.name;
            self.bankId = model.bankId;
        };
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        UITextField * textfield = (UITextField *)[self.view viewWithTag:textfieldTag + 2];
        SecondViewController *address = [[SecondViewController alloc]init];
        address.sheng = self.sheng;
        address.shi = self.shi;
        address.blockAddress = ^(NSDictionary *newAddress ,NSInteger sheng ,NSInteger shi){
            if (newAddress.count == 2) {
                textfield.text = [NSString stringWithFormat:@"%@ %@ ",newAddress[@"province"],newAddress[@"city"]];
                self.cityName = textfield.text;
                self.sheng = sheng;
                self.shi = shi;
            }
            else if (newAddress.count == 3){
                textfield.text = [NSString stringWithFormat:@"%@ %@ %@ ",newAddress[@"province"],newAddress[@"city"],newAddress[@"area"]];
                self.cityName = textfield.text;
            }
        };
        [self.navigationController pushViewController:address animated:YES];

    }
}
-(void)addButtonDidClicked
{
    if ([self getTextFieldTextWithTagType:1].length < 1) {
        [self showHint:@"请输入开户行支行"];
        return;
    }
    if ([self getTextFieldTextWithTagType:2].length < 1) {
        [self showHint:@"请选择开户行所在地"];
        return;
    }
    if ([self getTextFieldTextWithTagType:3].length < 1) {
        [self showHint:@"请输入银行卡号"];
        return;
    }
    if ([self getTextFieldTextWithTagType:4].length < 1) {
        [self showHint:@"请输入开户人姓名"];
        return;
    }
    if (self.bankId.length < 1) {
        [self showHint:@"请选择开户银行"];
        return;
    }
//    [self update];
    [self bankCardWithCard:[self getTextFieldTextWithTagType:3]];
}
-(void)update
{
    [self.addButton setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.addButton setUserInteractionEnabled:YES];
    });
    NSString * url = HD_Mine_Bank_ADD;
    if ([self.AddOrModify isEqualToString:@"2"]) {
        url = HD_Mine_Bank_update;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:[self getTextFieldTextWithTagType:4] forKey:@"name"];
    [self.updateParms setObject:[self getTextFieldTextWithTagType:1] forKey:@"bankName"];
    [self.updateParms setObject:self.bankId forKey:@"bank"];//银行id
    [self.updateParms setObject:[self getTextFieldTextWithTagType:3] forKey:@"bankNumber"];
    [self.updateParms setObject:[self getTextFieldTextWithTagType:2]  forKey:@"bankAddress"];
    [IWHttpTool postWithURL:url params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"添加成功，请耐心等待审核"];
            [self.navigationController popViewControllerAnimated:YES];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                for (UIViewController *temp in self.navigationController.viewControllers) {
//                    if ([temp isKindOfClass:[MineHomeViewController class]]) {
//                        [self.navigationController popToViewController:temp animated:YES];
//                    }
//                }
//            });
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)bankCardWithCard:(NSString *)card
{
    
    NSString * http = [NSString stringWithFormat:@"%@%@",BankCardGet,card];
    [IWHttpTool getWithURL:http params:nil success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * error_code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"error_code"]];
        if ([error_code isEqualToString:@"0"]) {
            [self update];
        }else{
            NSString * falseMessage = [dic objectForKey:@"reason"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
-(NSString *)getTextFieldTextWithTagType:(NSInteger )tag
{
    UITextField * textfield = (UITextField *)[self.view viewWithTag:textfieldTag + tag];
    return textfield.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"确认添加" forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor HDThemeColor]];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addButton.titleLabel.font = FONT(32);
        [_addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}
@end
