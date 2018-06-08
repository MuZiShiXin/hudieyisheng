//
//  MineInfoDataViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MineInfoDataViewController.h"
#import "GatoBaseHelp.h"
#import "InfoDataPhotoTableViewCell.h"
#import "InfoDataTitleTableViewCell.h"
#import "loginViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TextFieldInfoViewController.h"
#import "XFDaterView.h"
#import "consultingInfoViewController.h"
#import <Hyphenate/Hyphenate.h>
#import "MineInfoDataModel.h"
#import "WorkAddressViewController.h"
#import "newPayNumberViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "homeViewController.h"
@interface MineInfoDataViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,XFDaterViewDelegate>
{
    XFDaterView*dater;
    UIActionSheet * sexSheet;
}
@property (nonatomic ,strong) NSArray * titleArray;
@property (nonatomic ,strong) NSArray * imageArray;
@property (nonatomic ,strong) NSMutableArray * centerArray;
@property (nonatomic ,strong) UIButton * deleteToken;
@property (nonatomic ,strong) UIImage * PhotoImage;
@property (nonatomic ,strong) MineInfoDataModel * model;

@property (nonatomic ,strong) NSString * payPriceStr;
@property (nonatomic ,strong) NSString * notDisturbStr;
@end

@implementation MineInfoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"个人资料";

    Gato_TableView
    self.GatoTableview.height = Gato_Height ;
//    self.GatoTableview.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor appAllBackColor];
    self.titleArray = @[@"头像",@"姓名",@"",@"出生年月",@"个人简介",@"擅长",@"执业地点",@"咨询设置"];
    self.imageArray = @[@"mine_icon_0",@"mine_icon_1",@"",@"mine_icon_3",@"mine_icon_4",@"mine_icon_5",@"home_icon_location",@"mine_icon_7"];
    self.centerArray = [NSMutableArray array];
    for (int i = 0 ; i < self.titleArray.count ; i ++) {
        [self.centerArray addObject:@""];
    }
    
    self.deleteToken.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(46))
    .rightSpaceToView(self.view,Gato_Width_320_(46))
    .bottomSpaceToView(self.view,Gato_Height_548_(17))
    .heightIs(Gato_Height_548_(36));
    
    GatoViewBorderRadius(self.deleteToken, 5, 0, [UIColor redColor]);
    
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    [self updata];
}



-(void)updata
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    self.model = [[MineInfoDataModel alloc]init];
    [IWHttpTool postWithURL:HD_Mine_Info_data params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.model setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            self.notDisturbStr = self.model.notDisturb;
            [self centerArrayReloadData];
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)centerArrayReloadData
{
    [self.centerArray replaceObjectAtIndex:1 withObject:ModelNull(self.model.name)];
    [self.centerArray replaceObjectAtIndex:2 withObject:ModelNull(self.model.sex)];
    if ([self.model.isBirthday isEqualToString:@"1"]) {
        [self.centerArray replaceObjectAtIndex:3 withObject:@"保密"];
    }else{
        [self.centerArray replaceObjectAtIndex:3 withObject:ModelNull(self.model.birthday)];
    }
    [self.centerArray replaceObjectAtIndex:4 withObject:ModelNull(self.model.introduction)];
    [self.centerArray replaceObjectAtIndex:5 withObject:ModelNull(self.model.speciality)];
    [self.centerArray replaceObjectAtIndex:6 withObject:ModelNull(self.model.workAddress)];
    [self.GatoTableview reloadData];
}
#pragma mark - 修改个人信息
-(void)searchprogram
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    if (self.PhotoImage) {
        NSData *data = UIImageJPEGRepresentation(self.PhotoImage, 0.5f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self.updateParms setObject:encodedImageStr forKey:@"photo"];
    }else{
        [self.updateParms setObject:@"" forKey:@"photo"];
    }
    if (self.payPriceStr.length < 1) {
        self.payPriceStr = self.model.payPrice;
    }
