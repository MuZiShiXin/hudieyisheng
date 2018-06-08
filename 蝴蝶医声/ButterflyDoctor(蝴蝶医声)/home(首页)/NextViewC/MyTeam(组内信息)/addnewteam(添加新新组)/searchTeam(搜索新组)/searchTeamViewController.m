//
//  searchTeamViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/24.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "searchTeamViewController.h"
#import "GatoBaseHelp.h"
#import "AllTeamInfoTableViewCell.h"
#import "MyTeamVerifyModel.h"

@interface searchTeamViewController ()<UIActionSheetDelegate,UITextFieldDelegate>
{
    CGFloat page;
    CGFloat iphoneXHeight;
}
@property (nonatomic ,strong) UIView * topView;
@property (nonatomic ,strong) UIView * searchView;
@property (nonatomic ,strong) UITextField * textfield;
@property (nonatomic ,strong) NSMutableArray * DoctorsArray;//筛选组

@end

@implementation searchTeamViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入小组";
    iphoneXHeight = 0.0;
    if ([[GatoMethods getiPhoneType] isEqualToString:@"iPhone X"]) {
        iphoneXHeight = 24;
    }
    self.GatoTableview.frame = CGRectMake(0, 64 + iphoneXHeight, Gato_Width, Gato_Height - 64 - iphoneXHeight - Gato_Height_548_(47));\
    [self.view addSubview:self.GatoTableview];
    self.view.backgroundColor = [UIColor whiteColor];
    self.updataArray = [NSMutableArray array];
    [self addUnderButton];
    
    [self newFrame];
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
-(void)newFrame
{
    self.topView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(64 + iphoneXHeight);
    self.topView.backgroundColor = [UIColor HDThemeColor];
    
    
    self.searchView.sd_layout.leftSpaceToView(self.topView, Gato_Width_320_(15))
    .rightSpaceToView(self.topView, Gato_Width_320_(50))
    .topSpaceToView(self.topView, Gato_Height_548_(25) + iphoneXHeight)
    .heightIs(Gato_Height_548_(25));
    self.searchView.backgroundColor = [UIColor whiteColor];
    
    GatoViewBorderRadius(self.searchView, Gato_Height_548_(12.5), 1, [UIColor appAllBackColor]);
    
    
    self.textfield.sd_layout.leftSpaceToView(self.searchView, Gato_Width_320_(15))
    .rightSpaceToView(self.searchView, Gato_Width_320_(15))
    .topSpaceToView(self.searchView, 0)
    .heightIs(Gato_Height_548_(25));
    
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(30),Gato_Height_548_(18))];
    [right2Button setTitle:@"取消" forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(quxiaoButtonDidClicked)forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:right2Button];
    right2Button.sd_layout.rightSpaceToView(self.topView, Gato_Width_320_(15))
    .centerYEqualToView(self.searchView)
    .widthIs(Gato_Width_320_(30));
    
    
}
-(void)updateMyTeam
{
    if (self.textfield.text.length < 1) {
        [self showHint:@"请输入搜索组名"];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.textfield.text forKey:@"search"];
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


-(void)quxiaoButtonDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return Gato_Height_548_(30);
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(30))];
//    view.backgroundColor = [UIColor whiteColor];
//    UILabel * label = [[UILabel alloc]init];
//    label.font = FONT(30);
//    label.textColor = [UIColor HDBlackColor];
//    label.text = @"选择小组";
//    [view addSubview:label];
//    label.sd_layout.leftSpaceToView(view,Gato_Width_320_(17))
//    .rightSpaceToView(view,Gato_Width_320_(17))
//    .topSpaceToView(view,0)
//    .bottomSpaceToView(view,0);
//    return view;
//}
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
        }else{
            [self showHint:@"请选择所加入小组"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                Gato_DismissRootView
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
#pragma mark  点击搜索按钮-放在键盘上了
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (self.textfield.text.length > 0) {
        [self.view endEditing:YES];
        self.updataArray = [NSMutableArray array];
        [self updateMyTeam];
        [textField resignFirstResponder];
    }
    if (self.textfield.text.length == 0) {
        return NO;
    }
    
    return YES;
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

-(UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:_searchView];
    }
    return _searchView;
}
-(UITextField *)textfield
{
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.delegate = self;
        _textfield.placeholder = @"请输入搜索组名";
        _textfield.font = FONT(26);
        _textfield.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        [self.searchView addSubview:_textfield];
    }
    return _textfield;
}


@end
