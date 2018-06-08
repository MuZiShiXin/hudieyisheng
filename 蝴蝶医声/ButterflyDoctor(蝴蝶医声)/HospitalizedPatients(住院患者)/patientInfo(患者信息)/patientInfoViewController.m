//
//  patientInfoViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "patientInfoViewController.h"
#import "GatoBaseHelp.h"
#import "HospitalizedPatientsTableViewCell.h"
#import "patientInfoImageTableViewCell.h"
#import "patientInformationTableViewCell.h"
#import "patientInfoNoteTableViewCell.h"
#import "patientInfoSurgeryMessageTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "patientInfoOverTableViewCell.h"
#import "patientInfoNoteModel.h"
#import "OperationMethodViewController.h"
#import "OperationmethodModel.h"
#import "PushMessageViewController.h"
#import "hospitalDiagnosisViewController.h"
#import "TSHNumberViewController.h"
#import "YBPopupMenu.h"
#import "bedNumberViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import "JZAlbumViewController.h"
#import "LKBubble.h"
#import "SQXXTableViewCell.h"
#import "CZHAlertView.h"
#import "CZHHeader.h"

#define ACellTag 10201333
#define AHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + ACellTag]

#define BCellTag 10201444
#define BHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + BCellTag]
@interface patientInfoViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,UIScrollViewDelegate>
{
   
    NSMutableDictionary * cellHeightWith3;//术中信息
    NSMutableDictionary * cellHeightWith4;//出院信息
    UIActionSheet * tshSheet;\
    NSString * tshTopInt;
    NSString * tshUnderInt;
    NSString * BqingStr;//病情 良性 恶性
    NSString * jiaozhanxianYesOrNOSr;//是否是甲状腺
    UIActionSheet* exingSheet;//恶性选择弹出
}

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;
@property (nonatomic ,strong) patientInfoNoteModel * noteModel;//病床／备注model
@property (nonatomic ,strong) UIImageView * topUnderImage;//上方半圆背景

@property (nonatomic,strong) NSMutableArray* shuqainArray;//术前照片

@property (nonatomic ,strong) NSMutableArray * surgeryArray;//术中照片
@property (nonatomic ,strong) NSString * surgeryStr;//术中-手术方式
@property (nonatomic ,strong) NSMutableArray * surgeryDicArray;//术中信息DicArray;

@property (nonatomic ,strong) NSMutableArray * overImageArray;//出院照片
@property (nonatomic ,strong) NSString * overTSHStr;//出院TSH
@property (nonatomic ,strong) NSString * overMessageStr;//出院诊断
@property (nonatomic ,strong) NSMutableArray * overDianDicArray;//碘 dic
@property (nonatomic ,strong) NSString* buttonState;//1 术前 2 术中 3 出院
@property (nonatomic, strong) YBPopupMenu *popupMenu;
@property (nonatomic ,assign) BOOL updateImage;//defone NO
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic,strong)  NSMutableArray* BRAFArray;


@end

