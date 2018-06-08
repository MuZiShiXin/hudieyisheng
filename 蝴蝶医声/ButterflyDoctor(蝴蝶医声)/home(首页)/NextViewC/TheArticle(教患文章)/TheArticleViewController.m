//
//  TheArticleViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TheArticleViewController.h"
#import "GatoBaseHelp.h"
#import "TheArticleTableViewCell.h"
#import "PellTableViewSelect.h"
#import "AllArticleViewController.h"
#import "WebArticleViewController.h"
#import "AddArticleViewController.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
#import "makeArticleViewController.h"

#define underViewHeight Gato_Height_548_(39)
#define paixuButtonTag 4181647
#define shaixuanButtonTag 4181747

#define kCellTag 100425111
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

@interface TheArticleViewController ()
{
    NSMutableDictionary * cellHeightDic;
    CGFloat page;
}
@property (nonatomic ,strong) UIView * underView;//下方筛选
@property (nonatomic ,strong) UIButton * paixu;
@property (nonatomic ,strong) UIButton * shaixuan;
@property (nonatomic ,strong) UIImageView * paixuimage;
@property (nonatomic ,strong) UIImageView * shaixuanimage;
@property (nonatomic ,strong) UIView * paixuView;//排序view
@property (nonatomic ,strong) UIView * shaixuanView;//筛选view
@property (nonatomic ,strong) NSString * paixuStr;//当前选择排序
@property (nonatomic ,strong) NSString * shaixuanStr;//当前选择筛选
@end

@implementation TheArticleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.updataArray = [NSMutableArray array];
    [self update];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Gato_Return
    self.GatoTableview.frame = CGRectMake(0, Gato_Height_548_(83) , Gato_Width, Gato_Height - Gato_Height_548_(83) - underViewHeight - NAV_BAR_HEIGHT);
    [self.view addSubview:self.GatoTableview];
    cellHeightDic = [NSMutableDictionary dictionary];
    self.title = @"患教文章";
    self.paixuStr = @"";
    [self newFrame];
    page = 0;
    [self addPellView];
    if (!self.comeForPushMessage) {
        self.comeForPushMessage = NO;
    }
    
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
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.shaixuanStr forKey:@"filter"];
    [self.updateParms setObject:self.paixuStr forKey:@"sort"];
    [self.updateParms setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_Home_info_Article params:self.updateParms success:^(id json) {
        
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
                model.label = @"您还没有创建或引用患教文章";
                [self.updataArray addObject:model];
            }
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
    if (self.updataArray.count < 1) {
        return nil;
    }
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.updataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        TheArticleTableViewCell * cell = [TheArticleTableViewCell cellWithTableView:tableView];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.updataArray[indexPath.row];
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
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]])
    {
        
    }else{
        if (self.comeForPushMessage == YES) {
            
            TheArticleModel * model = [[TheArticleModel alloc]init];
            model = self.updataArray[indexPath.row];
            if ([model.isVerify isEqualToString:@"1"]) {
                if (self.addArticleBlock) {
                    self.addArticleBlock(model);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            return;
        }
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.updataArray[indexPath.row];
        if (![model.isVerify isEqualToString:@"1"]) {
            makeArticleViewController * vc = [[makeArticleViewController alloc]init];
            vc.articleID = model.articleId;
            vc.titleName = model.title;
            vc.classify = model.classify;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            WebArticleViewController * vc = [[WebArticleViewController alloc]init];
            vc.articleId = model.articleId;
            vc.isOwner = model.isOwner;
            vc.titleStr = model.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
} 
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.updataArray[indexPath.row] isKindOfClass:[NulllabelModel class]]) {
        return NO;
    }else
    {
       return YES;
    }
    
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    TheArticleModel * model = [[TheArticleModel alloc]init];
    model = self.updataArray[indexPath.row];
    
    NSLog(@"lalallalal~~~~~~~~%ld",self.updataArray.count);
    
    
    
    if ([model.isOwner isEqualToString:@"1"]) {
        // 设置删除按钮
        UITableViewRowAction *noDeleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除\n文章" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            //事件
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该文章？" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self deleteArticleWithArticledId:model.articleId];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        if ([model.isTop isEqualToString:@"0"]) {
            //
            //置顶
            UITableViewRowAction *noLoveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶\n文章" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [self zhidingArticleWithArticledId:model.articleId];
            }];
            noDeleAction.backgroundColor = [UIColor HDTitleRedColor];
            noLoveAction.backgroundColor = [UIColor HDThemeColor];
            return @[noLoveAction,noDeleAction];
        }else{
            //
            //置顶
            UITableViewRowAction *noLoveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消\n置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                //事件
                [self quxiaozhidingArticleWithArticledId:model.articleId];
            }];
            noDeleAction.backgroundColor = [UIColor HDTitleRedColor];
            noLoveAction.backgroundColor = [UIColor HDThemeColor];
            return @[noLoveAction,noDeleAction];
        }
        
    }else{
        UITableViewRowAction *noDeleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消\n引用" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            //事件
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"确定取消引用该文章？"
                                                                              preferredStyle:UIAlertControllerStyleAlert ];
            
            //添加取消到UIAlertController中
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            
            //添加确定到UIAlertController中
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self removeArticleWithArticledId:model.articleId];
            }];
            [alertController addAction:OKAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        if ([model.isTop isEqualToString:@"0"]) {
            //
            //置顶
            UITableViewRowAction *noLoveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶\n文章" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                //事件
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否置顶该文章？" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self zhidingArticleWithArticledId:model.articleId];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
            noDeleAction.backgroundColor = [UIColor HDTitleRedColor];
            noLoveAction.backgroundColor = [UIColor HDThemeColor];
            return @[noLoveAction,noDeleAction];
        }else{
            //
            //置顶
            UITableViewRowAction *noLoveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消\n置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                //事件
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消置顶该文章？" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self quxiaozhidingArticleWithArticledId:model.articleId];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
            noDeleAction.backgroundColor = [UIColor HDTitleRedColor];
            noLoveAction.backgroundColor = [UIColor HDThemeColor];
            return @[noLoveAction,noDeleAction];
        }
        
    }
}

