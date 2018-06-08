//
//  AddArticleViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AddArticleViewController.h"
#import "GatoBaseHelp.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "PellTableViewSelect.h"
#import "ZYBrowerView.h"
#import "ZYLoadingView.h"
#define imageButtontag 5041658
@interface AddArticleViewController ()<UITextFieldDelegate ,UITextViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;

@property (nonatomic ,strong) UITextField * titleTF;
@property (nonatomic ,strong) UITextField * smallTF;
@property (nonatomic ,strong) UITextField * typeTF;
@property (nonatomic ,strong) UITextView * centerTV;
@property (nonatomic ,strong) UILabel * textViewPlaceholder;
@property (nonatomic ,strong) UIScrollView * imageScrollview;
@property (nonatomic ,strong) UIButton * AddImageButton;

@property (nonatomic ,strong) NSMutableArray * imageArray;
@end

@implementation AddArticleViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"创建文章";
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(fabiaowenzhang)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    [self addAllViews];
    self.imageArray = [NSMutableArray array];
}

-(void)fabiaowenzhang
{
    if (self.titleTF.text.length < 1) {
        [self showHint:@"请输入标题"];
        return;
    }
    
    if (self.typeTF.text.length < 1) {
        [self showHint:@"请选择分类"];
        return;
    }
    if (self.centerTV.text.length < 1) {
        [self showHint:@"请输入文章内容"];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"发表文章需审核通过后方可查看引用，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [self update];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)update
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    NSMutableArray * imagemutable = [NSMutableArray array];
    if (self.imageArray) {
        for (int i = 0 ;i < self.imageArray.count ; i ++) {
            NSData *data = UIImageJPEGRepresentation(self.imageArray[i], 0.5f);
            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [imagemutable addObject:encodedImageStr];
        }
    }
    [self.updateParms setObject:imagemutable forKey:@"images"];
    [self.updateParms setObject:self.titleTF.text forKey:@"title"];
    [self.updateParms setObject:self.centerTV.text forKey:@"content"];
    [self.updateParms setObject:self.smallTF.text forKey:@"smallTitle"];
    [self.updateParms setObject:[GatoMethods getButterflyarticlesTypeWithName:self.typeTF.text] forKey:@"classify"];
    [IWHttpTool postWithURL:HD_Home_info_Article_Add params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self showHint:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
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


-(void)addImageButton:(UIButton *)sender
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
-(void)newScorllerViews
{
    for (UIImageView * image in self.imageScrollview.subviews) {
        if ([image isKindOfClass:[UIImageView class]]) {
            [image removeFromSuperview];
        }
    }
    for (UIButton * button in self.imageScrollview.subviews) {
        if ([button isKindOfClass:[UIButton class]] && button != self.AddImageButton) {
            [button removeFromSuperview];
        }
    }
    
    self.imageScrollview.contentSize = CGSizeMake(Gato_Width_320_(295)  / 3 * (self.imageArray.count + 1),0);
    for (int i = 0 ; i < self.imageArray.count ; i ++) {
        UIImageView * image = [[UIImageView alloc]init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.backgroundColor = [UIColor blackColor];
        image.image = self.imageArray[i];
        image.userInteractionEnabled = YES;
        [self.imageScrollview addSubview:image];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showZoomImageView:)];
        
        [image addGestureRecognizer:tap];
        
        image.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + i * Gato_Height_548_(90))
        .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
        .widthIs(Gato_Width_320_(77))
        .heightIs(Gato_Height_548_(77));
        
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.tag = i + imageButtontag;
//        [button addTarget:self action:@selector(lookImageButtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.imageScrollview addSubview:button];
//        button.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + i * Gato_Height_548_(90))
//        .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
//        .widthIs(Gato_Width_320_(77))
//        .heightIs(Gato_Height_548_(77));
        
        
        UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"deleteImage"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = i + imageButtontag;
        [self.imageScrollview addSubview:deleteButton];
        deleteButton.sd_layout.leftSpaceToView(image,- Gato_Width_320_(12))
        .topSpaceToView(image,- Gato_Width_320_(89))
        .widthIs(Gato_Width_320_(25))
        .heightIs(Gato_Width_320_(25));
        
        
        
    }
    self.AddImageButton.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(15) + self.imageArray.count * Gato_Height_548_(90))
    .topSpaceToView(self.imageScrollview,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(77))
    .heightIs(Gato_Height_548_(77));
}

