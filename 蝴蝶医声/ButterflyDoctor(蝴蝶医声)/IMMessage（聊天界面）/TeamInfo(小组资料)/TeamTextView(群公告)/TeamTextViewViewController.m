//
//  TeamTextViewViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "TeamTextViewViewController.h"
#import "GatoBaseHelp.h"
#import "MyTeamViewController.h"
#import "IMMessageOneForAllViewController.h"

@interface TeamTextViewViewController ()<UITextViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic)  UITextView *textview;
@property (nonatomic ,strong) UIWebView * webView;
@end

@implementation TeamTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"群公告";
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    UIButton*rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor HDThemeColor]];
    [rightButton addTarget:self action:@selector(updataHttp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    rightButton.sd_layout.leftSpaceToView(self.view, Gato_Width / 6)
    .rightSpaceToView(self.view, Gato_Width / 6)
    .bottomSpaceToView(self.view, Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(35));
    GatoViewBorderRadius(rightButton, 3, 0, [UIColor redColor]);
//    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem= rightItem;
    
    UIView * underView = [[UIView alloc]init];
    underView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:underView];
    underView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(10))
    .rightSpaceToView(self.view,Gato_Width_320_(10))
    .topSpaceToView(self.view,Gato_Height_548_(20))
    .heightIs(Gato_Height_548_(200));
    GatoViewBorderRadius(underView, 3, 1, [UIColor HDViewBackColor]);
    [underView addSubview:self.textview];
    self.textview.sd_layout.leftSpaceToView(underView,Gato_Width_320_(15))
    .rightSpaceToView(underView,Gato_Width_320_(15))
    .topSpaceToView(underView,Gato_Height_548_(5))
    .bottomSpaceToView(underView,Gato_Height_548_(5));
    
    
    if (self.teamModel) {
        self.textview.text = self.teamModel.noticeContent;
    }
    if (![self.teamModel.doctorId isEqualToString:TOKEN]) {
        self.textview.editable = NO;
        underView.height = Gato_Height - Gato_Height_548_(40);
    }
}

-(void)updataHttp
{
    
    if (self.textview.text.length < 1) {
        [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"确定清空群公告" success:^{
            [self baoCunHttpWithPush:@"0"];
        } WithVC:self];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将新公告通知给所有群成员？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self baoCunHttpWithPush:@"0"];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self baoCunHttpWithPush:@"1"];
            [self ATAllPeopleWithTextViewText];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
}
-(void)baoCunHttpWithPush:(NSString *)push
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.teamModel.groupId forKey:@"groupId"];
    [dic setObject:self.textview.text forKey:@"noticeContent"];
    [dic setObject:push forKey:@"isPush"];
    [IWHttpTool postWithURL:HD_chat_Team_gonggao params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"更改成功"];
            self.teamModel.noticeContent = self.textview.text;
            if (self.updateTeamModel) {
                self.updateTeamModel(self.teamModel);
            }
//            if ([self.HomeTeamCome isEqualToString:@"1"]) {
//            for (UIViewController *temp in self.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[IMMessageOneForAllViewController class]]) {
//                    [self.navigationController popToViewController:temp animated:YES];
//                }
//            }
//            }
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyTeamViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - @所有人 并且把新公告告诉群成员
-(void)ATAllPeopleWithTextViewText
{
    [self sendChatMsg:self.teamModel.groupId text:[NSString stringWithFormat:@"@所有人\n%@",self.textview.text]];
}
-(void)sendChatMsg:(NSString*)toUserId
              text:(NSString*)text{
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:toUserId
                                            messageType:EMChatTypeGroupChat
                                             messageExt:nil];
    
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITextView *)textview
{
    if (!_textview) {
        _textview = [[UITextView alloc]init];
        _textview.font = FONT(34);
    }
    return _textview;
}

@end
