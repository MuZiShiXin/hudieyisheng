//
//  IMMessageOneForAllViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "IMMessageOneForAllViewController.h"
#import "GatoBaseHelp.h"
#import "TeamInfoViewController.h"
#import "MyTeamMemberModel.h"
#import "DoctorHomeViewController.h"
#import "WebArticlePushViewController.h"
#import "TheArticleViewController.h"
#import "EMChooseViewController.h"
#import "ContactSelectionViewController.h"
#import "AtOnePersonViewController.h"
#import "OneMessageExtModel.h"

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface IMMessageOneForAllViewController ()<EMClientDelegate, EMChooseViewDelegate>
{
    UIView * topView;
}
@property (nonatomic ,strong) NSString * pushUrl;
@property (nonatomic ,strong) NSString * doctorName;
@property (nonatomic ,strong) NSString * doctorID;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;


@end


@implementation IMMessageOneForAllViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor HDThemeColor];
//    UIWindow *win = [UIApplication sharedApplication].keyWindow;
//    [win addSubview:topView];
    [self.navigationController.view addSubview:topView];
    topView.frame = CGRectMake(0, 0, Gato_Width, 20);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [topView removeFromSuperview];
    [[EMCDDeviceManager sharedInstance] stopPlaying];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD dismiss];

    
    Gato_Return
    self.title = @"组内信息";
    self.delegate = self;
    self.dataSource = self;
     self.showRefreshHeader = YES;
    [GatoMethods getTeamAndPeopleNumberWithunread];
    
    UserCacheInfo *user = [UserCacheManager myInfo];
    
    for (int i = 0 ; i < self.teamModel.members.count; i ++) {
        MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
        memberModel = self.teamModel.members[i];
        [UserCacheManager save:memberModel.phone avatarUrl:memberModel.photo nickName:memberModel.name];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_member"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(zhiyedidian)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}
#pragma mark - 清空聊天记录
- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}