-(void)deleteButton:(UIButton *)sender
{
    [self.imageArray removeObjectAtIndex:sender.tag - imageButtontag];
    [self newScorllerViews];
}

-(void)lookImageButtn:(UIButton *)sender
{
    NSLog(@"点击图片放大处理");
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textViewPlaceholder.hidden = YES;
    return YES;
}
//结束编辑

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.textViewPlaceholder.hidden = YES;
    }else{
        self.textViewPlaceholder.hidden = NO;
    }
}



-(void)addAllViews
{
    UIView * titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView addSubview:self.titleTF];
    titleView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(11))
    .rightSpaceToView(self.view,Gato_Width_320_(11))
    .topSpaceToView(self.view,Gato_Width_320_(13))
    .heightIs(Gato_Height_548_(32));
    
    self.titleTF.sd_layout.leftSpaceToView(titleView,Gato_Width_320_(10))
    .rightSpaceToView(titleView,Gato_Width_320_(10))
    .topSpaceToView(titleView,0)
    .bottomSpaceToView(titleView,0);
    
    UIView * smallView = [[UIView alloc]init];
    smallView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:smallView];
    [smallView addSubview:self.smallTF];
    smallView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(11))
    .rightSpaceToView(self.view,Gato_Width_320_(11))
    .topSpaceToView(titleView,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(32));
    
    self.smallTF.sd_layout.leftSpaceToView(smallView,Gato_Width_320_(10))
    .rightSpaceToView(smallView,Gato_Width_320_(10))
    .topSpaceToView(smallView,0)
    .bottomSpaceToView(smallView,0);
    
    
    UIView * typeView = [[UIView alloc]init];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    [typeView addSubview:self.typeTF];
    typeView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(11))
    .rightSpaceToView(self.view,Gato_Width_320_(11))
    .topSpaceToView(smallView,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(32));
    
    self.typeTF.sd_layout.leftSpaceToView(typeView,Gato_Width_320_(10))
    .rightSpaceToView(typeView,Gato_Width_320_(10))
    .topSpaceToView(typeView,0)
    .bottomSpaceToView(typeView,0);

    UIButton * typebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typebutton addTarget:self action:@selector(typeButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:typebutton];
    typebutton.sd_layout.leftSpaceToView(typeView,0)
    .rightSpaceToView(typeView,0)
    .topSpaceToView(typeView,0)
    .bottomSpaceToView(typeView,0);
    
    
    [self.view addSubview:self.imageScrollview];
    self.imageScrollview.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(11))
    .rightSpaceToView(self.view,Gato_Width_320_(11))
    .topSpaceToView(typeView,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(97));
    

    [self.imageScrollview addSubview:self.AddImageButton];
    self.AddImageButton.sd_layout.leftSpaceToView(self.imageScrollview,Gato_Width_320_(10))
    .topSpaceToView(self.imageScrollview,Gato_Width_320_(10))
    .widthIs(Gato_Width_320_(77))
    .heightIs(Gato_Height_548_(77));
    
    
    UIView * centerView = [[UIView alloc]init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centerView];
    [centerView addSubview:self.centerTV];
    centerView.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(11))
    .rightSpaceToView(self.view,Gato_Width_320_(11))
    .topSpaceToView(self.imageScrollview,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(144));
    
    self.centerTV.sd_layout.leftSpaceToView(centerView,Gato_Width_320_(10))
    .rightSpaceToView(centerView,Gato_Width_320_(10))
    .topSpaceToView(centerView,Gato_Height_548_(10))
    .bottomSpaceToView(centerView,Gato_Height_548_(10));
    
    self.textViewPlaceholder = [[UILabel alloc]init];
    self.textViewPlaceholder.font = FONT(26);
    self.textViewPlaceholder.textColor = [UIColor YMAppAllTitleColor];
    self.textViewPlaceholder.text = @"添加正文段落...";
    [centerView addSubview:self.textViewPlaceholder];
    self.textViewPlaceholder.sd_layout.leftSpaceToView(centerView,Gato_Width_320_(18))
    .rightSpaceToView(centerView,Gato_Width_320_(18))
    .topSpaceToView(centerView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(25));
    
    GatoViewBorderRadius(titleView, 3, 1, [UIColor HDViewBackColor]);
    GatoViewBorderRadius(smallView, 3, 1, [UIColor HDViewBackColor]);
    GatoViewBorderRadius(typeView, 3, 1, [UIColor HDViewBackColor]);
    GatoViewBorderRadius(self.imageScrollview, 3, 1, [UIColor HDViewBackColor]);
    GatoViewBorderRadius(centerView, 3, 1, [UIColor HDViewBackColor]);
}

