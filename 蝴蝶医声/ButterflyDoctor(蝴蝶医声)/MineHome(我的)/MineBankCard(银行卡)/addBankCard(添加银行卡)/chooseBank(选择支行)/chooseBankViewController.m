//
//  chooseBankViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "chooseBankViewController.h"
#import "GatoBaseHelp.h"
#import <SVProgressHUD.h>
#import "ChooseBankSonModel.h"
#import "ChooseBankInfoModel.h"
#import "choosebankTableViewCell.h"
#define kCellTag 1004333
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]
@interface chooseBankViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * leftArray;//银行
    NSMutableArray * rightArray;//支行
    NSMutableDictionary * rightCellHeight;
}
@property (nonatomic ,strong) UITableView * leftTableView;
@property (nonatomic ,strong) ChooseBankSonModel * bankNameModel;
@end

@implementation chooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"选择支行";
    self.view.backgroundColor = [UIColor appAllBackColor];
//    self.leftTableView.frame = CGRectMake(0, 0, Gato_Width_320_(130), Gato_Height - NAV_BAR_HEIGHT);
//    [self.view addSubview:self.leftTableView];
    
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT);
    [self.view addSubview:self.GatoTableview];
    rightCellHeight = [NSMutableDictionary dictionary];
    
    
    
    
//    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
//    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = FONT(30);
//    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(searchButton)forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem= rightItem;
    [self uodate];
}


-(void)uodate
{
    self.updataArray = [NSMutableArray array];
    self.updateParms = [NSMutableDictionary dictionary];
    [IWHttpTool postWithURL:HD_Mine_Bank_All params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count ; i ++) {
                ChooseBankSonModel * sonmodel = [[ChooseBankSonModel alloc]init];
                [sonmodel setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:sonmodel];
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
-(void)searchButton
{
    if (self.bankNameModel.name.length < 1) {
        [self showHint:@"请选择开户支行"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    if (self.bankName) {
        self.bankName(self.bankNameModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addArrayModel
{
//    leftArray = [NSMutableArray array];
//    rightArray = [NSMutableArray array];
//    for (int i = 0 ; i < 10 ; i ++) {
//        [leftArray addObject:@"中国建设银行建设银行"];
//    }
//    for (int i = 0 ; i < 20 ; i ++) {
//        [rightArray addObject:@"哈尔滨银行道里区新阳路支行"];
//    }
//    [self.leftTableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.updataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    choosebankTableViewCell * cell = [choosebankTableViewCell cellWithTableView:tableView];
    ChooseBankSonModel * sonmodel = [[ChooseBankSonModel alloc]init];
    sonmodel = self.updataArray[indexPath.row];
    [cell setValueWithModel:sonmodel];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(50);
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseBankSonModel * sonmodel = [[ChooseBankSonModel alloc]init];
    sonmodel = self.updataArray[indexPath.row];
    if (self.bankName) {
        self.bankName(sonmodel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Gato_Width , Gato_Height  ) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _leftTableView.tableFooterView = [[UIView alloc] init];
    }
    return _leftTableView;
}

@end
