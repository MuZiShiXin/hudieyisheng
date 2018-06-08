//
//  TextFieldInfoViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TextFieldInfoViewController.h"
#import "GatoBaseHelp.h"

@interface TextFieldInfoViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic)  UITextField *textfield;
@property (strong, nonatomic)  UITextView *textview;
@property (nonatomic ,assign) BOOL  textfieldLenght;

@end

@implementation TextFieldInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.view.backgroundColor = [UIColor appAllBackColor];
    self.title = self.titleStr;
    self.textfieldLenght = NO;
    if ([self.titleStr isEqualToString:@"年龄"]) {
        self.textfieldLenght = YES;
    }
    
    [self textNew];
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(updataHttp) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
   
    [self fieldOrViewWIthBool:self.FieldOrView];
}
-(void)textNew
{
    if ([self.titleStr isEqualToString:@"姓名"]) {
        self.textfield.text = self.model.name;
    }
    if ([self.titleStr isEqualToString:@"执业地点"]) {
        self.textfield.text = self.model.workAddress;
    }
    if ([self.titleStr isEqualToString:@"个人简介"]) {
        self.textview.text = ModelNull(self.model.introduction);
    }
    if ([self.titleStr isEqualToString:@"擅长"]) {
        self.textview.text = ModelNull(self.model.speciality);
    }
}

-(void)fieldOrViewWIthBool:(BOOL )TOV
{
    if (TOV == YES) {
        self.textview.hidden = YES;
        self.textfield.delegate = self;
        [self.textfield becomeFirstResponder];
        
        UIView * underView = [[UIView alloc]init];
        underView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:underView];
        
        [underView addSubview:self.textfield];
        
        underView.sd_layout.leftSpaceToView(self.view,0)
        .rightSpaceToView(self.view,0)
        .topSpaceToView(self.view,Gato_Height_548_(20))
        .heightIs(Gato_Height_548_(40));
        
        
        self.textfield.sd_layout.leftSpaceToView(underView,Gato_Width_320_(15))
        .rightSpaceToView(underView,Gato_Width_320_(15))
        .topSpaceToView(underView,0)
        .bottomSpaceToView(underView,0);
    }else{
        self.textfield.hidden = YES;
        self.textview.delegate = self;
        [self.textview becomeFirstResponder];
        
        UIView * underView = [[UIView alloc]init];
        underView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:underView];
        
        [underView addSubview:self.textview];
        
        underView.sd_layout.leftSpaceToView(self.view,0)
        .rightSpaceToView(self.view,0)
        .topSpaceToView(self.view,Gato_Height_548_(20))
        .heightIs(Gato_Height_548_(120));
        
        self.textview.sd_layout.leftSpaceToView(underView,Gato_Width_320_(15))
        .rightSpaceToView(underView,Gato_Width_320_(15))
        .topSpaceToView(underView,Gato_Height_548_(5))
        .bottomSpaceToView(underView,Gato_Height_548_(5));
    }
}
-(void)updataHttp
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:@"" forKey:@"photo"];
    [self.updateParms setObject:self.model.sex forKey:@"sex"];
    [self.updateParms setObject:self.model.birthday forKey:@"birthday"];
    [self.updateParms setObject:self.model.isBirthday forKey:@"isBirthday"];
    [self.updateParms setObject:self.model.payPrice  forKey:@"payPrice"];
    [self.updateParms setObject:self.model.notDisturb forKey:@"notDisturb"];
    [self.updateParms setObject:self.model.payPriceSet forKey:@"payPriceSet"];
    [self SetObjectWithDic:self.updateParms WithType:self.titleStr];
    [IWHttpTool postWithURL:HD_Mine_Info_data_UPdate params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self searchprogram];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//type 0 姓名  1个人简介  2擅长  3执业地点
-(void)SetObjectWithDic:(NSMutableDictionary *)dic WithType:(NSString * )typeStr
{
    NSInteger type = 0;
    if ([typeStr isEqualToString:@"姓名"]) {
        type = 0;
    }
    if ([typeStr isEqualToString:@"执业地点"]) {
        type = 3;
    }
    if ([typeStr isEqualToString:@"个人简介"]) {
        type = 1;
    }
    if ([typeStr isEqualToString:@"擅长"]) {
        type = 2;
    }
    switch (type) {
        case 0:
        {
            [self.updateParms setObject:self.textfield.text forKey:@"name"];
            [self.updateParms setObject:self.model.introduction forKey:@"introduction"];
            [self.updateParms setObject:self.model.speciality forKey:@"speciality"];
            [self.updateParms setObject:self.model.workAddress forKey:@"workAddress"];
            
        }
            break;
        case 1:
        {
            [self.updateParms setObject:self.model.name forKey:@"name"];
            [self.updateParms setObject:self.textview.text forKey:@"introduction"];
            [self.updateParms setObject:self.model.speciality forKey:@"speciality"];
            [self.updateParms setObject:self.model.workAddress forKey:@"workAddress"];
        }
            break;
        case 2:
        {
            [self.updateParms setObject:self.model.name forKey:@"name"];
            [self.updateParms setObject:self.model.introduction forKey:@"introduction"];
            [self.updateParms setObject:self.textview.text forKey:@"speciality"];
            [self.updateParms setObject:self.model.workAddress forKey:@"workAddress"];
        }
            break;
        case 3:
        {
            [self.updateParms setObject:self.model.name forKey:@"name"];
            [self.updateParms setObject:self.model.introduction forKey:@"introduction"];
            [self.updateParms setObject:self.model.speciality forKey:@"speciality"];
            [self.updateParms setObject:self.textfield.text forKey:@"workAddress"];
        }
            break;
            
        default:
            break;
    }
}

-(void)searchprogram
{
    NSString * blockStr = @"";
    if (self.FieldOrView == YES) {
        blockStr = self.textfield.text;
    }else{
        blockStr = self.textview.text; //默认不显示
//        blockStr = @"";
    }
    if (self.baocunBlock) {
        self.baocunBlock(blockStr);
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"]) //按会车可以改变
    {
        return YES;
    }
    if (self.textfieldLenght == YES) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];//得到输入框的内容
        if (self.textfield == textField)  //判断是否时我们想要限定的那个输入框
        {
            if ([toBeString length] > 2) { //如果输入框内容大于20则弹出警告
                textField.text = [toBeString substringToIndex:2];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
    }
    
    return YES;
}

-(UITextField *)textfield
{
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.font = FONT(26);
    }
    return _textfield;
}
-(UITextView *)textview
{
    if (!_textview) {
        _textview = [[UITextView alloc]init];
        _textview.font = FONT(26);
    }
    return _textview;
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
