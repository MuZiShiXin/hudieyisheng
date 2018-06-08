//
//  releaseStopWorkViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "releaseStopWorkViewController.h"
#import "GatoBaseHelp.h"
#import "TitleButtonView.h"
#import "releaseStopWorkTableViewCell.h"
#import "releaseWorkTableViewCell.h"
#import "AddStopMessageViewController.h"
#import "AddWorkMessageViewController.h"
#import "WorkAddressViewController.h"
#import "releaseStopModel.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"

#define kCellTag 10042333
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

@interface releaseStopWorkViewController ()<TitleButtonViewDelegate>
{
    NSInteger nowType;
    CGFloat page;
    NSMutableDictionary * cellHeightDic;
}
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *dataArray;
@property (nonatomic, strong) NSMutableArray *currentDataArray;
@property (nonatomic, strong) NSMutableArray *pageArray;//记录当前页面page
@property (nonatomic, strong) NSMutableArray *TypetitleArray;//已经点击过按钮  首次点击加载信息

@property (nonatomic, strong) NSString * urlStr;
@property (nonatomic, strong) UIButton * underButton;
@end

@implementation releaseStopWorkViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.JPushType)
    {
    [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
    [self.dataArray[nowType] removeAllObjects];
    [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    page = 0;
    nowType = 0;
    cellHeightDic = [NSMutableDictionary dictionary];
    self.urlStr = HD_Home_notice;
    Gato_Return
    self.title = @"出/停诊信息";
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,40)];
    [rightButton setTitle:@"执业地点" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(zhiyedidian)forControlEvents:UIControlEventTouchUpInside];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
//    创建数组
    [self initDatas];
    Gato_TableView
    self.GatoTableview.y = Gato_Height_548_(39);

    self.GatoTableview.height = Gato_Height - Gato_Height_548_(39) - Gato_Height_548_(47) - NAV_BAR_HEIGHT;

    TitleButtonView *headerView = [[TitleButtonView alloc]init];;
    [headerView setTitleWithArray:@[@"停诊公告",@"门诊时间"]];
    headerView.frame = CGRectMake(0, 0 , Gato_Width, Gato_Height_548_(39));
    headerView.delegate = self;
    [self.view addSubview:headerView];
    
//    [self headerBtnClicked:0];
//    创建底部an niu
    [self addUnderButton];
    
//    [self updateWithType:@"0"];
    [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    
    
    if (self.JPushType) {
        if ([self.JPushType isEqualToString:@"0"]) {
            [self.dataArray[0] removeAllObjects];
            [self headerBtnClicked:0];
        }else{
            [self.dataArray[1] removeAllObjects];
            [self headerBtnClicked:1];
            [headerView buttonType:1];
        }
    }
}
//刷新
-(void)loadNewTopic
{
    [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
    [self.dataArray[nowType] removeAllObjects];
    [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    
    NSString * pagestr = self.pageArray[nowType];
    pagestr = [NSString stringWithFormat:@"%.0f",[pagestr floatValue] + 1];
    [self.pageArray replaceObjectAtIndex:nowType withObject:pagestr];
    [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}

#pragma mark 网络请求
-(void)updateWithType:(NSString * )type
{
    
    if ([type isEqualToString:@"0"]) {
        self.urlStr = HD_Home_notice;
    }else{
        self.urlStr = HD_Home_MZ_ALL;
    }
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.pageArray[nowType] forKey:@"page"];
    [IWHttpTool postWithURL:self.urlStr params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        NSLog(@"%@",dic);
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                releaseStopModel * model = [[releaseStopModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                NSInteger typeFloat = [type integerValue];
                [self.dataArray[typeFloat] addObject:model];
            }
           
            if (_dataArray.count > nowType) {

                _currentDataArray = _dataArray[nowType];
            }
        }
        else
        {
            NSString * falseMessage = [dic objectForKey:@"message"];
            NSInteger typeFloat = [type integerValue];
            if (self.dataArray[typeFloat].count > 0)
            {
                if (![self.dataArray[typeFloat][0] isKindOfClass:[NulllabelModel class]]) {
                    [self showHint:falseMessage];
                }
            }
            else
            {
                NulllabelModel * model = [[NulllabelModel alloc]init];
                if (typeFloat == 0) {
                    model.label = @"您还没有发布过停诊";
                }else{
                    model.label = @"您还没有发布过出诊";
                }
                
                [_currentDataArray addObject:model];
            }
        }
        
        
        
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}



-(void)chutingzhenButton:(UIButton *)sender
{
    if (nowType == 0) {
        NSLog(@"发布停诊");
        AddStopMessageViewController * vc = [[AddStopMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSLog(@"发布门诊");
        AddWorkMessageViewController * vc = [[AddWorkMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)zhiyedidian
{
    NSLog(@"执业地点");
    WorkAddressViewController * vc = [[WorkAddressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.currentDataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        if (nowType == 0) {
            //停诊
            releaseStopWorkTableViewCell * cell = [releaseStopWorkTableViewCell cellWithTableView:tableView];
            releaseStopModel * model = [[releaseStopModel alloc]init];
            model = self.currentDataArray[indexPath.row];
            [cell setValueWithModel:model];
            cell.StopBianjiBlock = ^(){
                AddStopMessageViewController * vc = [[AddStopMessageViewController alloc]init];
                vc.model = model;
                vc.Modify = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
            [cellHeightDic setValue:value forKey:kHuShenKey];
            return cell;
        }else{
            //门诊
            releaseWorkTableViewCell * cell = [releaseWorkTableViewCell cellWithTableView:tableView];
            releaseStopModel * model = [[releaseStopModel alloc]init];
            model = self.currentDataArray[indexPath.row];
            [cell setValueWithModel:model];
            cell.workBianjiBlock = ^(){
                AddWorkMessageViewController * vc = [[AddWorkMessageViewController alloc]init];
                vc.model = model;
                vc.Modify = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };

            return cell;
    }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
        if (nowType == 0){
            NSNumber *value = [cellHeightDic objectForKey:kHuShenKey];
            CGFloat height = value.floatValue;
            if (height < Gato_Height_548_(140)) {
                height = Gato_Height_548_(140);
            }
            return height;
        }else{
            return [releaseWorkTableViewCell getHeight];
        }
    }
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark init data
- (void)initDatas {
    
    _dataArray = [NSMutableArray array];
    _pageArray = [NSMutableArray array];
    _currentDataArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        NSMutableArray *data = [NSMutableArray array];
        [_dataArray addObject:data];
        [_pageArray addObject:@"0"];
    }
    if (_dataArray.count > 0)
    {
        _currentDataArray = _dataArray[0];
    }
    [self.GatoTableview reloadData];
}
#pragma headerView delegate
- (void)headerBtnClicked:(ENUM_BTN_TYPE)type {
    nowType = type;
    if (_dataArray.count > type) {
        _currentDataArray = _dataArray[type];
    }
    
    
    if (self.pageArray.count > nowType) {
//        if ([self.pageArray[nowType] isEqualToString:@"0"]) {
//            for (int i = 0 ; i < self.TypetitleArray.count; i ++) {
//                NSString * typestr = [NSString stringWithFormat:@"%ld",nowType];
//                if ([typestr isEqualToString:self.TypetitleArray[i]]) {
//                    [self.GatoTableview reloadData];
//                    return;
//                }
//            }
//            [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
//            [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];//网络请求
//        }
        cellHeightDic = [NSMutableDictionary dictionary];
        NSMutableArray *data = [NSMutableArray array];
        [_dataArray replaceObjectAtIndex:nowType withObject:data];
        [self.dataArray[nowType] removeAllObjects];
        [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
        [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
        [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];//网络请求
    }
    [self.GatoTableview reloadData];
    if (type == 0) {
        [self.underButton setTitle:@"发布新的停诊" forState:UIControlStateNormal];
    }else{
        [self.underButton setTitle:@"发布新的门诊" forState:UIControlStateNormal];
    }
    
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
    
    
    self.underButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.underButton setTitle:@"发布新的停诊" forState:UIControlStateNormal];
    [self.underButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.underButton setBackgroundColor:[UIColor HDThemeColor]];
    [self.underButton addTarget:self action:@selector(chutingzhenButton:) forControlEvents:UIControlEventTouchUpInside];
    self.underButton.titleLabel.font = FONT(30);
    [view addSubview:self.underButton];
    self.underButton.sd_layout.leftSpaceToView(view,Gato_Width_320_(65))
    .topSpaceToView(view,Gato_Height_548_(7))
    .rightSpaceToView(view,Gato_Width_320_(65))
    .bottomSpaceToView(view,Gato_Height_548_(7));
    
    GatoViewBorderRadius(self.underButton, 5, 0, [UIColor redColor]);
}

-(NSMutableArray *)TypetitleArray
{
    if (!_TypetitleArray) {
        _TypetitleArray = [NSMutableArray array];
    }
    return _TypetitleArray;
}
@end
