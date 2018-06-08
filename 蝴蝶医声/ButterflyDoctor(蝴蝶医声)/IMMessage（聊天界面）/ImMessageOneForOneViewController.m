//
//  ImMessageOneForOneViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ImMessageOneForOneViewController.h"
#import "GatoBaseHelp.h"
#import "patientInfoViewController.h"
#import "DoctorHomeViewController.h"
#import "AfterPatientInfoViewController.h"
#import "WebArticlePushViewController.h"
#import "TheArticleViewController.h"
#import "EMChooseViewController.h"
#import "OneMessageExtModel.h"
#import "tishiXiaoShiViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "IMMessageOneMp3DataViewController.h"
#import "PellTableViewSelect.h"
#import <AVFoundation/AVFoundation.h>
#import "EMVoiceConverter.h"

#define topViewHieght Gato_Height_548_(70)
@interface ImMessageOneForOneViewController ()<EMClientDelegate, EMChooseViewDelegate,AVAudioPlayerDelegate>
{
    NSString * httpUrl;//发送文章链接
    NSString * httpName;//发送文章名字
    NSString * firstCome;//是否是首次咨询
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    NSMutableDictionary * _emotionDic;
    BOOL newViewController;//是否是当前页面  用于穿透消息-   进入页面 YES  退出页面NO
     UIView * topView;
    BOOL messageUpdate;//消息发送开关 默认NO 不拦截
}
@property (nonatomic ,strong) NSString * pushUrl;
@property (nonatomic ,strong) NSString * remainingStr;
@property (nonatomic ,strong) UILabel * remainingNumber;
@property (nonatomic ,strong) UIButton * toumingButton;
@property (nonatomic ,strong) IMMessageOneMp3DataViewController * yuyinPellView;
@property (nonatomic, strong) AVAudioPlayer *player; //播放器
@property (nonatomic, strong) AVAudioSession *session;
@end

@implementation ImMessageOneForOneViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    newViewController = YES;
//    补最上方的位置
    topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor HDThemeColor];
    [self.navigationController.view addSubview:topView];
    topView.frame = CGRectMake(0, 0, Gato_Width, 20);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    newViewController = NO;
    [topView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"医患交流";
    //查看小组&图文资讯未读消息
    [GatoMethods getTeamAndPeopleNumberWithunread];
    
    self.delegate = self;
    self.dataSource = self;
    [self addtopViews];
    self.showRefreshHeader = YES;
    [self update];
    [self removeImageMessage];
    self.faceView.hidden = YES;
    
    [self addyuyinViews];
    
}

