//
//  DoctorHomeViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "DoctorHomeViewController.h"
#import "GatoBaseHelp.h"
#import "DoctorHomeImageTableViewCell.h"
#import "DoctorHomeGoodTableViewCell.h"
#import "DoctorTitleAndMoreTableViewCell.h"
#import "DoctorHomeCommentsTableViewCell.h"
#import "TheArticleTableViewCell.h"
#import "DoctorHomeInfoMessageTableViewCell.h"
#import "DoctorHomePingjiaModel.h"
#import "DoctorHomeInfoDataModel.h"
#import "WebArticleViewController.h"

#define PLCellTag 4281419000
#define PLHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + PLCellTag]

#define kCellTag 100425111
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

#import "AllCommentsViewController.h"
#import "AllDoctorTitleViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface DoctorHomeViewController ()
{
    CGFloat cellHeightWithGood;
    NSString * GoodCellZhankai;
    NSMutableDictionary * PLCellHeight;
    NSMutableDictionary * cellHeightDic;
    CGFloat cellHeightInfo;
    DoctorHomeInfoDataModel * Datamodel;
}
@property (nonatomic ,strong) UIImageView * topUnderImage;//上方半圆背景
@property (nonatomic ,strong) NSMutableArray * pingjiaArray;
@property (nonatomic ,strong) NSMutableArray * wenzhangArray;
@property (nonatomic ,strong) NSString * personDataStr;
@end

@implementation DoctorHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"医生信息";
    self.topUnderImage.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(100));
    GoodCellZhankai = @"0";
    PLCellHeight = [NSMutableDictionary dictionary];
    cellHeightDic = [NSMutableDictionary dictionary];
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    Gato_TableView
    self.GatoTableview.backgroundColor = [UIColor clearColor];
 
    
    self.pingjiaArray = [NSMutableArray array];
    self.wenzhangArray = [NSMutableArray array];
    self.updataArray = [NSMutableArray array];
    
    if (self.doctorId) {
        [self updata];
    }else{
        for (int i =0 ; i < 10; i ++) {
            TheArticleModel * model = [[TheArticleModel alloc]init];
            model.type = [NSString stringWithFormat:@" "];
            model.title = @" ";
            model.time = @"2017.01.01发表";
            model.yinyong = @"0引用";
            model.yuedu = @"0阅读";
            model.zhiding = @"0";
            [self.updataArray addObject:model];
        }
        for (int i =0 ; i < 3; i ++) {
            [self.pingjiaArray addObject:@""];
            [self.wenzhangArray addObject:@""];
        }
    }
    
}
-(void)updata
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.doctorId forKey:@"doctorId"];
//    __weak __typeof(self) weakSelf = self;
    [IWHttpTool postWithURL:HD_Doctor_home params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * array = [[dic objectForKey:@"data"] objectForKey:@"info"];
            if (array.count < 1) {
                return ;
            }
            self->Datamodel = [[DoctorHomeInfoDataModel alloc]init];
            [self->Datamodel setValuesForKeysWithDictionary:[[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"doctorData"]];
            NSArray * articleArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"articleData"];
            for (int i = 0; i < articleArray.count ; i ++) {
                TheArticleModel * model = [[TheArticleModel alloc]init];
                [model setValuesForKeysWithDictionary:articleArray[i]];
                [self.wenzhangArray addObject:model];
            }
            
            NSArray * commentDataArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"commentData"];
            for (int i = 0; i < commentDataArray.count ; i ++) {
                DoctorHomePingjiaModel * model = [[DoctorHomePingjiaModel alloc]init];
                [model setValuesForKeysWithDictionary:commentDataArray[i]];
                [self.pingjiaArray addObject:model];
            }
