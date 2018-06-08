//
//  withdrawaInfoViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "withdrawaInfoViewController.h"
#import "GatoBaseHelp.h"
#import "ButterflyMoneyTradingCell.h"
#import "withdrawaInfoModel.h"
#import "WithdrawainfoTableViewCell.h"
@interface withdrawaInfoViewController ()

@end

@implementation withdrawaInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
     self.title = @"提现明细";
    self.cells = @[[ButterflyMoneyTradingCell getCellID]];
    self.updataArray = [NSMutableArray array];
    [self updateBefore];
    [self registCells];
}
-(void)updateBefore
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_withdrawal_Data params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                withdrawaInfoModel * model = [[withdrawaInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WithdrawainfoTableViewCell *cell = [WithdrawainfoTableViewCell cellWithTableView:tableView];
    withdrawaInfoModel * model = [[withdrawaInfoModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(95);
    
}


@end
