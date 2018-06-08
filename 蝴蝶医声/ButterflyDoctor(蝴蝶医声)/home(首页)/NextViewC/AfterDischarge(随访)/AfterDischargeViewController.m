//
//  AfterDischargeViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/27.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AfterDischargeViewController.h"
#import "GatoBaseHelp.h"
#import "HospitalizedPatientsTableViewCell.h"
#import "patientInfoViewController.h"
#import "ModifyArticleViewController.h"
#import "WaitingSurgeryTableViewCell.h"
#import "AfterDischargeTableViewCell.h"
#import "AfterPatientInfoViewController.h"
#import "HospitalizedDoctorsArrayModel.h"
#import "AfterDischargeModel.h"
#import "ImMessageOneForOneViewController.h"
#import "PellTableViewSelect.h"
#import "searchAfterDischargeViewController.h"
#import "NulllabelModel.h"
#import "NullLabelTableViewCell.h"
#import "JGGHospitalizedPatientsCellTableViewCell.h"
#import "SUIFANGTableViewCell.h"
#import "pusNnllTableViewCell.h"
#import "SUIFANGTableViewCell.h"

#define kCellTag 10201705
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]
#define KTanChuKey [NSString stringWithFormat:@"%ld", indexPath.row + 70152]

@interface AfterDischargeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat page;
    NSString * topType;
    BOOL reloadHttp;//define NO ；block YES
    NSString* laoyutStr;//1是九宫格。0是列表
    NSInteger JGGnum;//标记点击的是那个view
}
@property (nonatomic ,strong) UIView * topView;//筛选view
@property (nonatomic ,strong) UIButton * quanbuButton;
@property (nonatomic ,strong) UIButton * nameButton;
@property (nonatomic ,strong) UIButton * MyHuanzheButton;//未回复按钮
@property (nonatomic ,strong) UIButton * numberButton;

@property (nonatomic ,strong) NSMutableArray * DoctorsArray;//筛选组
@property (nonatomic ,assign) NSInteger AllDoctoresArrayCount;//全部筛选组的数量
@property (nonatomic ,strong) NSString * doctorId;//根据组长id筛选
@property (nonatomic ,strong) NSString * sort;//根据排序筛选

@property (nonatomic ,strong) NSMutableDictionary * cellHeightDic;
@property (nonatomic ,strong) UITableView* pushTableView;// 九宫格弹出tableView
@end

@implementation AfterDischargeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!reloadHttp) {
        page = 0;
        [self updateHttp];
    }
    reloadHttp = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"随访";
    topType = @"0";
    [self newFrame];
    page = 0;
    laoyutStr=@"0";
    self.GatoTableview.frame = CGRectMake(0,  Gato_Height_548_(39), Gato_Width, Gato_Height - Gato_Height_548_(39) - NAV_BAR_HEIGHT);
    [self.view addSubview:self.GatoTableview];
    self.doctorId = @"";
    self.sort = @"";
    self.DoctorsArray = [NSMutableArray array];
    self.cellHeightDic = [NSMutableDictionary dictionary];
    [self updateHttp];
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
    [self updateHttp];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    page ++;
    [self updateHttp];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}

