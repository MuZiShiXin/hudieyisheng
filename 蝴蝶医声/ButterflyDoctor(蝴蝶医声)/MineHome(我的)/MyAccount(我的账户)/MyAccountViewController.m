//
//  MyAccountViewController.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountViewController.h"
#import "GatoBaseHelp.h"
#import "MyAccountBalanceCell.h"
#import "MyAccountWithdrawalCell.h"
#import "MyAccountDetailTextCell.h"
#import "MyAccountDetailCell.h"
#import "MyAccountDetailVC.h"
@interface MyAccountViewController ()
{
    NSArray * array;
}
@property (nonatomic ,strong) NSString * accountNumber;
@property (nonatomic ,strong) NSMutableArray * timeArray;
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.pushType == 1) {
        GatoReturnButton *returnButton = [[GatoReturnButton alloc] initWithTarget:self IsAccoedingBar:YES WithRootViewControllers:1];\
        self.navigationItem.leftBarButtonItem = returnButton;
    }else{
        Gato_Return
    }
    
    self.title = @"我的账户";
    self.view.backgroundColor = [UIColor appAllBackColor];
    self.GatoTableview.height = Gato_Height - NAV_BAR_HEIGHT;
    self.cells = @[
                   [MyAccountBalanceCell    getCellID],
                   [MyAccountWithdrawalCell getCellID],
                   [MyAccountDetailTextCell getCellID],
                   [MyAccountDetailCell     getCellID]
                   ];
    
    [self registCells];
    self.updataArray = [NSMutableArray array];
    self.timeArray = [NSMutableArray array];
    [self.view addSubview:self.GatoTableview];
    self.accountNumber = @"0";
    [self updata];
}

-(void)updata
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_Account params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            self.accountNumber = [[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"accountData"] objectForKey:@"accountCount"];
            NSArray * detailArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"detailData"];
            for (int i = 0 ; i < detailArray.count; i ++) {
                [self.updataArray addObject:[detailArray[i] objectForKey:@"son"]];
                [self.timeArray addObject:[detailArray[i] objectForKey:@"time"]];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    } else {
        return self.timeArray.count + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                MyAccountBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountBalanceCell getCellID]];
                [cell setValueWithTitle:self.accountNumber];
                return cell;
            } else if (indexPath.row == 1) {
                MyAccountWithdrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountWithdrawalCell getCellID]];
                cell.PushBlock = ^(){
                    MyAccountDetailVC * vc = [[MyAccountDetailVC alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }
        case 1:
            if (indexPath.row == 0) {
                MyAccountDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailTextCell getCellID]];
                return cell;
            } else {
                MyAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailCell getCellID]];
                [cell setValueWithTime:self.timeArray[indexPath.row - 1]];
                [cell setValueWithArray:self.updataArray[indexPath.row - 1]];
                return cell;
            }
            
        default:
            break;
    }
    
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return [MyAccountBalanceCell    getHeightForCell];
            } else if (indexPath.row == 1) {
                return [MyAccountWithdrawalCell getHeightForCell];
            }
        case 1:
            if (indexPath.row == 0) {
                return [MyAccountDetailTextCell getHeightForCell];
            } else {
                return [MyAccountDetailCell getHeightWithArray:self.updataArray[indexPath.row - 1]];
            }

            
        default:
            break;
    }
    return 0.0f;
}

@end
