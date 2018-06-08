//
//  newAddressViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/21.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "newAddressViewController.h"
#import "GatoBaseHelp.h"
#import "PellTableViewSelect.h"
#import "SecondViewController.h"
@interface newAddressViewController ()<UITextViewDelegate>
@property (nonatomic ,strong) UITextView * textview;
@property (nonatomic ,strong) UILabel * textViewPlaceholder;

@property (nonatomic ,strong) NSMutableArray * nameArray;
@property (nonatomic ,strong) NSMutableArray * hospitalIdArray;
@property (nonatomic ,strong) NSString * nowHospitalID;
@property (nonatomic ,strong) NSString * cityStr;
@property (nonatomic ,assign) NSInteger cityInteger;
@property (nonatomic ,assign) NSInteger shi;
@end


@implementation newAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"修改执业地点";
    self.view.backgroundColor = [UIColor appAllBackColor];
    self.nameArray = [NSMutableArray array];
    self.hospitalIdArray  = [NSMutableArray array];
    [self addUnderButton];
    [self addAllView];
}
-(void)addAllView
{
    
    
    UILabel * city = [[UILabel alloc]init];
    city.text = @"请选择城市";
    city.textColor = [UIColor HDBlackColor];
    city.font = FONT(30);
    [self.view addSubview:city];
    city.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(15))
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(35));
    
    
    UITextField * cityTF = [[UITextField alloc]init];
    cityTF.placeholder = @"点击选择执业城市";
    cityTF.font = FONT(26);
    cityTF.tag = 6091326;
    cityTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cityTF];
    cityTF.sd_layout.leftEqualToView(city)
    .rightEqualToView(city)
    .topSpaceToView(city, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(30));
    
    GatoViewBorderRadius(cityTF, 3, 1, [UIColor HDViewBackColor]);
    
    
    UIButton * cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityButton addTarget:self action:@selector(cityButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityButton];
    cityButton.sd_layout.leftEqualToView(city)
    .rightEqualToView(city)
    .topSpaceToView(city, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(30));
    
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"执业地点";
    label.textColor = [UIColor HDBlackColor];
    label.font = FONT(30);
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(15))
    .topSpaceToView(cityButton,Gato_Height_548_(10))
    .rightSpaceToView(self.view,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(35));
    
    self.textview = [[UITextView alloc]init];
    self.textview.font = FONT(24);
    self.textview.delegate = self;
    [self.view addSubview:self.textview];
    self.textview.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(16))
    .rightSpaceToView(self.view,Gato_Width_320_(16))
    .topSpaceToView(label,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(120));
    
    GatoViewBorderRadius(self.textview, 3, 1, [UIColor appAllBackColor]);
    
    self.textViewPlaceholder = [[UILabel alloc]init];
    self.textViewPlaceholder.font = FONT(24);
    self.textViewPlaceholder.textColor = [UIColor YMAppAllTitleColor];
    self.textViewPlaceholder.text = @"点击选择新执业地点";
    [self.view addSubview:self.textViewPlaceholder];
    self.textViewPlaceholder.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(18))
    .rightSpaceToView(self.view,Gato_Width_320_(18))
    .topSpaceToView(label,Gato_Height_548_(12))
    .heightIs(Gato_Height_548_(25));

    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(xuanzeyiyuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(16))
    .rightSpaceToView(self.view,Gato_Width_320_(16))
    .topSpaceToView(label,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(120));
    
    
    GatoViewBorderRadius(self.textview, 3, 1, [UIColor HDViewBackColor]);
    
    
}

-(void)cityButtonDidClicked
{
    SecondViewController *address = [[SecondViewController alloc]init];
    address.sheng = self.cityInteger;
    address.shi = self.shi;
    address.blockAddress = ^(NSDictionary *newAddress ,NSInteger sheng ,NSInteger shi){
        UITextField * textfield = (UITextField *)[self.view viewWithTag:6091326];
        if (newAddress.count == 2) {
            textfield.text = [NSString stringWithFormat:@"%@ %@ ",newAddress[@"province"],newAddress[@"city"]];
            self.cityStr = textfield.text;
            self.cityInteger = sheng;
            self.shi = shi;
        }
        else if (newAddress.count == 3){
            textfield.text = [NSString stringWithFormat:@"%@ %@ %@ ",newAddress[@"province"],newAddress[@"city"],newAddress[@"area"]];
            self.cityStr = textfield.text;
        }
    };
    [self presentViewController:address animated:YES completion:^{
        
    }];

}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewPlaceholder.hidden = YES;
    return YES;
}
//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.textViewPlaceholder.hidden = YES;
    }else{
        self.textViewPlaceholder.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 提交按钮
-(void)chutingzhenButton:(UIButton *)sender
{
    if (self.textview.text.length < 1) {
        [self showHint:@"点击选择新执业地点"];
        return;
    }
    [self updata];
}

-(void)updata
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.oldDoctor forKey:@"oldHospital"];
    [self.updateParms setObject:self.nowHospitalID forKey:@"newHospital"];
    [self.updateParms setObject:self.textview.text forKey:@"remark"];
    [IWHttpTool postWithURL:HD_Home_change_new params:self.updateParms success:^(id json) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"修改成功，等待审核"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)xuanzeyiyuan
{
    if (self.cityStr.length < 1) {
        [self showHint:@"请先选择执业城市"];
        return;
    }
    self.nameArray = [NSMutableArray array];
    self.hospitalIdArray = [NSMutableArray array];
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.cityStr forKey:@"search"];
    [IWHttpTool postWithURL:HD_ZhuCe_Doctor params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                [self.nameArray addObject:[jsonArray[i] objectForKey:@"name"]];
                [self.hospitalIdArray addObject:[jsonArray[i] objectForKey:@"hospitalId"]];
            }
//            [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(0, Gato_Width_320_(60) + NAV_BAR_HEIGHT, Gato_Width, 40 * self.nameArray.count) selectData:self.nameArray action:^(NSInteger index) {
//                self.nowHospitalID = self.hospitalIdArray[index];
//                self.textview.text = self.nameArray[index];
//                self.textViewPlaceholder.hidden = YES;
//            } animated:YES];
            UIAlertController * classSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            for (int i = 0 ; i < self.nameArray.count ; i ++) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:self.nameArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    self.nowHospitalID = self.hospitalIdArray[i];
                    self.textview.text = self.nameArray[i];
                    self.textViewPlaceholder.hidden = YES;
                }];
                [classSheet addAction:action];
            }
            UIAlertAction * quxiao = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [classSheet addAction:quxiao];
            [self presentViewController:classSheet animated:YES completion:nil];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor HDThemeColor]];
    [button addTarget:self action:@selector(chutingzhenButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FONT(30);
    [view addSubview:button];
    button.sd_layout.leftSpaceToView(view,Gato_Width_320_(65))
    .topSpaceToView(view,Gato_Height_548_(7))
    .rightSpaceToView(view,Gato_Width_320_(65))
    .bottomSpaceToView(view,Gato_Height_548_(7));
    
    GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
}

@end