-(void)updateHttp{
    self.AllDoctoresArrayCount = 0;
    self.DoctorsArray = [NSMutableArray array];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    if (self.doctorId.length > 0) {
        [dic setObject:self.doctorId forKey:@"doctorId"];
    }
    if (self.sort.length > 0) {
        [dic setObject:self.sort forKey:@"sort"];
    }
    [dic setObject:topType forKey:@"mypatient"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    Gato_WeakSelf(self)
    [IWHttpTool postWithURL:HD_Home_visit_All params:dic success:^(id json) {
        if (self->page == 0)
        {
            weakself.updataArray = [NSMutableArray array];
            weakself.DoctorsArray = [NSMutableArray array];
            weakself.AllDoctoresArrayCount = 0;
        }
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"patient"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                AfterDischargeModel * model = [[AfterDischargeModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }

                NSArray * doctorArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"group"];
                for (int i = 0 ; i < doctorArray.count; i ++) {
                    HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
                    [model setValuesForKeysWithDictionary:doctorArray[i]];
                    if([self.quanbuButton.titleLabel.text rangeOfString:model.name].location !=NSNotFound)//_roaldSearchText
                    {
                        [self.quanbuButton setTitle:[NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]] forState:UIControlStateNormal];
                    }
                    model.name = [NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]];
                    self.AllDoctoresArrayCount += [[doctorArray[i] objectForKey:@"count"] integerValue];
                    [self.DoctorsArray addObject:model];

            }
            if([self.quanbuButton.titleLabel.text rangeOfString:@"全部"].location !=NSNotFound)//_roaldSearchText
            {
                [self.quanbuButton setTitle:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount] forState:UIControlStateNormal];
            }
            NSString * minecount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"minecount"];
            if (minecount.length > 0) {
                [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(%@)",minecount] forState:UIControlStateNormal];
            }else{
                [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(0)"] forState:UIControlStateNormal];
            }
        }else if([success isEqualToString:@"404"]){

                NSArray * doctorArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"group"];
                for (int i = 0 ; i < doctorArray.count; i ++) {
                    HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
                    [model setValuesForKeysWithDictionary:doctorArray[i]];
                    if([self.quanbuButton.titleLabel.text rangeOfString:model.name].location !=NSNotFound)//_roaldSearchText
                    {
                        [self.quanbuButton setTitle:[NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]] forState:UIControlStateNormal];
                    }
                    model.name = [NSString stringWithFormat:@"%@(%@)",[doctorArray[i] objectForKey:@"name"],[doctorArray[i] objectForKey:@"count"]];
                    self.AllDoctoresArrayCount += [[doctorArray[i] objectForKey:@"count"] integerValue];
                    [self.DoctorsArray addObject:model];

            }
            if([self.quanbuButton.titleLabel.text rangeOfString:@"全部"].location !=NSNotFound)//_roaldSearchText
            {
                [self.quanbuButton setTitle:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount] forState:UIControlStateNormal];

            }
            NSString * minecount = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"minecount"];
            if (minecount.length > 0) {
                [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(%@)",minecount] forState:UIControlStateNormal];
            }else{
                [self.MyHuanzheButton setTitle:[NSString stringWithFormat:@"我的患者(0)"] forState:UIControlStateNormal];
            }
            if (self.updataArray.count > 0) {
                if (![self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
                    [self showHint:@"没有更多数据了哦～"];
                }
            }else{
                NulllabelModel * model = [[NulllabelModel alloc]init];
                model.label = @"当前您还没有随访患者";
                [self.updataArray addObject:model];
            }

        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(void)newFrame
{
    self.topView.sd_layout.leftSpaceToView(self.view,-1)
    .rightSpaceToView(self.view,-1)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(39));
    
    GatoViewBorderRadius(self.topView, 0, 0.5, [UIColor HDViewBackColor]);
    
    self.quanbuButton.sd_layout.leftSpaceToView(self.topView,0)
    .topSpaceToView(self.topView,0)
    .widthIs(Gato_Width / 3)
    .bottomSpaceToView(self.topView,0);
    
    self.MyHuanzheButton.sd_layout.leftSpaceToView(self.quanbuButton,0)
    .topSpaceToView(self.topView,0)
    .widthIs(Gato_Width / 3)
    .bottomSpaceToView(self.topView,0);
    
    self.numberButton.sd_layout.leftSpaceToView(self.MyHuanzheButton,0)
    .topSpaceToView(self.topView,0)
    .widthIs(Gato_Width / 3)
    .bottomSpaceToView(self.topView,0);
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3)
    .topSpaceToView(self.topView,Gato_Height_548_(8))
    .widthIs(1)
    .heightIs(Gato_Height_548_(27));
    
    UIView * fgx1 = [[UIView alloc]init];
    fgx1.backgroundColor = [UIColor appAllBackColor];
    [self.topView addSubview:fgx1];
    fgx1.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3 * 2)
    .topSpaceToView(self.topView,Gato_Height_548_(8))
    .widthIs(1)
    .heightIs(Gato_Height_548_(27));
    
    
