//
//  searchHospitalizedViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/23.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "searchHospitalizedViewController.h"
#import "GatoBaseHelp.h"
#import "HospitalizedPatientsTableViewCell.h"
#import "patientInfoViewController.h"
#import "ModifyArticleViewController.h"
#import "PushMessageViewController.h"
#import "EaseMessageViewController.h"
#import "HospitalizedPatientInfoModel.h"
#import "ImMessageOneForOneViewController.h"
#import "PellTableViewSelect.h"
#import "HospitalizedDoctorsArrayModel.h"

@interface searchHospitalizedViewController ()<UIActionSheetDelegate,UITextFieldDelegate>
{
    CGFloat page;
}
@property (nonatomic ,strong) UIView * topView;
@property (nonatomic ,strong) UIView * searchView;
@property (nonatomic ,strong) UITextField * textfield;
@property (nonatomic ,strong) NSMutableArray * DoctorsArray;//筛选组
@property (nonatomic ,strong) NSString * NoSchuyuanId;//未手术出院患者id
@property (nonatomic ,strong) NSString * minecount;

@property (nonatomic ,strong) NSString * searchStr;
@end

@implementation searchHospitalizedViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newFrame];
    page = 0;
    self.DoctorsArray = [NSMutableArray array];
    self.updataArray = [NSMutableArray array];
    self.GatoTableview.frame = CGRectMake(0,  Gato_Height_548_(57), Gato_Width, Gato_Height - Gato_Height_548_(57));
    [self.view addSubview:self.GatoTableview];
    //下拉刷新
    self.GatoTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    //上拉刷新
    self.GatoTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    //自动更改透明度
    self.GatoTableview.mj_header.automaticallyChangeAlpha = YES;
    self.searchStr = @"";
    
}
//刷新
-(void)loadNewTopic
{
    page = 0;
    self.updataArray = [NSMutableArray array];
    [self updateHttpWithSearch:self.searchStr];
    [self.GatoTableview.mj_header beginRefreshing];
    [self.GatoTableview.mj_header setHidden:NO];
}
//加载更多
-(void)loadMoreTopic
{
    page ++;
    [self updateHttpWithSearch:self.searchStr];
    [self.GatoTableview.mj_footer resetNoMoreData];
    [self.GatoTableview.mj_footer setHidden:NO];
}


-(void)updateHttpWithSearch:(NSString *)search;
{
    if ([search isEqualToString:@"Gato_Nil"]) {
        [self.updataArray removeAllObjects];
        [self.GatoTableview reloadData];
        return;
    }
    if (search.length < 1) {
        [self showHint:@"请输入搜索内容"];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:search forKey:@"search"];
    [dic setObject:[NSString stringWithFormat:@"%.0f",page] forKey:@"page"];
    [IWHttpTool postWithURL:HD_patient_all params:dic success:^(id json) {
        if (page == 0) {
            [self.updataArray removeAllObjects];
        }
        if (self.searchStr.length < 1) {
            [self.updataArray removeAllObjects];
            [self.GatoTableview reloadData];
            return;
        }
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"patient"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:jsonArray[i]];
                [self.updataArray addObject:model];
            }
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                NSArray * doctorArray = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"group"];
                for (int i = 0 ; i < doctorArray.count; i ++) {
                    HospitalizedDoctorsArrayModel * model = [[HospitalizedDoctorsArrayModel alloc]init];
                    [model setValuesForKeysWithDictionary:doctorArray[i]];
                    [self.DoctorsArray addObject:model];
                }
            });
            
        }else{
            
        }
        [self.GatoTableview.mj_header endRefreshing];
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } WithFlash:NO];
}