//            [weakSelf.model setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            
            self.personDataStr = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"personData"];
            [self.GatoTableview reloadData];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5 + self.pingjiaArray.count  + self.wenzhangArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DoctorHomeImageTableViewCell * cell = [DoctorHomeImageTableViewCell cellWithTableView:tableView];
        Datamodel.paiming = self.paiming;
        Datamodel.paimingNumber = self.paimingNumber;
        [cell setValueWithModel:Datamodel];
        return cell;
    }else if (indexPath.row == 1){
        DoctorHomeGoodTableViewCell * cell = [DoctorHomeGoodTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:ModelNull(Datamodel.speciality)  WithZhankai:GoodCellZhankai];
        cell.zhankaiBlock = ^(){
            if ([GoodCellZhankai isEqualToString:@"0"]) {
                GoodCellZhankai = @"1";
            }else{
                GoodCellZhankai = @"0";
            }
            [self.GatoTableview reloadData];
        };
        cellHeightWithGood = cell.height;
        return cell;
    }else if (indexPath.row == 2){
        DoctorTitleAndMoreTableViewCell * cell = [DoctorTitleAndMoreTableViewCell cellWithTableView:tableView];
        [cell setValueWithImage:@"honor_icon_smiling-face" WithTitle:@"患者评价" WithMoreStr:@"全部"];
        cell.buttonBlock = ^(){
            AllCommentsViewController * vc = [[AllCommentsViewController alloc]init];
            vc.doctorId = self.doctorId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.row < self.pingjiaArray.count + 3){
        DoctorHomeCommentsTableViewCell * cell = [DoctorHomeCommentsTableViewCell cellWithTableView:tableView];

        DoctorHomePingjiaModel * model = [[DoctorHomePingjiaModel alloc]init];
        model = self.pingjiaArray[indexPath.row - 3];
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.height];
        [PLCellHeight setValue:value forKey:PLHuShenKey];
        return cell;
    }else if (indexPath.row == self.pingjiaArray.count + 3){
        DoctorTitleAndMoreTableViewCell * cell = [DoctorTitleAndMoreTableViewCell cellWithTableView:tableView];
        [cell setValueWithImage:@"honor_icon_text" WithTitle:@"发表文章" WithMoreStr:@"更多"];
        cell.buttonBlock = ^(){
            AllDoctorTitleViewController * vc = [[AllDoctorTitleViewController alloc]init];
            vc.doctorId = self.doctorId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else if (indexPath.row < self.pingjiaArray.count + 4 +self.wenzhangArray.count){ //应该是 < 上方总数量 + 数组数量
        TheArticleTableViewCell * cell = [TheArticleTableViewCell cellWithTableView:tableView];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.wenzhangArray[indexPath.row - self.pingjiaArray.count - 4];
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }else if (indexPath.row == self.pingjiaArray.count + 4 +self.wenzhangArray.count){
        DoctorHomeInfoMessageTableViewCell * cell = [DoctorHomeInfoMessageTableViewCell cellWithTableView:tableView];
        if (self.personDataStr) {
            [cell setValueWithModel:self.personDataStr];
        }else{
            [cell setValueWithModel:@""];
        }
        
        cellHeightInfo = cell.height;
        return cell;
    }
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return Gato_Height_548_(185);
    }else if (indexPath.row == 1){
        return cellHeightWithGood;
    }else if (indexPath.row == 2){
        return Gato_Height_548_(50);
    }else if (indexPath.row < self.pingjiaArray.count + 3){
        NSNumber *value = [PLCellHeight objectForKey:PLHuShenKey];
        CGFloat height = value.floatValue;
        if (height < 1) {
            height = 1;
        }
        return height;
    }else if (indexPath.row == self.pingjiaArray.count + 3){
        return Gato_Height_548_(50);
    }else if (indexPath.row < self.pingjiaArray.count + 4 +self.wenzhangArray.count){
        NSNumber *value = [cellHeightDic objectForKey:kHuShenKey];
        CGFloat height = value.floatValue;
        if (height < 1) {
            height = 1;
        }
        return height;
    }else if (indexPath.row == self.pingjiaArray.count + 4 +self.wenzhangArray.count){
        return cellHeightInfo;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.pingjiaArray.count + 3){
        
    }else if (indexPath.row < self.pingjiaArray.count + 4 + self.wenzhangArray.count){ //应该是 < 上方总数量 + 数组数量
        WebArticleViewController * vc = [[WebArticleViewController alloc]init];
        TheArticleModel * model = [[TheArticleModel alloc]init];
        model = self.wenzhangArray[indexPath.row - self.pingjiaArray.count - 4];
        vc.articleId = model.articleId;
        vc.isOwner = model.isOwner;
        vc.titleStr = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row >= self.pingjiaArray.count + 4 +self.wenzhangArray.count){
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView * )topUnderImage
{
    if (!_topUnderImage) {
        _topUnderImage = [[UIImageView alloc]init];
        _topUnderImage.image = [UIImage imageNamed:@"mine_bg_head-portrait"];
        [self.view addSubview:_topUnderImage];
    }
    return _topUnderImage;
}

@end
