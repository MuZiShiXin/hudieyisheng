//
//  addnewteamViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/21.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "addnewteamViewController.h"
#import "GatoBaseHelp.h"
#import "AllTeamInfoTableViewCell.h"
#import "MyTeamVerifyModel.h"
#import "searchTeamViewController.h"
@interface addnewteamViewController ()
{
    CGFloat page;
}
@end

@implementation addnewteamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"加入小组";
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - Gato_Height_548_(47) - NAV_BAR_HEIGHT);\
    [self.view addSubview:self.GatoTableview];
    self.view.backgroundColor = [UIColor whiteColor];
    self.updataArray = [NSMutableArray array];
    [self addUnderButton];
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"nav_seek"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchNewTeam)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    [self updateMyTeam];
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
    [self updateMyTeam];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    page ++;
    [self updateMyTeam];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}

-(void)updateMyTeam
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
//    [dic setObject:TOKEN forKey:@"hospitalDepartment"];
    [IWHttpTool postWithURL:HD_AllTeam params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                
                MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                model.select = @"1";
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


-(void)searchNewTeam
{
    searchTeamViewController * vc = [[searchTeamViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Gato_Height_548_(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(30))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc]init];
    label.font = FONT(30);
    label.textColor = [UIColor HDBlackColor];
    label.text = @"选择小组";
    [view addSubview:label];
    label.sd_layout.leftSpaceToView(view,Gato_Width_320_(17))
    .rightSpaceToView(view,Gato_Width_320_(17))
    .topSpaceToView(view,0)
    .bottomSpaceToView(view,0);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllTeamInfoTableViewCell * cell = [AllTeamInfoTableViewCell cellWithTableView: tableView];
    MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(79);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
        model = self.updataArray[i];
        model.select = @"1";
        [self.updataArray replaceObjectAtIndex:i withObject:model];
    }
    MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
    model = self.updataArray[indexPath.row];
    model.select = @"0";
    [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [self.GatoTableview reloadData];
}



-(void)chutingzhenButton:(UIButton *)sender
{
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        
        MyTeamVerifyModel * model = [[MyTeamVerifyModel alloc]init];
        model = self.updataArray[i];
        if ([model.select isEqualToString:@"0"]) {
            [self addTeamHttpWithModel:model];
            return;
        }
    }
    [self showHint:@"请选择所加入小组"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
-(void)addTeamHttpWithModel:(MyTeamVerifyModel *)model
{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:model.doctorId forKey:@"doctorId"];
    [IWHttpTool postWithURL:HD_AllTeam_add params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"申请成功，等待审批"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if (self.returnUpdateHttp) {
                    self.returnUpdateHttp();
                }
                if (self.navigationController) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    Gato_DismissRootView
                }
            });
            
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)addUnderButton
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    GatoViewBorderRadius( view, 0, 1, [UIColor appAllBackColor]);
    view.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(47));
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"申请加入" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor HDThemeColor]];
    [button addTarget:self action:@selector(chutingzhenButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = FONT(30);
    [view addSubview:button];
    button.sd_layout.leftSpaceToView(view,Gato_Width_320_(65))
    .topSpaceToView(view,Gato_Height_548_(7))
    .rightSpaceToView(view,Gato_Width_320_(65))
    .bottomSpaceToView(view,Gato_Height_548_(7));
    
    GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
}

@end
