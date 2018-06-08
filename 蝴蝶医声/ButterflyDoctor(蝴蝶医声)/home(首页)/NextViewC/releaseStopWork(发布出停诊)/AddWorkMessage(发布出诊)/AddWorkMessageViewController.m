//
//  AddWorkMessageViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/19.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AddWorkMessageViewController.h"
#import "GatoBaseHelp.h"
@interface AddWorkMessageViewController ()<UITextViewDelegate>
@property (nonatomic ,strong) UITextView * textview;
@property (nonatomic ,strong) UILabel * textViewPlaceholder;
@end

@implementation AddWorkMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    [self addUnderButton];
    [self newFrame];
    if (self.Modify) {
        [self updateOld];
        self.title = @"修改门诊时间";
    }else{
        self.title = @"发布门诊时间";
    }
}
#pragma mark - 加载老信息
-(void)updateOld
{
    self.textview.text = self.model.content;
    self.textViewPlaceholder.hidden = YES;
}

#pragma mark - 发布
-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    NSString * url = HD_Home_MZ_Add_new;
    if (self.Modify) {
        url = HD_Home_MZ_Add_update;
        [self.updateParms setObject:self.model.outId forKey:@"outId"];
    }
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.textview.text forKey:@"content"];
    [IWHttpTool postWithURL:url params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"发布成功，等待审核"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)chutingzhenButton:(UIButton *)sender
{

    if (self.textview.text.length < 1) {
        [self showHint:@"请先填写门诊时间"];
    }else{
        [self update];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newFrame
{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"发布最新门诊时间，全网更新。可填写门诊时间（上 下午）、门诊类型、价格、地点等信息。";
    label.textColor = [UIColor YMAppAllTitleColor];
    label.numberOfLines = 0;
    label.font = FONT(30);
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(15))
    .topSpaceToView(self.view,Gato_Height_548_(15))
    .rightSpaceToView(self.view,Gato_Width_320_(15))
    .autoHeightRatio(0);
    
    self.textview.sd_layout.leftEqualToView(label)
    .rightEqualToView(label)
    .topSpaceToView(label,Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(120));
    
    GatoViewBorderRadius(self.textview, 3, 1, [UIColor appAllBackColor]);
    
    self.textViewPlaceholder = [[UILabel alloc]init];
    self.textViewPlaceholder.font = FONT(30);
    self.textViewPlaceholder.textColor = [UIColor YMAppAllTitleColor];
    self.textViewPlaceholder.numberOfLines = 0;
    self.textViewPlaceholder.text = @"如：周一下午，专家门诊，7元，甲状腺科二楼；\n 周二下午，特需，200元，甲状腺科二楼";
    [self.textview addSubview:self.textViewPlaceholder];
    self.textViewPlaceholder.sd_layout.leftSpaceToView(self.textview,Gato_Width_320_(5))
    .rightSpaceToView(self.textview,Gato_Width_320_(18))
    .topSpaceToView(self.textview,Gato_Height_548_(7))
    .autoHeightRatio(0);
    
    
    GatoViewBorderRadius(self.textview, 3, 1, [UIColor HDViewBackColor]);
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
    if (self.Modify) {
        [button setTitle:@"修改" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"发布" forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor HDThemeColor]];
    [button addTarget:self action:@selector(chutingzhenButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FONT(34);
    [view addSubview:button];
    button.sd_layout.leftSpaceToView(view,Gato_Width_320_(65))
    .topSpaceToView(view,Gato_Height_548_(7))
    .rightSpaceToView(view,Gato_Width_320_(65))
    .bottomSpaceToView(view,Gato_Height_548_(7));
    
    GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
}

-(UITextView *)textview
{
    if (!_textview) {
        _textview = [[UITextView alloc]init];
        _textview.backgroundColor = [UIColor whiteColor];
        _textview.delegate = self;
        _textview.font = FONT(30);
        [self.view addSubview:_textview];
    }
    return _textview;
}
@end