-(void)zhiyedidian
{
    TeamInfoViewController * vc = [[TeamInfoViewController alloc]init];
    vc.groupId = self.groupId;
    vc.teamModel = self.teamModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击头像
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    
    NSLog(@"点击聊天头像 跳转个人信息  %@",messageModel);
    NSString * phone = messageModel.nickname;
    NSString * doctorId = @"";
    for (int i = 0 ; i < self.teamModel.members.count; i ++) {
        MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
        memberModel = self.teamModel.members[i];
        if ([phone isEqualToString:memberModel.phone]) {
            doctorId = memberModel.doctorId;
            break;
        }
    }
    DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
    vc.doctorId = doctorId;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 长按头像
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectLongAvatarMessageModel:(id<IMessageModel>)messageModel
{
    
    NSString * phone = messageModel.nickname;
    if (!self.doctorName) {
        self.doctorName = @"";
    }
    NSString * doctorStr = @"";
    for (int i = 0 ; i < self.teamModel.members.count; i ++) {
        MyTeamMemberModel * memberModel = [[MyTeamMemberModel alloc]init];
        memberModel = self.teamModel.members[i];
        if ([phone isEqualToString:memberModel.phone]) {
            doctorStr = memberModel.name;
            self.doctorID = memberModel.doctorId;
            break;
        }
    }
    
    EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
    if (toolbar.inputTextView.text.length > 0) {
        toolbar.inputTextView.text = [NSString stringWithFormat:@"%@ @%@ ",toolbar.inputTextView.text,doctorStr];
    }else{
        toolbar.inputTextView.text = [NSString stringWithFormat:@"@%@ ",doctorStr];
    }
    
    
}
#pragma mark - 用户输入@ 选择要输入的对象
- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    __weak typeof(self) weakSelf = self;

   
    if (self.teamModel.members.count > 0) {
        AtOnePersonViewController * vc = [[AtOnePersonViewController alloc]init];
        vc.teamInfoArray = self.teamModel.members;
        vc.ATInfoBlock = ^(MyTeamMemberModel *teamMemberModel) {
            if (!self.doctorName) {
                weakSelf.doctorName = @"";
            }
            NSString * doctorStr = teamMemberModel.name;
            weakSelf.doctorID = teamMemberModel.doctorId;
            EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
            if (toolbar.inputTextView.text.length > 0) {
                toolbar.inputTextView.text = [NSString stringWithFormat:@"%@ %@ ",toolbar.inputTextView.text,doctorStr];
            }else{
                toolbar.inputTextView.text = [NSString stringWithFormat:@"%@ ",doctorStr];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)messageViewController:(EaseMessageViewController *)viewController
            didSelectMoreView:(EaseChatBarMoreView *)moreView
                      AtIndex:(NSInteger)index
{
    __weak typeof(self) weakSelf = self;

    TheArticleViewController * vc = [[TheArticleViewController alloc]init];
    vc.comeForPushMessage = YES;
    
    vc.addArticleBlock = ^(TheArticleModel *model){
        weakSelf.pushUrl = [NSString stringWithFormat:@"%@?articleId=%@",HD_Article_Web_Center,model.articleId];
        NSMutableDictionary * extDic = [NSMutableDictionary dictionary];
        [extDic setObject:model.title forKey:@"title"];
        [extDic setObject:weakSelf.pushUrl forKey:@"url"];
//        httpUrl = self.pushUrl;
//        httpName = model.title;
        //        [self sendTextMessage:self.pushUrl withExt:extDic];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.images]]];
        NSData * imagedata = UIImageJPEGRepresentation(image, 1.0f);
        [weakSelf sendImageMessage:imagedata withExt:extDic];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击文本代理 主要用于web跳转
-(void)tapWithMessageTextForModel:(id<IMessageModel>)model
{
    NSArray * webPush = @[@"http://",@"www",@"com",@"net",@"cn"];
    BOOL webPushBool = NO;
    for (int i = 0 ; i < webPush.count ; i ++) {
        if ([model.text rangeOfString:webPush[i]].location != NSNotFound){
            webPushBool = YES;
            break;
        }
    }

    if (webPushBool == YES) {
        NSLog(@"我点击了网站 ： %@",model.text);
        WebArticlePushViewController * vc = [[WebArticlePushViewController alloc]init];
        vc.pushURL = model.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/*
 点击图片代理
 */
-(void)tapWithMessageImageForModel:(id<IMessageModel>)model
{
    NSLog(@"ext %@",model.message.ext);
    OneMessageExtModel * extModel = [[OneMessageExtModel alloc]init];
    [extModel setValuesForKeysWithDictionary:model.message.ext];
    if (extModel.url.length > 0) {
        WebArticlePushViewController * vc = [[WebArticlePushViewController alloc]init];
        vc.pushURL = extModel.url;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}


#pragma mark - 发送消息时触发
-(void)didSendTextOver:(EMMessage *)EMMessage WithText:(NSString *)text
{
    if (text.length < 1) {
        return;
    }
    
    [self sendMessage];
    [self createHistoryWithMessage:EMMessage WithText:text WithImageData:nil WithHttp:nil WithTime:nil];
    NSString * utf = [NSString stringWithCString:[text UTF8String] encoding:NSUnicodeStringEncoding];
    NSLog(@"utf %@",utf);
}
-(void)sendMessage
{
    
    
}

#pragma mark - 发送图片消息
-(void)didSendTextOver:(EMMessage *)EMMessage WithimageData:(NSData *)imageData
{
    
    
    [self sendMessage];
    [self createHistoryWithMessage:EMMessage WithText:nil WithImageData:imageData WithHttp:nil WithTime:nil];
    
}
/*
 发送拍照图片消息按钮
 */
-(void)didSendTextOver:(EMMessage *)EMMessage Withimage:(UIImage *)image
{
    NSData * imagedata = UIImageJPEGRepresentation(image, 0.7f);
    
    [self sendMessage];
    [self createHistoryWithMessage:EMMessage WithText:nil WithImageData:imagedata WithHttp:nil WithTime:nil];
}
#pragma mark - 发送文章
-(void)didSendTextOver:(EMMessage *)EMMessage WithimageData:(NSData *)imageData WithEXT:(NSDictionary *)ext
{
    //    [self updateMessageNumber];
    [self sendMessage];
    OneMessageExtModel * extModel = [[OneMessageExtModel alloc]init];
    [extModel setValuesForKeysWithDictionary:EMMessage.ext];
    [self createHistoryWithMessage:EMMessage WithText:extModel.url WithImageData:nil WithHttp:nil WithTime:nil];
}
/*
 发送语音消息按钮
 */
-(void)didSendVidoeMessage:(EMMessage *)EMMessage WithLocalPath:(NSString *)localPath duration:(NSInteger)duration
{
    NSLog(@"localPath %@",localPath);
    NSData *data = [NSData dataWithContentsOfFile:localPath];
    NSString *vidoeStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self sendMessage];
    [self createHistoryWithMessage:EMMessage WithText:nil WithImageData:nil WithHttp:vidoeStr WithTime:[NSString stringWithFormat:@"%ld",duration]];
    
}

-(void)createHistoryWithMessage:(EMMessage *)EMMessage WithText:(NSString *)text WithImageData:(NSData *)imageData WithHttp:(NSString *)amrData WithTime:(NSString *)time
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.groupId forKey:@"groupId"];
    if([text containsString:@"@"])//_roaldSearchText
    {
        if (self.doctorID) {
            [dic setObject:self.doctorID forKey:@"doctorId"];
        }
    }
    [IWHttpTool postWithURL:@"http://api.hudieyisheng.com/v1/home/group-message" params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
    
}

@end
