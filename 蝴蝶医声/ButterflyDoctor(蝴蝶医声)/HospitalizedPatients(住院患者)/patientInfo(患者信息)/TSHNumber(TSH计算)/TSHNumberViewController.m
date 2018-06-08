//
//  TSHNumberViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TSHNumberViewController.h"
#import "GatoBaseHelp.h"
#import "TSHNumberTableViewCell.h"
#import "TSHNumberTwoTableViewCell.h"
#import "SVProgressHUD.h"
@interface TSHNumberViewController ()
{
    CGFloat cellOneHeight;
    CGFloat cellTwoHeight;
    NSString * topInt;
    NSString * underInt;
    NSInteger NumberOne;
    NSInteger NumberTwo;
}
@property (nonatomic ,strong) NSString * tshStrOne;
@property (nonatomic ,strong) NSString * tshStrTwo;
@end

@implementation TSHNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    
    self.title = @"TSH数值";
    
    NumberOne = -1;
    NumberTwo = -1;
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
    NSString * getTSH;
    if ([self.tshStrOne isEqualToString:@"0"]) {
        if ([self.tshStrTwo isEqualToString:@"0"]) {
           getTSH = @"0.1~0.5";
        }else{
           getTSH = @"<0.1";
        }
    }else{
        if ([self.tshStrTwo isEqualToString:@"0"]) {
            getTSH = @"0.5~1.0";
        }else{
            getTSH = @"<0.1";
        }
    }
    
    if (self.tshStrOne.length > 0 && self.tshStrTwo.length > 0) {
        if (self.tshStrBlock) {
            self.tshStrBlock(getTSH,topInt,underInt);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.tshStrOne.length < 1) {
        [self showHint:@"请选择TSH"];
    }else{
        [self showHint:@"请选择DTC"];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TSHNumberTableViewCell * cell = [TSHNumberTableViewCell cellWithTableView:tableView];
        cellOneHeight = cell.height;
        cell.oneBlock = ^(NSInteger row){
            NumberOne = row;
//            if (self.tshStrOne) {
//                self.tshStrOne = [NSString stringWithFormat:@"%@,%ld",self.tshStrOne,row];
//            }else{
//                self.tshStrOne = [NSString stringWithFormat:@"%ld",row];
//            }
            self.tshStrOne = [NSString stringWithFormat:@"%ld",row];
            switch (row) {
                case 0:
                {
                    topInt = @"低";
                }
                    break;
                case 1:
                {
                    topInt = @"中";
                }
                    break;
                case 2:
                {
                    topInt = @"高";
                }
                    break;
                    
                default:
                    break;
            }
        };
        [cell setValueWithNumberButton:NumberOne];
        return cell;
    }else{
        TSHNumberTwoTableViewCell * cell = [TSHNumberTwoTableViewCell cellWithTableView:tableView];
        cellTwoHeight = cell.height;
        cell.twoBlock = ^(NSInteger row){
            self->NumberTwo = row;
//            if (self.tshStrTwo) {
//                self.tshStrTwo = [NSString stringWithFormat:@"%@,%ld",self.tshStrTwo,row];
//            }else{
//                self.tshStrTwo = [NSString stringWithFormat:@"%ld",row];
//            }
            self.tshStrTwo = [NSString stringWithFormat:@"%ld",row];
            switch (row) {
                case 0:
                {
                    self->underInt = @"低";
                }
                    break;
                case 1:
                {
                    self->underInt = @"中";
                }
                    break;
                case 2:
                {
                    self->underInt = @"高";
                }
                    break;
                    
                default:
                    break;
            }
        };
        [cell setValueWithNumberButton:NumberTwo];
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return cellOneHeight;
    }else{
        return cellTwoHeight;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
