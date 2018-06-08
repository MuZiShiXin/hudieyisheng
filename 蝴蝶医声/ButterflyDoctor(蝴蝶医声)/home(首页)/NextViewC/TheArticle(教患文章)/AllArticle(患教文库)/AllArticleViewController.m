//
//  AllArticleViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllArticleViewController.h"
#import "GatoBaseHelp.h"
#import "TitleButtonView.h"
#import "AllArticleTitleTableViewCell.h"
#import "WebArticleViewController.h"
#import "AllArticleModel.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
@interface AllArticleViewController ()<TitleButtonViewDelegate,UITextFieldDelegate>
{
    NSInteger nowType;
    CGFloat page;
}
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataArray;
@property (nonatomic, strong) NSMutableArray *currentDataArray;
@property (nonatomic, strong) NSMutableArray *pageArray;//记录当前页面page
@property (nonatomic, strong) NSMutableArray *TypetitleArray;//已经点击过按钮  首次点击加载信息

@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, strong) UITextField * searchTF;
@property (nonatomic, strong) NSString * typeName;
@end

@implementation AllArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    nowType = 0;
    Gato_Return
    self.title = @"患教文库";
    self.typeName = @"hot";
    [self initDatas];
    Gato_TableView
    self.GatoTableview.y = Gato_Height_548_(75);
    self.GatoTableview.height = Gato_Height - Gato_Height_548_(75) - NAV_BAR_HEIGHT;
    
    TitleButtonView *headerView = [[TitleButtonView alloc]init];;
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setTitleWithArray:@[@"热门引用",@"优秀文章",@"最新文章"]];
    headerView.frame = CGRectMake(0, Gato_Height_548_(36), Gato_Width, Gato_Height_548_(39));
    headerView.delegate = self;
    [self.view addSubview:headerView];
    
    self.searchView.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(39));
    
    self.searchTF.sd_layout.leftSpaceToView(self.searchView,Gato_Width_320_(7))
    .topSpaceToView(self.searchView,Gato_Height_548_(6))
    .rightSpaceToView(self.searchView,Gato_Width_320_(7))
    .bottomSpaceToView(self.searchView,Gato_Height_548_(6));

    GatoViewBorderRadius(self.searchTF, 5, 1, [UIColor appAllBackColor]);
    
    [self updateWithType:@"0"];
    [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
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
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:@"1" forKey:self.typeName];
    [self.updateParms setObject:self.searchTF.text forKey:@"search"];
    [self.updateParms setObject:self.pageArray[nowType] forKey:@"page"];
    [IWHttpTool postWithURL:HD_Home_info_Article_All params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            //            [self.model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                AllArticleModel * model = [[AllArticleModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                NSInteger typeFloat = [type integerValue];
                [self.dataArray[typeFloat] addObject:model];
            }
            
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
        }
        if ([_dataArray[nowType] count] < 1) {
            NulllabelModel * model = [[NulllabelModel alloc]init];
            if ([type isEqualToString:@"0"]) {
                model.label = @"当前还没有热门引用";
            }else if ([type isEqualToString:@"1"]){
                model.label = @"当前还没有优秀文章";
            }else if ([type isEqualToString:@"2"]){
                model.label = @"当前还没有最新文章";
            }
            
            [_dataArray[nowType] addObject:model];
        }
        if (_dataArray.count > nowType) {
            _currentDataArray = _dataArray[nowType];
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currentDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentDataArray.count < indexPath.row) {
        Gato_tableviewcell_new
    }
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.currentDataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }
    AllArticleTitleTableViewCell * cell = [AllArticleTitleTableViewCell cellWithTableView:tableView];
    AllArticleModel * model = [[AllArticleModel alloc]init];
    model = self.currentDataArray[indexPath.row];
    [cell setValueWithModel:model WithNowType:nowType];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentDataArray.count < indexPath.row) {
        return 0;
    }
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
        return [AllArticleTitleTableViewCell getHeight];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.currentDataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return ;
    }else{
        WebArticleViewController * vc = [[WebArticleViewController alloc]init];
        AllArticleModel * model = [[AllArticleModel alloc]init];
        model = self.currentDataArray[indexPath.row];
        vc.articleId = model.articleId;
        vc.isOwner = model.isOwner;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark init data
- (void)initDatas {
    
    _dataArray = [NSMutableArray array];
    _pageArray = [NSMutableArray array];
    _currentDataArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *data = [NSMutableArray array];
//        for (int j = 0 ; j < i * 5 + 1; j ++) {
//            [data addObject:@"data"];
//        }
        [_dataArray addObject:data];
        [_pageArray addObject:@"0"];
    }
    if (_dataArray.count > 0) {
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
    if (type == 0) {
        self.typeName = @"hot";
    }else if (type == 1){
        self.typeName = @"excellent";
    }else{
        self.typeName = @"new";
    }
    
    if (self.pageArray.count > nowType) {
        if ([self.pageArray[nowType] isEqualToString:@"0"]) {
            for (int i = 0 ; i < self.TypetitleArray.count; i ++) {
                NSString * typestr = [NSString stringWithFormat:@"%ld",nowType];
                if ([typestr isEqualToString:self.TypetitleArray[i]]) {
                    [self.GatoTableview reloadData];
                    return;
                }
            }
            [self.TypetitleArray addObject:[NSString stringWithFormat:@"%ld",nowType]];
           
            [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];//网络请求
        }
    }
    [self.GatoTableview reloadData];
    
}
#pragma mark - 点击键盘搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self.view endEditing:YES];
        [self.pageArray replaceObjectAtIndex:nowType withObject:@"0"];
        [self.dataArray[nowType] removeAllObjects];
        [self updateWithType:[NSString stringWithFormat:@"%ld",nowType]];//网络请求
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]init];
        _searchTF.textAlignment = NSTextAlignmentCenter;
        _searchTF.placeholder = @"搜索更多患教文章";
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.font= FONT(26);
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        [self.searchView addSubview:_searchTF];
    }
    return _searchTF;
}
-(UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = Gato_(201,200,206);
        [self.view addSubview:_searchView];
    }
    return _searchView;
}
-(NSMutableArray *)TypetitleArray
{
    if (!_TypetitleArray) {
        _TypetitleArray = [NSMutableArray array];
    }
    return _TypetitleArray;
}

@end
