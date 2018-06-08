//
//  PushMessageViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "PushMessageViewController.h"
#import "GatoBaseHelp.h"
#import "pushMessageTitleTableViewCell.h"
#import "pushMessageTitleModel.h"
#import "TheArticleTableViewCell.h"
#import "WebArticleViewController.h"
#import "ModifyArticleViewController.h"
#import "modifyArticleModel.h"
#import "WaitingSurgeryViewController.h"
#import "searchHospitalizedViewController.h"
#define kCellTag 1004250929
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

#define TitleCellTag 1004252222
#define TitleHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + TitleCellTag]


#define SendHttp @"http://wechat.hudieyisheng.com/app/interface.php?func=sendTemplate"
#define HXUserId @"http://wechat.hudieyisheng.com/app/interface.php?func=geteasemobId"//返回环信ID
@interface PushMessageViewController ()
{
    CGFloat topCellHeight;
    NSMutableDictionary * cellHeightDic;
    NSMutableDictionary * TitlecellHeightDic;
}

@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UILabel * underLabel;
@property (nonatomic ,strong) UIButton * underButton;
@property (nonatomic ,strong) pushMessageTitleModel * titleMessageModel;

@property (nonatomic ,strong) UILabel * NullViewLabel;
@end

@implementation PushMessageViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.updataArray = [NSMutableArray array];
    [self update];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT - Gato_Height_548_(47));\
    [self.view addSubview:self.GatoTableview];
    self.title = @"推送消息";
    self.titleMessageModel = [[pushMessageTitleModel alloc]init];
    cellHeightDic = [NSMutableDictionary dictionary];
    TitlecellHeightDic = [NSMutableDictionary dictionary];
    [self newFrame];
    [self addOtherView];
    
}
#pragma mark - 读取模板设置
-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.comeForWhere forKey:@"type"];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    
    [IWHttpTool postWithURL:HD_ModifyArticle_Old params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            modifyArticleModel * titleModel = [[modifyArticleModel alloc]init];
            [titleModel setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            self.titleMessageModel.title = titleModel.title;
            self.titleMessageModel.time = titleModel.time;
            self.titleMessageModel.center = titleModel.content;
            self.titleMessageModel.pushId = titleModel.pushId;
            self.titleMessageModel.picurl = titleModel.picurl;
            for (int i = 0; i < titleModel.articles.count ; i ++) {
                TheArticleModel * model = [[TheArticleModel alloc]init];
                [model setValuesForKeysWithDictionary:titleModel.articles[i]];
                [self.updataArray addObject:model];
            }

        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        if (self.titleMessageModel.title.length < 1 && self.titleMessageModel.center.length < 1 && self.updataArray.count < 1) {
            self.NullViewLabel.hidden = NO;
        }else{
            self.NullViewLabel.hidden = YES;
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)newFrame
{
    self.underView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(47));
    
    
    self.underButton.sd_layout.rightSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,0)
    .bottomSpaceToView(self.underView,0)
    .widthIs(Gato_Width_320_(130));
    
    
    self.underLabel.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(14))
    .rightSpaceToView(self.underButton,Gato_Width_320_(14))
    .topSpaceToView(self.underView,Gato_Height_548_(0))
    .bottomSpaceToView(self.underView,Gato_Height_548_(0));
    
    
    self.NullViewLabel.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}


