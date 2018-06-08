//
//  GatoBaseViewController.m
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "GatoBaseHelp.h"
@interface GatoBaseViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation GatoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.GatoTableview.backgroundColor = [UIColor appAllBackColor];
    if (@available(iOS 11.0, *)){
        self.GatoTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.GatoTableview.estimatedRowHeight = 0;
        self.GatoTableview.estimatedSectionFooterHeight = 0;
        self.GatoTableview.estimatedSectionHeaderHeight = 0;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.firstBool = YES;
    
    //下拉刷新
//    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
//    //上拉刷新
//    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
//    
    // Do any additional setup after loading the view.
}



-(void)dealloc
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@---", NSStringFromClass(self.class)]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableViewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark 注册cell
- (void)registCells {
    for (NSString *identifier in self.cells) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        [self.GatoTableview registerNib:nib forCellReuseIdentifier:identifier];
    }
}


-(NSMutableArray *)updataArray
{
    if (!_updataArray) {
        _updataArray = [NSMutableArray array];
    }
    return _updataArray;
}

-(NSMutableDictionary * )updateParms
{
    if (!_updateParms) {
        _updateParms = [NSMutableDictionary dictionary];
    }
    return _updateParms;
}

#pragma mark lazyLoad
-(UITableView *)GatoTableview{
    if (!_GatoTableview) {
        _GatoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Gato_Width , Gato_Height  ) style:UITableViewStylePlain];
        _GatoTableview.delegate = self;
        _GatoTableview.dataSource = self;
        
        _GatoTableview.showsVerticalScrollIndicator = NO;
        _GatoTableview.separatorStyle = UITableViewCellSelectionStyleNone;
        _GatoTableview.tableFooterView = [[UIView alloc] init];
    }
    return _GatoTableview;
}

/*
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT - 90 * Gato_Height_1334);
    [self.view addSubview:self.GatoTableview];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 * Gato_Height_1334;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:Gato_CGRectMake(0, 0, 750, 30)];
    view.backgroundColor = Gato_(243, 243, 243);
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
 
*/

@end
