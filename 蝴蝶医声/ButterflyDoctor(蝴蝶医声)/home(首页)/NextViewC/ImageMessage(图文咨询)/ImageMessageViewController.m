//
//  ImageMessageViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ImageMessageViewController.h"
#import "GatoBaseHelp.h"
#import "TitleButtonView.h"
#import "AllArticleTitleTableViewCell.h"
#import "ImageMessageTableViewCell.h"
#import "AfterPatientInfoViewController.h"
#import "releaseStopModel.h"
#import "ImageMessageModel.h"
#import "ImMessageOneForOneViewController.h"
#import "newPayNumberViewController.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"


#define kCellTag 10201705
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

@interface ImageMessageViewController ()<TitleButtonViewDelegate>
{
    NSInteger nowType;
    CGFloat page;
    TitleButtonView * headerView;
}
@property (nonatomic ,strong) UIView * topView;//筛选view
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataArray;
@property (nonatomic, strong) NSMutableArray *currentDataArray;
@property (nonatomic, strong) NSMutableArray *pageArray;//记录当前页面page

@property (nonatomic ,strong) UILabel * TopRedNumberlabel;//上方未读小红点
@property (nonatomic, strong) NSMutableArray *TypetitleArray;//已经点击过按钮  首次点击加载信息
@property (nonatomic, strong) NSString * urlStr;

@property (nonatomic ,strong) UILabel * nullLabel;

@property (nonatomic ,strong) NSMutableDictionary * cellHeightDic;

@property (nonatomic ,strong) NSString * weiduCount;//未读人数
@property (nonatomic ,strong) NSString * allCount;//全部人数
@property (nonatomic ,strong) NSString * WhuifuCount;//未回复人数
@end