- (void)addyuyinViews
{
    self.yuyinPellView = [[IMMessageOneMp3DataViewController alloc]init];
    CGRect yuyinRect = CGRectMake(0, Gato_Height, Gato_Width, Gato_Height);
    self.yuyinPellView.frame = yuyinRect;
    [self.yuyinPellView addAllView];
    [self.view addSubview:self.yuyinPellView];
}
-(void)update
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString * patientId;
    if (self.model) {
        patientId = self.model.patientCaseId;
    }else if(self.afterModel){
        patientId = self.afterModel.patientCaseId;
    }else{
        patientId = self.messageModel.patientCaseId;
        [dic setObject:self.messageModel.identity forKey:@"user_identity"];
    }
    [dic setObject:patientId forKey:@"patientCaseId"];
    [dic setObject:TOKEN forKey:@"token"];
    
    [IWHttpTool postWithURL:HD_patientAndDoctor_chat_remainingNumber params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.remainingStr = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"replyCount"];
            
            firstCome = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"isFirst"];
            if ([self.remainingStr integerValue] < 1) {
                 [self.view endEditing:YES];
                self.toumingButton.hidden = NO;
//                [GatoMethods AleartViewWithMessage:[NSString stringWithFormat:@"该患者付费交流次数已用完"]];
                self.remainingStr = @"0";
                self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                self.PlayNumber = self.remainingStr;
            }else{
                self.toumingButton.hidden = YES;
                self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                self.PlayNumber = self.remainingStr;
            }
            if ([firstCome isEqualToString:@"1"]) {
                [self.toumingButton setTitle:@"该患者尚未进行付费咨询" forState:UIControlStateNormal];
            }else{
                [self.toumingButton setTitle:@"该患者付费交流次数已用完" forState:UIControlStateNormal];
            }
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }

        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)removeImageMessage
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString * patientId;
    if (self.model) {
        patientId = self.model.patientCaseId;
        [dic setObject:@"0" forKey:@"user_identity"];
    }else if(self.afterModel){
        patientId = self.afterModel.patientCaseId;
        [dic setObject:@"0" forKey:@"user_identity"];
    }else{
        patientId = self.messageModel.patientCaseId;
        [dic setObject:self.messageModel.identity forKey:@"user_identity"];
    }
    [dic setObject:patientId forKey:@"patientCaseId"];
    [dic setObject:TOKEN forKey:@"token"];
    
    [IWHttpTool postWithURL:HD_Home_Remove_ImageMessage params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)toumingButtonDid
{
    
}
#pragma mark - 加载患者个人信息
-(void)addtopViews
{
    NSString * photoStr,* nameStr, *sexStr, * ageStr ,*timeStr,*zhenduanStr ,*TouserId;
    
    if (self.model) {
        photoStr = self.model.photo;
        nameStr = self.model.name;
        sexStr = self.model.sex;
        ageStr = self.model.age;
        TouserId = self.model.patientEasemobId;
        timeStr = [GatoMethods getStringWithLeftStr:@"入院时间：" WithRightStr:self.model.bedTime];
        zhenduanStr = [GatoMethods getStringWithLeftStr:@"入院诊断：" WithRightStr:self.model.diagnose];
    }else if(self.afterModel){
        photoStr = self.afterModel.photo;
        nameStr = self.afterModel.name;
        sexStr = self.afterModel.sex;
        ageStr = self.afterModel.age;
        TouserId = self.afterModel.patientEasemobId;
        timeStr = [GatoMethods getStringWithLeftStr:@"出院时间：" WithRightStr:self.afterModel.endTime];
        zhenduanStr = [GatoMethods getStringWithLeftStr:@"出院诊断：" WithRightStr:self.afterModel.lDiagnose];
    }else{
        if ([self.messageModel.isLeave isEqualToString:@"0"]) {
            //未出院
            photoStr = self.messageModel.photo;
            nameStr = self.messageModel.name;
            sexStr = self.messageModel.sex;
            ageStr = self.messageModel.age;
            TouserId = self.messageModel.patientEasemobId;
            timeStr = @"";
            zhenduanStr = [GatoMethods getStringWithLeftStr:@"入院诊断：" WithRightStr:self.messageModel.diagnose];
        }else{
            photoStr = self.messageModel.photo;
            nameStr = self.messageModel.name;
            sexStr = self.messageModel.sex;
            ageStr = self.messageModel.age;
            TouserId = self.messageModel.patientEasemobId;
            timeStr = @"";
            zhenduanStr = [GatoMethods getStringWithLeftStr:@"出院诊断：" WithRightStr:self.messageModel.lDiagnose];
        }
    }
    
    NSString *userOpenId = TouserId;// 用户环信ID
    NSString *nickName = [NSString stringWithFormat:@"%@",nameStr];// 用户昵称
    NSString *avatarUrl = [NSString stringWithFormat:@"%@",photoStr];// 用户头像（绝对路径）
    // 通过消息的扩展属性传递昵称和头像时，需要调用这句代码缓存
    [UserCacheManager save:userOpenId avatarUrl:avatarUrl nickName:nickName];
    

    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.frame= CGRectMake(0, 0, self.view.frame.size.width, topViewHieght);
    
    UIImageView * photo = [[UIImageView alloc]init];
    [photo sd_setImageWithURL:[NSURL URLWithString:photoStr] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    photo.frame = CGRectMake(Gato_Width_320_(12), Gato_Height_548_(11), Gato_Width_320_(37), Gato_Height_548_(37));
    [view addSubview:photo];
    photo.layer.masksToBounds = YES;
    photo.layer.cornerRadius = photo.frame.size.width / 2;
    
    UILabel * name = [[UILabel alloc]init];
    name.font = [UIFont systemFontOfSize:16];
    [view addSubview:name];
    name.frame = CGRectMake(CGRectGetMaxX(photo.frame) + Gato_Width_320_(10), Gato_Height_548_(10), Gato_Width_320_(50), Gato_Height_548_(20));
    name.text = nameStr;
    [name sizeToFit];
    
    
    UIImageView * sex = [[UIImageView alloc]init];
    if ([sexStr isEqualToString:@"女"]) {
        sex.image = [UIImage imageNamed:@"image-text_icon_woman"];
    }else{
        sex.image = [UIImage imageNamed:@"image-text_icon_man"];
    }
    sex.frame = CGRectMake(CGRectGetMaxX(name.frame) + Gato_Width_320_(7), Gato_Height_548_(12), Gato_Width_320_(12), Gato_Height_548_(12));
//    sex.sd_layout.leftSpaceToView(name, Gato_Width_320_(7))
//    .centerYEqualToView(name)
//    .widthIs(Gato_Width_320_(12))
//    .heightIs(Gato_Height_548_(12));
    [view addSubview:sex];
    
    UILabel * age = [[UILabel alloc]init];
    age.font = [UIFont systemFontOfSize:16];
    [view addSubview:age];
    age.frame = CGRectMake(CGRectGetMaxX(sex.frame) + Gato_Width_320_(7), Gato_Height_548_(10), Gato_Width_320_(35), Gato_Height_548_(20));
//    age.sd_layout.leftSpaceToView(sex, Gato_Width_320_(7))
//    .centerYEqualToView(sex)
//    .widthIs(Gato_Width_320_(50))
//    .heightIs(Gato_Height_548_(20));
    age.text = [NSString stringWithFormat:@"%@岁",ageStr];
    [age sizeToFit];
    
    UILabel * time = [[UILabel alloc]init];
    time.font = [UIFont systemFontOfSize:14];
    time.textAlignment = NSTextAlignmentRight;
    [view addSubview:time];
    time.frame = CGRectMake( Gato_Width_320_(10), CGRectGetMinY(name.frame), Gato_Width_320_(300), Gato_Height_548_(15));
    time.text = timeStr;
//    [time sizeToFit];
    
    UILabel * zhenduan = [[UILabel alloc]init];
    zhenduan.font = [UIFont systemFontOfSize:14];
    [view addSubview:zhenduan];
    zhenduan.frame = CGRectMake(CGRectGetMaxX(photo.frame) + Gato_Width_320_(10),CGRectGetMaxY(name.frame) + Gato_Height_548_(5), Gato_Width_320_(300), Gato_Height_548_(15));
    zhenduan.text = zhenduanStr;
    
    self.remainingNumber = [[UILabel alloc]init];
    self.remainingNumber.font = [UIFont systemFontOfSize:14];
    self.remainingNumber.textAlignment = NSTextAlignmentRight;
    self.remainingNumber.textColor = [UIColor HDTitleRedColor];
    [view addSubview:self.remainingNumber];
    self.remainingNumber.frame = CGRectMake(Gato_Width_320_(10),CGRectGetMaxY(zhenduan.frame) + Gato_Height_548_(5), Gato_Width_320_(300), Gato_Height_548_(10));
    
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0];
    [view addSubview:fgx];
    fgx.frame = CGRectMake(0, topViewHieght - 1, Gato_Width, 1);
    
    [self addTopInfoButton];
    
    self.toumingButton.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(Gato_Height_548_(50) + Gato_iPhoneXHeight);
//    self.toumingButton.frame = self.chatToolbar.frame;
}