//    if (self.notDisturbStr.length < 1) {
//        self.notDisturbStr = self.model.notDisturb;
//    }
    [self.updateParms setObject:ModelNull( self.model.name) forKey:@"name"];
    [self.updateParms setObject:ModelNull( self.model.sex) forKey:@"sex"];
    [self.updateParms setObject:ModelNull( self.model.birthday) forKey:@"birthday"];
    [self.updateParms setObject:ModelNull( self.model.isBirthday) forKey:@"isBirthday"];
    [self.updateParms setObject:ModelNull( self.model.introduction) forKey:@"introduction"];
    [self.updateParms setObject:ModelNull( self.model.speciality) forKey:@"speciality"];
    [self.updateParms setObject:ModelNull( self.model.workAddress) forKey:@"workAddress"];
    [self.updateParms setObject:ModelNull( self.payPriceStr)  forKey:@"payPrice"];
    [self.updateParms setObject:ModelNull( self.notDisturbStr) forKey:@"notDisturb"];
    [self.updateParms setObject:ModelNull( self.model.payPriceSet) forKey:@"payPriceSet"];
    [IWHttpTool postWithURL:HD_Mine_Info_data_UPdate params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            if (self.updateInfo) {
                self.updateInfo();
            }
            [UserWebManager updateMyAvatar:self.PhotoImage completed:^(UIImage *imageData) {
                if (imageData) {
                    UserCacheInfo *user = [UserCacheManager myInfo];
                    NSLog(@"%@",user.avatarUrl);
                }
            }];
            [UserWebManager updateMyNick:self.model.name completed:^(BOOL isSucc) {
                if (isSucc) {
                    UserCacheInfo *user = [UserCacheManager myInfo];
                    NSLog(@"%@",user.nickName);
                }
            }];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_UPDATEPHOTO];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        InfoDataPhotoTableViewCell * cell = [InfoDataPhotoTableViewCell cellWithTableView:tableView];
        if (self.PhotoImage) {
            [cell setvalueWithPhoto:self.PhotoImage];
        }else{
            [cell setvalueWithPhotoUrl:self.model.photo];
        }
        [cell setValueWithImage:self.imageArray[indexPath.row] WithTitle:self.titleArray[indexPath.row]];
        return cell;
    }else{
        InfoDataTitleTableViewCell * cell = [InfoDataTitleTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 2) {
            [cell jiantouHidden];
        }else{
            [cell setValueWithCenter:self.centerArray[indexPath.row]];
            [cell setValueWithImage:self.imageArray[indexPath.row] WithTitle:self.titleArray[indexPath.row]];
        }
        return cell;
    }
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 0;
    }else if (indexPath.row == 0) {
        return Gato_Height_548_(69);
    }else{
        return Gato_Height_548_(43);
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        //头像选择
        [self alertView];
    }else if (indexPath.row == 6){
        WorkAddressViewController * vc = [[WorkAddressViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4 ||indexPath.row == 5){
        TextFieldInfoViewController * vc = [[TextFieldInfoViewController alloc]init];
        vc.FieldOrView = NO;
        vc.model = self.model;
        vc.titleStr = self.titleArray[indexPath.row];
        vc.baocunBlock = ^(NSString * text){
            if (indexPath.row == 4) {
                weakSelf.model.introduction = text;
            }else{
                weakSelf.model.speciality = text;
            }
            [weakSelf.centerArray replaceObjectAtIndex:indexPath.row withObject:text];
            [weakSelf.GatoTableview reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 3){
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_XFDate_Type];
        dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        dater.delegate=self;
        [dater showInView:self.view animated:YES];
        
    }else if (indexPath.row == 2){
        sexSheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"男", @"女", nil];
        [sexSheet showInView:self.view];
    }else if (indexPath.row == 7){
        newPayNumberViewController * vc = [[newPayNumberViewController alloc]init];
//        vc.model = self.model;
        vc.payPriceBlock = ^(NSString *payPrice, NSString *notDisturbStr){
            weakSelf.payPriceStr = payPrice;
            weakSelf.notDisturbStr = notDisturbStr;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)deleteTokenButton:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出当前登录账号？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            NSLog(@"退出成功");
        }
        [self logout];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
   
}
#pragma mark - 退出登录
-(void)logout
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_OUT_TOKEN params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
//            [self.navigationController popToRootViewControllerAnimated:NO];
//            [homeViewController deleteToken];
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_Again_Login];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:GET_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:GET_Again_Login];
            loginViewController *login = [[loginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:NO completion:nil];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}
+ (void)TabSelectedIndex
{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MainViewController *tab = (MainViewController *)tempAppDelegate.window.rootViewController;
    tab.selectedIndex = 0;
    
}
#pragma mark - 选择日期
- (void)daterViewDidClicked:(XFDaterView *)daterView{
    
    [self.centerArray replaceObjectAtIndex:3 withObject:dater.dateString];
    self.model.birthday = dater.dateString;
    self.model.isBirthday = @"0";
    [self.GatoTableview reloadData];
}
- (void)daterViewDidCancel:(XFDaterView *)daterView{
    [self.centerArray replaceObjectAtIndex:3 withObject:@"保密"];
    self.model.birthday = @"保密";
    self.model.isBirthday = @"1";
    [self.GatoTableview reloadData];
}





#pragma mark 选择拍照 或者相册
-(void)alertView{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
#pragma mark 头像截取
- (void)loadPortrait {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        __block UIImage *protraitImg = [UIImage imageNamed:@"default_avatar"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.PhotoImage = protraitImg;
            
            
        });
    });
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    self.PhotoImage = editedImage;
    [self.GatoTableview reloadData];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    //    [self NewPhoneUpdata];//头像网络请求
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == sexSheet) {
        if (buttonIndex == 0) {
            [self.centerArray replaceObjectAtIndex:2 withObject:@"男"];
            [self.GatoTableview reloadData];
        }else if (buttonIndex == 1){
            [self.centerArray replaceObjectAtIndex:2 withObject:@"女"];
            [self.GatoTableview reloadData];
        }
    }else{
        if (buttonIndex == 0) {
            // 拍照
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
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
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
        }
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
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



-(UIButton *)deleteToken
{
    if (!_deleteToken) {
        _deleteToken = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteToken setTitle:@"退出登录" forState:UIControlStateNormal];
        [_deleteToken setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteToken setBackgroundColor:[UIColor redColor]];
        _deleteToken.titleLabel.font = FONT(30);
        [_deleteToken addTarget:self action:@selector(deleteTokenButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_deleteToken];
    }
    return _deleteToken;
}

@end