-(void)deletePatientWithpatientCaseId:(NSString *)patientCaseId
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:patientCaseId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_patient_delete params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"删除成功"];
            self.updataArray = [NSMutableArray array];
            [self updateHttpWithSearch:self.searchStr];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)newFrame
{
    self.topView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(57));
    self.topView.backgroundColor = [UIColor HDThemeColor];
    
    
    self.searchView.sd_layout.leftSpaceToView(self.topView, Gato_Width_320_(15))
    .rightSpaceToView(self.topView, Gato_Width_320_(50))
    .topSpaceToView(self.topView, Gato_Height_548_(25))
    .heightIs(Gato_Height_548_(25));
    self.searchView.backgroundColor = [UIColor whiteColor];
    
    GatoViewBorderRadius(self.searchView, Gato_Height_548_(12.5), 1, [UIColor appAllBackColor]);
    
    
    self.textfield.sd_layout.leftSpaceToView(self.searchView, Gato_Width_320_(15))
    .rightSpaceToView(self.searchView, Gato_Width_320_(15))
    .topSpaceToView(self.searchView, 0)
    .heightIs(Gato_Height_548_(25));
    [self.textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton*right2Button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,Gato_Width_320_(30),Gato_Height_548_(18))];
    [right2Button setTitle:@"取消" forState:UIControlStateNormal];
    right2Button.titleLabel.font = FONT(30);
    [right2Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right2Button addTarget:self action:@selector(quxiaoButtonDidClicked)forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:right2Button];
    right2Button.sd_layout.rightSpaceToView(self.topView, Gato_Width_320_(15))
    .centerYEqualToView(self.searchView)
    .widthIs(Gato_Width_320_(30));
    
    
}
-(void)quxiaoButtonDidClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  点击搜索按钮-放在键盘上了
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (self.textfield.text.length > 0) {
        [self.view endEditing:YES];
        page = 0;
        self.updataArray = [NSMutableArray array];
        self.searchStr = textField.text;
        [self updateHttpWithSearch:self.searchStr];
    }
    if (self.textfield.text.length == 0) {
        return YES;
    }
    
    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    //-shouldChangeCharactersInRange gets called before text field actually changes its text, that's why you're getting old text value. To get the text after update use:
//    NSString * new_text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串
//    NSLog(@"%@",new_text_str);
//    if (new_text_str.length > 0 ) {
//        self.updataArray = [NSMutableArray array];
//        self.searchStr = new_text_str;
//        page = 0;
//        [self updateHttpWithSearch:self.searchStr];
//    }else{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.searchStr = @"";
//            [self updateHttpWithSearch:@"Gato_Nil"];
//        });
//    }
//    return YES;
//}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSString * new_text_str = theTextField.text;
    NSLog( @"text changed: %@", theTextField.text);
    if (new_text_str.length > 0 ) {
        self.updataArray = [NSMutableArray array];
        self.searchStr = new_text_str;
        page = 0;
        [self updateHttpWithSearch:self.searchStr];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.searchStr = @"";
            [self updateHttpWithSearch:@"Gato_Nil"];
        });
    }
}
-(void)mobanButton
{
    ModifyArticleViewController * vc = [[ModifyArticleViewController alloc]init];
    vc.type = @"0";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HospitalizedPatientsTableViewCell * cell = [HospitalizedPatientsTableViewCell cellWithTableView:tableView];
    HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
    if (self.updataArray != nil && self.updataArray.count != 0) {
    model = self.updataArray[indexPath.row];
    cell.ButtonBlock = ^(NSInteger row){
        switch (row) {
            case 0:
            {
                //医患沟通
                //环信ID:@"8001"
                //聊天类型:EMConversationTypeChat
                ImMessageOneForOneViewController *chatController = [[ImMessageOneForOneViewController alloc] initWithConversationChatter:model.patientEasemobId conversationType:EMConversationTypeChat];
                chatController.model = model;
                chatController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatController animated:YES];
            }
                break;
            case 1:
            {
                //出院
                self.NoSchuyuanId = model.patientCaseId;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将患者移入随访栏目？" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return ;
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self pushTheHospitalizedWithdiagnose:model.diagnose];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case 2:
            {
                //等待病理
                patientInfoViewController * vc = [[patientInfoViewController alloc]init];
                vc.comeForWhere = @"0";
                vc.type = @"1";
                vc.userId = model.patientCaseId;
                
                vc.returnBlock = ^(NSDictionary *dict) {
                    if ([[dict objectForKey:@"delete"] isEqualToString:@"1"]) {
                        [self.updataArray removeObjectAtIndex:indexPath.row];
                        [self.GatoTableview reloadData];
                    }else{
                        model.bedNumber = [dict objectForKey:@"bedNumber"];
                        model.caseNo = [dict objectForKey:@"caseNo"];
                        [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
                        [self.GatoTableview reloadData];
                    }
                };
                
                
                vc.hidesBottomBarWhenPushed = YES;
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    cell.pushBlock = ^{
        patientInfoViewController * vc = [[patientInfoViewController alloc]init];
        HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
        model = self.updataArray[indexPath.row];
        vc.userId = model.patientCaseId;
        vc.type = @"0";
        vc.returnBlock = ^(NSDictionary *dict) {
            if ([[dict objectForKey:@"delete"] isEqualToString:@"1"]) {
                [self.updataArray removeObjectAtIndex:indexPath.row];
                [self.GatoTableview reloadData];
            }
        };
        
        
        vc.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.MyPatientBlock = ^{
        [self setValueWithMinePatientWithpatientCaseId:model.patientCaseId];
    };
    
    [cell setValueWithModel:model];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(170);
}

#pragma mark - 未手术出院使用
-(void)pushTheHospitalizedWithdiagnose:(NSString *)diagnose
{
    diagnose = [NSString stringWithFormat:@"%@未手术",diagnose];
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.NoSchuyuanId forKey:@"patientCaseId"];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:diagnose forKey:@"lDiagnose"];

    [IWHttpTool postWithURL:HD_NoSurgery_Out params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            page = 0;
            self.updataArray = [NSMutableArray array];
            [self updateHttpWithSearch:self.searchStr];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    patientInfoViewController * vc = [[patientInfoViewController alloc]init];
//    HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
//    model = self.updataArray[indexPath.row];
//    vc.userId = model.patientCaseId;
//    vc.type = @"0";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
        model = self.updataArray[indexPath.row];
        [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"确定删除该患者？" success:^{
           [self deletePatientWithpatientCaseId:model.patientCaseId];
        } WithVC:self];
    }
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除\n患者";
}

#pragma mark - 标记成我的患者
- (void)setValueWithMinePatientWithpatientCaseId:(NSString *)patientCaseId
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:patientCaseId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_patient_Mine params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            for (int i = 0 ; i < self.updataArray.count ; i ++) {
                HospitalizedPatientInfoModel * model = [[HospitalizedPatientInfoModel alloc]init];
                model = self.updataArray[i];
                if ([model.patientCaseId isEqualToString:patientCaseId]) {
                    if ([model.ismine isEqualToString:@"0"]) {
                        self.minecount = [NSString stringWithFormat:@"%ld",[self.minecount integerValue] + 1];
                        model.ismine = @"1";
                    }else{
                        self.minecount = [NSString stringWithFormat:@"%ld",[self.minecount integerValue] - 1];
                        model.ismine = @"0";
                    }
                    [self.updataArray replaceObjectAtIndex:i withObject:model];
                    [self.GatoTableview reloadData];
                }
            }
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        //        [self.GatoTableview.mj_header endRefreshing];
        //        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _popupMenu = [YBPopupMenu showRelyOnView:textField titles:@[@"请勿输入除患者姓名外其他字段，符号，等表情，以免搜索不到您想查询的信息！"] icons:nil menuWidth:textField.bounds.size.width otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = self;
        popupMenu.showMaskView = NO;
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionBottom;
        popupMenu.maxVisibleCount = 1;
        popupMenu.itemHeight = 60;
        popupMenu.borderWidth = 1;
        popupMenu.fontSize = 12;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.borderColor = [UIColor brownColor];
        popupMenu.textColor = [UIColor brownColor];
    }];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_popupMenu dismiss];
}
*/

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_topView];
    }
    return _topView;
}

-(UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:_searchView];
    }
    return _searchView;
}
-(UITextField *)textfield
{
    if (!_textfield) {
        _textfield = [[UITextField alloc]init];
        _textfield.delegate = self;
        _textfield.placeholder = @"请输入搜索患者姓名";
        _textfield.font = FONT(26);
        _textfield.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        [self.searchView addSubview:_textfield];
    }
    return _textfield;
}

- (void)dealloc
{
    NSLog(@"释放了");
}

@end