@implementation patientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return    
    self.view.backgroundColor = [UIColor appAllBackColor];
    self.title = @"完善患者信息";
    [self addOtherView];
    
    //上方半圆背景
    self.topUnderImage.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(65));
    
    self.updateImage = NO;
    BqingStr=@"良性";
    jiaozhanxianYesOrNOSr=@"良性";
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT );
    self.GatoTableview.scrollsToTop = NO;
    [self.view addSubview:self.GatoTableview];
    self.GatoTableview.backgroundColor = [UIColor clearColor];
    
    cellHeightWith3 = [NSMutableDictionary dictionary];
    cellHeightWith4 = [NSMutableDictionary dictionary];
    
    self.shuqainArray =[NSMutableArray array];//术前照片数组
    self.surgeryArray = [NSMutableArray array];//术中照片数组
    self.overImageArray = [NSMutableArray array];//出院照片数组
    
    
    self.surgeryDicArray = [NSMutableArray array];
    self.overDianDicArray = [NSMutableArray array];
    self.BRAFArray=[NSMutableArray array];
    self.noteModel = [[patientInfoNoteModel alloc]init];
    
    if (self.comeForWhere) {
        if ([self.comeForWhere isEqualToString:@"1"]) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [[self GatoTableview]scrollToRowAtIndexPath:scrollIndexPath        atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if ([self.comeForWhere isEqualToString:@"2"]){
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [[self GatoTableview]scrollToRowAtIndexPath:scrollIndexPath        atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if ([self.comeForWhere isEqualToString:@"0"] && [self.type isEqualToString:@"1"]){
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [[self GatoTableview]scrollToRowAtIndexPath:scrollIndexPath        atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
//    获取住院患者信息
    [self update];
}
-(void)update
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:TOKEN forKey:@"token"];
    [dic setObject:self.userId forKey:@"patientCaseId"];
    [IWHttpTool postWithURL:HD_patient_info params:dic success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            [self.noteModel setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            [self updateAddsurgeryDicArray];
            [self updateAddoverDianDicArray];
            for (int i = 0 ; i < self.noteModel.sImg.count ; i ++) {
                [self.surgeryArray addObject:self.noteModel.sImg[i]];
            }
            for (int i = 0 ; i < self.noteModel.lImg.count ; i ++) {
                [self.overImageArray addObject:self.noteModel.lImg[i]];
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
-(void)addOtherView
{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(overButton)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    //自定义一个NaVIgationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
#pragma mark - 加载历史信息
-(void)updateAddsurgeryDicArray
{
    self.surgeryDicArray = [NSMutableArray array];
    NSString * dicKey = @"indexRow";
    NSString * dicText = @"text";
    if ([self.noteModel.sTumourLocation isEqualToString:@"无"]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"0" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sTumourLocation isEqualToString:@"上极"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"1" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sTumourLocation isEqualToString:@"中极"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"2" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sTumourLocation isEqualToString:@"下极"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"3" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }
    
    if ([self.noteModel.sTunica isEqualToString:@"无"]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"1" forKey:dicKey];
        [dic setObject:@"0" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sTunica isEqualToString:@"是"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"1" forKey:dicKey];
        [dic setObject:@"1" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sTunica isEqualToString:@"否"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"1" forKey:dicKey];
        [dic setObject:@"2" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }
    
    if ([self.noteModel.sThyroid isEqualToString:@"无"]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"2" forKey:dicKey];
        [dic setObject:@"0" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sThyroid isEqualToString:@"是"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"2" forKey:dicKey];
        [dic setObject:@"1" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sThyroid isEqualToString:@"否"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"2" forKey:dicKey];
        [dic setObject:@"2" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }
    
    if ([self.noteModel.sMultiFoci isEqualToString:@"无"]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"3" forKey:dicKey];
        [dic setObject:@"0" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sMultiFoci isEqualToString:@"是"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"3" forKey:dicKey];
        [dic setObject:@"1" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }else if ([self.noteModel.sMultiFoci isEqualToString:@"否"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"3" forKey:dicKey];
        [dic setObject:@"2" forKey:dicText];
        [self.surgeryDicArray addObject:dic];
    }
    
}
-(void)updateAddoverDianDicArray
{
    self.overDianDicArray = [NSMutableArray array];
    NSString * dicKey = @"indexRow";
    NSString * dicText = @"text";
    if ([self.noteModel.lRadioactiveIodine isEqualToString:@"无"]) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"0" forKey:dicText];
        [self.overDianDicArray addObject:dic];
    }else if ([self.noteModel.lRadioactiveIodine isEqualToString:@"是"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"1" forKey:dicText];
        [self.overDianDicArray addObject:dic];
    }else if ([self.noteModel.lRadioactiveIodine isEqualToString:@"否"]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:@"0" forKey:dicKey];
        [dic setObject:@"2" forKey:dicText];
        [self.overDianDicArray addObject:dic];
    }
    
}
#pragma mark - 右上角完成按钮
-(void)overButton
{
   
    CZHAlertView *alertView = [CZHAlertView czh_alertViewWithTitle:@"提示" message:@"为了能够便于术后复查了解患者病情,请您对术后大病理进行拍照\n" preferredStyle:CZHAlertViewStyleAlert];
    
    CZHAlertItem* item=[CZHAlertItem  czh_itemWithTitle:@"已拍照" titleFont:CZHGlobelNormalFont(15) titleColor:Gato_(83, 172, 255) backgroundColor:Gato_(250, 250, 250) style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
        
    }];
    
    CZHAlertItem* item1=[CZHAlertItem  czh_itemWithTitle:@"去拍照" titleFont:CZHGlobelNormalFont(15) titleColor:Gato_(0, 0, 0) backgroundColor:Gato_(250, 250, 250) style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
        
    }];
    
    CZHAlertItem* item2=[CZHAlertItem  czh_itemWithTitle:@"无情拒绝" titleFont:CZHGlobelNormalFont(15) titleColor:Gato_(255, 25, 26) backgroundColor:Gato_(250, 250, 250) style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
        
    }];
    
    [alertView czh_addAlertItem:item];
    [alertView czh_addAlertItem:item1];
    [alertView czh_addAlertItem:item2];
    [alertView czh_showView];
    //保存患者信息
//    if ([self.type isEqualToString:@"0"] && self.noteModel.lDiagnose.length < 1) {
//        NSLog(@"~~~~~~~~~~~~~~dianjianniu~~~~~~~~~~~~~~~");
//        [self newInfoDataWithDelete:@"0"];
//        return;
//    }
//    if (self.noteModel.lDiagnose.length > 0) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定当前患者移入随访？" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [self newInfoDataWithDelete:@"1"];
//
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//
//    if ([self.type isEqualToString:@"1"] && [self.comeForWhere isEqualToString:@"0"]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否对该患者进行模版推送？" preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self newInfoDataWithDelete:@"1"];
//        }]];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            [self pushMessageWithComeForWiere:@"0"];
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//    if ([self.type isEqualToString:@"1"] && self.noteModel.lDiagnose.length < 1) {
//        [self showHint:@"请选择出院诊断"];
//        return;
//    }
}

#pragma mark - 保存患者信息
-(void)newInfoDataWithDelete:(NSString *)delete
{
    [self.view endEditing:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SVProgressHUD showWithStatus:@"保存中..."];
        NSString *changeState = @"2";
        [self updateNoteModel];
        self.updateParms = [NSMutableDictionary dictionary];
        [self.updateParms setObject:delete forKey:@"delete"];
        [self.updateParms setObject:self.userId forKey:@"patientCaseId"];
        [self.updateParms setObject:TOKEN forKey:@"token"];
        
        [self.updateParms setObject:self.noteModel.bedNumber forKey:@"bedNumber"];
        [self.updateParms setObject:self.noteModel.caseNo forKey:@"caseNo"];
        [self.updateParms setObject:self.noteModel.remark forKey:@"remark"];
        NSMutableArray * sImages = [NSMutableArray array];
        if (self.surgeryArray.count > 0) {
            for (int i = 0 ;i < self.surgeryArray.count ; i ++) {
                if ([self.surgeryArray[i] isKindOfClass:[UIImage class]]) {
                    NSData *data = [self zipNSDataWithImage:self.surgeryArray[i]];
                    //                NSData *data = UIImageJPEGRepresentation(self.surgeryArray[i], 0.5f);
                    //                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    changeState = @"1";
                    [sImages addObject:data];
                }else{
                    [sImages addObject:self.surgeryArray[i]];
                }
                
                //            if ([self.surgeryArray[i] isKindOfClass:[UIImage class]]) {
                //                NSData *data = [self zipNSDataWithImage:self.surgeryArray[i]];
                //                [sImages addObject:data];
                //            }else{
                //                [sImages addObject:self.surgeryArray[i]];
                //            }
            }
        }
        //    NSArray * sImageArray = sImages;
        //    [self.updateParms setObject:sImageArray forKey:@"sImg"];
        [self.updateParms setObject:self.noteModel.sTumourLocation forKey:@"sTumourLocation"];
        [self.updateParms setObject:self.noteModel.sTunica forKey:@"sTunica"];
        [self.updateParms setObject:self.noteModel.sThyroid forKey:@"sThyroid"];
        [self.updateParms setObject:self.noteModel.sMultiFoci forKey:@"sMultiFoci"];
        [self.updateParms setObject:self.noteModel.sWay forKey:@"sWay"];
        NSMutableArray * lImages = [NSMutableArray array];
        if (self.overImageArray.count > 0) {
            for (int i = 0 ;i < self.overImageArray.count ; i ++) {
                if ([self.overImageArray[i] isKindOfClass:[UIImage class]]) {
                    //                NSData *data = UIImageJPEGRepresentation(self.overImageArray[i], 0.5f);
                    NSData *data = [self zipNSDataWithImage:self.overImageArray[i]];
                    //                NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    changeState = @"1";
                    [lImages addObject:data];
                }else{
                    [lImages addObject:self.overImageArray[i]];
                }
                //            if ([self.overImageArray[i] isKindOfClass:[UIImage class]]) {
                //                NSData *data = [self zipNSDataWithImage:self.overImageArray[i]];
                //                [lImages addObject:data];
                //            }else{
                //                [lImages addObject:self.overImageArray[i]];
                //            }
            }
        }
        //    NSArray * lImageArray = lImages;
        //    [self.updateParms setObject:lImageArray forKey:@"lImg"];
        [self.updateParms setObject:self.noteModel.lRadioactiveIodine forKey:@"lRadioactiveIodine"];
        [self.updateParms setObject:self.noteModel.lTshS forKey:@"lTshS"];
        [self.updateParms setObject:self.noteModel.lDiagnose forKey:@"lDiagnose"];
        if ([self.type isEqualToString:@"1"] && self.noteModel.lDiagnose.length < 1) {
            [self.updateParms setObject:@"1" forKey:@"waitPathology"];
        }
        [self.updateParms setObject:self.noteModel.secondarylDiagnose forKey:@"secondarylDiagnose"];
        if ([ModelNull(self.noteModel.lTshS) isEqualToString:@"更多"] || [ModelNull(self.noteModel.lTshS) isEqualToString:@"正常范围"] || [ModelNull(self.noteModel.lTshS) isEqualToString:@"无"]) {
            self->tshTopInt = @"";
            self->tshUnderInt = @"";
        }
        [self.updateParms setObject:ModelNull(tshTopInt) forKey:@"option1"];
        [self.updateParms setObject:ModelNull(tshUnderInt) forKey:@"option2"];
        [self.updateParms setObject:@(self.overImageArray.count) forKey:@"lImgCount"];
        [self.updateParms setObject:@(self.surgeryArray.count) forKey:@"sImgCount"];
        NSMutableArray *ImageAry = [NSMutableArray array];
        [ImageAry addObject:sImages];
        [ImageAry addObject:lImages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [IWHttpTool startMultiPartUploadTaskWithURL:HD_Surgery_Info imagesArray:ImageAry ChangeState:changeState parametersDict:self.updateParms succeedBlock:^(id json) {
                NSLog(@"%@",json);
                //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
                //        NSString * success = [dic objectForKey:@"code"];
                
                NSString * success = [json objectForKey:@"code"];
                if ([success isEqualToString:@"200"]) {
                    [SVProgressHUD dismiss];
                    [self showHint:@"保存成功"];
                    NSLog(@"%@",self.updateParms);
                    if (self.returnBlock) {
                        self.returnBlock(self.updateParms);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    //            [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    NSString * falseMessage = [json objectForKey:@"message"];
                    [self showHint:falseMessage];
                    
                }
                [self.GatoTableview.mj_header endRefreshing];
                [self.GatoTableview reloadData];
            } failedBlock:^(NSError *error) {
                NSLog(@"%@",error);
            } uploadProgressBlock:^(float fractionCompleted, long long totalUnitCount, long long completedUnitCount) {
//                        [SVProgressHUD showProgress:fractionCompleted status:@"正在上传请稍候"];
            }];
            
        });

        
    });

    
    
    
//    [SVProgressHUD showWithStatus:@"上传中请稍候"];
   
    
    
//    if (fractionCompleted <= 0) {
//        [SVProgressHUD dismiss];
//    }else
//    {
//        [SVProgressHUD showProgress:fractionCompleted status:@"正在上传请稍候"];
//    }
    
//    [IWHttpTool postWithURL:HD_Surgery_Info params:self.updateParms success:^(id json) {
//
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
//        NSString * success = [dic objectForKey:@"code"];
//        if ([success isEqualToString:@"200"]) {
//            [SVProgressHUD dismiss];
//            [self showHint:@"保存成功"];
//            if (self.returnBlock) {
//                self.returnBlock(self.updateParms);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//
////            [self.navigationController popToRootViewControllerAnimated:YES];
//        }else{
//            NSString * falseMessage = [dic objectForKey:@"message"];
//            [self showHint:falseMessage];
//        }
//        [self.GatoTableview.mj_header endRefreshing];
//        [self.GatoTableview reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
}
#pragma mark - 跳转模板推送
-(void)pushMessageWithComeForWiere:(NSString *)comeForWhere
{
    [self updateNoteModel];
    PushMessageViewController * vc = [[PushMessageViewController alloc]init];
    vc.returnBlock = ^(NSDictionary *dict) {
        if (self.returnBlock) {
            self.returnBlock(dict);
        }
    };
    vc.noteModel = self.noteModel;
    vc.patientCaseId = self.userId;
    vc.type = self.type;
    vc.comeForWhere = comeForWhere;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 更新model信息
-(void)updateNoteModel
{
    for (int i = 0 ; i < self.surgeryDicArray.count; i++) {
        NSDictionary * dic = self.surgeryDicArray[i];
        NSString * dicKey = @"indexRow";
        NSString * dicText = @"text";
        if ([[dic objectForKey:dicKey] isEqualToString:@"0"]) {
            NSString * type = [dic objectForKey:dicText];
            if ([type isEqualToString:@"0"]) {
                self.noteModel.sTumourLocation = @"无";
            }else if ([type isEqualToString:@"1"]){
                self.noteModel.sTumourLocation = @"上极";
            }else if ([type isEqualToString:@"2"]){
                self.noteModel.sTumourLocation = @"中极";
            }else if ([type isEqualToString:@"3"]){
                self.noteModel.sTumourLocation = @"下极";
            }else{
                self.noteModel.sTumourLocation = @"";
            }
            
        }else if ([[dic objectForKey:dicKey] isEqualToString:@"1"]){
            NSString * type = [dic objectForKey:dicText];
            if ([type isEqualToString:@"0"]) {
                self.noteModel.sTunica = @"无";
            }else if ([type isEqualToString:@"1"]){
                self.noteModel.sTunica = @"是";
            }else if ([type isEqualToString:@"2"]){
                self.noteModel.sTunica = @"否";
            }else{
                self.noteModel.sTunica = @"";
            }
        }else if ([[dic objectForKey:dicKey] isEqualToString:@"2"]){
            NSString * type = [dic objectForKey:dicText];
            if ([type isEqualToString:@"0"]) {
                self.noteModel.sThyroid = @"无";
            }else if ([type isEqualToString:@"1"]){
                self.noteModel.sThyroid = @"是";
            }else if ([type isEqualToString:@"2"]){
                self.noteModel.sThyroid = @"否";
            }else{
                self.noteModel.sThyroid = @"";
            }
        }else if ([[dic objectForKey:dicKey] isEqualToString:@"3"]){
            NSString * type = [dic objectForKey:dicText];
            if ([type isEqualToString:@"0"]) {
                self.noteModel.sMultiFoci = @"无";
            }else if ([type isEqualToString:@"1"]){
                self.noteModel.sMultiFoci = @"是";
            }else if ([type isEqualToString:@"2"]){
                self.noteModel.sMultiFoci = @"否";
            }else{
                self.noteModel.sMultiFoci = @"";
            }
        }
    }
    
//    self.noteModel.lImg = self.overImageArray;
    for (int i = 0 ; i < self.overDianDicArray.count; i++) {
        NSDictionary * dic = self.overDianDicArray[i];
        NSString * dicText = @"text";
        NSString * type = [dic objectForKey:dicText];
        if ([type isEqualToString:@"0"]) {
            self.noteModel.lRadioactiveIodine = @"无";
        }else if ([type isEqualToString:@"1"]){
            self.noteModel.lRadioactiveIodine = @"是";
        }else if ([type isEqualToString:@"2"]){
            self.noteModel.lRadioactiveIodine = @"否";
        }else{
            self.noteModel.lRadioactiveIodine = @"";
        }  
    }
    self.noteModel.sImg = self.surgeryArray;
    self.noteModel.lImg = self.overImageArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
//    患者头像
    if (indexPath.row == 0) {
        patientInfoImageTableViewCell * cell = [patientInfoImageTableViewCell cellWithTableView:tableView];
        [cell setValueWithImageUrl:self.noteModel.photo];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if (indexPath.row == 1)
//       基本信息
    {
        patientInformationTableViewCell * cell = [patientInformationTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:self.noteModel];
        return cell;
    }else if (indexPath.row == 2)
    {
//        病床号。。。
        patientInfoNoteTableViewCell * cell = [patientInfoNoteTableViewCell cellWithTableView: tableView];
        cell.textFieldBlock = ^(NSString * text,NSInteger row){
            NSLog(@"输入文字 %@, 第%ld个输入框",text,row);
            if (row == 0)
            {
                weakSelf.noteModel.bedNumber = text;
            }else{
                weakSelf.noteModel.caseNo = text;
            }
        };
        cell.bedNumberBlock = ^(){
            //这里需要返回数据
            bedNumberViewController * vc = [[bedNumberViewController alloc]init];
            vc.bedNumberStrBlock = ^(NSString *betNumber) {
                weakSelf.noteModel.bedNumber = betNumber;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.textViewBlock = ^(NSString * text){
            NSLog(@"输入备注 %@",text);
            weakSelf.noteModel.remark = text;
        };
        [cell setValueWithModel:self.noteModel];
        return cell;
    }
//    术前信息
    else if(indexPath.row==3)
    {
        SQXXTableViewCell * cell = [SQXXTableViewCell cellWithTableView:tableView];
        [cell setvalueWithImageArray:self.shuqainArray];
        cell.addImageBlock = ^(){
            weakSelf.buttonState=@"1";
            if (weakSelf.updateImage == NO) {
                [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"上传病历前，请获取病人及医院的相关授权或隐藏病人及医院的相关信息，否则因此造成的任何法律纠纷和后果，平台不承担任何法律责任。" success:^{
                    [weakSelf alertView];
                } WithVC:weakSelf];
            }else{
                [weakSelf alertView];
            }
        };
        cell.deleteButton = ^(NSInteger row){
            [weakSelf.shuqainArray removeObjectAtIndex:row];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
            [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.imageLookBlock = ^(UITapGestureRecognizer *tag) {
            [weakSelf showZoomImageView:tag];
        };
//        BRAF
        cell.dicArrayBlock = ^(NSMutableArray *DicArray) {
            NSLog(@"%@",DicArray);
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            dic=[DicArray objectAtIndex:0];
            if (weakSelf.BRAFArray.count == 0) {
                [weakSelf.BRAFArray addObject:dic];
            }else{

                [weakSelf.BRAFArray replaceObjectAtIndex:0 withObject:dic];
                
            }
        };
        [cell setvaleueBRAFArray:self.BRAFArray];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        patientInfoSurgeryMessageTableViewCell * cell = [patientInfoSurgeryMessageTableViewCell cellWithTableView:tableView];
        [cell setvalueWithImageArray:self.surgeryArray];
        cell.addImageBlock = ^(){
            weakSelf.buttonState=@"2";
            if (weakSelf.updateImage == NO) {
                [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"上传病历前，请获取病人及医院的相关授权或隐藏病人及医院的相关信息，否则因此造成的任何法律纠纷和后果，平台不承担任何法律责任。" success:^{
                    [weakSelf alertView];;
                } WithVC:weakSelf];
            }else{
                [weakSelf alertView];
            }
            
        };
//        良性 恶性选择
        cell.selectSegmented = ^(NSString *str) {
            if([str isEqualToString:@"恶性"])
            {
            self->BqingStr=str;
                
                [self alertBingQing];
            }
            else
            {
                self->jiaozhanxianYesOrNOSr=str;
                self->BqingStr=str;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:5 inSection:0];
                [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
//         淋巴结转移
        cell.linbajiezhuanyiBlock = ^{
            [self linbajiezhuanyi];
        };
        cell.selectStr=BqingStr;
        cell.deleteButton = ^(NSInteger row){
            [weakSelf.surgeryArray removeObjectAtIndex:row];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
            [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.MoerButton = ^(){
            [weakSelf pushMoreSurgery];
        };
        [cell setvalueWithMoryButtonStr:self.noteModel.sWay];
        cell.dicArrayBlock = ^(NSMutableArray * array){
            weakSelf.surgeryDicArray = array;
        };
        if (self.surgeryDicArray.count > 0) {
            [cell setValueWithinfoArray:self.surgeryDicArray];
        }
        cell.imageLookBlock = ^(UITapGestureRecognizer *tag) {
            [weakSelf showZoomImageView:tag];
        };
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [cellHeightWith3 setValue:value forKey:AHuShenKey];
        return cell;
    }else if (indexPath.row == 5){
        patientInfoOverTableViewCell * cell = [patientInfoOverTableViewCell cellWithTableView:tableView];
        [cell setvalueWithImageArray:self.overImageArray];
        
        cell.selectStr=jiaozhanxianYesOrNOSr;
        
        cell.dianBlock = ^(NSInteger str){
            NSLog(@"碘131治疗 %ld",str);
            if (weakSelf.overDianDicArray.count == 0) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:[NSString stringWithFormat:@"%ld",str] forKey:@"text"];
                [weakSelf.overDianDicArray addObject:dic];
            }else{
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:[NSString stringWithFormat:@"%ld",str] forKey:@"text"];
                [weakSelf.overDianDicArray replaceObjectAtIndex:0 withObject:dic];
                
            }
        };
        if (self.overDianDicArray.count > 0) {
            [cell setvalueWithdian131Str:self.overDianDicArray];
        }
//        次要诊断
        cell.TSHBlock = ^(){
            [self ciyaozhenduan];
        };
        cell.zhenduanBlock = ^(){
            [weakSelf pushzhenduanVCWithOneForAll:0];
        };
        cell.ciyaozhenduanBlock = ^{
            [weakSelf pushzhenduanVCWithOneForAll:1];
        };
        [cell setValueWithTSHStr:self.noteModel.lTshS WithZhenduan:self.noteModel.lDiagnose WithCiyaozhenduan:self.noteModel.secondarylDiagnose];
        cell.addImageBlock = ^(){
            weakSelf.buttonState=@"3";
            if (weakSelf.updateImage == NO) {
                [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"上传病历前，请获取病人及医院的相关授权或隐藏病人及医院的相关信息，否则因此造成的任何法律纠纷和后果，平台不承担任何法律责任。" success:^{
                    [weakSelf alertView];;
                } WithVC:weakSelf];
            }else{
                [weakSelf alertView];
            }
        };
        cell.deleteButton = ^(NSInteger row){
            [weakSelf.overImageArray removeObjectAtIndex:row];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
            [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.imageLookBlock = ^(UITapGestureRecognizer *tag) {
            [weakSelf showZoomImageView:tag];
        };
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [cellHeightWith4 setValue:value forKey:BHuShenKey];
        return cell;
    }
    Gato_tableviewcell_new
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return Gato_Height_548_(110);
    }else if (indexPath.row == 1)
    {
        return Gato_Height_548_(224);
    }else if (indexPath.row == 2)
    {
        return Gato_Height_548_(215);
    }else if (indexPath.row == 3)
    {
        return Gato_Height_548_(170);
    }
    else if (indexPath.row == 4)
    {
        if([BqingStr isEqualToString:@"良性"])
        {
        return Gato_Height_548_(200);
        }
        else
        {
            return Gato_Height_548_(384);
        }
    }else if (indexPath.row == 5)
    {
//        return Gato_Height_548_(245) + Gato_Height_548_(96) / 3;
        if([jiaozhanxianYesOrNOSr isEqualToString:@"良性"])
        {
        return Gato_Height_548_(245-129);
        }
        else if ([jiaozhanxianYesOrNOSr isEqualToString:@"甲状腺恶性肿瘤"])
        {
             return Gato_Height_548_(260);
        }
        else
        {
             return Gato_Height_548_(215);
        }
        
    }
    return 0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 图片预览
-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    UIImageView *picView = (UIImageView *)tap.view;
    NSLog(@"点击了第%ld张图片", tap.view.tag);
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    if (tap.view.tag >= 5024 && tap.view.tag < 6024) {
        jzAlbumVC.currentIndex = tap.view.tag - 5024;
        jzAlbumVC.imagesUrl = [self.surgeryArray mutableCopy];
    }else
    {
        jzAlbumVC.currentIndex = tap.view.tag - 6024;
        jzAlbumVC.imagesUrl = [self.overImageArray mutableCopy];
    }
    [self presentViewController:jzAlbumVC animated:YES completion:nil];

//    if (![(UIImageView *)tap.view image]) {
//        return;
//    }
//    //scrollView作为背景
//    UIScrollView *bgView = [[UIScrollView alloc] init];
//    bgView.frame = [UIScreen mainScreen].bounds;
//    bgView.backgroundColor = [UIColor blackColor];
//    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
//    [bgView addGestureRecognizer:tapBg];
//
//    UIImageView *picView = (UIImageView *)tap.view;
//
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = picView.image;
//    imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
//    [bgView addSubview:imageView];
//
//    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
//
//    self.lastImageView = imageView;
//    self.originalFrame = imageView.frame;
//    self.scrollView = bgView;
//    //最大放大比例
//    self.scrollView.maximumZoomScale = 1.5;
//    self.scrollView.delegate = self;
//
//    [UIView animateWithDuration:0 animations:^{
//        CGRect frame = imageView.frame;
//        frame.size.width = bgView.frame.size.width;
//        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
//        frame.origin.x = 0;
//        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
//        imageView.frame = frame;
//    }];
}

-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer
{
    __weak __typeof(self) weakSelf = self;
    self.scrollView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.5 animations:^{
        //        self.lastImageView.frame = self.originalFrame;
        //        tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [tapBgRecognizer.view removeFromSuperview];
        weakSelf.scrollView = nil;
        weakSelf.lastImageView = nil;
    }];
}

//返回可缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.lastImageView;
}
#pragma mark - 术中信息 手术方式 更多
-(void)pushMoreSurgery
{
    __weak __typeof(self) weakSelf = self;
    OperationMethodViewController * vc = [[OperationMethodViewController alloc]init];
    vc.titleBlock = ^(OperationmethodModel * model){
        weakSelf.noteModel.sWay = model.titleStr;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 出院诊断 - TSH
-(void)pushTSHViewCollecter
{
    self.overTSHStr = @"0.4TSH";
    __weak __typeof(self) weakSelf = self;
    TSHNumberViewController * vc = [[TSHNumberViewController alloc]init];
    
    vc.tshStrBlock = ^(NSString *tshStr, NSString *topInt, NSString *UnderInt) {
        weakSelf.noteModel.lTshS = tshStr;
        weakSelf.noteModel.tshTopInt = topInt;
        weakSelf.noteModel.tshUnderInt = UnderInt;
        self->tshTopInt = topInt;
        self->tshUnderInt = UnderInt;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 出院诊断 —— //row 0单选 1多选
-(void)pushzhenduanVCWithOneForAll:(NSInteger )row
{
    __weak __typeof(self) weakSelf = self;
    self.overMessageStr = @"我是出院诊断";
    hospitalDiagnosisViewController * vc = [[hospitalDiagnosisViewController alloc]init];
    vc.oneForAll = row;
    vc.titleArrayBlock = ^(NSArray * array){
        for (int i = 0 ; i < array.count ; i ++) {
            OperationmethodModel * model = [[OperationmethodModel alloc]init];
            model = array[i];
            if ( i == 0) {
                weakSelf.overMessageStr = model.titleStr;
            }else{
                weakSelf.overMessageStr = [NSString stringWithFormat:@"%@,%@",weakSelf.overMessageStr,model.titleStr];
            }
        }
        if (row == 0) {
            weakSelf.noteModel.lDiagnose = weakSelf.overMessageStr;
        }else{
            weakSelf.noteModel.secondarylDiagnose = weakSelf.overMessageStr;
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        [weakSelf.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择相册代理方法
- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect textFieldRect = CGRectMake(0, rect.origin.y , rect.size.width,0);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        
        textFieldRect = rect;
    }
    
    //    [UIView animateWithDuration:0.25 animations:^{
    //        self.UnderTextField.frame = textFieldRect;
    //        //
    //    }];
    
    //    CGFloat h = rect.size.height;
    //    if (_totalKeybordHeight != h) {
    //        _totalKeybordHeight = h;
    //        [self adjustTableViewToFitKeyboard];
    //    }
}
//淋巴结转移
-(void)linbajiezhuanyi
{
    CZHAlertView *alertView = [CZHAlertView czh_alertViewWithTitle:@"" message:@"" preferredStyle:CZHAlertViewStyleActionSheet animationStyle:CZHAlertViewAnimationStyleSlideFromBottom];
    
    CZHAlertItem *item = [CZHAlertItem czh_itemWithTitle:@"取消" titleFont:CZHGlobelNormalFont(14) titleColor:[UIColor redColor] style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
    }];
    
    CZHAlertItem *item1 = [CZHAlertItem czh_itemWithTitle:@"中央区转移" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
  
        
    }];
    
    CZHAlertItem *item2 = [CZHAlertItem czh_itemWithTitle:@"颈侧区转移" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
       
    }];
    
    CZHAlertItem *item3 = [CZHAlertItem czh_itemWithTitle:@"中央区+颈侧区转移" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {

    }];
    
    CZHAlertItem *item4 = [CZHAlertItem czh_itemWithTitle:@"无" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
        
    }];
    
    [alertView czh_addAlertItem:item];
    [alertView czh_addAlertItem:item1];
    [alertView czh_addAlertItem:item2];
    [alertView czh_addAlertItem:item3];
    [alertView czh_addAlertItem:item4];
    
    [alertView czh_showView];
}
//恶性病情选择
-(void)alertBingQing
{
    CZHAlertView *alertView = [CZHAlertView czh_alertViewWithTitle:@"" message:@"" preferredStyle:CZHAlertViewStyleActionSheet animationStyle:CZHAlertViewAnimationStyleSlideFromBottom];

    CZHAlertItem *item = [CZHAlertItem czh_itemWithTitle:@"取消" titleFont:CZHGlobelNormalFont(14) titleColor:[UIColor redColor] style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"zhongliu" object:nil];
    }];
        
        CZHAlertItem *item1 = [CZHAlertItem czh_itemWithTitle:@"甲状腺恶性肿瘤" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
                 //甲状腺恶性肿瘤
            self->jiaozhanxianYesOrNOSr=@"甲状腺恶性肿瘤";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:5 inSection:0];
            [self.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        CZHAlertItem *item2 = [CZHAlertItem czh_itemWithTitle:@"其它恶性肿瘤" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
            //其它恶性肿瘤
            self->jiaozhanxianYesOrNOSr=@"其它恶性肿瘤";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
            [self.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:5 inSection:0];
            [self.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    
        [alertView czh_addAlertItem:item];
        [alertView czh_addAlertItem:item1];
        [alertView czh_addAlertItem:item2];
        
        [alertView czh_showView];
}
//次要诊断
-(void)ciyaozhenduan
{
    CZHAlertView *alertView = [CZHAlertView czh_alertViewWithTitle:@"" message:@"" preferredStyle:CZHAlertViewStyleActionSheet animationStyle:CZHAlertViewAnimationStyleSlideFromBottom];
    
    CZHAlertItem *item = [CZHAlertItem czh_itemWithTitle:@"取消" titleFont:CZHGlobelNormalFont(14) titleColor:[UIColor redColor] style:CZHAlertItemStyleCancel handler:^(CZHAlertItem *item) {
    }];
    
    CZHAlertItem *item1 = [CZHAlertItem czh_itemWithTitle:@"良性疾病" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
        //良性
        self.noteModel.lTshS = @"正常范围";
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        [self.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    CZHAlertItem *item2 = [CZHAlertItem czh_itemWithTitle:@"恶性疾病" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
        //恶性
        [self pushTSHViewCollecter];
    }];
    
    CZHAlertItem *item3 = [CZHAlertItem czh_itemWithTitle:@"非甲状腺疾病" titleFont:CZHGlobelNormalFont(14) titleColor:Gato_(0, 0, 0) style:CZHAlertItemStyleDefault handler:^(CZHAlertItem *item) {
        //非甲状腺
        self.noteModel.lTshS = @"无";
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        [self.GatoTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [alertView czh_addAlertItem:item];
    [alertView czh_addAlertItem:item1];
    [alertView czh_addAlertItem:item2];
    [alertView czh_addAlertItem:item3];
    
    [alertView czh_showView];
    
}
#pragma mark 选择拍照 或者相册
-(void)alertView{
    self.updateImage = YES;
    UIAlertController * sheetController = [UIAlertController alertControllerWithTitle:@""
                                                                              message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *Cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"hahahahahha");
    }];
    
    UIAlertAction * Done = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
            // 无权限 做一个友好的提示
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许该应用访问您的相机\n设置>隐私>相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
            return;
            
        }
            
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    
    UIAlertAction * Destructive = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    
    [sheetController addAction:Cancel];
    [sheetController addAction:Done];
    [sheetController addAction:Destructive];
    [self presentViewController:sheetController animated:YES completion:nil];
}


#pragma mark 头像截取
- (void)loadPortrait {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        __block UIImage *protraitImg = [UIImage imageNamed:@"default_avatar"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
//            术中信息
            if ([strongSelf.buttonState isEqualToString:@"2"]) {
                [strongSelf.surgeryArray addObject: protraitImg];

            }else if([strongSelf.buttonState isEqualToString:@"3"])
//            出院信息
            {
                [strongSelf.overImageArray addObject: protraitImg];

            }
//            术前信息
            else
            {
                [strongSelf.shuqainArray addObject:protraitImg];
            }
            
        });
    });
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            术中信息
            if ([self.buttonState isEqualToString:@"2"]) {
                if (editedImage != nil) {
                    NSData *data = [self zipNSDataWithImage:editedImage];
                    UIImage *image = [UIImage imageWithData: data];
                    [self.surgeryArray addObject: image];
                }

            }else if([self.buttonState isEqualToString:@"3"])
//            出院信息
            {
                if (editedImage != nil) {
                    NSData *data = [self zipNSDataWithImage:editedImage];
                    UIImage *image = [UIImage imageWithData: data];
                    [self.overImageArray addObject: image];
                }

            }
            else
//                术前信息
            {
                if (editedImage != nil) {
                    NSData *data = [self zipNSDataWithImage:editedImage];
                    UIImage *image = [UIImage imageWithData: data];
                    [self.shuqainArray addObject: image];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.GatoTableview reloadData];
                [cropperViewController dismissViewControllerAnimated:YES completion:^{
                    // TO DO
                }];
            });
        });
//    }
    //    [self NewPhoneUpdata];//头像网络请求
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (actionSheet == tshSheet) {
//        if (buttonIndex == 0) {
//
//        }else if (buttonIndex == 1) {
//
//        }else if (buttonIndex == 2){
//
//        }
//    }else if (actionSheet==exingSheet)
//    {
//        if (buttonIndex == 0) {
//
//
//
//        }else if (buttonIndex == 1) {
//
//        }
//        else
//        {
//            NSLog(@"1346564646");
//
//        }
//    }
   
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {

        SEL selector = NSSelectorFromString(@"_alertController");
        
        if ([actionSheet respondsToSelector:selector])//ios8
        {
            UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
            
            if ([alertController isKindOfClass:[UIAlertController class]])
                
            {
                alertController.view.tintColor = [UIColor blackColor];
//                alertController.title=@"111111";
                NSLog(@"%@",alertController.view);
              
            }
        }
        
//    }
    
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    @autoreleasepool {

    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            术中信息
            if ([self.buttonState isEqualToString:@"2"]) {
                if (portraitImg != nil) {
                    NSData *data = [self zipNSDataWithImage:portraitImg];
                    UIImage *image = [UIImage imageWithData: data];
                    [self.surgeryArray addObject: image];
                    
                }

            }else if([self.buttonState isEqualToString:@"3"])
            {
//                出院信息
                if (portraitImg != nil) {
                    NSData *data = [self zipNSDataWithImage:portraitImg];
                    UIImage *image = [UIImage imageWithData: data];
                    [self.overImageArray addObject: image];
                }
            }
//             术前信息
            else
            {
                if (portraitImg != nil) {
                    NSData *data = [self zipNSDataWithImage:portraitImg];
                    UIImage *image = [UIImage imageWithData: data];
                    [self.shuqainArray addObject: image];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.GatoTableview reloadData];
            });
        });

        
        //        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        //        // present the cropper view controller
        //        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) limitScaleRatio:3.0];
        //        imgCropperVC.delegate = self;
        //        [self presentViewController:imgCropperVC animated:YES completion:^{
        //            // TO DO
        //        }];
    }];
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < Gato_Width) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = Gato_Width;
        btWidth = sourceImage.size.width * (Gato_Width / sourceImage.size.height);
    } else {
        btWidth = Gato_Width;
        btHeight = sourceImage.size.height * (Gato_Width / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280) {
        if (width>height) {
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }else{
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }
        //2.高度大于1280
    }else if(height>1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>2*1024*1024) {//2M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.4);
        }else if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.5);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }
    }
    return data;
}






#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
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
- (void)dealloc
{
    NSLog(@"释放了");
    [[NSNotificationCenter defaultCenter]removeObserver:@"zhongliu"];
}
@end
