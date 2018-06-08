//
//  OperationMethodViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "OperationMethodViewController.h"
#import "GatoBaseHelp.h"
#import "OperationmethodTableViewCell.h"
#import "OperationmethodModel.h"
#import <SVProgressHUD.h>

#define kCellTag 10201705
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]


@interface OperationMethodViewController ()
@property (nonatomic ,strong) NSMutableDictionary * cellHeightDic;
@end

@implementation OperationMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    self.title = @"手术方式";
    [self addJiashuju];
    
    self.cellHeightDic = [NSMutableDictionary dictionary];
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(overButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}
-(void)overButton
{
    for (int i = 0 ; i < self.updataArray.count; i ++) {
        OperationmethodModel * model = [[OperationmethodModel alloc]init];
        model = self.updataArray[i];
        if ([model.select isEqualToString:@"1"]) {
            if (self.titleBlock) {
                self.titleBlock(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    [self showHint:@"请选择手术方式"];
    
    
}

-(void)addJiashuju
{
    self.updataArray = [NSMutableArray array];
    NSArray * titleArray = @[@"单侧腺叶次全切除",@"双侧腺叶次全切除",@"单侧腺叶切除+单侧中央区淋巴结清扫",@"单侧腺叶切除+对侧次全切除+单侧中央区淋巴结清扫",@"单侧腺叶切除+单侧中央区淋巴结清扫+单侧侧颈淋巴结清扫",@"双侧腺叶切除+双侧中央区淋巴结清扫",@"双侧腺叶切除+双侧中央区淋巴结清扫+单侧侧颈淋巴结清扫",@"双侧腺叶切除+双侧中央区淋巴结清扫+双侧侧颈淋巴结清扫",@"甲状腺癌姑息切除术",@"甲状旁腺切除术",@"双侧腺叶切除+单侧中央区淋巴结清扫",@"双侧腺叶切除+单侧中央区淋巴结清扫+单侧侧颈淋巴结清扫",@"其他"];
    for (int i = 0 ; i < titleArray.count; i ++) {
        OperationmethodModel * model = [[OperationmethodModel alloc]init];
        model.titleStr = titleArray[i];
        model.select = @"0";
        [self.updataArray addObject:model];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OperationmethodTableViewCell * cell = [OperationmethodTableViewCell cellWithTableView:tableView];
    OperationmethodModel * model = [[OperationmethodModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
    [self.cellHeightDic setValue:value forKey:kHuShenKey];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *value = [self.cellHeightDic objectForKey:kHuShenKey];
    CGFloat height = value.floatValue;
    if (height < 1) {
        height = 1;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for (int i = 0 ; i < self.updataArray.count; i ++) {
        OperationmethodModel * model = [[OperationmethodModel alloc]init];
        model = self.updataArray[i];
        model.select = @"0";
    }
    OperationmethodModel * model = [[OperationmethodModel alloc]init];
    model = self.updataArray[indexPath.row];
    model.select = @"1";
    [self.GatoTableview reloadData];
}

@end