//设置进入编辑状态时，Cell不会缩进

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - 删除文章
-(void)deleteArticleWithArticledId:(NSString * )articleId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:articleId forKey:@"articleId"];
    [IWHttpTool postWithURL:HD_Home_info_Article_Delete params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            self.updataArray = [NSMutableArray array];
            [self update];
            
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

#pragma mark - 取消引用
-(void)removeArticleWithArticledId:(NSString * )articleId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:articleId forKey:@"articleId"];
    [IWHttpTool postWithURL:HD_Article_Quote_remove params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"取消引用成功"];
            self.updataArray = [NSMutableArray array];
            [self update];
            
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
#pragma mark - 置顶文章
-(void)zhidingArticleWithArticledId:(NSString *)articledId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:articledId forKey:@"articleId"];
    [IWHttpTool postWithURL:HD_Article_TOP params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"设置成功"];
            self.updataArray = [NSMutableArray array];
            [self update];
            
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
#pragma mark - 取消置顶文章
-(void)quxiaozhidingArticleWithArticledId:(NSString *)articledId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:articledId forKey:@"articleId"];
    [IWHttpTool postWithURL:HD_Article_TOP_Down params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"设置成功"];
            self.updataArray = [NSMutableArray array];
            [self update];
            
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
#pragma mark - 创建文章
-(void)AddArticla:(UIButton *)sender
{
    NSLog(@"chuangjian");
    makeArticleViewController * vc = [[makeArticleViewController alloc]init];
    //    AddArticleViewController * vc = [[AddArticleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 全部文章
-(void)LookAllArticlaArticla:(UIButton *)sender
{
    NSLog(@"quanbu");
    AllArticleViewController * vc = [[AllArticleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 排序
-(void)paixu:(UIButton *)senrder
{
    NSLog(@"paixu");
    [PellTableViewSelect addPellTableViewSelectWithwithView:self.paixuView WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(120)) WithViewFrame:CGRectMake(0, Gato_Height - Gato_Height_548_(120) - underViewHeight, Gato_Width, Gato_Height_548_(120)) selectData:nil action:^(NSInteger index) {
        ;
    } animated:YES];
}
#pragma mark - 筛选
-(void)shaixuan:(UIButton *)senrder
{
    NSLog(@"shaixuan");
    [PellTableViewSelect addPellTableViewSelectWithwithView:self.shaixuanView WindowFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(160)) WithViewFrame:CGRectMake(0, Gato_Height - Gato_Height_548_(160) - underViewHeight, Gato_Width, Gato_Height_548_(160)) selectData:nil action:^(NSInteger index) {
        ;
    } animated:YES];
}
#pragma mark - 点击排序按钮事件
-(void)paixuButtonView:(UIButton *)sender
{
    [PellTableViewSelect hiden];
    for (UIButton * button  in self.paixuView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
            GatoViewBorderRadius(button, 3, 1, [UIColor appAllBackColor]);
        }
    }
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(sender, 3, 1, [UIColor HDThemeColor]);
    if ([sender.titleLabel.text isEqualToString:@"更新时间"]) {
        self.paixuStr = @"time";
    }else if ([sender.titleLabel.text isEqualToString:@"浏览人数"]){
        self.paixuStr = @"click";
    }else{
        self.paixuStr = @"";
    }
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self update];
}
#pragma mark - 点击筛选按钮事件
-(void)shaixuanButtonView:(UIButton *)sender
{
    [PellTableViewSelect hiden];
    for (UIButton * button  in self.shaixuanView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
            GatoViewBorderRadius(button, 3, 1, [UIColor appAllBackColor]);
        }
    }
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    GatoViewBorderRadius(sender, 3, 1, [UIColor HDThemeColor]);
    self.shaixuanStr = [GatoMethods getButterflyarticlesTypeWithName:sender.titleLabel.text];
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self update];
}
-(void)newFrame
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(83));
    
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"home_icon_establish"];
    [self.view addSubview:image];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"创建文章";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor HDBlackColor];
    label.font = FONT(30);
    [self.view addSubview:label];
    
    image.sd_layout.topSpaceToView(self.view,Gato_Height_548_(21) )
    .widthIs(Gato_Width_320_(23))
    .heightIs(Gato_Height_548_(22))
    .centerXEqualToView(label);
    
    label.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(image,Gato_Height_548_(10))
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(30));
    
    UIImageView * image1 = [[UIImageView alloc]init];
    image1.image = [UIImage imageNamed:@"home_icon_library"];
    [self.view addSubview:image1];
    
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"患教文库";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor HDBlackColor];
    label1.font = FONT(30);
    [self.view addSubview:label1];
    
    label1.sd_layout.leftSpaceToView(label,0)
    .topEqualToView(label)
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(30));
    
    image1.sd_layout.topSpaceToView(self.view,Gato_Height_548_(21) )
    .widthIs(Gato_Width_320_(23))
    .heightIs(Gato_Height_548_(22))
    .centerXEqualToView(label1);
    
    
    
    UIButton * AddArticla = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddArticla addTarget:self action:@selector(AddArticla:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AddArticla];
    AddArticla.sd_layout.leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(83));
    
    UIButton * LookAllArticla= [UIButton buttonWithType:UIButtonTypeCustom];
    [LookAllArticla addTarget:self action:@selector(LookAllArticlaArticla:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LookAllArticla];
    LookAllArticla.sd_layout.leftSpaceToView(AddArticla,0)
    .topEqualToView(AddArticla)
    .widthIs(Gato_Width / 2)
    .heightRatioToView(AddArticla,1);
    
    self.underView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(underViewHeight);
    
    
    self.paixu.sd_layout.leftSpaceToView(self.underView,0)
    .topSpaceToView(self.underView,0)
    .widthIs(Gato_Width / 2)
    .heightIs(underViewHeight);
    
    self.paixuimage.sd_layout.leftSpaceToView(self.underView,Gato_Width / 4 + 20)
    .topSpaceToView(self.underView,Gato_Height_548_(16))
    .widthIs(Gato_Width_320_(12))
    .heightIs(Gato_Height_548_(9));
    
    self.shaixuan.sd_layout.leftSpaceToView(self.paixu,0)
    .topEqualToView(self.paixu)
    .widthIs(Gato_Width / 2)
    .heightRatioToView(self.paixu,1);
    
    self.shaixuanimage.sd_layout.leftSpaceToView(self.underView,Gato_Width / 4 * 3 + 20)
    .topSpaceToView(self.underView,Gato_Height_548_(16))
    .widthIs(Gato_Width_320_(12))
    .heightIs(Gato_Height_548_(9));
    
    UIView * underFgx = [[UIView alloc]init];
    underFgx.backgroundColor = [UIColor appAllBackColor];
    [self.underView addSubview:underFgx];
    underFgx.sd_layout.leftSpaceToView(self.underView,Gato_Width / 2)
    .topSpaceToView(self.underView,Gato_Height_548_(8))
    .widthIs(Gato_Width_320_(1))
    .heightIs(Gato_Height_548_(26));
    
    
    /*
     self.updataArray = [NSMutableArray array];
     for (int i =0 ; i < 10; i ++) {
     TheArticleModel * model = [[TheArticleModel alloc]init];
     model.type = @"我是type";
     model.title = @"我是标题，心脑血管着应该这样管理自己！不要让你的身体在失控！";
     model.time = @"2017.2.23发表";
     model.yinyong = @"199引用";
     model.yuedu = @"1312阅读";
     model.zhiding = @"1";
     [self.updataArray addObject:model];
     }
     */
}
#pragma mark - 下方两个筛选view加载
-(void)addPellView
{
    NSArray * paixuArray = @[@"默认排序",@"更新时间",@"浏览人数"];
    NSArray * shaixuanArray = @[@"全部",@"学术研究",@"医学科普",@"诊前须知",@"诊后必读",@"术后需知",@"经典问答",@"出院需知",@"同位素治疗"];
    CGFloat buttonY = Gato_Height_548_(20);
    for (int i = 0 ; i < paixuArray.count ; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:paixuArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        button.tag = paixuButtonTag + i;
        button.titleLabel.font = FONT(26);
        [button addTarget:self action:@selector(paixuButtonView:) forControlEvents:UIControlEventTouchUpInside];
        [self.paixuView addSubview:button];
        
        GatoViewBorderRadius(button, 3, 1, [UIColor appAllBackColor]);
        
        button.sd_layout.leftSpaceToView(self.paixuView, i * Gato_Width / 3 + Gato_Width / 3 / 2 - Gato_Width_320_(80)/2)
        .topSpaceToView(self.paixuView,i / 3 * Gato_Height_548_(30) + buttonY)
        .widthIs(Gato_Width_320_(80))
        .heightIs(Gato_Height_548_(25));
        
        if (i == 0) {
            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
            GatoViewBorderRadius(button, 3, 1, [UIColor HDThemeColor]);
            self.paixuStr = @"";
        }
    }
    
    for (int i = 0 ; i < shaixuanArray.count ; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:shaixuanArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        button.tag = paixuButtonTag + i;
        button.titleLabel.font = FONT(26);
        [button addTarget:self action:@selector(shaixuanButtonView:) forControlEvents:UIControlEventTouchUpInside];
        [self.shaixuanView addSubview:button];
        GatoViewBorderRadius(button, 3, 1, [UIColor appAllBackColor]);
        
        button.sd_layout.leftSpaceToView(self.shaixuanView, ( i % 3 )* Gato_Width / 3 + Gato_Width / 3 / 2 - Gato_Width_320_(80)/2)
        .topSpaceToView(self.shaixuanView,(i / 3) * Gato_Height_548_(35) + buttonY)
        .widthIs(Gato_Width_320_(80))
        .heightIs(Gato_Height_548_(25));
        
        if (i == 0) {
            [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
            GatoViewBorderRadius(button, 3, 1, [UIColor HDThemeColor]);
            self.shaixuanStr = shaixuanArray[i];
        }
    }
}
-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_underView];
        
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.underView addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(self.underView, 0)
        .rightSpaceToView(self.underView, 0)
        .topSpaceToView(self.underView, 0)
        .heightIs(1);
    }
    return _underView;
}

