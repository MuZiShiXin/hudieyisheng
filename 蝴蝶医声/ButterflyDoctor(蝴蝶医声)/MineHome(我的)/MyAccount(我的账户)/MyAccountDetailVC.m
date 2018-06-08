//
//  MyAccountDetailVC.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailVC.h"
#import "GatoBaseHelp.h"
#import "MyAccountDetailHeaderView.h"
#import "MyAccountDetailInfoCell.h"
#import "MyAccountDetailContactCell.h"
#import "MineBankCardViewController.h"
#import "MyAccountDetailModel.h"
@interface MyAccountDetailVC () <UITableViewDelegate>

@property (nonatomic ,strong) NSString * accountReceipts;//收入账户待汇款
@property (nonatomic ,strong) NSString * accountAllRemit;//累计已汇款
@property (nonatomic ,strong) NSMutableArray * timeArray;
@end

@implementation MyAccountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.pushType == 1) {
        GatoReturnButton *returnButton = [[GatoReturnButton alloc] initWithTarget:self IsAccoedingBar:YES WithRootViewControllers:1];\
        self.navigationItem.leftBarButtonItem = returnButton;
    }else{
        Gato_Return
    };
    self.title = @"提现明细";
    self.GatoTableview.height = Gato_Height - NAV_BAR_HEIGHT;
    self.cells = @[
                   [MyAccountDetailInfoCell    getCellID],
                   [MyAccountDetailContactCell getCellID],
                   ];
    
    [self registCells];
    self.timeArray = [NSMutableArray array];
    self.updataArray = [NSMutableArray array];
    [self.view addSubview:self.GatoTableview];
    [self updata];
}
-(void)updata
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_Account_cash params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.accountReceipts = [[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"accountData"] objectForKey:@"accountReceipts"];
            self.accountAllRemit = [[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"accountData"] objectForKey:@"accountAllRemit"];
            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"detailData"];
            for (int i = 0; i < jsonArray.count ; i ++) {
                [self.timeArray addObject:[jsonArray[i] objectForKey:@"time"]];
                NSArray * sonArray = [jsonArray[i] objectForKey:@"son"];
                for (int j = 0 ; j < sonArray.count; j ++) {
                    MyAccountDetailModel * model = [[MyAccountDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:sonArray[j]];
                    [self.updataArray addObject:model];
                }
            }
            [self.GatoTableview reloadData];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.updataArray.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        MyAccountDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailInfoCell getCellID]];
        [cell setValueWithShou:self.accountReceipts WithChu:self.accountAllRemit];
        cell.PushBlock = ^(){
            MineBankCardViewController * vc = [[MineBankCardViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    } else {
        MyAccountDetailContactCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailContactCell getCellID]];
        MyAccountDetailModel * model = [[MyAccountDetailModel alloc]init];
        model = self.updataArray[indexPath.section - 1];
        [cell setValueWithModel:model];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [MyAccountDetailInfoCell getHeightForCell];
    } else {
        return [MyAccountDetailContactCell getHeightForCell];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    } else {
        MyAccountDetailHeaderView *headerView = [MyAccountDetailHeaderView instanceView];
        headerView.text = self.timeArray[section - 1];
        
        UIView * fgx0 = [[UIView alloc]init];
        fgx0.backgroundColor = [UIColor HDViewBackColor];
        [headerView addSubview:fgx0];
        fgx0.sd_layout.leftSpaceToView(headerView,0)
        .rightSpaceToView(headerView,0)
        .topSpaceToView(headerView,0)
        .heightIs(Gato_Height_548_(0.5));
        
        
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor HDViewBackColor];
        [headerView addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(headerView,0)
        .rightSpaceToView(headerView,0)
        .topSpaceToView(headerView,25.5f)
        .heightIs(Gato_Height_548_(0.5));
        return headerView;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    } else {
        return 26.0f;
    }
}

@end
