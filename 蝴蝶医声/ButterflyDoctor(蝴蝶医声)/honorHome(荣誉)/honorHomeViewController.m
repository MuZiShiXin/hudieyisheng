//
//  honorHomeViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "honorHomeViewController.h"
#import "GatoBaseHelp.h"
#import "HomeLBTTableViewCell.h"
#import "rankingButtonTableViewCell.h"
#import "HomeDoctorTableViewCell.h"
#import "DoctorHomeViewController.h"
#import "HonorHomeModel.h"
#import "HomeWebViewController.h"
#import "UITabBar+bedge.h"
#import "MineHomeModel.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
@interface honorHomeViewController ()
{
    CGFloat page;
}
@property (nonatomic ,strong) NSString * rankingStr;
@property (nonatomic ,strong) NSMutableArray * bannerArray;
@end

@implementation honorHomeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self mineMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蝴蝶医声";
    self.tabBarItem.title = [NSString stringWithFormat:@"荣誉"];
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT );\
    [self.view addSubview:self.GatoTableview];
    self.bannerArray = [NSMutableArray array];
    self.rankingStr = @"1";
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self update];
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    [self updateBanner];
    
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
-(void)updateBanner
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:@"2" forKey:@"location"];
    [IWHttpTool postWithURL:HD_Home_Banner params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                HomeLBTModel *model = [[HomeLBTModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.bannerArray addObject:model];
            }
            [self.GatoTableview reloadData];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } ];
    
}

//刷新
-(void)loadNewTopic
{
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self update];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    page ++;
    [self update];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}

-(void)update
{
 

    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:[self rankingStrWithType:self.rankingStr] forKey:@"type"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_HonorHome params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            //            [self.model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                HonorHomeModel * model = [[HonorHomeModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
            if (self.updataArray.count < 1) {
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"荣誉功能尚未开启,敬请期待";
                [self.updataArray addObject:model];
            }
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

-(NSString *)rankingStrWithType:(NSString *)rankingStr
{
    if ([rankingStr isEqualToString:@"1"]) {
        return @"week";
    }else if ([rankingStr isEqualToString:@"2"]){
        return @"month";
    }else if ([rankingStr isEqualToString:@"3"]){
        return @"year";
    }else{
        return @"";
    }
}
- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0) {
            HomeLBTTableViewCell * cell = [HomeLBTTableViewCell cellWithTableView:tableView];
            [cell setValueWithModel:self.bannerArray WithHeight:Gato_Height_548_(74)];
            cell.imageBlock = ^(HomeLBTModel *model) {
                HomeWebViewController * vc = [[HomeWebViewController alloc]init];
                NSString * url = @"https://www.baidu.com";
                if (model.linkurl.length > 0) {
                    url = model.linkurl;
                }else{
                    return ;
                }
                vc.pushUrl = url;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }else if (indexPath.row == 1){
            rankingButtonTableViewCell * cell = [rankingButtonTableViewCell cellWithTableView:tableView];
            [cell setValueWithRank:self.rankingStr];
            cell.rankingBlcok = ^(NSInteger row){
                if (row == 1) {
                    //周
                    self.rankingStr = @"1";
                }else if (row == 2){
                    //月
                    self.rankingStr = @"2";
                }else{
                    //年
                    self.rankingStr = @"3";
                }
                self.updataArray = [NSMutableArray array];
                [self update];
            };
            return cell;
        }else{
            if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
                NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model = self.updataArray[0];
                [cell setValueWithModel:model];
                return cell;
            }else{
                HomeDoctorTableViewCell * cell = [HomeDoctorTableViewCell cellWithTableView:tableView];
                HonorHomeModel * model = [[HonorHomeModel alloc]init];
                model = self.updataArray[indexPath.row - 2];
                [cell setValueWithModel:model WithTitle:indexPath.row - 2];
                return cell;
            }
        }
    
    Gato_tableviewcell_new
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return Gato_Height_548_(74);
    }else if (indexPath.row == 1){
        return Gato_Height_548_(34);
    }else{
        if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
            return Gato_Height - Gato_Height_548_(34) - Gato_Height_548_(74) - NAV_BAR_HEIGHT- Tab_BAr_Height;
        }else{
            return [HomeDoctorTableViewCell getHetigh];
        }
    }
    return 0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > 1) {
        if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
            
        }else{
            DoctorHomeViewController * vc = [[DoctorHomeViewController alloc]init];
            HonorHomeModel * model = [[HonorHomeModel alloc]init];
            model = self.updataArray[indexPath.row - 2];
            vc.doctorId = model.doctorId;
            vc.paimingNumber = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
            vc.paiming = self.rankingStr;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

@end
