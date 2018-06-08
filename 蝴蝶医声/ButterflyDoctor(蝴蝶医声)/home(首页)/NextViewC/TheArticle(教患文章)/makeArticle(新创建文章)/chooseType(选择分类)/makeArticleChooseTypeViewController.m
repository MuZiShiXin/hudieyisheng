//
//  makeArticleChooseTypeViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/7.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "makeArticleChooseTypeViewController.h"
#import "GatoBaseHelp.h"
#import "TheArticleViewController.h"

#define addUrl @"http://wechat.hudieyisheng.com/app/interface.php?func=article"
#define oldUrl @"http://wechat.hudieyisheng.com/app/interface.php?func=article_update"//修改 使用  token变成id
#define buttonTag 70711111
#define imageTag 70701111
@interface makeArticleChooseTypeViewController ()
{
    NSArray * shaixuanArray ;
    NSString * chooseType;
}

@end

@implementation makeArticleChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择分类";
    Gato_Return
    self.view.backgroundColor = [UIColor appAllBackColor];
    [self addAllButtons];
}

-(void)addAllButtons
{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"请选择文章分类：";
    label.font = FONT_Bold_(36);
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(15))
    .rightSpaceToView(self.view, Gato_Width_320_(15))
    .topSpaceToView(self.view, Gato_Height_548_(15))
    .heightIs(Gato_Height_548_(30));
    
    shaixuanArray = @[@"学术研究",@"医学科普",@"诊前须知",@"诊后必读",@"术后需知",@"经典问答",@"出院须知",@"同位素治疗"];
    for (int i = 0 ; i < shaixuanArray.count ; i ++) {
        CGFloat x = i % 3;
        CGFloat y = i / 3;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:shaixuanArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(34);
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor appTabBarTitleColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + buttonTag;
        [self.view addSubview:button];
        GatoViewBorderRadius(button, 5, 1, [UIColor HDViewBackColor]);
        button.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(15) + x * Gato_Width_320_(290 / 3))
        .topSpaceToView(label, y * Gato_Height_548_(45))
        .widthIs(Gato_Width_320_(260 / 3))
        .heightIs(Gato_Height_548_(35));
        
        UIImageView * selectImage = [[UIImageView alloc]init];
        selectImage.tag = i + imageTag;
        [self.view addSubview:selectImage];
        selectImage.sd_layout.rightEqualToView(button)
        .bottomEqualToView(button)
        .widthIs(Gato_Width_320_(20))
        .heightIs(Gato_Height_548_(20));
    }
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"发 布" forState:UIControlStateNormal];
    nextButton.titleLabel.font = FONT(38);
    [nextButton setBackgroundColor:[UIColor HDThemeColor]];
    [nextButton addTarget:self action:@selector(nextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    nextButton.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(15))
    .rightSpaceToView(self.view, Gato_Width_320_(15))
    .bottomSpaceToView(self.view, Gato_Height_548_(15))
    .heightIs(Gato_Height_548_(35));
    GatoViewBorderRadius(nextButton, 5, 0, [UIColor whiteColor]);
    
    if (self.classify) {
        for (int i = 0 ; i < shaixuanArray.count ; i ++) {
            if ([[GatoMethods getButterflyarticlesTypeWithType:self.classify] isEqualToString:shaixuanArray[i]]) {
                UIButton * button = (UIButton *)[self.view viewWithTag:i + buttonTag];
                [self chooseTypeButton:button];
            }
        }
    }
}

-(void)chooseTypeButton:(UIButton *)sender
{
    for (int i = 0 ; i < shaixuanArray.count ; i ++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:i + buttonTag];
        [button setTitleColor:[UIColor appTabBarTitleColor] forState:UIControlStateNormal];
        GatoViewBorderRadius(button, 5, 1, [UIColor HDViewBackColor]);
        
        UIImageView * image = (UIImageView *)[self.view viewWithTag:i + imageTag];
        image.image = [UIImage imageNamed:@""];
    }
    
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(sender, 5, 1, [UIColor HDThemeColor]);
    
    UIImageView * image = (UIImageView *)[self.view viewWithTag:sender.tag - buttonTag + imageTag];
    image.image = [UIImage imageNamed:@"chooseTypeYes"];
    
    chooseType = sender.titleLabel.text;
}

-(void)nextButton
{
    
    if (!chooseType) {
        [self showHint:@"请选择分类"];
        return;
    }
    NSString * url;
    if (self.articleID.length > 0) {
        [self.updateDic setValue:self.articleID forKey:@"id"];
        url = oldUrl;
    }else{
        [self.updateDic setValue:TOKEN forKey:@"token"];
        url = addUrl;
    }
    [self.updateDic setValue:chooseType forKey:@"classify"];
    [IWHttpTool postWithURL:url params:self.updateDic success:^(id json) {

        [self showHint:@"发布成功,请耐心等待审核"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[TheArticleViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        });
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
