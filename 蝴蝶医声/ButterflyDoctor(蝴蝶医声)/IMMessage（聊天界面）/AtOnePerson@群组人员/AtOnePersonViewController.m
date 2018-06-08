//
//  AtOnePersonViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/12.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "AtOnePersonViewController.h"
#import "TeamImageModel.h"
#import "GatoBaseHelp.h"
#import "AtOnePersonTableViewCell.h"
#import "MyTeamMemberModel.h"
@interface AtOnePersonViewController ()
{
    UIView * topView;
}
@property (nonatomic ,strong) NSMutableArray * atArray;
@end

@implementation AtOnePersonViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor HDThemeColor];
    //    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    //    [win addSubview:topView];
    [self.navigationController.view addSubview:topView];
    topView.frame = CGRectMake(0, 0, Gato_Width, 20);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [topView removeFromSuperview];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    self.title = @"选择提醒的人";
    self.atArray = [NSMutableArray array];
    for (int i = 0 ; i < self.teamInfoArray.count ; i ++) {
        MyTeamMemberModel * model = [[MyTeamMemberModel alloc]init];
        model = self.teamInfoArray[i];
        if (![model.phone isEqualToString:GATO_PHOTO]) {
            [self.atArray addObject:model];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.atArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AtOnePersonTableViewCell * cell = [AtOnePersonTableViewCell cellWithTableView:tableView];
    [cell setValueWithModel:self.atArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Gato_Height_548_(55);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ATInfoBlock) {
        self.ATInfoBlock(self.atArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
