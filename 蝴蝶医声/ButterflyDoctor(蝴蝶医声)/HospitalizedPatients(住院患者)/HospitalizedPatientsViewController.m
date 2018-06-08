//
//  HospitalizedPatientsViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HospitalizedPatientsViewController.h"
#import "GatoBaseHelp.h"
#import "HospitalizedPatientsTableViewCell.h"
#import "patientInfoViewController.h"
#import "ModifyArticleViewController.h"
#import "PushMessageViewController.h"
#import "EaseMessageViewController.h"
#import "HospitalizedPatientInfoModel.h"
#import "ImMessageOneForOneViewController.h"
#import "PellTableViewSelect.h"
#import "HospitalizedDoctorsArrayModel.h"
#import "searchHospitalizedViewController.h"
#import "UITabBar+bedge.h"
#import "MineHomeModel.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
#import "JGGHospitalizedPatientsCellTableViewCell.h"
#import "pushTableViewCell.h"
#import "pusNnllTableViewCell.h"

@interface HospitalizedPatientsViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CGFloat page;
    NSString * Toptype;//0全部 排序 1未回复
    BOOL reloadHttp;//define NO ；block YES
    NSString* laoyutStr;//1是九宫格。0是列表
    __block UIView* contentView;
    NSInteger JGGnum;//标记点击的是那个view
}
@property (nonatomic ,strong) UIView * topView;//筛选view
@property (nonatomic ,strong) UIButton * quanbuButton;
@property (nonatomic ,strong) UIButton * paixuButton;
@property (nonatomic ,strong) UIButton * MyHuanzheButton;
@property (nonatomic ,strong) NSMutableArray * DoctorsArray;//筛选组
@property (nonatomic ,assign) NSInteger AllDoctoresArrayCount;//全部筛选组的数量
@property (nonatomic ,strong) NSString * doctorId;//根据组长id筛选
@property (nonatomic ,strong) NSString * sort;//根据排序筛选
@property (nonatomic ,strong) NSString * NoSchuyuanId;//未手术出院患者id
@property (nonatomic ,strong) NSString * minecount;
@property (nonatomic ,strong) UITableView* pushTableView;// 九宫格弹出tableView
@end

@implementation HospitalizedPatientsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!reloadHttp) {
        self.DoctorsArray = [NSMutableArray array];
        self.updataArray = [NSMutableArray array];
        page = 0;
        if (!Toptype) {
            Toptype = @"0";
        }
        [self updateMyTeamWithmypatient:Toptype];
    }else{
        self.DoctorsArray = [NSMutableArray array];
        self.updataArray = [NSMutableArray array];
        page = 0;
        if (!Toptype) {
            Toptype = @"0";
        }
        [self updateTopTitle:Toptype];
        [self updateMyTeamWithmypatient:Toptype];
    }
    reloadHttp = NO;
    [self mineMessage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    创建UI
    [self newFrame];
    
    self.doctorId = @"";
    self.sort = @"";
    laoyutStr= @"0";
    self.GatoTableview.frame = CGRectMake(0,  Gato_Height_548_(39), Gato_Width, Gato_Height - Gato_Height_548_(39) - Tab_BAr_Height - NAV_BAR_HEIGHT);
    [self.view addSubview:self.GatoTableview];
    
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    
    
    
    if (@available(iOS 11.0, *)){
        self.GatoTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.GatoTableview.estimatedRowHeight = 0;
        self.GatoTableview.estimatedSectionFooterHeight = 0;
        self.GatoTableview.estimatedSectionHeaderHeight = 0;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"HospitalizedPatientsViewController" object:nil];
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    NSLog(@"%@",notification.userInfo);
    reloadHttp = YES;
    NSString * patientCaseId = [notification.userInfo objectForKey:@"patientCaseId"];
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
        model = self.updataArray[i];
        if ([model.patientCaseId isEqualToString:patientCaseId]) {
            [self.updataArray removeObjectAtIndex:i];
            [self.GatoTableview reloadData];
        }
    }
}
//刷新
-(void)loadNewTopic
{
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self updateMyTeamWithmypatient:Toptype];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    page ++;
    [self updateMyTeamWithmypatient:Toptype];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO ];
}

