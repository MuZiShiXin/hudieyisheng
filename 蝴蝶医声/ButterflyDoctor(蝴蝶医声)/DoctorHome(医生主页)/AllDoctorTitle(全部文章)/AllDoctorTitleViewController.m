//
//  AllDoctorTitleViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllDoctorTitleViewController.h"
#import "GatoBaseHelp.h"
#import "TheArticleTableViewCell.h"
#import "TheArticleModel.h"
#import "WebArticleViewController.h"

#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"

#define kCellTag 10042333
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]
@interface AllDoctorTitleViewController ()
{
    CGFloat page;
    NSMutableDictionary * cellHeightDic;
}
@end

@implementation AllDoctorTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"全部文章";
    Gato_TableView
    page = 0;
    
    self.updataArray = [NSMutableArray array];
//    for (int i =0 ; i < 10; i ++) {
//        TheArticleModel * model = [[TheArticleModel alloc]init];
//        model.type = [NSString stringWithFormat:@"我是type%d",i];
//        model.title = @"我是标题，心脑血管着应该这样管理自己！不要让你的身体在失控！";
//        model.time = @"2017.2.23发表";
//        model.yinyong = @"199引用";
//        model.yuedu = @"1312阅读";
//        model.zhiding = @"0";
//        [self.updataArray addObject:model];
//    }
    
    [self update];
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
    [self update];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    page ++;
    [self update];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}

-(void)update
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.doctorId forKey:@"doctorId"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_Doctor_home_articles params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            //            [self.model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                TheArticleModel * model = [[TheArticleModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            if (self.updataArray.count > 0) {
                if (![self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
                    [self showHint:falseMessage];
                }
            }else{
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"当前该医生还没有发布过文章";
                [self.updataArray addObject:model];
            }
//            NSString * falseMessage = [dic objectForKey:@"message"];
//            NulllabelModel * model = [[NulllabelModel alloc]init];
//            model.label = @"当前该医生还没有发布过文章";
//            [self.updataArray addObject:model];
        }
        [self.GatoTableview.mj_header endRefreshing];
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
    return self.updataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.updataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        TheArticleTableViewCell * cell = [TheArticleTableViewCell cellWithTableView:tableView];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.updataArray[indexPath.row ];
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
        NSNumber *value = [cellHeightDic objectForKey:kHuShenKey];
        CGFloat height = value.floatValue;
        if (height < 1) {
            height = 1;
        }
        return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.updataArray.count < 1) {
        return;
    }
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        
    }else{
        WebArticleViewController * vc = [[WebArticleViewController alloc]init];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.updataArray[indexPath.row];
        vc.articleId = model.articleId;
        vc.isOwner = model.isOwner;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