-(void)typeButtonDidClicked
{
    [self.view endEditing:YES];
    NSArray * shaixuanArray = @[@"学术研究",@"医学科普",@"诊前需知",@"诊后必读",@"术后需知",@"经典问答",@"出院需知",@"同位素治疗"];
    
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(Gato_Width_320_(10), Gato_Height_548_(129) + NAV_BAR_HEIGHT, Gato_Width_320_(300), 40 * shaixuanArray.count) selectData:shaixuanArray action:^(NSInteger index) {
        
        self.typeTF.text = shaixuanArray[index];

    } animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showZoomImageView:(UITapGestureRecognizer *)tap
{
    if (![(UIImageView *)tap.view image]) {
        return;
    }
    //scrollView作为背景
    UIScrollView *bgView = [[UIScrollView alloc] init];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
    [bgView addGestureRecognizer:tapBg];
    
    UIImageView *picView = (UIImageView *)tap.view;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = picView.image;
    imageView.frame = [bgView convertRect:picView.frame fromView:self.view];
    [bgView addSubview:imageView];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    self.lastImageView = imageView;
    self.originalFrame = imageView.frame;
    self.scrollView = bgView;
    //最大放大比例
    self.scrollView.maximumZoomScale = 1.5;
    self.scrollView.delegate = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = imageView.frame;
        frame.size.width = bgView.frame.size.width;
        frame.size.height = frame.size.width * (imageView.image.size.height / imageView.image.size.width);
        frame.origin.x = 0;
        frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5;
        imageView.frame = frame;
    }];
}

-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer
{
    self.scrollView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.5 animations:^{
//        self.lastImageView.frame = self.originalFrame;
//        tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [tapBgRecognizer.view removeFromSuperview];
        self.scrollView = nil;
        self.lastImageView = nil;
    }];
}

//返回可缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.lastImageView;
}



#pragma mark 头像截取
- (void)loadPortrait {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
        __block UIImage *protraitImg = [UIImage imageNamed:@"default_avatar"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.imageArray addObject: protraitImg];
            
        });
    });
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [self.imageArray addObject:editedImage];
    [self newScorllerViews];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.imageArray addObject:portraitImg];
        [self newScorllerViews];
//        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        portraitImg = [self imageByScalingToMaxSize:portraitImg];
//        // present the cropper view controller
//        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) limitScaleRatio:3.0];
//        imgCropperVC.delegate = self;
//        [self presentViewController:imgCropperVC animated:YES completion:^{
//            // TO DO
//        }];
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




-(UITextField *)titleTF
{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.delegate = self;
        _titleTF.font = FONT(30);
        _titleTF.placeholder = @"请输入文章标题";
    }
    return _titleTF;
}
-(UITextField *)smallTF
{
    if (!_smallTF) {
        _smallTF = [[UITextField alloc]init];
        _smallTF.delegate = self;
        _smallTF.font = FONT(30);
        _smallTF.placeholder = @"请输入文章小标题";
    }
    return _smallTF;
}
-(UITextField *)typeTF
{
    if (!_typeTF) {
        _typeTF = [[UITextField alloc]init];
        _typeTF.delegate = self;
        _typeTF.font = FONT(30);
        _typeTF.placeholder = @"请选择文章分类";
    }
    return _typeTF;
}
-(UITextView *)centerTV
{
    if (!_centerTV) {
        _centerTV = [[UITextView alloc]init];
        _centerTV.delegate = self;
        _centerTV.font = FONT(30);
        
    }
    return _centerTV;
}
-(UIScrollView *)imageScrollview
{
    if (!_imageScrollview) {
        _imageScrollview = [[UIScrollView alloc]init];
        _imageScrollview.backgroundColor = [UIColor whiteColor];
        _imageScrollview.delegate = self;
        _imageScrollview.scrollEnabled = YES;
    }
    return _imageScrollview;
}
-(UIButton *)AddImageButton
{
    if (!_AddImageButton) {
        _AddImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AddImageButton addTarget:self action:@selector(addImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [_AddImageButton setBackgroundColor:[UIColor appAllBackColor]];
        [_AddImageButton setBackgroundImage:[UIImage imageNamed:@"group_btn_picture"] forState:UIControlStateNormal];
        [self.imageScrollview addSubview:_AddImageButton];
    }
    return _AddImageButton;
}
@end