//    UIView * fgx1 = [[UIView alloc]init];
//    fgx1.backgroundColor = [UIColor appAllBackColor];
//    [self.topView addSubview:fgx1];
//    fgx1.sd_layout.leftSpaceToView(self.topView,Gato_Width / 3 * 2)
//    .topSpaceToView(self.topView,Gato_Height_548_(8))
//    .widthIs(1)
//    .heightIs(Gato_Height_548_(27));
    
    UIButton*right1Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [right1Button setBackgroundImage:[UIImage imageNamed:@"HZLBJGG"] forState:UIControlStateNormal];
    right1Button.titleLabel.font = FONT(30);
    [right1Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right1Button addTarget:self action:@selector(mobanButton:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:right1Button];
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(17),Gato_Height_548_(18))];
    [right2Button setBackgroundImage:[UIImage imageNamed:@"nav_seek"] forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(searchButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:right2Button];
    self.navigationItem.rightBarButtonItems = @[rightItem2,rightItem1];
}
//九宫格列表切换
-(void)mobanButton:(UIButton*)sender
{
    if ([laoyutStr isEqual:@"1"]) {
        laoyutStr=@"0";
        [sender setBackgroundImage:[UIImage imageNamed:@"HZLBJGG"] forState:UIControlStateNormal];
    }
    else
    {
        laoyutStr=@"1";
        [sender setBackgroundImage:[UIImage imageNamed:@"HZLB"] forState:UIControlStateNormal];
    }
    [self.GatoTableview reloadData];
}
//-(void)mobanButton
//{
//    ModifyArticleViewController * vc = [[ModifyArticleViewController alloc]init];
//    vc.type = @"1";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}
-(void)searchButton
{
    searchAfterDischargeViewController * vc = [[searchAfterDischargeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    reloadHttp = NO;
}
#pragma mark - 入院时间
-(void)paixuButton:(UIButton *)sender
{
    self.sort = @"beginTime";
    topType = @"0";
    [self.nameButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.numberButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.updataArray = [NSMutableArray array];
    [self updateHttp];
}
-(void)quanbuButtonButton:(UIButton *)sender
{
    NSMutableArray * nameArray = [NSMutableArray array];
    topType = @"0";
    [self.nameButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.numberButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    [nameArray addObject:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount]];
    for (int i = 0 ; i < self.DoctorsArray.count ; i ++) {
        HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
        model = self.DoctorsArray[i];
        [nameArray addObject:model.name];
    }
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(0, Gato_Height_548_(39) + NAV_BAR_HEIGHT, Gato_Width, 40 * nameArray.count) selectData:nameArray action:^(NSInteger index) {
        NSLog(@"点击第%ld个小组",index);
        if (index == 0) {
            self.doctorId = @"";
            [self.quanbuButton setTitle:[NSString stringWithFormat:@"全部(%ld)",self.AllDoctoresArrayCount] forState:UIControlStateNormal];
        }else{
            HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
            model = self.DoctorsArray[index - 1];
            self.doctorId = model.doctorId;
            [self.quanbuButton setTitle:model.name forState:UIControlStateNormal];
        }
        self.updataArray = [NSMutableArray array];
        self->page = 0;
        [self updateHttp];
    } animated:YES];
}
- (void)myHuanZheButtonButton:(UIButton *)sender
{
    topType = @"1";
    [self.nameButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.numberButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.updataArray = [NSMutableArray array];
    page = 0;
    [self updateHttp];
}

#pragma mark - 出院时间
-(void)binganhaoButton:(UIButton *)sender
{
    self.sort = @"endTime";
    topType = @"0";
    [self.nameButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.numberButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.updataArray = [NSMutableArray array];
    page = 0;
    [self updateHttp];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    //    判断是否是九宫格弹出view
    if (tableView==_pushTableView)
    {
        return 3;
    }
    else
    {
    if ([laoyutStr isEqual:@"1"])
    {
        if (self.updataArray.count<3) {
            return 1;
        }
        else
        {
            int num=(int)self.updataArray.count/3;
            if (num%3>0)
            {
                return num+1;
            }
            else
            {
                return num;
            }
        }
    }
    else
    {
        return self.updataArray.count;
    }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_pushTableView)
    {
        if (indexPath.row==1) {
             Gato_WeakSelf(self)
            SUIFANGTableViewCell * cell = [SUIFANGTableViewCell cellWithTableView:tableView];
            AfterDischargeModel * model = [[AfterDischargeModel alloc]init];
            model = self.updataArray[JGGnum];
            cell.ButtonBlock = ^(NSInteger row){
                 [weakself.pushTableView removeFromSuperview];
                switch (row) {
                    case 0:
                    {
                        //医患沟通
                        ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:model.patientEasemobId conversationType:EMConversationTypeChat];
                        chatController.afterModel = model;
                        chatController.hidesBottomBarWhenPushed = YES;
                        [weakself.navigationController pushViewController:chatController animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //信息
                        AfterPatientInfoViewController * vc = [[AfterPatientInfoViewController alloc]init];
                        vc.patientCaseId = model.patientCaseId;
                        [weakself.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                     
                        [weakself.pushTableView removeFromSuperview];
                    }
                        break;
                    default:
                        break;
                }
            };
            [cell setValueWithModel:model];
            NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
            [self.cellHeightDic setValue:value forKey:KTanChuKey];
            return cell;
        }
        else
        {
            pusNnllTableViewCell * cell = [pusNnllTableViewCell cellWithTableView:tableView];
            
            return cell;
        }
     
    }
    else
    {
    
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        NullLabelTableViewCell * cell  = [NullLabelTableViewCell cellWithTableView:tableView];
        NulllabelModel * model = [[NulllabelModel alloc]init];
        model = self.updataArray[0];
        [cell setValueWithModel:model];
        return cell;
    }else{
        
        if ([laoyutStr isEqual:@"1"])
        {
            JGGHospitalizedPatientsCellTableViewCell* JGGcell=[JGGHospitalizedPatientsCellTableViewCell cellWithTableView:tableView];
//            在随访页面九宫格调这个方法传数据
            [JGGcell setValueWithSuiFangArray:self.updataArray andIndex:indexPath];
            JGGcell.tapPush = ^(NSInteger row)
            {
                NSLog(@"%ld",(long)row);
                //            九宫格弹出view
                [self pusView:row];
            };
            return JGGcell;
        }
        else
        {
        AfterDischargeTableViewCell * cell = [AfterDischargeTableViewCell cellWithTableView:tableView];
        AfterDischargeModel * model = [[AfterDischargeModel alloc]init];
        model = self.updataArray[indexPath.row];
        Gato_WeakSelf(self);
        cell.ButtonBlock = ^(NSInteger row){
            switch (row) {
                case 0:
                {
                    //医患沟通
                    ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:model.patientEasemobId conversationType:EMConversationTypeChat];
                    chatController.afterModel = model;
                    chatController.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController pushViewController:chatController animated:YES];
                }
                    break;
                case 1:
                {
                    //信息
                    AfterPatientInfoViewController * vc = [[AfterPatientInfoViewController alloc]init];
                    vc.patientCaseId = model.patientCaseId;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //召回患者
                    
                }
                    break;
                default:
                    break;
            }
        };
        [cell setValueWithModel:model];
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [self.cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }
    }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_pushTableView)
    {
        if (indexPath.row==1) {
            NSNumber *value = [self.cellHeightDic objectForKey:KTanChuKey];
            CGFloat height = value.floatValue;
            if (height < 1) {
                height = 1;
            }
            return height;
//          return Gato_Height_548_(200);
        }
        else if(indexPath.row==0)
        {
            return Gato_Height_548_(170);
        }
        else
        {
            return Gato_Height_548_(500);
        }
    }
    else
    {
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]) {
        return [NullLabelTableViewCell getHeightWithNullCellWithTableview:tableView];
    }
    else
    {
        if ([laoyutStr isEqual:@"1"])
        {
            return Gato_Height_548_(115);;
        }
        else
        {
            NSNumber *value = [self.cellHeightDic objectForKey:kHuShenKey];
            CGFloat height = value.floatValue;
            if (height < 1) {
                height = 1;
            }
            return height;
        }
    }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.updataArray[0] isKindOfClass:[NulllabelModel class]]){
        return NO;
    }else{
        return YES;
    }
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"召回患者");
    AfterDischargeModel * model = [[AfterDischargeModel alloc]init];
    if (tableView==_pushTableView)
    {
        [self.pushTableView removeFromSuperview];
        model = self.updataArray[JGGnum];
    }
    else
    {
        model = self.updataArray[indexPath.row];
    }
  
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否召回患者到上一阶段？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self zhaohuiUpdateWithpatientCaseId:model.patientCaseId];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"召回\n患者";
}
#pragma makr - 召回患者
-(void)zhaohuiUpdateWithpatientCaseId:(NSString *)patientCaseId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:patientCaseId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_Home_visit_ComeBefore params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            self->page = 0;
            self.updataArray = [NSMutableArray array];
            [self updateHttp];
            [self showHint:@"召回成功"];
        }else{
            
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topView];
    }
    return _topView;
}
-(UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _nameButton.titleLabel.font = FONT(28);
        [_nameButton setTitle:@"入院时间" forState:UIControlStateNormal];
        [_nameButton addTarget:self action:@selector(paixuButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self.topView addSubview:_nameButton];
        
    }
    return _nameButton;
}
-(UIButton *)numberButton
{
    if (!_numberButton) {
        _numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_numberButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _numberButton.titleLabel.font = FONT(28);
        [_numberButton setTitle:@"出院时间" forState:UIControlStateNormal];
        [_numberButton addTarget:self action:@selector(binganhaoButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_numberButton];
        
    }
    return _numberButton;
}
-(UIButton *)quanbuButton
{
    if (!_quanbuButton) {
        _quanbuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quanbuButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _quanbuButton.titleLabel.font = FONT(28);
        [_quanbuButton setTitle:@"全部" forState:UIControlStateNormal];
        [_quanbuButton addTarget:self action:@selector(quanbuButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_quanbuButton];
        
    }
    return _quanbuButton;
}
- (UIButton *)MyHuanzheButton
{
    if (!_MyHuanzheButton) {
        _MyHuanzheButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MyHuanzheButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        _MyHuanzheButton.titleLabel.font = FONT(28);
        [_MyHuanzheButton setTitle:@"我的患者" forState:UIControlStateNormal];
        [_MyHuanzheButton addTarget:self action:@selector(myHuanZheButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:_MyHuanzheButton];
        
    }
    return _MyHuanzheButton;
}
//九宫格view弹出
-(void)pusView:(NSInteger)row
{
    JGGnum=row;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    _pushTableView=[[UITableView alloc]initWithFrame:win.frame style:UITableViewStylePlain];
    _pushTableView.delegate = self;
    _pushTableView.dataSource = self;
    _pushTableView.showsVerticalScrollIndicator = NO;
    _pushTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _pushTableView.tableFooterView = [[UIView alloc] init];
    _pushTableView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
    _pushTableView.scrollEnabled = NO;
    [win addSubview:_pushTableView];
    [_pushTableView reloadData];
    
}
@end