-(UIButton *)paixu
{
    if (!_paixu) {
        _paixu = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paixu setTitle:@"排序" forState:UIControlStateNormal];
        [_paixu setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _paixu.titleLabel.font = FONT(30);
        [_paixu addTarget:self action:@selector(paixu:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_paixu];
    }
    return _paixu;
}
-(UIButton *)shaixuan
{
    if (!_shaixuan) {
        _shaixuan = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shaixuan setTitle:@"筛选" forState:UIControlStateNormal];
        [_shaixuan setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _shaixuan.titleLabel.font = FONT(30);
        [_shaixuan addTarget:self action:@selector(shaixuan:) forControlEvents:UIControlEventTouchUpInside];
        [self.underView addSubview:_shaixuan];
    }
    return _shaixuan;
}
-(UIImageView *)paixuimage
{
    if (!_paixuimage) {
        _paixuimage = [[UIImageView alloc]init];
        _paixuimage.image = [UIImage imageNamed:@"home_icon_sort"];
        [self.underView addSubview:_paixuimage];
    }
    return _paixuimage;
}
-(UIImageView *)shaixuanimage
{
    if (!_shaixuanimage) {
        _shaixuanimage = [[UIImageView alloc]init];
        _shaixuanimage.image = [UIImage imageNamed:@"home_icon_filtrate"];
        [self.underView addSubview:_shaixuanimage];
    }
    return _shaixuanimage;
}

-(UIView *)shaixuanView
{
    if (!_shaixuanView) {
        _shaixuanView = [[UIView alloc]initWithFrame:CGRectMake(0, Gato_Height, Gato_Width, 100)];
        _shaixuanView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_shaixuanView];
    }
    return _shaixuanView;
}
-(UIView *)paixuView
{
    if (!_paixuView) {
        _paixuView = [[UIView alloc]initWithFrame:CGRectMake(0, Gato_Height, Gato_Width, 100)];
        _paixuView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_paixuView];
    }
    return _paixuView;
}

@end

