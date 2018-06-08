//
//  GatoReturnButton.m
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GatoReturnButton.h"
#import "GatoBaseHelp.h"
#import "AppDelegate.h"
#import "DLTabBarController.h"

@interface GatoReturnButton ()

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) BOOL flag;//yes 需要把barButton显示

@property (nonatomic ,assign) NSInteger popRow;
@end


@implementation GatoReturnButton


- (instancetype)initWithTarget:(id)target
{
    self = [self initWithTarget:target IsAccoedingBar:NO];
    return self;
}


- (instancetype)initWithTarget:(id)target IsAccoedingBar:(BOOL)flag WithRootViewControllers:(NSInteger )row{
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
//        [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(-20, 0, Gato_Width_320_(50), Gato_Height_548_(64));
    //    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(buttonDidClickedRoot) forControlEvents:UIControlEventTouchUpInside];
    self = [super initWithCustomView:button];
    [button sizeToFit];
    _vc = target;
    _flag = flag;
    _popRow = row;
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"nav_back"];
    [button addSubview:image];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 11.0) {
        image.sd_layout.leftSpaceToView(button, 0)
        .topSpaceToView(button, Gato_Width_320_(3))
        .widthIs(Gato_Width_320_(11))
        .heightIs(Gato_Width_320_(18));
    }else{
        image.sd_layout.leftSpaceToView(button, 0)
        .topSpaceToView(button, Gato_Height_548_(23))
        .widthIs(Gato_Width_320_(11))
        .heightIs(Gato_Width_320_(18));
    }
    
   
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidClicked)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.vc.view addGestureRecognizer:recognizer];
    
    return self;
    
}

- (instancetype)initWithTarget:(id)target IsAccoedingBar:(BOOL)flag{
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
//    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
    button.frame = CGRectMake(-20, 0, Gato_Width_320_(50), Gato_Height_548_(64));
//    [button setBackgroundColor:[UIColor blueColor]];
//    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button setTitle:@"返回按钮" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self = [super initWithCustomView:button];
    _vc = target;
    _flag = flag;
    
    UIImageView * image = [[UIImageView alloc]init];//WithFrame:CGRectMake(0,  Gato_Height_548_(23), Gato_Width_320_(11), Gato_Height_548_(18))
    image.image = [UIImage imageNamed:@"nav_back"];
    [button addSubview:image];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 11.0) {
        image.sd_layout.leftSpaceToView(button, 0)
        .topSpaceToView(button, Gato_Height_548_(3))
        .widthIs(Gato_Width_320_(11))
        .heightIs(Gato_Width_320_(18));
    }else{
        image.sd_layout.leftSpaceToView(button, 0)
        .topSpaceToView(button, Gato_Height_548_(23))
        .widthIs(Gato_Width_320_(11))
        .heightIs(Gato_Width_320_(18));
    }
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidClicked)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.vc.view addGestureRecognizer:recognizer];
    return self;
}

- (BOOL) isiOS11
{
    [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%.2f",[[[UIDevice currentDevice] systemVersion] floatValue] );
    return YES;
    
}

-(void)buttonDidClicked{
    
    if ([GATO_JPush_Return isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:GET_JPush_Dismiss];
        [_vc dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (_flag) {
        _vc.hidesBottomBarWhenPushed = YES;
    }
    
    if (_vc.navigationController) {
        [_vc.navigationController popViewControllerAnimated:YES];
    }else{
        [_vc dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)buttonDidClickedRoot
{
    [_vc.navigationController popToRootViewControllerAnimated:YES];
}
@end
