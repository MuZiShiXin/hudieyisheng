//
//  ModifyArticleViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ModifyArticleViewController.h"
#import "GatoBaseHelp.h"
#import "ModifyArticleTextTableViewCell.h"
#import "modifyArticleModel.h"
#import "ModifyArticleDeleteTableViewCell.h"
#import "TheArticleViewController.h"
#import "TheArticleModel.h"
#import "WebArticleViewController.h"
#define kCellTag 100425000
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

@interface ModifyArticleViewController ()
{
    
    NSMutableDictionary * cellHeightDic;
    
}
@property (nonatomic ,strong)modifyArticleModel * textModel;
@property (nonatomic ,strong) UIButton * removeButton;
@end

@implementation ModifyArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    self.title = @"模版设置";
    self.textModel = [[modifyArticleModel alloc]init];
    cellHeightDic = [NSMutableDictionary dictionary];
    self.updataArray = [NSMutableArray array];
//    for (int i = 0 ; i < 3 ; i ++) {
//        TheArticleModel * model = [[TheArticleModel alloc]init];
//        model.type = @"我是type";
//        if (i == 0) {
//            model.title = @"我是标题，心脑血管着应该这样管理自己！不要让你的身体在失控！";
//        }else if (i == 1){
//            model.title = @"我是标题，心脑血管着应该这样管理自己！不要让你的身体在失控！心脑血管着应该这样管理自己！不要让你的身体在失控！";
//        }else{
//            model.title = @"我是标题，心脑血管着应该这样！";
//        }
//        model.time = @"2017.2.23发表";
//        model.yinyong = @"199引用";
//        model.yuedu = @"1312阅读";
//        model.zhiding = @"1";
//        [self.updataArray addObject:model];
//    }
    UIButton*right1Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(32),Gato_Height_548_(18))];
    [right1Button setTitle:@"保存" forState:UIControlStateNormal];
    right1Button.titleLabel.font = FONT(30);
    [right1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right1Button addTarget:self action:@selector(baocunButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:right1Button];
    
    self.removeButton.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(Gato_Height_548_(50));
    
    self.navigationItem.rightBarButtonItem = rightItem1;
    [self update];
}
#pragma mark - 读取模板设置
-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.comeForWhere forKey:@"type"];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    
    [IWHttpTool postWithURL:HD_ModifyArticle_Old params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.textModel setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            NSMutableArray * articlesArray = [NSMutableArray array];
            for (int i = 0; i < self.textModel.articles.count ; i ++) {
                TheArticleModel * model = [[TheArticleModel alloc]init];
                [model setValuesForKeysWithDictionary:self.textModel.articles[i]];
                [articlesArray addObject:model];
            }
            self.textModel.articles = articlesArray;
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
#pragma mark -  保存消息模版
-(void)baocunButton
{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.updateParms = [NSMutableDictionary dictionary];
        [self.updateParms setObject:self.comeForWhere forKey:@"type"];
        [self.updateParms setObject:TOKEN forKey:@"token"];
        [self.updateParms setObject:self.textModel.pushId forKey:@"pushId"];
        [self.updateParms setObject:self.textModel.title forKey:@"title"];
        [self.updateParms setObject:self.textModel.content forKey:@"content"];
        NSString * articlesStr = @"";
        for (int i = 0 ; i < self.textModel.articles.count; i ++) {
            TheArticleModel * model = [[TheArticleModel alloc]init];
            model = self.textModel.articles[i];
            if (i == 0) {
                articlesStr = [NSString stringWithFormat:@"%@,",model.articleId];
            }else{
                articlesStr = [NSString stringWithFormat:@"%@%@,",articlesStr,model.articleId];
            }
        }
        [self.updateParms setObject:articlesStr forKey:@"articles"];
        [IWHttpTool postWithURL:HD_ModifyArticle_New params:self.updateParms success:^(id json) {
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            NSString * success = [dic objectForKey:@"code"];
            if ([success isEqualToString:@"200"]) {
                [self showHint:@"保存成功"];
                [self.navigationController popViewControllerAnimated: YES];
            }else{
                NSString * falseMessage = [dic objectForKey:@"message"];
                [self showHint:falseMessage];
            }
            [self.GatoTableview.mj_header endRefreshing];
            [self.GatoTableview reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textModel.articles.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        ModifyArticleTextTableViewCell * cell = [ModifyArticleTextTableViewCell cellWithTableView:tableView];
        cell.textBlock = ^(NSString * text, NSInteger row){
            if (row == 0) {
                weakSelf.textModel.title = text;
            }else{
                weakSelf.textModel.content = text;
            }
        };
        cell.MoerButton = ^(){
            NSLog(@"跳转文库");
            TheArticleViewController * vc = [[TheArticleViewController alloc]init];
            vc.comeForPushMessage = YES;
            vc.addArticleBlock = ^(TheArticleModel * model){
                BOOL chongfu = NO;
                for (int i =0 ;  i< weakSelf.textModel.articles.count; i ++) {
                    TheArticleModel * textModel = [[TheArticleModel alloc]init];
                    textModel = weakSelf.textModel.articles[i];
                    if ([model.articleId isEqualToString:textModel.articleId]) {
                        chongfu = YES;
                    }
                }
                if (!chongfu) {
                    NSMutableArray * articleArray = [NSMutableArray array];
                    articleArray = [weakSelf.textModel.articles mutableCopy];
                    [articleArray addObject:model];
                    weakSelf.textModel.articles = articleArray;
                    [weakSelf.GatoTableview reloadData];

                }
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [cell setValueWithModel:self.textModel];
        return cell;
    }else{
        ModifyArticleDeleteTableViewCell * cell = [ModifyArticleDeleteTableViewCell cellWithTableView:tableView];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.textModel.articles[indexPath.row - 1];
        [cell setValueWithModel:model];
        cell.deleteBlock = ^(){
            NSLog(@"点击删除按钮 删除第 %ld 个文章",indexPath.row - 1);
            NSMutableArray * articleArray = [NSMutableArray array];
            articleArray = [weakSelf.textModel.articles mutableCopy];
            [articleArray removeObjectAtIndex:indexPath.row - 1];
            weakSelf.textModel.articles = articleArray;
            [weakSelf.GatoTableview reloadData];
        };
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [ModifyArticleTextTableViewCell getheight];
    }
    NSNumber *value = [cellHeightDic objectForKey:kHuShenKey];
    CGFloat height = value.floatValue;
    if (height < 1) {
        height = 1;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        WebArticleViewController * vc = [[WebArticleViewController alloc]init];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.textModel.articles[indexPath.row - 1];
        vc.articleId = model.articleId;
        vc.isOwner = model.isOwner;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 一键删除
-(void)removeButtonDidClicked
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该推送模版？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteUpdate];
    }]];
     [self presentViewController:alertController animated:YES completion:nil];
}
-(void)deleteUpdate
{
   
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.comeForWhere forKey:@"type"];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.textModel.pushId forKey:@"pushId"];
    [self.updateParms setObject:@"" forKey:@"title"];
    [self.updateParms setObject:@"" forKey:@"content"];
    [self.updateParms setObject:@"" forKey:@"articles"];
    [IWHttpTool postWithURL:HD_ModifyArticle_New params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            [self.navigationController popViewControllerAnimated: YES];
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
-(UIButton *)removeButton
{
    if (!_removeButton) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setTitle:@"一键删除" forState:UIControlStateNormal];
        _removeButton.titleLabel.font = FONT(30);
        [_removeButton setBackgroundColor:[UIColor HDThemeColor]];
        [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(removeButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_removeButton];
    }
    return _removeButton;
}
@end