#pragma mark - 我的小红点处理
-(void)mineMessage
{
    if ([GatoMethods getTeamAndPeopleNumberWithunread] > 0) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:0];
    }else{
        [self.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_Info params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            MineHomeModel * model = [[MineHomeModel alloc]init];
            [model setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            NSString * teamApplyCount = model.teamApplyCount;
            NSString * noReadMessageCount = model.noReadMessageCount;
            if ([teamApplyCount integerValue] + [noReadMessageCount integerValue] > 0) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
            }else{
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
}

-(void)updateMyTeamWithmypatient:(NSString * )mypatient
{
    self.AllDoctoresArrayCount = 0;
    self.DoctorsArray = [NSMutableArray array];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.doctorId forKey:@"doctorId"];
    [dic setObject:self.sort forKey:@"sort"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [dic setObject:mypatient forKey:@"mypatient"];
    
    [IWHttpTool postWithURL:HD_patient_all params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        NSLog(@"%@",dic);
        NSArray * doctorArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"group"];
        for (int i = 0 ; i < doctorArray.count; i ++) {
            HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
            [model setValuesForKeysWithDictionary:doctorArray[i]];
            if([self.quanbuButton.titleLabel.text rangeOfString:model.name].location !=NSNotFound)//_roaldSearchText
            {
                [self.quanbuButton setTitle:[NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]] forState:UIControlStateNormal];
            }
            model.name = [NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]];
            self.AllDoctoresArrayCount += [[doctorArray[i] objectForKey:@"count"] integerValue];
            [self.DoctorsArray addObject:model];
            
            
        }
        
        if([self.quanbuButton.titleLabel.text rangeOfString:@"全部"].location !=NSNotFound)//_roaldSearchText
        {
            [self.quanbuButton setTitle:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount] forState:UIControlStateNormal];
        }
        self.minecount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"minecount"];
        if (self.minecount.length > 0) {
            [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(%@)",self.minecount] forState:UIControlStateNormal];
        }else{
            [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(0)"] forState:UIControlStateNormal];
        }
        
        if ([success isEqualToString:@"200"]) {
            if (page == 0)
            {
                self.updataArray = [NSMutableArray array];
            }
            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"patient"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
        }else{

            if (self.updataArray.count > 0) {
                if (![self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
                    [self showHint:@"没有更多数据了哦～"];
                }
            }else{
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"当前您还没有住院患者";
                [self.updataArray addObject:model];
            }
        }

        [self.GatoTableview.mj_footer endRefreshing];
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
        [self.pushTableView removeFromSuperview];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)updateTopTitle:(NSString * )mypatient
{
    self.AllDoctoresArrayCount = 0;
    self.DoctorsArray = [NSMutableArray array];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.doctorId forKey:@"doctorId"];
    [dic setObject:self.sort forKey:@"sort"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [dic setObject:mypatient forKey:@"mypatient"];
    
    [IWHttpTool postWithURL:HD_patient_all params:dic success:^(id json) {
        NSInteger jisu = 0;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSArray * doctorArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"group"];
        for (int i = 0 ; i < doctorArray.count; i ++) {
            HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
            [model setValuesForKeysWithDictionary:doctorArray[i]];
            if([self.quanbuButton.titleLabel.text rangeOfString:model.name].location !=NSNotFound)//_roaldSearchText
            {
                [self.quanbuButton setTitle:[NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]] forState:UIControlStateNormal];
            }
            model.name = [NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]];
            jisu += [[doctorArray[i] objectForKey:@"count"] integerValue];
            [self.DoctorsArray addObject:model];
            
            
        }
        self.AllDoctoresArrayCount = jisu;
        if([self.quanbuButton.titleLabel.text rangeOfString:@"全部"].location !=NSNotFound)//_roaldSearchText
        {
            [self.quanbuButton setTitle:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount] forState:UIControlStateNormal];
        }
        self.minecount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"minecount"];
        if (self.minecount.length > 0) {
            [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(%@)",self.minecount] forState:UIControlStateNormal];
        }else{
            [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(0)"] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 打印tableView在y方向上偏移了多少
//    NSLog(@"打印tableView在y方向上偏移了多少 %lf", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y > self.updataArray.count * Gato_Height_548_(170)) {
//        self.GatoTableview.contentOffset = self.updataArray.count * Gato_Height_548_(170);
    }
    
}

-(void)deletePatientWithpatientCaseId:(NSString *)patientCaseId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:patientCaseId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_patient_delete params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            self.updataArray = [NSMutableArray array];
            [self updateMyTeamWithmypatient:Toptype];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
// 创建UI
-(void)newFrame
{
    self.topView.sd_layout.leftSpaceToView(self.view,-1)
    .rightSpaceToView(self.view,-1)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(39));
    
    GatoViewBorderRadius(self.topView, 0, 0.5, [UIColor HDViewBackColor]);
    
    
    self.quanbuButton.sd_layout.leftSpaceToView(self.topView,0)
    .topSpaceToView(self.topView,0)
    .widthIs(Gato_Width / 3)
    .bottomSpaceToView(self.topView,0);
    
    self.MyHuanzheButton.sd_layout.leftSpaceToView(self.quanbuButton,0)
    .topSpaceToView(self.topView,0)
    .widthIs(Gato_Width / 3)
    .bottomSpaceToView(self.topView,0);
    
    self.paixuButton.sd_layout.leftSpaceToView(self.MyHuanzheButton,0)
    .topSpaceToView(self.topView,0)
    .widthIs(Gato_Width / 3)
    .bottomSpaceToView(self.topView,0);
    
    UIView * fgx0 = [[UIView alloc]init];
    fgx0.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx0];
    fgx0.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3)
    .topSpaceToView(self.topView,Gato_Height_548_(8))
    .widthIs(1)
    .heightIs(Gato_Height_548_(27));
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3 * 2)
    .topSpaceToView(self.topView,Gato_Height_548_(8))
    .widthIs(1)
    .heightIs(Gato_Height_548_(27));
    
    UIView * fgx1 = [[UIView alloc]init];
    fgx1.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx1];
    fgx1.sd_layout.leftSpaceToView(self.topView,0)
    .bottomSpaceToView(self.topView,0)
    .widthIs(Gato_Width)
    .heightIs(0.5);
    
    
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
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];

    //导航栏左侧页面九宫格切换
    UIButton*leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"HZLBJGG"] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = FONT(30);
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButton:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

