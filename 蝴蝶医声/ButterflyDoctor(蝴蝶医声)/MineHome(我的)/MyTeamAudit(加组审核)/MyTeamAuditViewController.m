//
//  MyTeamAuditViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/6.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyTeamAuditViewController.h"
#import "GatoBaseHelp.h"
#import "MyTeamAuditTableViewCell.h"
#import "MyTeamAuditPleaseModel.h"
@interface MyTeamAuditViewController ()
{
     CGFloat page;
}
@end

@implementation MyTeamAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    self.title = @"申请成员";
    self.updataArray = [NSMutableArray array];
    [self update];
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    
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
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_Mine_AddTeamPlease params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
//            [self.model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                MyTeamAuditPleaseModel * model = [[MyTeamAuditPleaseModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
//        MyTeamAuditPleaseModel * model = [[MyTeamAuditPleaseModel alloc]init];
//        model.doctorId = @"11";//医生ID
//        model.photo = @"11";//头像
//        model.name = @"mingzi";//姓名
//        model.work = @"职位";//职位
//        model.time = @"2017-06-22";//申请时间
//        model.isTeam = @"1";//是否是组长
//        [self.updataArray addObject:model];
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    MyTeamAuditTableViewCell * cell = [MyTeamAuditTableViewCell cellWithTableView:tableView];
    MyTeamAuditPleaseModel * model = [[MyTeamAuditPleaseModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    GatoViewBorderRadius(cell, 0, 1, [UIColor appAllBackColor]);
    cell.tongyiBlock = ^(){
        NSLog(@" 同意 %s",__FUNCTION__);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定同意该医生的加组申请？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf replyPleaseWithModel:model Withallow:@"1"];
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        
    };
    cell.bohuiBlock = ^(){
        NSLog(@" 驳回 %s",__FUNCTION__);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定驳回该医生的加组申请？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf replyPleaseWithModel:model Withallow:@"0"];
        }]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    };
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(90);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
}

//是否允许 0：不允许 1：允许
-(void)replyPleaseWithModel:(MyTeamAuditPleaseModel *)model Withallow:(NSString *)allow
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:model.doctorId forKey:@"doctorId"];
    [self.updateParms setObject:allow forKey:@"allow"];
    [IWHttpTool postWithURL:HD_Mine_AddTeamPlease_reply params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.updataArray = [NSMutableArray array];
            [self update];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
