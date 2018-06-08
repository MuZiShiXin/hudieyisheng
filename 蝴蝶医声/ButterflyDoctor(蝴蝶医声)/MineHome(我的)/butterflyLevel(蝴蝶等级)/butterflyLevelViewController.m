//
//  butterflyLevelViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "butterflyLevelViewController.h"
#import "GatoBaseHelp.h"
#import "butterflyLevelTableViewCell.h"

@interface butterflyLevelViewController ()
@property (nonatomic ,strong) NSString * butterflyLevelStr;
@end

@implementation butterflyLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    self.title = @"我的蝴蝶等级";
    [self update];
}
-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_Level params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.butterflyLevelStr = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"goldCount"];
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        butterflyLevelTableViewCell * cell = [butterflyLevelTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:self.butterflyLevelStr];
        return cell;
    }
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return Gato_Height_548_(548);
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