-(void)mobanButton
{
    reloadHttp = YES;
    ModifyArticleViewController * vc = [[ModifyArticleViewController alloc]init];
    vc.type = @"0";
    vc.comeForWhere = @"0";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)searchButton
{
    reloadHttp = YES;
    searchHospitalizedViewController * vc = [[searchHospitalizedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    reloadHttp = NO;
}
//列表九宫格切换
-(void)leftButton:(UIButton*)sender
{
    if ([laoyutStr isEqual:@"1"]) {
        laoyutStr=@"0";
          [sender setBackgroundImage:[UIImage imageNamed:@"HZLBJGG"] forState:UIControlStateNormal];
    }
    else
    {
        laoyutStr=@"1";
          [sender setBackgroundImage:[UIImage imageNamed:@"HZLB"] forState:UIControlStateNormal];
    }
    [self.GatoTableview reloadData];
}

-(void)paixuButton:(UIButton *)sender
{
    Toptype = @"0";
    [self.paixuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(0, Gato_Height_548_(39) + NAV_BAR_HEIGHT, Gato_Width, 40 * 3) selectData:@[@"全部",@"根据床号排序",@"根据入院时间排序"] action:^(NSInteger index) {
        NSLog(@"点击第%ld个排序",index);
        if (index == 1) {
            self.sort = @"bedNumber";
            [self.paixuButton setTitle:@"根据床号排序" forState:UIControlStateNormal];
        }else if(index == 2){
            self.sort = @"bedTime";
            [self.paixuButton setTitle:@"根据入院时间排序" forState:UIControlStateNormal];
        }else{
            self.sort = @"";
            [self.paixuButton setTitle:@"排序" forState:UIControlStateNormal];
        }
        page = 0;
        self.updataArray = [NSMutableArray array];
        [self updateMyTeamWithmypatient:Toptype];
    } animated:YES];
}
-(void)quanbuButtonButton:(UIButton *)sender
{
    Toptype = @"0";
    [self.paixuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    NSMutableArray * nameArray = [NSMutableArray array];
    [nameArray addObject:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount]];
    for (int i = 0 ; i < self.DoctorsArray.count ; i ++) {
        HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
        model = self.DoctorsArray[i];
        [nameArray addObject:model.name];
    }
 
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(0, Gato_Height_548_(39) + NAV_BAR_HEIGHT, Gato_Width,40 * nameArray.count) selectData:nameArray action:^(NSInteger index) {
        NSLog(@"点击第%ld个小组",index);
        if (index == 0)
        {
            self.doctorId = @"";
            [self.quanbuButton setTitle:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount] forState:UIControlStateNormal];
        }
        else
        {
            HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
            model = self.DoctorsArray[index - 1];
            self.doctorId = model.doctorId;
            [self.quanbuButton setTitle:model.name forState:UIControlStateNormal];
        }
        self.updataArray = [NSMutableArray array];
        page = 0;
        [self updateMyTeamWithmypatient:Toptype];
    } animated:YES];
}
- (void)myHuanZheButtonButton:(UIButton *)sender
{
    Toptype = @"1";
    [self.paixuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.updataArray = [NSMutableArray array];
    page = 0;
    [self updateMyTeamWithmypatient:Toptype];
}
/**
 
tableView 代理方法
 
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    判断是否是九宫格弹出view
    if (tableView==_pushTableView)
    {
        return 3;
    }
    else
    {
    if ([laoyutStr isEqual:@"1"])
    {
        if (self.updataArray.count<3) {
            return 1;
        }
        else
        {
        int num=(int)self.updataArray.count/3;
        if (num%3>0)
        {
            return num+1;
        }
        else
        {
             return num;
        }
    }
    }
    else
    {
        return self.updataArray.count;
    }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    if(tableView==_pushTableView)
    {
        if (indexPath.row==1) {
            pushTableViewCell * cell = [pushTableViewCell cellWithTableView:tableView];
            HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
            if (indexPath.row > self.updataArray.count)
            {
                return nil;
            }
            model = self.updataArray[JGGnum];
            [cell setValueWithModel:model];
            cell.ButtonBlock = ^(NSInteger row)
            {
               [weakSelf.pushTableView removeFromSuperview];
                switch (row)
                {
                    case 0:
                    {
                        //医患沟通
                        //环信ID:@"8001"
                        //聊天类型:EMConversationTypeChat
                        self->reloadHttp = YES;
                        ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:model.patientEasemobId conversationType:EMConversationTypeChat];
                        chatController.model = model;
                        chatController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:chatController animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //出院
                        self->reloadHttp = YES;
                        self.NoSchuyuanId = model.patientCaseId;
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将患者移入随访栏目？" preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            return ;
                        }]];
                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [weakSelf pushTheHospitalizedWithdiagnose:model.diagnose];
                        }]];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                        break;
                    case 2:
                    {
                        //等待病理
                        self->reloadHttp = YES;
                        patientInfoViewController * vc = [[patientInfoViewController alloc]init];
                        vc.comeForWhere = @"0";
                        vc.type = @"1";
                        vc.userId = model.patientCaseId;
                        vc.returnBlock = ^(NSDictionary *dict) {
                            self->reloadHttp = YES;
                            if ([[dict objectForKey:@"delete"] isEqualToString:@"1"]) {
                                if(weakSelf.updataArray.count != 0 && weakSelf.updataArray != nil)
                                {
                                    [weakSelf.updataArray removeObjectAtIndex:indexPath.row];
                                }
                                [weakSelf.GatoTableview reloadData];
                            }else{
                                model.bedNumber = [dict objectForKey:@"bedNumber"];
                                model.caseNo = [dict objectForKey:@"caseNo"];
                                [weakSelf.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
                                [weakSelf.GatoTableview reloadData];
                            }
                        };
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 4:
                    {
                        [weakSelf.pushTableView removeFromSuperview];
                    }
                        break;
                    default:
                        break;
                }
            };
            cell.pushBlock = ^{
                self->reloadHttp = YES;
//                隐藏pusPushTableView
                [weakSelf.pushTableView removeFromSuperview];
                patientInfoViewController * vc = [[patientInfoViewController alloc]init];
                HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
                model = weakSelf.updataArray[0];
                vc.userId = model.patientCaseId;
                vc.type = @"0";
                vc.comeForWhere = @"0";
                vc.returnBlock = ^(NSDictionary *dict)
                {
                    self->reloadHttp = YES;
                    if ([[dict objectForKey:@"delete"] isEqualToString:@"1"]) {
                        [weakSelf.updataArray removeObjectAtIndex:indexPath.row];
                        [weakSelf.GatoTableview reloadData];
                    }else{
                        model.bedNumber = [dict objectForKey:@"bedNumber"];
                        model.caseNo = [dict objectForKey:@"caseNo"];
                        [weakSelf.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
                        [weakSelf.GatoTableview reloadData];
                    }
                };
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            };
            cell.MyPatientBlock = ^{
                [weakSelf setValueWithMinePatientWithpatientCaseId:model.patientCaseId];
            };
            return cell;
        }
        else
        {
            pusNnllTableViewCell * cell = [pusNnllTableViewCell cellWithTableView:tableView];

            return cell;
        }
    
    }
    else
    {
    if ([laoyutStr isEqual:@"1"])
    {
        JGGHospitalizedPatientsCellTableViewCell* JGGcell=[JGGHospitalizedPatientsCellTableViewCell cellWithTableView:tableView];
        [JGGcell setValueWithArray:self.updataArray andIndex:indexPath];
        JGGcell.tapPush = ^(NSInteger row)
        {
            NSLog(@"%ld",(long)row);
//            九宫格弹出view
            [self pusView:row];
        };
        return JGGcell;
    }
    else
    {
      if (self.updataArray.count == 0 || self.updataArray.count < indexPath.row)
      {
            Gato_tableviewcell_new
      }
      if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]])
      {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.updataArray[0];
        [cell setValueWithModel:model];
        return cell;
      }else
      {
        HospitalizedPatientsTableViewCell * cell = [HospitalizedPatientsTableViewCell cellWithTableView:tableView];
        HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
        if (indexPath.row > self.updataArray.count)
        {
            return nil;
        }
        model = self.updataArray[indexPath.row];
        cell.ButtonBlock = ^(NSInteger row){
            switch (row)
            {
                case 0:
                {
                    //医患沟通
                    //环信ID:@"8001"
                    //聊天类型:EMConversationTypeChat
                    self->reloadHttp = YES;
                    ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:model.patientEasemobId conversationType:EMConversationTypeChat];
                    chatController.model = model;
                    chatController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:chatController animated:YES];
                }
                    break;
                case 1:
                {
                    //出院
                    self->reloadHttp = YES;
                    self.NoSchuyuanId = model.patientCaseId;
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将患者移入随访栏目？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        return ;
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf pushTheHospitalizedWithdiagnose:model.diagnose];
                    }]];
                    [self presentViewController:alertController animated:YES completion:nil];

                }
                    break;
                case 2:
                {
                    //等待病理
                    self->reloadHttp = YES;
                    patientInfoViewController * vc = [[patientInfoViewController alloc]init];
                    vc.comeForWhere = @"0";
                    vc.type = @"1";
                    vc.userId = model.patientCaseId;
                    vc.returnBlock = ^(NSDictionary *dict) {
                        self->reloadHttp = YES;
                        if ([[dict objectForKey:@"delete"] isEqualToString:@"1"]) {
                            if(weakSelf.updataArray.count != 0 && weakSelf.updataArray != nil)
                            {
                                [weakSelf.updataArray removeObjectAtIndex:indexPath.row];
                            }
                            [weakSelf.GatoTableview reloadData];
                        }else{
                            model.bedNumber = [dict objectForKey:@"bedNumber"];
                            model.caseNo = [dict objectForKey:@"caseNo"];
                            [weakSelf.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
                            [weakSelf.GatoTableview reloadData];
                        }
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        };
        cell.pushBlock = ^{
            self->reloadHttp = YES;
            patientInfoViewController * vc = [[patientInfoViewController alloc]init];
            HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
            model = weakSelf.updataArray[indexPath.row];
            vc.userId = model.patientCaseId;
            vc.type = @"0";
            vc.comeForWhere = @"0";
            vc.returnBlock = ^(NSDictionary *dict) {
                self->reloadHttp = YES;
                if ([[dict objectForKey:@"delete"] isEqualToString:@"1"]) {
                    [weakSelf.updataArray removeObjectAtIndex:indexPath.row];
                    [weakSelf.GatoTableview reloadData];
                }else{
                    model.bedNumber = [dict objectForKey:@"bedNumber"];
                    model.caseNo = [dict objectForKey:@"caseNo"];
                    [weakSelf.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
                    [weakSelf.GatoTableview reloadData];
                }
            };
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.MyPatientBlock = ^{
            [weakSelf setValueWithMinePatientWithpatientCaseId:model.patientCaseId];
        };
        [cell setValueWithModel:model];
       
        return cell;
    }
    }
  }
}
// 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//   弹出tabberView
    if (tableView==_pushTableView)
    {
        if (indexPath.row==1) {
            return Gato_Height_548_(200);
        }
        else if(indexPath.row==0)
        {
            return Gato_Height_548_(170);
        }
        else
        {
            return Gato_Height_548_(500);
        }
    }
    else
    {
        if ([laoyutStr isEqual:@"1"])
        {
          return Gato_Height_548_(115);;
        }
        else
        {
        if (self.updataArray.count == 0 || self.updataArray.count < indexPath.row) {
            return 0;
        }
        if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]])
        {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
        }
        else
        {
        if (self.GatoTableview.contentOffset.y > self.updataArray.count * Gato_Height_548_(170))
        {
            self.GatoTableview.contentOffset = CGPointMake(0, self.updataArray.count * Gato_Height_548_(170));
        }
        return Gato_Height_548_(170);
    }
    }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.updataArray.count == 0) {
        return NO;
    }
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return NO;
    }else{
        return YES;
    }
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
        if (tableView==_pushTableView) {
             model = self.updataArray[JGGnum];
        }
        else
        {
             model = self.updataArray[indexPath.row];
        }
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该患者？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deletePatientWithpatientCaseId:model.patientCaseId];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除\n患者";
}

/**
 
 tableView  代理方法结束
 
 
 */
#pragma mark - 标记成我的患者
- (void)setValueWithMinePatientWithpatientCaseId:(NSString *)patientCaseId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:patientCaseId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_patient_Mine params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            for (int i = 0 ; i < self.updataArray.count ; i ++) {
                HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
                model = self.updataArray[i];
                if ([model.patientCaseId isEqualToString:patientCaseId]) {
                    if ([model.ismine isEqualToString:@"0"]) {
                        self.minecount = [NSString stringWithFormat:@"%ld",[self.minecount integerValue] + 1];
                        model.ismine = @"1";
                    }else{
                        self.minecount = [NSString stringWithFormat:@"%ld",[self.minecount integerValue] - 1];
                        model.ismine = @"0";
                    }
                    [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(%@)",self.minecount] forState:UIControlStateNormal];
                    [self.updataArray replaceObjectAtIndex:i withObject:model];
                    [self.GatoTableview reloadData];
                    [self.pushTableView reloadData];
                }
            }
        }else
        {
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
//        [self.GatoTableview.mj_header endRefreshing];
//        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
#pragma mark - 未手术出院使用
-(void)pushTheHospitalizedWithdiagnose:(NSString *)diagnose
{
    diagnose = [NSString stringWithFormat:@"%@未手术",diagnose];
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.NoSchuyuanId forKey:@"patientCaseId"];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:diagnose forKey:@"lDiagnose"];
    
    [IWHttpTool postWithURL:HD_NoSurgery_Out params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            for (int i = 0 ; i < self.updataArray.count ; i ++) {
                HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
                model = self.updataArray[i];
                if ([model.patientCaseId isEqualToString:self.NoSchuyuanId]) {
                    [self.updataArray removeObjectAtIndex:i];
                    [self.GatoTableview reloadData];
                    [self updateTopTitle:self->Toptype];
                }
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
//        [self.GatoTableview.mj_header endRefreshing];
//        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)hidePushTableView
{
    _pushTableView.hidden=YES;
}
//九宫格view弹出
-(void)pusView:(NSInteger)row
{
    JGGnum=row;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    _pushTableView=[[UITableView alloc]initWithFrame:win.frame style:UITableViewStylePlain];
    _pushTableView.delegate = self;
    _pushTableView.dataSource = self;
    _pushTableView.showsVerticalScrollIndicator = NO;
    _pushTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _pushTableView.tableFooterView = [[UIView alloc] init];
    _pushTableView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    _pushTableView.scrollEnabled = NO;
    [win addSubview:_pushTableView];
    [_pushTableView reloadData];
    
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
-(UIButton *)paixuButton
{
    if (!_paixuButton) {
        _paixuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paixuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _paixuButton.titleLabel.font = FONT(28);
        [_paixuButton setTitle:@"排序" forState:UIControlStateNormal];
        [_paixuButton addTarget:self action:@selector(paixuButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_paixuButton];
        
    }
    return _paixuButton;
}
-(UIButton *)quanbuButton
{
    if (!_quanbuButton) {
        _quanbuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _quanbuButton.titleLabel.font = FONT(28);
        [_quanbuButton setTitle:@"全部" forState:UIControlStateNormal];
        [_quanbuButton addTarget:self action:@selector(quanbuButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_quanbuButton];
        
    }
    return _quanbuButton;
}
- (UIButton *)MyHuanzheButton
{
    if (!_MyHuanzheButton) {
        _MyHuanzheButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _MyHuanzheButton.titleLabel.font = FONT(28);
        [_MyHuanzheButton setTitle:@"我的患者" forState:UIControlStateNormal];
        [_MyHuanzheButton addTarget:self action:@selector(myHuanZheButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_MyHuanzheButton];
        
    }
    return _MyHuanzheButton;
}


@end