@implementation ImageMessageViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!nowType) {
        nowType = 0;
    }
    [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
    [self.dataArray[nowType] removeAllObjects];
    [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];
    //获取未读消息数量
    [self addMessageNumberHttp];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"图文咨询";
   
    self.TypetitleArray = [NSMutableArray array];
    page = 0;
    nowType = 0;
    self.cellHeightDic = [NSMutableDictionary dictionary];
    [self initDatas];
    Gato_TableView
    self.GatoTableview.y = Gato_Height_548_(39);
    self.GatoTableview.height = Gato_Height - Gato_Height_548_(39) - NAV_BAR_HEIGHT;
    [self.view addSubview:self.GatoTableview];

    [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    
    self.TopRedNumberlabel.hidden = YES;
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(19),Gato_Height_548_(18))];
    [right2Button setBackgroundImage:[UIImage imageNamed:@"nav_set"] forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(mineOtherButtonItem)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
    self.navigationItem.rightBarButtonItems = @[rightItem2];
     [self newFrame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payShoppingPayOK:) name:@"homeMessage" object:nil];
    
}
- (void)payShoppingPayOK:(NSNotification *)notification
{

}
-(void)mineOtherButtonItem
{
    newPayNumberViewController * vc = [[newPayNumberViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//刷新
-(void)loadNewTopic
{
    [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
    [self.dataArray[nowType] removeAllObjects];
    [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    
    NSString * pagestr = self.pageArray[nowType];
    pagestr = [NSString stringWithFormat:@"%.0f",[pagestr floatValue] + 1];
    [self.pageArray replaceObjectAtIndex:nowType withObject:pagestr];
    [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}

#pragma mark 网络请求
-(void)updateWithType:(NSString * )type
{
   
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.pageArray[nowType] forKey:@"page"];
    if ([type isEqualToString:@"0"]) {
        [self.updateParms setObject:@"noread" forKey:@"type"];
    }else if([type isEqualToString:@"1"]){
        [self.updateParms setObject:@"norecive" forKey:@"type"];
    }else{
        [self.updateParms setObject:@"all" forKey:@"type"];
    }
    [IWHttpTool postWithURL:HD_Home_TWZX_Text params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];

        if ([success isEqualToString:@"200"]) {
            
            self.nullLabel.hidden = YES;
//            未读数量
            self.weiduCount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"noread"];
//            全部数量
            self.allCount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"total"];
//            未回复数量
            self.WhuifuCount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"norecive"];
//           头部数据
            [headerView setTitleWithArray:@[[NSString stringWithFormat:@"未读(%@)",self.weiduCount],[NSString stringWithFormat:@"未回复(%@)",self.WhuifuCount],[NSString stringWithFormat:@"全部(%@)",self.allCount]]];
//            获取所有会话
//            NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//            NSMutableArray * teamConversations = [NSMutableArray array];
            
//            for (int i = 0 ; i < conversations.count; i ++) {
//                EMConversation *conversation = [[EMConversation alloc]init];
//                conversation = conversations[i];
////             EMConversationTypeChat  *** 单聊会话 ***
//                if (conversation.type == EMConversationTypeChat)
//                {
//                    [teamConversations addObject:conversation];
//                }
//            }

            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"data"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                ImageMessageModel * model = [[ImageMessageModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                model.isMessage = @"0";
//                获取一个聊天会话
                EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:model.patientEasemobId type:EMConversationTypeChat createIfNotExist:NO];
                NSInteger unreadCount = 0;
//                会话未读消息数量
                unreadCount = conversation.unreadMessagesCount;
                model.isMessage = [NSString stringWithFormat:@"%ld",unreadCount];
                NSLog(@"model.ismessage %@\nconversation.conversationId %@\nmodel.patientEasemobId %@ ",model.isMessage,conversation.conversationId,model.patientEasemobId);

                NSInteger typeFloat = [type integerValue];
                
                [self.dataArray[typeFloat] addObject:model];
                
            }
            if (_dataArray.count > nowType) {
                _currentDataArray = _dataArray[nowType];
            }
        }
        else
        {
            self.weiduCount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"noread"];
            
            self.allCount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"total"];
            
            self.WhuifuCount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"norecive"];
            
            [headerView setTitleWithArray:@[[NSString stringWithFormat:@"未读(%@)",self.weiduCount],[NSString stringWithFormat:@"未回复(%@)",self.WhuifuCount],[NSString stringWithFormat:@"全部(%@)",self.allCount]]];
            
            NSString * falseMessage = [dic objectForKey:@"message"];
            NSInteger typeFloat = [type integerValue];
            if (self.dataArray[typeFloat].count > 0) {
                if (![self.dataArray[typeFloat][0] isKindOfClass:[NulllabelModel class]]) {
                    [self showHint:falseMessage];
                }
            }else{
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"当前没有患者对您进行咨询";
                [_currentDataArray addObject:model];
            }
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
//获取未读消息数量
-(void)addMessageNumberHttp
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.pageArray[nowType] forKey:@"page"];
    [IWHttpTool postWithURL:HD_Home_TWZX_Number params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取未读消息数量%@",dic);
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.TopRedNumberlabel.text = [[dic objectForKey:@"data"] objectForKey:@"info"];
            if ([self.TopRedNumberlabel.text isEqualToString:@"0"]) {
                self.TopRedNumberlabel.hidden = YES;
            }else{
                self.TopRedNumberlabel.hidden = NO;
            }
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}


