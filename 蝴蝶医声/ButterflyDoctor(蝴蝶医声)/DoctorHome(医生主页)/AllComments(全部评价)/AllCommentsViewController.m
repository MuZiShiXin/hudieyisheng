//
//  AllCommentsViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllCommentsViewController.h"
#import "GatoBaseHelp.h"
#import "DoctorHomeCommentsTableViewCell.h"

#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"

#define PLCellTag 4281419111
#define PLHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + PLCellTag]

@interface AllCommentsViewController ()
{
    NSMutableDictionary * PLCellHeight;
    CGFloat page;
}
@property (nonatomic ,strong) UIView * topView;
@property (nonatomic ,strong) UILabel * people;
@property (nonatomic ,strong) UILabel * satisfaction;
@property (nonatomic ,strong) UILabel * level;
@end

@implementation AllCommentsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self newFrame];
    Gato_Return
    self.title = @"全部评论";
    page = 0;
    PLCellHeight = [NSMutableDictionary dictionary];
    self.updataArray = [NSMutableArray array];
    self.GatoTableview.frame = CGRectMake(0, Gato_Height_548_(61), Gato_Width, Gato_Height - Gato_Height_548_(61) - NAV_BAR_HEIGHT);
    [self.view addSubview:self.GatoTableview];
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
    [IWHttpTool postWithURL:HD_Doctor_home_comments params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            //            [self.model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            NSArray * infoArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            if (infoArray.count < 1) {
                return ;
            }
            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"commentBoyData"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                DoctorHomePingjiaModel * model = [[DoctorHomePingjiaModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
            self.people.text = [NSString stringWithFormat:@"评价患者量:%@人",[[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"commentHeadData"] objectForKey:@"patientAllCount"]];
//            self.satisfaction.text = [NSString stringWithFormat:@"满意度:%@",[[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"commentHeadData"] objectForKey:@"satisfied"]];3
//            self.level.text = [NSString stringWithFormat:@"蝴蝶等级:%@",[GatoMethods getButterflyLevelNameWithMonery:[[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"commentHeadData"] objectForKey:@"goldCount"]]];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            if (self.updataArray.count == 0) {
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"当前该医生还没有获得评论";
                [self.updataArray addObject:model];
            }
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)newFrame
{
    self.topView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(61));
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"患者综合评价";
    label.font = FONT(30);
    label.textColor = [UIColor YMAppAllTitleColor];
    [self.topView addSubview:label];
    label.sd_layout.leftSpaceToView(self.topView,Gato_Width_320_(14))
    .topSpaceToView(self.topView,Gato_Height_548_(14))
    .rightSpaceToView(self.topView,0)
    .heightIs(Gato_Height_548_(20));
    
    self.people.sd_layout.leftSpaceToView(self.topView,Gato_Width_320_(14))
    .topSpaceToView(label,Gato_Height_548_(0))
    .rightSpaceToView(self.topView,Gato_Width_320_(14))
    .heightIs(Gato_Height_548_(20));
    
    self.satisfaction.sd_layout.leftSpaceToView(self.topView,Gato_Width_320_(14))
    .topSpaceToView(label,Gato_Height_548_(0))
    .rightSpaceToView(self.topView,Gato_Width_320_(14))
    .heightIs(Gato_Height_548_(20));
    
    self.level.sd_layout.leftSpaceToView(self.topView,Gato_Width_320_(14))
    .topSpaceToView(label,Gato_Height_548_(0))
    .rightSpaceToView(self.topView,Gato_Width_320_(14))
    .heightIs(Gato_Height_548_(20));
    
    
//    self.people.text = @"患者量：还没有";
//    self.satisfaction.text = @"满意度：还没写";
//    self.level.text = @"蝴蝶等级：网络请求还没做";
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
        DoctorHomeCommentsTableViewCell * cell = [DoctorHomeCommentsTableViewCell cellWithTableView:tableView];
        GatoViewBorderRadius(cell, 0, 1, [UIColor appAllBackColor]);
        DoctorHomePingjiaModel * model = [[DoctorHomePingjiaModel alloc]init];
        model = self.updataArray[indexPath.row];
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.height];
        [PLCellHeight setValue:value forKey:PLHuShenKey];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }else{
        NSNumber *value = [PLCellHeight objectForKey:PLHuShenKey];
        CGFloat height = value.floatValue;
        if (height < 1) {
            height = 1;
        }
        return height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)satisfaction
{
    if (!_satisfaction) {
        _satisfaction = [[UILabel alloc]init];
        _satisfaction.font = FONT(30);
        _satisfaction.textColor = [UIColor HDTitleRedColor];
        _satisfaction.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:_satisfaction];
    }
    return _satisfaction;
}
-(UILabel *)level
{
    if (!_level) {
        _level = [[UILabel alloc]init];
        _level.font = FONT(30);
        _level.textColor = [UIColor HDTitleRedColor];
        _level.textAlignment = NSTextAlignmentRight;
        [self.topView addSubview:_level];
    }
    return _level;
}
-(UILabel *)people
{
    if (!_people) {
        _people = [[UILabel alloc]init];
        _people.font = FONT(30);
        _people.textColor = [UIColor HDTitleRedColor];
        [self.topView addSubview:_people];
    }
    return _people;
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

@end
