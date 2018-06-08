//
//  APPMessageViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "APPMessageViewController.h"
#import "GatoBaseHelp.h"
#import "APPMessageTableViewCell.h"
#import "AppMessageModel.h"
#import "MyTeamViewController.h"
#import "MyTeamAuditViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "WaitingSurgeryViewController.h"
#import "AfterDischargeViewController.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
#import "validationPasswordViewController.h"
#import "PayLoginPasswordViewController.h"

#define kCellTag 1004666
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]
@interface APPMessageViewController ()
{
    NSArray * ceshiArray;
    NSMutableDictionary * cellHeightDic;
    CGFloat page;
}

@end

@implementation APPMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    page = 0;
    self.title = @"站内消息";
    cellHeightDic = [NSMutableDictionary dictionary];
    ceshiArray = @[@"您的入组信息已被审核通过！",
                   @"患者XXX通过您的扫码成功",
                   @"医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！",
                   @"医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！v医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！",
                   @"医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！",
                   @"医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！医生您好！2017年01月的结算完成。您的税后收入 将在1-3工作日内到账，请耐心等待！"];
    self.updataArray = [NSMutableArray array];
    
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,Gato_Height_548_(18))];
    [right2Button setTitle:@"一键阅读" forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(mineOtherButtonItem)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
    self.navigationItem.rightBarButtonItems = @[rightItem2];
    
    
    [self update];
}
-(void)mineOtherButtonItem
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_ZNXX_read_All params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"一键阅读消息成功"];
            self->page = 0;
            self.updataArray = [NSMutableArray array];
            [self update];
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
    [self.updateParms setObject:@"1" forKey:@"type"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_ZNXX params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count;  i++) {
                AppMessageModel * model = [[AppMessageModel alloc]init];
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
                model.label = @"当前您还没有站内消息";
                [self.updataArray addObject:model];
            }
        }
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

    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.updataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        APPMessageTableViewCell * cell = [APPMessageTableViewCell cellWithTableView:tableView];
        AppMessageModel * model = [[AppMessageModel alloc]init];
        model = self.updataArray[indexPath.row];
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
    NSNumber *value = [cellHeightDic objectForKey:kHuShenKey];
    CGFloat height = value.floatValue;
    if (height < 1) {
        height = 1;
    }
    return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return;
    }else{
        AppMessageModel * model = [[AppMessageModel alloc]init];
        model = self.updataArray[indexPath.row];
        [self readOneMessageWithId:model.messageId WithIndexPathRow:indexPath.row];
        if ([model.recordType isEqualToString:@"0"]) {
            MyTeamViewController * vc = [[MyTeamViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.recordType isEqualToString:@"1"]){
            [self.navigationController popToRootViewControllerAnimated:NO];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            MainViewController *tab = (MainViewController *)app.window.rootViewController;
            tab.selectedIndex = 1;
        }else if ([model.recordType isEqualToString:@"2"]){
            if ([self.isSetSafePassword isEqualToString:@"1"]) {
                validationPasswordViewController * vc =[[validationPasswordViewController alloc]init];
                vc.pushType = 1;
//                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"需要设定安全,是否现在设定" success:^{
                    PayLoginPasswordViewController * vc = [[PayLoginPasswordViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } WithVC:self];
            }
        }
//        else if ([model.recordType isEqualToString:@"3"]){
//            WaitingSurgeryViewController * vc = [[WaitingSurgeryViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if ([model.recordType isEqualToString:@"4"]){
//            AfterDischargeViewController * vc = [[AfterDischargeViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        AppMessageModel * model = [[AppMessageModel alloc]init];
        model = self.updataArray[indexPath.row];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该消息？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self removeMessageWithId:model.messageId WithIndexPathRow:indexPath.row];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除\n消息";
}

-(void)removeMessageWithId:(NSString *)messageId WithIndexPathRow:(NSInteger )row
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:messageId forKey:@"messageId"];
    [IWHttpTool postWithURL:HD_ZNXX_Remove params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            [self.updataArray removeObjectAtIndex:row];
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


-(void)readOneMessageWithId:(NSString * )messageId WithIndexPathRow:(NSInteger )row
{
    
    
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:messageId forKey:@"messageId"];
    [IWHttpTool postWithURL:HD_ZNXX_read_One params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            AppMessageModel * model = [[AppMessageModel alloc]init];
            model = self.updataArray[row];
            model.isRead = @"1";
            [self.updataArray replaceObjectAtIndex:row withObject:model];
            [self.GatoTableview reloadData];
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

@end
