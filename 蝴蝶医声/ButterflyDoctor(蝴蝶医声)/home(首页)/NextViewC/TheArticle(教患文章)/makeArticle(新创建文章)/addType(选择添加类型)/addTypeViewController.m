//
//  addTypeViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "addTypeViewController.h"
#import "GatoBaseHelp.h"
@interface addTypeViewController ()

@end

@implementation addTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:@"添加小标题" forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setBackgroundImage:[UIImage imageNamed:@"newadd1"] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titlebuttonDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleButton];
    
    [titleButton setTitleColor:[UIColor HDViewBackColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(titleButton, 5, 1, [UIColor HDViewBackColor]);
    titleButton.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(30))
    .rightSpaceToView(self.view, Gato_Width_320_(30))
    .topSpaceToView(self.view, Gato_Height_548_(50))
    .heightIs(Gato_Height_548_(100));
    
    
    UIButton * centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton setTitle:@"添加正文" forState:UIControlStateNormal];
    [centerButton setBackgroundImage:[UIImage imageNamed:@"newadd2"] forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(centerbuttonDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerButton];
    
    [centerButton setTitleColor:[UIColor HDViewBackColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(centerButton, 5, 1, [UIColor HDViewBackColor]);
    centerButton.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(30))
    .rightSpaceToView(self.view, Gato_Width_320_(30))
    .topSpaceToView(titleButton, Gato_Height_548_(30))
    .heightIs(Gato_Height_548_(100));
    
    
    UIButton * ImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ImageButton setTitle:@"添加图片" forState:UIControlStateNormal];
    [ImageButton setBackgroundImage:[UIImage imageNamed:@"newadd3"] forState:UIControlStateNormal];
    [ImageButton addTarget:self action:@selector(imagebuttonDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ImageButton];
    
    [ImageButton setTitleColor:[UIColor HDViewBackColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(ImageButton, 5, 1, [UIColor HDViewBackColor]);
    ImageButton.sd_layout.leftSpaceToView(self.view, Gato_Width_320_(30))
    .rightSpaceToView(self.view, Gato_Width_320_(30))
    .topSpaceToView(centerButton, Gato_Height_548_(30))
    .heightIs(Gato_Height_548_(100));
    
    UIButton * returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnButton setBackgroundImage:[UIImage imageNamed:@"newadd4"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
    \
    [returnButton setTitleColor:[UIColor HDViewBackColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(returnButton, Gato_Width_320_(50) / 2, 1, [UIColor HDViewBackColor]);
    returnButton.sd_layout.centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, Gato_Height_548_(50))
    .widthIs(Gato_Width_320_(50))
    .heightIs(Gato_Height_548_(50));
}


-(void)titlebuttonDid
{
    if (self.addTypeBlock) {
        self.addTypeBlock(@"0");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)centerbuttonDid
{
    if (self.addTypeBlock) {
        self.addTypeBlock(@"1");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagebuttonDid
{
    if (self.addTypeBlock) {
        self.addTypeBlock(@"2");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonDidClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
