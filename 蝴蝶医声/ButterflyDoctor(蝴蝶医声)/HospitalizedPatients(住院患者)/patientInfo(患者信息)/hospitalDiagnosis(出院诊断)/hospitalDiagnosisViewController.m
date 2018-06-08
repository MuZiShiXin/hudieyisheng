//
//  hospitalDiagnosisViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "hospitalDiagnosisViewController.h"
#import "GatoBaseHelp.h"
#import "OperationmethodModel.h"
#import <SVProgressHUD.h>
#import "OperationmethodTableViewCell.h"
#define kCellTag 10201705
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

@interface hospitalDiagnosisViewController ()
@property (nonatomic ,strong) NSMutableArray * blockArray;
@property (nonatomic ,strong) NSMutableDictionary * cellHeightDic;
@end

@implementation hospitalDiagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    if (self.oneForAll == 0) {
        self.title = @"出院诊断";
    }else{
        self.title = @"次要诊断";
    }
    
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(overButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    [self addJiashuju];
    self.blockArray = [NSMutableArray array];
    self.cellHeightDic = [NSMutableDictionary dictionary];
}

#pragma mark - 右上角完成按钮
-(void)overButton
{
    for (int i = 0 ; i < self.updataArray.count; i ++) {
        OperationmethodModel * model = [[OperationmethodModel alloc]init];
        model = self.updataArray[i];
        if ([model.select isEqualToString:@"1"]) {
            [self.blockArray addObject:model];
        }
    }
    if (self.blockArray.count > 0) {
        if (self.titleArrayBlock) {
            self.titleArrayBlock(self.blockArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.oneForAll == 0) {
        [self showHint:@"请选择出院诊断"];
    }else{
        [self showHint:@"请选择次要诊断"];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addJiashuju
{
    self.updataArray = [NSMutableArray array];
    NSArray * titleArray =@[@"原发甲状旁腺功能亢进",@"继发甲状旁腺功能亢进",@"结节性甲状腺肿",@"甲状腺腺瘤",
                            @"原发甲亢",@"结甲继发甲亢",@"甲状腺炎",@"甲状腺乳头状癌",
                            @"甲状腺滤泡癌",@"甲状腺髓样癌",@"甲状腺未分化癌",@"颈部淋巴结转移癌（中央区）",@"颈部淋巴结转移癌（侧颈区）",@"颈部淋巴结转移癌（中央区+侧颈区）",@"颈部肿物",@"其他"];
    for (int i = 0 ; i < titleArray.count; i ++) {
        OperationmethodModel * model = [[OperationmethodModel alloc]init];
        model.titleStr = titleArray[i];
        model.select = @"0";
        [self.updataArray addObject:model];
    }
    [self.GatoTableview reloadData];
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
    
    if (self.oneForAll == 0) {
        for (int i = 0 ; i < self.updataArray.count ; i ++) {
            OperationmethodModel * model = [[OperationmethodModel alloc]init];
            model = self.updataArray[i];
            model.select = @"0";
            [self.updataArray replaceObjectAtIndex:i withObject:model];
        }
    }else{
        
    }
    OperationmethodModel * model = [[OperationmethodModel alloc]init];
    model = self.updataArray[indexPath.row];
    if ([model.select isEqualToString:@"0"]) {
        model.select = @"1";
    }else{
        model.select = @"0";
    }
    
    [self.GatoTableview reloadData];
}

@end
