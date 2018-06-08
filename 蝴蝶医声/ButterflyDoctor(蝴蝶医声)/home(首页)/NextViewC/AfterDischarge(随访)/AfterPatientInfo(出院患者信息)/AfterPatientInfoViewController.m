//
//  AfterPatientInfoViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AfterPatientInfoViewController.h"
#import "GatoBaseHelp.h"
#import "patientInfoImageTableViewCell.h"
#import "AfterPatientInfoDataOneTableViewCell.h"
#import "AfterPatientInfoTwoTableViewCell.h"
#import "AfterPatientInfoThreeTableViewCell.h"
#import "patientInfoNoteModel.h"
#import "ZYBrowerView.h"
@interface AfterPatientInfoViewController ()
{
    CGFloat cellHeightForTwo;
    CGFloat cellHeightForThree;
    CGFloat cellHeightForOne;
}
@property (nonatomic ,strong) patientInfoNoteModel * noteModel;//病床／备注model
@property (nonatomic ,strong) UIImageView * topUnderImage;
@end

@implementation AfterPatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    
//    self.navigationController
    
    self.topUnderImage.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(65));
    
    self.noteModel = [[patientInfoNoteModel alloc]init];
    Gato_TableView
    self.GatoTableview.backgroundColor = [UIColor clearColor];
    self.title = @"患者信息";
    
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    if (self.patientCaseId) {
        [self update];
    }
    
}
-(void)update
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.patientCaseId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_patient_info params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            [self.noteModel setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];

        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf =self;
    if (indexPath.row == 0) {
        patientInfoImageTableViewCell * cell = [patientInfoImageTableViewCell cellWithTableView:tableView];
        [cell setValueWithImageUrl:self.noteModel.photo];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if (indexPath.row == 1){
        AfterPatientInfoDataOneTableViewCell * cell = [AfterPatientInfoDataOneTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:self.noteModel];
        cellHeightForOne = cell.height;
        return cell;
    }else if (indexPath.row == 2){
        AfterPatientInfoTwoTableViewCell * cell = [AfterPatientInfoTwoTableViewCell cellWithTableView:tableView];
        [cell setvalueWithImageArray:self.noteModel];
        cell.imageButtonBlock = ^(NSInteger row) {
//            [GatoMethods amplificationImageWithPicUrl:self.noteModel.sImg[row]];
            ZYBrowerView *browerView = [[ZYBrowerView alloc] initWithFrame:[UIScreen mainScreen].bounds imagesUrlAry:weakSelf.noteModel.sImg currentIndex:row];
            [browerView show];
        };
        cellHeightForTwo = cell.height;
        return cell;
    }else if (indexPath.row == 3){
        AfterPatientInfoThreeTableViewCell * cell = [AfterPatientInfoThreeTableViewCell cellWithTableView:tableView];
        [cell setvalueWithImageArray:self.noteModel];
        cell.imageButtonBlock = ^(NSInteger row) {
            ZYBrowerView *browerView = [[ZYBrowerView alloc] initWithFrame:[UIScreen mainScreen].bounds imagesUrlAry:weakSelf.noteModel.lImg currentIndex:row];
            [browerView show];
        };
        cellHeightForThree = cell.height;
        return cell;
    }
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return Gato_Height_548_(110);
    }else if (indexPath.row == 1){
        return cellHeightForOne;
    }else if (indexPath.row ==  2){
        return cellHeightForTwo;
    }else if (indexPath.row == 3){
        return cellHeightForThree;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIImageView * )topUnderImage
{
    if (!_topUnderImage) {
        _topUnderImage = [[UIImageView alloc]init];
        _topUnderImage.image = [UIImage imageNamed:@"inpatient_image_bg-background"];
        [self.view addSubview:_topUnderImage];
    }
    return _topUnderImage;
}

@end