-(void)addOtherView
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_alter"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(overButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
-(void)overButton
{
    ModifyArticleViewController * vc = [[ModifyArticleViewController alloc]init];
    vc.type = self.type;
    vc.comeForWhere = self.comeForWhere;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)underButtonDid
{
    if (self.chuyuanzhenduan) {
        if ([self.type isEqualToString:@"1"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将患者移入随访栏目？" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self pushTheHospitalized];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [self pushTheHospitalized];
        }
        
        
    }
    if (self.noteModel) {
        if (self.noteModel.lDiagnose.length > 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将患者移入随访栏目？" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self pushNextHospitalized];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [self pushNextHospitalized];
        }
        
        
    }
    
}
#pragma mark - 未手术出院使用
-(void)pushTheHospitalized
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.patientCaseId forKey:@"patientCaseId"];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.chuyuanzhenduan forKey:@"lDiagnose"];
    [IWHttpTool postWithURL:HD_NoSurgery_Out params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 改变用户状态
-(void)pushNextHospitalized
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SVProgressHUD showWithStatus:@"保存中..."];
        NSString *changeState = @"2";
        self.updateParms = [NSMutableDictionary dictionary];
        [self.updateParms setObject:ModelNull(self.patientCaseId) forKey:@"patientCaseId"];
        [self.updateParms setObject:TOKEN forKey:@"token"];
        [self.updateParms setObject:ModelNull(self.titleMessageModel.pushId) forKey:@"pushId"];
        [self.updateParms setObject:ModelNull(self.noteModel.bedNumber) forKey:@"bedNumber"];
        [self.updateParms setObject:ModelNull(self.noteModel.caseNo) forKey:@"caseNo"];
        [self.updateParms setObject:ModelNull(self.noteModel.remark) forKey:@"remark"];
        NSMutableArray * sImages = [NSMutableArray array];
        if (self.noteModel.sImg.count > 0) {
            for (int i = 0 ;i < self.noteModel.sImg.count ; i ++) {
                if ([self.noteModel.sImg[i] isKindOfClass:[UIImage class]]) {
//                    NSData *data = UIImageJPEGRepresentation(self.noteModel.sImg[i], 0.5f);
                    NSData *data = [IWHttpTool zipNSDataWithImage:self.noteModel.sImg[i]];
//                    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    changeState = @"1";
                    [sImages addObject:data];
                }else{
                    [sImages addObject:self.noteModel.sImg[i]];
                }
                
            }
        }
        [self.updateParms setObject:sImages forKey:@"sImg"];
        [self.updateParms setObject:ModelNull(self.noteModel.sTumourLocation) forKey:@"sTumourLocation"];
        [self.updateParms setObject:ModelNull(self.noteModel.sTunica) forKey:@"sTunica"];
        [self.updateParms setObject:ModelNull(self.noteModel.sThyroid) forKey:@"sThyroid"];
        [self.updateParms setObject:ModelNull(self.noteModel.sMultiFoci) forKey:@"sMultiFoci"];
        [self.updateParms setObject:ModelNull(self.noteModel.sWay) forKey:@"sWay"];
        NSMutableArray * lImages = [NSMutableArray array];
        if (self.noteModel.lImg.count > 0) {
            for (int i = 0 ;i < self.noteModel.lImg.count ; i ++) {
                if ([self.noteModel.lImg[i] isKindOfClass:[UIImage class]]) {
//                    NSData *data = UIImageJPEGRepresentation(self.noteModel.lImg[i], 0.5f);
//                    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    NSData *data = [IWHttpTool zipNSDataWithImage:self.noteModel.lImg[i]];
                    changeState = @"1";
                    [lImages addObject:data];
                }else{
                    [lImages addObject:self.noteModel.lImg[i]];
                }
            }
        }
        [self.updateParms setObject:lImages forKey:@"lImg"];
        [self.updateParms setObject:ModelNull(self.noteModel.lRadioactiveIodine) forKey:@"lRadioactiveIodine"];
        [self.updateParms setObject:ModelNull(self.noteModel.lTshS) forKey:@"lTshS"];
        [self.updateParms setObject:ModelNull(self.noteModel.lDiagnose) forKey:@"lDiagnose"];
        if ([self.type isEqualToString:@"1"] && [self.comeForWhere isEqualToString:@"0"]) {
            //只有在住院患者移入等待病理的时候才需要传的参数 其他时候都不要
            [self.updateParms setObject:@"1" forKey:@"waitPathology"];
        }
        [self.updateParms setObject:self.noteModel.secondarylDiagnose forKey:@"secondarylDiagnose"];
        if ([ModelNull(self.noteModel.lTshS) isEqualToString:@"更多"] || [ModelNull(self.noteModel.lTshS) isEqualToString:@"正常范围"] || [ModelNull(self.noteModel.lTshS) isEqualToString:@"无"]) {
            self.noteModel.tshTopInt = @"";
            self.noteModel.tshUnderInt = @"";
        }
        [self.updateParms setObject:ModelNull(self.noteModel.tshTopInt) forKey:@"option1"];
        [self.updateParms setObject:ModelNull(self.noteModel.tshUnderInt) forKey:@"option2"];
        [self.updateParms setObject:@(lImages.count) forKey:@"lImgCount"];
        [self.updateParms setObject:@(sImages.count) forKey:@"sImgCount"];
        [SVProgressHUD show];
        NSLog(@"dic %@",self.updateParms);
        NSMutableArray *ImageAry = [NSMutableArray array];
        [ImageAry addObject:sImages];
        [ImageAry addObject:lImages];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IWHttpTool startMultiPartUploadTaskWithURL:HD_Surgery_Info imagesArray:ImageAry ChangeState:changeState parametersDict:self.updateParms succeedBlock:^(id json) {
//                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
//                NSString * success = [dic objectForKey:@"code"];
                NSString * success = [json objectForKey:@"code"];
                NSLog(@"%@",json);
                if ([success isEqualToString:@"200"]) {
                    
                    [self senderHetto];
                    [self getHXId];
                    
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.patientCaseId,@"patientCaseId", nil];
                    NSNotification *notification = [NSNotification notificationWithName:@"HospitalizedPatientsViewController" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [SVProgressHUD dismiss];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:@"1" forKey:@"delete"];
                    if (self.returnBlock) {
                        self.returnBlock(dic);
                    }
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[WaitingSurgeryViewController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }else if([temp isKindOfClass:[searchHospitalizedViewController class]])
                        {
                            
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    NSString * falseMessage = [json objectForKey:@"message"];
                    [self showHint:falseMessage];
                }
                [self.GatoTableview.mj_header endRefreshing];
                [self.GatoTableview reloadData];
            } failedBlock:^(NSError *error) {
                
            } uploadProgressBlock:^(float fractionCompleted, long long totalUnitCount, long long completedUnitCount){
            }];
        });
    });
    
    
    
    
    
    
    
    
    
    
    
    