#pragma mark - 上方top信息跳转按钮
-(void)addTopInfoButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(addTopInfoButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(80);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 消息已送达回执
- (void)messagesDidDeliver:(NSArray *)aMessages
{
    for (EMMessage * message in aMessages) {
        NSLog(@"消息已送达回执 %@",message);
        
    }
}
#pragma mark - 失败消息 点击红色按钮重新发送回调
-(void)redButtonForModel:(id<IMessageModel>)model
{
    if (model.bodyType == EMMessageBodyTypeText) {
//        [self updateMessageNumber];
        [self sendMessage];
        [self createHistoryWithMessage:model.message WithText:model.text WithImageData:nil WithHttp:nil WithTime:nil];
    }else if (model.bodyType == EMMessageBodyTypeImage){
//        [self updateMessageNumber];
        [self sendMessage];
        NSData *data = UIImagePNGRepresentation(model.image);
        [self createHistoryWithMessage:model.message WithText:nil WithImageData:data WithHttp:nil WithTime:nil];
    }else if (model.bodyType == EMMessageBodyTypeVoice){
        EaseMessageModel * messageModel = model;
        EMVoiceMessageBody * voiceBody = (EMVoiceMessageBody *)messageModel.firstMessageBody;
        NSData *data = [NSData dataWithContentsOfFile:voiceBody.localPath];
        NSString *vidoeStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        [self updateMessageNumber];
        [self sendMessage];
        [self createHistoryWithMessage:model.message WithText:nil WithImageData:nil WithHttp:vidoeStr WithTime:[NSString stringWithFormat:@"%.0f",messageModel.mediaDuration]];
    }
}

#pragma mark - topButton按钮
-(void)addTopInfoButtonDidClicked
{
    NSLog(@"点击topbutton跳转个人信息");

    BOOL chuyuan = NO;
    NSString * patientId;
    if (self.model) {
        chuyuan = NO;
        patientId = self.model.patientCaseId;
    }else if(self.afterModel){
        chuyuan = YES;
        patientId = self.afterModel.patientCaseId;
    }else{
        patientId = self.messageModel.patientCaseId;
        if ([self.messageModel.isLeave isEqualToString:@"0"]) {
            chuyuan = NO;
        }else{
            chuyuan = YES;
        }
    }
    
    if (chuyuan == NO) {
        patientInfoViewController * vc = [[patientInfoViewController alloc]init];
        vc.userId = patientId;
        vc.type = @"0";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AfterPatientInfoViewController * vc = [[AfterPatientInfoViewController alloc]init];
        vc.patientCaseId = patientId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 点击头像
- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    NSLog(@"点击聊天头像 跳转个人信息");
    if ([messageModel.nickname isEqualToString:GATO_PHOTO]) {
        DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
        vc.doctorId = TOKEN;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self addTopInfoButtonDidClicked];
    }
   
    
}

- (void)messageViewController:(EaseMessageViewController *)viewController
didReceiveHasReadAckForModel:(id<IMessageModel>)messageModel
{
    
    
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
        if (model.title.length > 7) {
            model.title = [NSString stringWithFormat:@"%@...",[model.title substringToIndex:7]];
        }
        [extDic setObject:model.title forKey:@"title"];
        [extDic setObject:weakSelf.pushUrl forKey:@"url"];
        self->httpUrl = weakSelf.pushUrl;
        self->httpName = model.title;
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



//- (void)messagesDidReceive:(NSArray *)aMessages
//{
//    for (EMMessage * message in aMessages) {
//        NSDictionary * ext = message.ext;
//        NSLog(@"透传消息ext ： %@",ext);
//    }
//}
#pragma mark - 透传消息
//- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
//{
//    
//}
#pragma mark - 透传消息
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
    NSString * patientId;
    if (self.model) {
        patientId = self.model.patientEasemobId;
    }else if(self.afterModel){
        patientId = self.afterModel.patientEasemobId;
    }else{
        patientId = self.messageModel.patientEasemobId;
    }
    if (newViewController == YES) {
        
        [self update];
    }
    for (EMMessage * message in aCmdMessages) {
        NSDictionary * ext = message.ext;
        NSLog(@"透传消息ext ： %@",ext);
        if ([ext[@"action"] isEqualToString:@"refush"]) {
            [self update];
        }
        
    }
//    EMMessage *message = [EaseSDKHelper sendCmdMessage:@"sdfsdflkj" to:patientId messageType:EMChatTypeChat messageExt:nil cmdParams:nil];
}

#pragma mark - 发送消息时触发
-(void)didSendTextOver:(EMMessage *)EMMessage WithText:(NSString *)text
{
    if (text.length < 1) {
        return;
    }
//    [self updateMessageNumber];
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
    
//    [self updateMessageNumber];
    [self sendMessage];
    [self createHistoryWithMessage:EMMessage WithText:nil WithImageData:imageData WithHttp:nil WithTime:nil];
    
}
/*
 发送拍照图片消息按钮
 */
-(void)didSendTextOver:(EMMessage *)EMMessage Withimage:(UIImage *)image
{
    NSData * imagedata = UIImageJPEGRepresentation(image, 0.7f);
//    [self updateMessageNumber];
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
-(void)createHistoryWithMessage:(EMMessage *)EMMessage WithText:(NSString *)text WithImageData:(NSData *)imageData WithHttp:(NSString *)amrData WithTime:(NSString *)time
{
    if (messageUpdate == YES) {
        [self showHint:@"您还有消息正在发送中..."];
        return;
    }
    messageUpdate = YES;
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    NSString * patientId;
    NSString * patientEasemobId;
    if (self.model) {
        patientId = self.model.patientCaseId;
        patientEasemobId = self.model.patientEasemobId;
        [dic setObject:@"0" forKey:@"user_identity"];
    }else if(self.afterModel){
        patientId = self.afterModel.patientCaseId;
        patientEasemobId = self.afterModel.patientEasemobId;
        [dic setObject:@"0" forKey:@"user_identity"];
    }else{
        patientId = self.messageModel.patientCaseId;
        patientEasemobId = self.messageModel.patientEasemobId;
        [dic setObject:self.messageModel.identity forKey:@"user_identity"];
    }
    [dic setObject:patientEasemobId forKey:@"patientEasemobId"];
    [dic setObject:patientId forKey:@"patientCaseId"];
    [dic setObject:EMMessage.messageId forKey:@"messageId"];
    NSLog(@"conversationId %@ \n messageId %@ \n timestamp %.0lld  \n localTime %.0lld",EMMessage.conversationId,EMMessage.messageId,EMMessage.timestamp,EMMessage.localTime);
    if (text) {
        [dic setObject:@"chat" forKey:@"type"];
        if (httpUrl.length > 0) {
            NSString * titleNmae = httpName;
            if (titleNmae.length > 7) {
                titleNmae = [NSString stringWithFormat:@"%@...",[titleNmae substringToIndex:7]];
            }
            NSString * httpText = [NSString stringWithFormat:@"<a href=\"%@\"><span class=\"wzwz\"><span class=\"btbt\">%@</span>点击查看详情</span><span><img src=\"http://wechat.hudieyisheng.com/images/logo.jpg\" class=\"tptp\"></span></a>",httpUrl,titleNmae];
            [dic setObject:httpText forKey:@"data"];
        }else{
            [dic setObject:text forKey:@"data"];
        }
    }
    if (imageData) {
        [dic setObject:@"img" forKey:@"type"];
        NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [dic setObject:encodedImageStr forKey:@"data"];
    }
    if (amrData) {
        [dic setObject:@"mp3" forKey:@"type"];
        [dic setObject:amrData forKey:@"data"];
        [dic setObject:time forKey:@"length"];
    }
    httpUrl = @"";
    httpName = @"";

    NSLog(@"\n\n\n\n 请求home/create-history 【开始】 \n\n");

    [IWHttpTool postWithURL:HD_Create_history params:dic success:^(id json) {
        messageUpdate = NO;
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSLog(@"\n\n\n\n 请求home/create-history 【成功】\n\n");
            
            [self _sendMessage:EMMessage];
            [self updateMessageNumber];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        messageUpdate = NO;
        
        NSLog(@"%@",error);
        [GatoMethods AleartViewWithMessage:@"网络请求超时，请尝试重新发送"];
    } ];
    
}
-(void )afn{
    
    
}
#pragma mark - 计算剩余咨询次数
-(void)updateMessageNumber
{
//    BOOL NowInter = [self afn];
//    NSLog(@"当前网络状态：%d",NowInter);
//    if (NowInter) {
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    BOOL status = NO;
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                
                status = YES;
                if ([self.remainingStr integerValue ] > 0) {
                    self.remainingStr = [NSString stringWithFormat:@"%ld",[self.remainingStr integerValue] - 1];
                    if ([self.remainingStr isEqualToString:@"0"]) {
                        [self.view endEditing:YES];
                        self.toumingButton.hidden = NO;
                    }
                    self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                }else{
                    [self.view endEditing:YES];
                    self.toumingButton.hidden = NO;
                    //        [GatoMethods AleartViewWithMessage:[NSString stringWithFormat:@"该患者付费交流次数已用完"]];
                    self.remainingStr = @"0";
                    self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                [self showHint:@"当前网络状态不好，请尝试重新发送。"];
                status = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                status = YES;
                if ([self.remainingStr integerValue ] > 0) {
                    self.remainingStr = [NSString stringWithFormat:@"%ld",[self.remainingStr integerValue] - 1];
                    if ([self.remainingStr isEqualToString:@"0"]) {
                        [self.view endEditing:YES];
                        self.toumingButton.hidden = NO;
                    }
                    self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                }else{
                    [self.view endEditing:YES];
                    self.toumingButton.hidden = NO;
                    //        [GatoMethods AleartViewWithMessage:[NSString stringWithFormat:@"该患者付费交流次数已用完"]];
                    self.remainingStr = @"0";
                    self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                status = YES;
                if ([self.remainingStr integerValue ] > 0) {
                    self.remainingStr = [NSString stringWithFormat:@"%ld",[self.remainingStr integerValue] - 1];
                    if ([self.remainingStr isEqualToString:@"0"]) {
                        [self.view endEditing:YES];
                        self.toumingButton.hidden = NO;
                    }
                    self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                }else{
                    [self.view endEditing:YES];
                    self.toumingButton.hidden = NO;
                    //        [GatoMethods AleartViewWithMessage:[NSString stringWithFormat:@"该患者付费交流次数已用完"]];
                    self.remainingStr = @"0";
                    self.remainingNumber.text = [GatoMethods getStringWithLeftStr:@"剩余咨询次数：" WithRightStr:self.remainingStr];
                }
                break;
            default:
                status = NO;
                break;
        }
        self.PlayNumber = self.remainingStr;
    }];
    
}

/*
 发送语音消息按钮
 */
-(void)didSendVidoeMessage:(EMMessage *)EMMessage WithLocalPath:(NSString *)localPath duration:(NSInteger)duration
{
    CGRect yuyinRect = CGRectMake(0, 0, Gato_Width, Gato_Height);
    Gato_WeakSelf(self);
    self.yuyinPellView.frame = yuyinRect;
    [PellTableViewSelect addPellTableViewSelectWithwithView:self.yuyinPellView WindowFrame:yuyinRect WithViewFrame:yuyinRect selectData:nil action:nil animated:YES];
    self.yuyinPellView.playerBlock = ^{

        if ([weakself.player isPlaying]) {
            return ;
        }
        NSString * wavFilePath = [[localPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"wav"];
        [EMVoiceConverter amrToWav:localPath wavSavePath:wavFilePath];
        NSData * urldata = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:wavFilePath]];
        weakself.player = [[AVAudioPlayer alloc] initWithData:urldata error:nil];
        weakself.player.delegate = weakself;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [weakself.player play];
    };
    self.yuyinPellView.hiddenBlock = ^{
        [weakself.player stop];
        [PellTableViewSelect hiden];
    };
    self.yuyinPellView.sendBlock = ^{
        [weakself.player stop];
        [PellTableViewSelect hiden];
        NSLog(@"localPath %@",localPath);
        NSData *data = [NSData dataWithContentsOfFile:localPath];
        NSString *vidoeStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        //    [self updateMessageNumber];
        [weakself sendMessage];
        [weakself createHistoryWithMessage:EMMessage WithText:nil WithImageData:nil WithHttp:vidoeStr WithTime:[NSString stringWithFormat:@"%ld",duration]];
    };
    
    
}
#pragma mark -  音频播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}


- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}




-(UIButton *)toumingButton
{
    if (!_toumingButton) {
        _toumingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toumingButton addTarget:self action:@selector(toumingButtonDid) forControlEvents:UIControlEventTouchUpInside];
        [_toumingButton setBackgroundImage:[UIImage imageNamed:@"blackTM"] forState:UIControlStateNormal];
        
        _toumingButton.titleLabel.font = FONT(36);
        _toumingButton.hidden = YES;
        [self.view addSubview:_toumingButton ];
    }
    return _toumingButton;
}
@end
