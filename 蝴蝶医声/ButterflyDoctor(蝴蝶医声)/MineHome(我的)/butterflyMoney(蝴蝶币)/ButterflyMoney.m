//
//  ButterflyMoney.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ButterflyMoney.h"
#import "GatoBaseHelp.h"
#import "ButterflyMoneyInfoCell.h"
#import "ButterflyMoneyTradingCell.h"
#import "PellTableViewSelect.h"
#import "withdrawaViewController.h"
#import "ButterflyMoneryBeforeModel.h"
@interface ButterflyMoney () <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat page;
}
@property (nonatomic ,strong) UIView * shuomingView;
@property (nonatomic ,strong) UIView * tixianView;
@property (nonatomic ,strong) NSString * butterflyLevelStr;

@end

@implementation ButterflyMoney

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蝴蝶币";
    page = 0;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"说明" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
    self.GatoTableview.height = Gato_Height - NAV_BAR_HEIGHT;
    self.cells = @[[ButterflyMoneyInfoCell getCellID], [ButterflyMoneyTradingCell getCellID]];
    [self registCells];
    
    self.updataArray = [NSMutableArray array];
    [self.view addSubview:self.GatoTableview];
    [self update];
    [self updateBefore];
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


//马上连同蝴蝶币获得记录
-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_Mine_Level params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self.butterflyLevelStr = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"goldCount"];
            if (self.butterflyLevelStr.length < 1) {
                self.butterflyLevelStr = @"0";
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
-(void)updateBefore
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Mine_ButterflyB_Before params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                ButterflyMoneryBeforeModel * model = [[ButterflyMoneryBeforeModel alloc]init];
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

#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return self.updataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0) {
        ButterflyMoneyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButterflyMoneyInfoCell getCellID]];
        cell.tixianBlock = ^(){
            withdrawaViewController * vc = [[withdrawaViewController alloc]init];
            vc.goldNumber = weakSelf.butterflyLevelStr;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [cell setvalueWithMonery:self.butterflyLevelStr];
        return cell;
    } else {
        ButterflyMoneyTradingCell *cell = [tableView dequeueReusableCellWithIdentifier:[ButterflyMoneyTradingCell getCellID]];
        ButterflyMoneryBeforeModel * model = [[ButterflyMoneryBeforeModel alloc]init];
        model = self.updataArray[indexPath.row];
        [cell setValueWithModel:model];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [ButterflyMoneyInfoCell getHeightForCell];
    } else {
        return [ButterflyMoneyTradingCell getHeightForCell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    } else {
        return Gato_Height_548_(10.0);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor appAllBackColor];
        if (self.updataArray.count > 0) {
            UIView * fgx0 = [[UIView alloc]init];
            fgx0.backgroundColor = [UIColor HDViewBackColor];
            [view addSubview:fgx0];
            fgx0.sd_layout.leftSpaceToView(view,0)
            .rightSpaceToView(view,0)
            .topSpaceToView(view,0)
            .heightIs(Gato_Height_548_(0.5));
            
            
            UIView * fgx = [[UIView alloc]init];
            fgx.backgroundColor = [UIColor HDViewBackColor];
            [view addSubview:fgx];
            fgx.sd_layout.leftSpaceToView(view,0)
            .rightSpaceToView(view,0)
            .topSpaceToView(view,Gato_Height_548_(9.5))
            .heightIs(Gato_Height_548_(0.5));
            
        }
        return view;
    }
}

-(void)rightButtonDidClicked
{
    [PellTableViewSelect addPellTableViewSelectWithwithView:self.shuomingView
                                                WindowFrame:CGRectMake(0, 0,Gato_Width_320_(290), Gato_Height_548_(400))
                                              WithViewFrame:CGRectMake(Gato_Width_320_(15),Gato_Height_548_(75), Gato_Width_320_(290), Gato_Height_548_(400))
                                                 selectData:nil
                                                     action:^(NSInteger index) {
                                                         ;
                                                     } animated:YES];
}
-(void)shuomingOkButton
{
    [PellTableViewSelect hiden];
}
-(UIView *)shuomingView
{
    if (!_shuomingView) {
        _shuomingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width_320_(290), Gato_Height_548_(300))];
        _shuomingView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shuomingView];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"jinbi"];
        [self.shuomingView addSubview:image];
        image.sd_layout.leftSpaceToView(self.shuomingView,Gato_Width_320_(105))
        .topSpaceToView(self.shuomingView,Gato_Height_548_(10))
        .widthIs(Gato_Width_320_(30))
        .heightIs(Gato_Height_548_(30));
        
        
        UILabel * title = [[UILabel alloc]init];
        title.text = @"蝴蝶币";
        title.textColor = [UIColor HDTitleRedColor];
        title.font = FONT(40);
        [self.shuomingView addSubview:title];
        title.sd_layout.leftSpaceToView(image,Gato_Width_320_(5))
        .topEqualToView(image)
        .widthIs(Gato_Width / 2)
        .heightRatioToView(image,1);
        
        
        UILabel * label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.text = @"什么是蝴蝶币?\n\n        蝴蝶币是蝴蝶医声软件系统内可以兑现的一种货币，通过对蝴蝶币的积累医生可以升级自己的蝴蝶等级进而提高知名度，从而更加容易被患者关注。\n\n如何获得蝴蝶币?\n\n        当患者对医生的医疗服务做出评价时，会根据医生的诊治效果和服务态度赠送医生蝴蝶勋章。蝴蝶勋章分为铜勋章、银勋章和金勋章。铜勋章为免费赠与，医生获得后自动兑换一枚蝴蝶币。银勋章与金勋章为付费内容，医生获得后分别自动兑换两枚和四枚蝴蝶币。";
        label.font = FONT(34);
        label.textColor = [UIColor YMAppAllTitleColor];
        [self.shuomingView addSubview:label];
        label.sd_layout.leftSpaceToView(self.shuomingView,Gato_Width_320_(10))
        .rightSpaceToView(self.shuomingView,Gato_Width_320_(10))
        .topSpaceToView(image,Gato_Height_548_(10))
        .autoHeightRatio(0);
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor HDThemeColor]];
        [button setTitle:@"知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(30);
        [button addTarget:self action:@selector(shuomingOkButton) forControlEvents:UIControlEventTouchUpInside];
        [self.shuomingView addSubview:button];
        button.sd_layout.centerXEqualToView(self.shuomingView)
        .bottomSpaceToView(self.shuomingView,Gato_Height_548_(10))
        .widthIs(Gato_Width_320_(150))
        .heightIs(Gato_Height_548_(30));
        
        GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
        GatoViewBorderRadius(self.shuomingView, 5, 0, [UIColor redColor]);
        
        [label updateLayout];
        
    }
    return _shuomingView;
}


@end