//    [IWHttpTool postWithURL:HD_Surgery_Info params:self.updateParms success:^(id json) {
//
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
//        NSString * success = [dic objectForKey:@"code"];
//        if ([success isEqualToString:@"200"]) {
//            [self senderHetto];
//            [self getHXId];
//
//            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.patientCaseId,@"patientCaseId", nil];
//            NSNotification *notification = [NSNotification notificationWithName:@"HospitalizedPatientsViewController" object:nil userInfo:dict];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//            [SVProgressHUD dismiss];
//
//            for (UIViewController *temp in self.navigationController.viewControllers) {
//                if ([temp isKindOfClass:[WaitingSurgeryViewController class]]) {
//                    [self.navigationController popToViewController:temp animated:YES];
//                }
//            }
//            [self.navigationController popToRootViewControllerAnimated:YES];
//
//        }else{
//            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
//        }
//        [self.GatoTableview.mj_header endRefreshing];
//        [self.GatoTableview reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//
//    }];
}

-(void)senderHetto
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.comeForWhere forKey:@"type"];
    [self.updateParms setObject:self.patientCaseId forKey:@"userId"];
    [IWHttpTool postWithURL:SendHttp params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        NSLog(@"SendHttp %@",dic);
        if ([success isEqualToString:@"200"]) {
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
-(void)getHXId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.patientCaseId forKey:@"userId"];
    [IWHttpTool postWithURL:HXUserId params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"resultcode"];
        NSLog(@"HXUserId %@",dic);
        if ([success isEqualToString:@"0"]) {
            NSArray * easeId = [dic objectForKey:@"easemobId"];
            [self sendChatMsgArray:easeId text:nil];
        }else{
//            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)sendChatMsgArray:(NSArray * )toUserIdArray
                    text:(NSString *)text{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:@"模版消息" forKey:@"title"];
    NSString * textStr = [NSString stringWithFormat:@"http://wechat.hudieyisheng.com/template.php?doctorId=%@&userId=%@",TOKEN,self.noteModel.UserCaseId];
    NSMutableDictionary * extDic = [NSMutableDictionary dictionary];
    [extDic setObject:@"模版消息" forKey:@"title"];
    [extDic setObject:textStr forKey:@"url"];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.titleMessageModel.picurl]]];
    for (int i = 0 ; i < toUserIdArray.count ; i ++) {
        
        NSString * touserId = [toUserIdArray[i] objectForKey:@"easemobId"];
        NSString * userIdentity = [toUserIdArray[i] objectForKey:@"user_identity"];
        NSLog(@" 11111 touserId %@  \n\n userIdentity %@",touserId,userIdentity );
        EMMessage * message = [EaseSDKHelper sendImageMessageWithImage:image to:touserId messageType:EMChatTypeChat messageExt:extDic];
        [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
            if (!aError) {
                NSLog(@"22222 touserId %@  \n\n userIdentity %@",touserId,userIdentity );
                [self createHistoryWithText:textStr WithImageuserid:touserId WithMessage:message WithUserIdentity:userIdentity] ;
            }else{
                
            }
        }];
    }
}


