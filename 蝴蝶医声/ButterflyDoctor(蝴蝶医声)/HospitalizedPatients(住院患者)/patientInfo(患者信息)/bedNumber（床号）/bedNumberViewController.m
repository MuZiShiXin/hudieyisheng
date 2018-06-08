//
//  bedNumberViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "bedNumberViewController.h"
#import "GatoBaseHelp.h"
#import "bedNumberLeftTableViewCell.h"
#import "bedNumberRightTableViewCell.h"
@interface bedNumberViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView * rightTableView;
@property (nonatomic ,strong) NSMutableArray * rightArray;
@property (nonatomic ,assign) NSInteger row;
@end

@implementation bedNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"选择床号";
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width_320_(100), Gato_Height);
    self.GatoTableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.GatoTableview];
    self.rightTableView.frame = CGRectMake(Gato_Width_320_(100), 0, Gato_Width_320_(220), Gato_Height);
    [self.view addSubview:self.rightTableView];
    self.updataArray = [NSMutableArray array];
    self.rightArray = [NSMutableArray array];
    self.row = 0;
    NSArray * leftArray = @[@"1~50 床",@"51～100 床",@"1～50 加床"];
    for (int i = 0 ; i < leftArray.count ; i ++) {
        [self.updataArray addObject:leftArray[i]];
        int star = 1;
        switch (i) {
            case 0:
                star = 1;
                break;
            case 1:
                star = 51;
                break;
            case 2:
                star = 1;
                break;
            default:
                break;
        }
        NSMutableArray * right = [NSMutableArray array];
        for (int j = star ; j < star + 50; j ++) {
            if (i < 2) {
                [right addObject:[NSString stringWithFormat:@"%d 床",j]];
            }else{
                [right addObject:[NSString stringWithFormat:@"加 %d 床",j]];
            }
        }
        [self.rightArray addObject:right];
    }
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.GatoTableview) {
        return 3;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;

    if (tableView == self.GatoTableview) {
        bedNumberLeftTableViewCell * cell = [bedNumberLeftTableViewCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor whiteColor];
        BOOL select = NO;
        if (indexPath.row == self.row) {
            select = YES;
        }
        [cell setValueWithName:self.updataArray[indexPath.row] WithIndexSelect:select];
        return cell;
    }else{
        bedNumberRightTableViewCell * cell = [bedNumberRightTableViewCell cellWithTableView:tableView];
        [cell setValueWithNameArray:self.rightArray[self.row]];
        cell.backgroundColor = [UIColor appAllBackColor];
        
        cell.CellBedNumberStrBlock = ^(NSString *betNumber) {
            if (weakSelf.bedNumberStrBlock) {
                weakSelf.bedNumberStrBlock(betNumber);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        return cell;
    }
   
    
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.GatoTableview) {
        return Gato_Height_548_(50);
    }
    NSArray * array = self.rightArray[self.row];
    CGFloat height = 0;
    height = array.count / 4 * Gato_Height_548_(50);
    if (array.count / 4 > 0) {
        height += Gato_Height_548_(100);
    }
    return height + Gato_Height_548_(10);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.GatoTableview) {
        self.row = indexPath.row;
        [self.GatoTableview reloadData];
        [self.rightTableView reloadData];
//        [self.rightTableView setContentOffset:CGPointMake(0,0) animated:NO];.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]init];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _rightTableView.tableFooterView = [[UIView alloc] init];
    }
    return _rightTableView;
}

@end