-(void)newFrame
{
    headerView = [[TitleButtonView alloc]init];;
    [headerView setTitleWithArray:@[@"未读",@"未回复",@"全部"]];
    headerView.frame = CGRectMake(0, Gato_Height_548_(0), Gato_Width, Gato_Height_548_(39));
    headerView.delegate = self;
    [self.view addSubview:headerView];
    
    [self.view addSubview:self.TopRedNumberlabel];
    
    self.TopRedNumberlabel.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(80))
    .topSpaceToView(self.view,Gato_Height_548_(8))
    .heightEqualToWidth(self.TopRedNumberlabel)
    .minWidthIs(Gato_Width_320_(11));
    
    [self.TopRedNumberlabel setSingleLineAutoResizeWithMaxWidth:Gato_Width_320_(50)];
    
    self.TopRedNumberlabel.text = @"5";
    
    [self.TopRedNumberlabel updateLayout];
    
    GatoViewBorderRadius(self.TopRedNumberlabel, self.TopRedNumberlabel.height / 2, 0, [UIColor redColor]);
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3)
    .topSpaceToView(self.topView,Gato_Height_548_(8))
    .widthIs(1)
    .heightIs(Gato_Height_548_(27));
    
    UIView * fgx1 = [[UIView alloc]init];
    fgx1.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx1];
    fgx1.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3 * 2)
    .topSpaceToView(self.topView,Gato_Height_548_(8))
    .widthIs(1)
    .heightIs(Gato_Height_548_(27));
    
    
    UIButton*right1Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [right1Button setBackgroundImage:[UIImage imageNamed:@"nav_essay"] forState:UIControlStateNormal];
    right1Button.titleLabel.font = FONT(30);
    [right1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right1Button addTarget:self action:@selector(mobanButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:right1Button];
    
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [right2Button setBackgroundImage:[UIImage imageNamed:@"nav_seek"] forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(searchButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
//    self.navigationItem.rightBarButtonItems = @[rightItem2];
}
-(void)mobanButton
{

}
-(void)searchButton
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.currentDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (self.currentDataArray.count < indexPath.row || self.currentDataArray.count < 1) {
        Gato_tableviewcell_new
    }
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.currentDataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        ImageMessageTableViewCell * cell = [ImageMessageTableViewCell cellWithTableView:tableView];
        ImageMessageModel * model = [[ImageMessageModel alloc]init];
        model = self.currentDataArray[indexPath.row];
        [cell setValueWithModel:model];
        cell.ButtonBlock = ^(){
            AfterPatientInfoViewController * vc = [[AfterPatientInfoViewController alloc]init];
            vc.patientCaseId = model.patientCaseId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [self.cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentDataArray.count < indexPath.row || self.currentDataArray.count < 1) {
        return 0;
    }
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
        NSNumber *value = [self.cellHeightDic objectForKey:kHuShenKey];
        CGFloat height = value.floatValue;
        if (height < 1) {
            height = 1;
        }
        return height;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentDataArray.count < 1 )
    {
        return;
    }
   if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]])
   {
       
   }
   else
   {
       NSLog(@"点我进入聊天");
       ImageMessageModel * model = [[ImageMessageModel alloc]init];
       model = self.currentDataArray[indexPath.row];
       ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:model.patientEasemobId conversationType:EMConversationTypeChat];
       chatController.messageModel = model;
       chatController.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:chatController animated:YES];
   }
    
}

#pragma mark init data
- (void)initDatas {
    
    _dataArray = [NSMutableArray array];
    _pageArray = [NSMutableArray array];
    _currentDataArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *data = [NSMutableArray array];
        [_dataArray addObject:data];
        [_pageArray addObject:@"0"];
    }
    if (_dataArray.count > 0) {
        _currentDataArray = _dataArray[0];
    }
    [self.GatoTableview reloadData];
}
#pragma headerView delegate
- (void)headerBtnClicked:(ENUM_BTN_TYPE)type {
    nowType = type;
    if (_dataArray.count > type) {
        _currentDataArray = _dataArray[type];
    }
    
    if (self.pageArray.count > nowType) {
//        if ([self.pageArray[nowType] isEqualToString:@"0"]) {
//            for (int i = 0 ; i < self.TypetitleArray.count; i ++) {
//                NSString * typestr = [NSString stringWithFormat:@"%ld",nowType];
//                if ([typestr isEqualToString:self.TypetitleArray[i]]) {
//                    [self.GatoTableview reloadData];
//                    return;
//                }
//            }
//        [headerView buttonType:type];
            NSMutableArray *data = [NSMutableArray array];
            [_dataArray replaceObjectAtIndex:nowType withObject:data];
            [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
            [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
            [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];//网络请求
            
//        }
    }
    [self.GatoTableview reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topView];
    }
    return _topView;
}
-(UILabel *)TopRedNumberlabel
{
    if (!_TopRedNumberlabel) {
        _TopRedNumberlabel = [[UILabel alloc]init];
        _TopRedNumberlabel.backgroundColor = [UIColor orangeColor];
        _TopRedNumberlabel.textColor = [UIColor whiteColor];
        _TopRedNumberlabel.font = FONT(26);
        _TopRedNumberlabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _TopRedNumberlabel;
}


@end