-(void)createHistoryWithText:(NSString *)text WithImageuserid:(NSString *)userid WithMessage:(EMMessage *)EMMessage WithUserIdentity:(NSString *)user_identity
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.patientCaseId forKey:@"patientCaseId"];
    [dic setObject:EMMessage.messageId forKey:@"messageId"];
    [dic setObject:@"chat" forKey:@"type"];
    [dic setObject:user_identity forKey:@"user_identity"];
    [dic setObject:userid forKey:@"patientEasemobId"];
    NSString * titleNmae = self.titleMessageModel.title;
    if (titleNmae.length > 7) {
        titleNmae = [NSString stringWithFormat:@"%@...",[titleNmae substringToIndex:7]];
    }
    NSString * httpText = [NSString stringWithFormat:@"<a href=\"%@\" class=\"moban\"><span class=\"wzwz\"><span class=\"btbt\">%@</span>点击查看详情</span><span><img src=\"http://wechat.hudieyisheng.com/images/logo.jpg\" class=\"tptp\"></span></a>",text,titleNmae];
    [dic setObject:httpText forKey:@"data"];
//    [dic setObject:@"3" forKey:@"replyCount"];//[后台计数错误]
    [IWHttpTool postWithURL:HD_Create_history params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        NSLog(@"HD_Create_history %@",dic);
        if ([success isEqualToString:@"200"]) {
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.updataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return Gato_Height_548_(30) ;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, Gato_Width + 2, Gato_Height_548_(30))];
    view.backgroundColor = [UIColor appAllBackColor];
    GatoViewBorderRadius(view, 0, 1, [UIColor appAllBackColor]);
    UILabel * label = [[UILabel alloc]init];
    label.text = @"患教文章";
    label.font = FONT(30);
    [view addSubview:label];
    label.sd_layout.leftSpaceToView(view,Gato_Width_320_(13))
    .rightSpaceToView(view,Gato_Width_320_(13))
    .topSpaceToView(view,0)
    .bottomSpaceToView(view,0);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        pushMessageTitleTableViewCell * cell = [pushMessageTitleTableViewCell cellWithTableView:tableView];
        [cell setvalueWithModel:self.titleMessageModel];
        topCellHeight = cell.height;
        return cell;
    }else{
        TheArticleTableViewCell * cell = [TheArticleTableViewCell cellWithTableView:tableView];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.updataArray[indexPath.row];
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [TitlecellHeightDic setValue:value forKey:TitleHuShenKey];
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return topCellHeight;
    }else{
        NSNumber *value = [TitlecellHeightDic objectForKey:TitleHuShenKey];
        CGFloat height = value.floatValue;
        if (height < 1) {
            height = 1;
        }
        return height;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        WebArticleViewController * vc = [[WebArticleViewController alloc]init];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.updataArray[indexPath.row];
        vc.articleId = model.articleId;
        vc.isOwner = model.isOwner;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(UIButton *)underButton
{
    if (!_underButton) {
        _underButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_underButton setTitle:@"确定" forState:UIControlStateNormal];
        [_underButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_underButton setBackgroundColor:[UIColor HDThemeColor]];
        [_underButton addTarget:self action:@selector(underButtonDid) forControlEvents:UIControlEventTouchUpInside];
        _underButton.titleLabel.font = FONT(34);
        [self.underView addSubview:_underButton];
    }
    return _underButton;
}
-(UILabel *)underLabel
{
    if (!_underLabel) {
        _underLabel = [[UILabel alloc]init];
        _underLabel.textColor = [UIColor YMAppAllTitleColor];
        _underLabel.font = FONT(28);
        _underLabel.text = @"推送模版消息、文章给患者，并移入 随访";
        _underLabel.numberOfLines = 0;
        [self.underView addSubview:_underLabel];
    }
    return _underLabel;
}
-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_underView];
    }
    return _underView;
}

-(UILabel *)NullViewLabel
{
    if (!_NullViewLabel) {
        _NullViewLabel = [[UILabel alloc]init];
        _NullViewLabel.textAlignment = NSTextAlignmentCenter;
        _NullViewLabel.font = FONT(34);
        _NullViewLabel.text = @"您当前还没有创建模版\n请点击右上角创建新模版";
        _NullViewLabel.hidden = YES;
        _NullViewLabel.backgroundColor = [UIColor whiteColor];
        _NullViewLabel.numberOfLines = 0;
        [self.view addSubview:_NullViewLabel];
    }
    return _NullViewLabel;
}
@end
