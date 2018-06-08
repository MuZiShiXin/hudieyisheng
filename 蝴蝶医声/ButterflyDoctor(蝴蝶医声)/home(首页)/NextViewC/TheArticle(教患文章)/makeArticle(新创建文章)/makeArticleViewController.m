//
//  makeArticleViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "makeArticleViewController.h"
#import "GatoBaseHelp.h"
#import "makeArticleModel.h"
#import "makeArticleOneTableViewCell.h"
#import "makeArticleTwoTableViewCell.h"
#import "makeArticleThreeTableViewCell.h"
#import "addTypeViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"

#import "lookArticleViewController.h"

#import "FMDBArticle.h"
#import "makeArticleChooseTypeViewController.h"

#define oldArticle @"http://wechat.hudieyisheng.com/app/interface.php?func=getArticle"//参数id

@interface makeArticleViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
{
    CGFloat contentOffsetY;
    FMDBArticle * manager;
}

@property (nonatomic ,strong) UIView * topView;
@property (nonatomic ,strong) UITextField * titleTF;
@property (nonatomic ,strong) UIView * underView;;
@property (nonatomic ,strong) UIButton * addButton;

@property (nonatomic ,strong) UIView * overView;
@end

@implementation makeArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"创建文章";
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,55,40)];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(30);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(fabiaowenzhang)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.GatoTableview.frame = CGRectMake(0, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT - Gato_Height_548_(40));\
    [self.view addSubview:self.GatoTableview];
    self.GatoTableview.backgroundColor = [UIColor appAllBackColor];
    if (self.articleID.length > 0) {
        [self updateHttp];
        self.titleTF.text = self.titleName;
    }else{
        [self addFMDB];
    }
    
//    [self addmodels];
    [self newFrame];
    [self.GatoTableview setEditing:YES animated:YES];
 
    

}
#pragma mark - 读取旧文章用做更改
-(void)updateHttp
{
    self.updataArray = [NSMutableArray array];
    self.updateParms = [NSMutableDictionary dictionary];
//    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.articleID forKey:@"id"];

    [IWHttpTool postWithURL:oldArticle params:self.updateParms success:^(id json) {
        NSString * str = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
        
        NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
        
        str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        
        str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
        
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        for (int i = 0 ; i < dataArray.count ; i ++) {
            makeArticleModel * model = [[makeArticleModel alloc]init];
            NSDictionary * dic = dataArray[i];
            model.title = [dic objectForKey:@"value"];
            NSString * type = [dic objectForKey:@"type"];
            if ([type isEqualToString:@"subtitle"]) {
                model.type = @"0";
            }else if ([type isEqualToString:@"content"]){
                model.type = @"1";
            }else if ([type isEqualToString:@"picurl"]){
                model.type = @"2";
                UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"picurl"]]]];
                model.photoImage = image;
                model.photoImageStrData = UIImagePNGRepresentation(model.photoImage);
            }
            model.indexPathRow = [NSString stringWithFormat:@"%d",i];
            [self.updataArray addObject:model];
        }
       
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)fabiaowenzhang
{
    [self.view endEditing:YES];
    
    if (self.titleTF.text.length < 1) {
        [self showHint:@"请输入标题"];
        return;
    }
    
    if (self.updataArray.count < 1) {
        [self showHint:@"请输入文章正文"];
        return;
    }
    
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        makeArticleModel * model = [[makeArticleModel alloc]init];
        model = self.updataArray[i];
        if ([model.type isEqualToString:@"0"]) {
            if (model.title.length < 1) {
                [self showHint:@"请输入小标题"];
                return;
            }
        }else if ([model.type isEqualToString:@"1"]){
            if (model.title.length < 1) {
                [self showHint:@"请输入正文"];
                return;
            }
        }else if ([model.type isEqualToString:@"2"]){
            if (model.title.length < 1) {
                model.title = @"null";
            }
        }
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
//    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:self.titleTF.text forKey:@"title"];
//    NSMutableArray * dataArray = [NSMutableArray array];
//    for (int i = 0 ; i < self.updataArray.count ; i ++) {
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        makeArticleModel * model = [[makeArticleModel alloc]init];
//        model = self.updataArray[i];
//        if ([model.type isEqualToString:@"0"]) {
//            [dic setObject:@"subtitle" forKey:@"type"];
//            [dic setObject:model.title forKey:@"subtitle"];
//        }else if ([model.type isEqualToString:@"1"]){
//            [dic setObject:@"content" forKey:@"type"];
//            [dic setObject:model.title forKey:@"content"];
//        }else if ([model.type isEqualToString:@"2"]){
//            [dic setObject:@"picurl" forKey:@"type"];
//            [dic setObject:model.photoImageStrData forKey:@"picurl"];
//            [dic setObject:model.title forKey:@"remark"];
//        }
//        [dataArray addObject:dic];
//    }
    [self.updateParms setObject:[self makeJsonWithArray:self.updataArray] forKey:@"data"];

 
    NSLog(@"%@",self.updateParms);
    
    
    
    makeArticleChooseTypeViewController * vc = [[makeArticleChooseTypeViewController alloc]init];
    vc.updateDic = self.updateParms;
    vc.articleID = self.articleID;
    vc.classify = self.classify;
    [self.navigationController pushViewController:vc animated:YES];

}

-(NSString *)makeJsonWithArray:(NSArray *)array
{
    NSString * jsonStr = @"";
    for (int i = 0 ; i < array.count ; i ++) {
        makeArticleModel * model = [[makeArticleModel alloc]init];
        model = self.updataArray[i];
        if ([model.type isEqualToString:@"0"]) {
            if (i == 0) {
                jsonStr = [NSString stringWithFormat:@"subtitle!@#$^&*%@",model.title];
            }else{
                jsonStr = [NSString stringWithFormat:@"%@!@#$^&*subtitle!@#$^&*%@",jsonStr,model.title];
            }
        }else if ([model.type isEqualToString:@"1"]){
            if (i == 0) {
                jsonStr = [NSString stringWithFormat:@"content!@#$^&*%@",model.title];
            }else{
                jsonStr = [NSString stringWithFormat:@"%@!@#$^&*content!@#$^&*%@",jsonStr,model.title];
            }
            NSLog(@"%@",[self getCenterStrWithstr:model.title]);
        }else if ([model.type isEqualToString:@"2"]){
            if (!model.photoImageStrData) {
                model.photoImageStrData = UIImagePNGRepresentation(model.photoImage);
            }
            if (i == 0) {
                NSString *encodedImgStr = [model.photoImageStrData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSLog(@"imageBase64 %@",encodedImgStr);
                jsonStr = [NSString stringWithFormat:@"picurl!@#$^&*%@!@#$^&*%@",encodedImgStr,model.title];
            }else{
                NSString *encodedImgStr = [model.photoImageStrData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSLog(@"imageBase64 %@",encodedImgStr);
                jsonStr = [NSString stringWithFormat:@"%@!@#$^&*picurl!@#$^&*%@!@#$^&*%@",jsonStr,encodedImgStr,model.title];
            }
        }
    }
    
    return jsonStr;
}



-(NSString *)getCenterStrWithstr:(NSString *)str
{
    NSString *getstr = str;
    getstr = [getstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    getstr = [getstr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    getstr = [getstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return getstr;
}

-(void)addFMDB
{
    
    
    manager = [[FMDBArticle alloc] init];
    
    //创建数据库
    BOOL open = [manager createDataBaseWithName:ArticlePlist];
    //打开数据库
    if (open) {
        NSLog(@"数据库打开成功");
    }
    
    //创建表
    BOOL createTable = [manager createTableWithDic:@[@"title",@"indexPathRow",@"photoImage",@"type",@"photoImageStrData",@"PathComponentStr"]];
    if (createTable) {
        NSLog(@"创建表成功");
    }
    
    NSArray * dataArray = [manager selectAllModels];
    if (dataArray.count > 0) {
        NSLog(@"%@",dataArray);
        for (int i = 0 ; i < dataArray.count ; i ++ ) {
            makeArticleModel * model = [[makeArticleModel alloc]init];
            model = dataArray[i];
            [self.updataArray addObject:model];
        }
        [self.GatoTableview reloadData];
    }
    
    if (GATO_ArticleTitle) {
        self.titleTF.text = GATO_ArticleTitle;
    }
    
}

-(void)newFrame
{
    
    self.overView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(Gato_Height_548_(40));
    
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(60))];
    top.backgroundColor = [UIColor appAllBackColor];
    [top addSubview:self.topView];
    self.topView.frame = CGRectMake(Gato_Width_320_(10), Gato_Height_548_(5), Gato_Width_320_(300), Gato_Height_548_(50));
    self.titleTF.frame = CGRectMake(Gato_Width_320_(10), Gato_Height_548_(0), Gato_Width_320_(290), Gato_Height_548_(50));
    
    UIView * under = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(110))];
    under.backgroundColor = [UIColor appAllBackColor];
    [under addSubview:self.underView];
    self.underView.frame = CGRectMake(Gato_Width_320_(10), Gato_Height_548_(5), Gato_Width_320_(300), Gato_Height_548_(100));
    self.addButton.frame = CGRectMake(0, 0, Gato_Width_320_(300), Gato_Height_548_(100));
    
    GatoViewBorderRadius(self.topView, 3, 1, [UIColor HDViewBackColor]);
    GatoViewBorderRadius(self.underView, 3, 1, [UIColor HDViewBackColor]);
    
    self.GatoTableview.tableHeaderView = top;
    self.GatoTableview.tableFooterView = under;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    makeArticleModel * model = [[makeArticleModel alloc]init];
    model = self.updataArray[indexPath.row];
    if ([model.type isEqualToString:@"0"]) {
        makeArticleOneTableViewCell * cell = [makeArticleOneTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:model];
        cell.textViewText = ^(NSString *textViewText) {
            model.title = textViewText;
            [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
        };
        cell.deleteOneBlcok = ^{
            [self deleteWithIndexRow:indexPath.row];
        };
        
        return cell;
    }else if ([model.type isEqualToString:@"1"]){
        makeArticleTwoTableViewCell * cell = [makeArticleTwoTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:model];
        cell.textViewText = ^(NSString *textViewText) {
            model.title = textViewText;
            [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
        };
        cell.deleteOneBlcok = ^{
            [self deleteWithIndexRow:indexPath.row];
        };
        return cell;
    }else if ([model.type isEqualToString:@"2"]){
        makeArticleThreeTableViewCell * cell = [makeArticleThreeTableViewCell cellWithTableView:tableView];
        [cell setValueWithModel:model];
        cell.textViewText = ^(NSString *textViewText) {
            model.title = textViewText;
            [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
        };
        cell.deleteOneBlcok = ^{
            [self deleteWithIndexRow:indexPath.row];
        };

        return cell;
    }
    
    Gato_tableviewcell_new
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    makeArticleModel * model = [[makeArticleModel alloc]init];
    model = self.updataArray[indexPath.row];
    if ([model.type isEqualToString:@"0"]) {
        return 100;
    }else if ([model.type isEqualToString:@"1"]){
        return 150;
    }else if ([model.type isEqualToString:@"2"]){
        return Gato_Height_548_(240);
    }
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark 选择编辑模式，添加模式很少用,默认是删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


#pragma mark 排序 当移动了某一行时候会调用
//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
     [self.view endEditing:YES];
    NSInteger goodsDestinationIndexRow = 0;
    // 取出要拖动的模型数据
    makeArticleModel *goods = self.updataArray[sourceIndexPath.row];
    //删除之前行的数据
    [self.updataArray removeObject:goods];
    // 插入数据到新的位置
    goods.indexPathRow = [NSString stringWithFormat:@"%ld",destinationIndexPath.row];
    goodsDestinationIndexRow = [goods.indexPathRow integerValue];
    [self.updataArray insertObject:goods atIndex:destinationIndexPath.row];
    [self.GatoTableview reloadData];

}

#pragma mark - 删除
-(void)deleteWithIndexRow:(NSInteger )row
{
    [self.view endEditing:YES];
    [self.updataArray removeObjectAtIndex:row];
    [self.GatoTableview reloadData];
//    [GatoMethods AlertControllerWithtitle:@"提示" WithMessage:@"是否删除该模块，删除后将无法恢复" success:^{
//        [self.updataArray removeObjectAtIndex:row];
//        [self.GatoTableview reloadData];
//    } WithVC:self];
    
}
#pragma mark - 添加跳转
-(void)addButtonDidClicked:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    addTypeViewController * vc = [[addTypeViewController alloc]init];
    vc.addTypeBlock = ^(NSString *type) {
        if ([type isEqualToString:@"2"]) {
            UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:weakSelf
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"拍照", @"从相册中选取", nil];
            [choiceSheet showInView:weakSelf.view];
        }else{
            makeArticleModel * model = [[makeArticleModel alloc]init];
            model.type = type;
            model.photoImage = nil;
            model.title = @"";
            model.indexPathRow = [NSString stringWithFormat:@"%ld",weakSelf.updataArray.count];
            [weakSelf.updataArray addObject:model];
            [weakSelf.GatoTableview reloadData];
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 预览
-(void)leftButtonDidClicked
{
    if (self.updataArray.count < 1) {
        [GatoMethods AleartViewWithMessage:@"请输入文章正文后再进行预览"];
        return;
    }
    if (self.titleTF.text.length < 1) {
        [GatoMethods AleartViewWithMessage:@"请输入文章标题后再进行预览"];
        return;
    }
    lookArticleViewController * vc = [[lookArticleViewController alloc]init];
    vc.dateArray = self.updataArray;
    vc.titleStr = self.titleTF.text;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 保存
-(void)rightButtonDidClicked
{
    
    manager = [[FMDBArticle alloc] init];
    //创建数据库
    BOOL open = [manager createDataBaseWithName:ArticlePlist];
    //打开数据库
    if (open) {
        NSLog(@"数据库打开成功");
    }
    
    
    
    //创建表
    BOOL createTable = [manager createTableWithDic:@[@"title",@"indexPathRow",@"photoImage",@"type",@"photoImageStrData",@"PathComponentStr"]];
    if (createTable) {
        NSLog(@"创建表成功");
    }

    //删除表
    BOOL removeData = [manager deleteDataBase];
    if (!removeData) {
        NSLog(@"删除所有数据失败");
    }
    
    BOOL addBool = YES;
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        makeArticleModel * model = [[makeArticleModel alloc]init];
        model = self.updataArray[i];
        model.indexPathRow = [NSString stringWithFormat:@"%d",i];
        BOOL success = [manager insertWithModel:model];
        if (!success) {
            addBool = NO;
        }

    }
    if (!addBool) {
        [GatoMethods AleartViewWithMessage:@"创建失败"];
    }
    
    [GatoMethods AleartViewWithMessage:@"保存成功"];
    [[NSUserDefaults standardUserDefaults] setObject:self.titleTF.text forKey:Get_ArticleTitle];
}

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
-(UITextField *)titleTF
{
    if (!_titleTF) {
        _titleTF = [[UITextField alloc]init];
        _titleTF.font = FONT(40);
        _titleTF.placeholder = @"请输入文章标题";
        [self.topView addSubview:_titleTF];
    }
    return _titleTF;
}
-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
    }
    return _underView;
}
-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton addTarget:self action:@selector(addButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
        [self.underView addSubview:_addButton];
    }
    return _addButton;
}

-(UIView *)overView
{
    if (!_overView) {
        _overView = [[UIView alloc]init];
        [self.view addSubview:_overView];
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"预览" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        leftButton.titleLabel.font = FONT_Bold_(36);
        [self.overView addSubview:leftButton];
        leftButton.sd_layout.leftSpaceToView(self.overView, Gato_Width_320_(10))
        .topSpaceToView(self.overView, 0)
        .bottomSpaceToView(self.overView, 0)
        .widthIs(Gato_Width_320_(60));
        
        [leftButton addTarget:self action:@selector(leftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = FONT_Bold_(36);
        [self.overView addSubview:rightButton];
        rightButton.sd_layout.rightSpaceToView(self.overView, Gato_Width_320_(10))
        .topSpaceToView(self.overView, 0)
        .bottomSpaceToView(self.overView, 0)
        .widthIs(Gato_Width_320_(60));
        
        [rightButton addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor HDViewBackColor];
        [self.overView addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(self.overView, 0)
        .rightSpaceToView(self.overView, 0)
        .topSpaceToView(self.overView, 0)
        .heightIs(1);
    }
    return _overView;
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
        

        makeArticleModel * model = [[makeArticleModel alloc]init];
        model.type = @"2";
        model.photoImage = portraitImg;
        model.photoImageStrData = UIImageJPEGRepresentation(portraitImg,0.7f);
        model.title = @"";
        model.indexPathRow = [NSString stringWithFormat:@"%ld",self.updataArray.count];
        
        //存图片
        NSData *imageData = UIImageJPEGRepresentation(portraitImg, 0.5);
        //获取沙盒路径
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"Article%@.png",model.indexPathRow]];
        [imageData writeToFile:fullPath atomically:NO];
        model.PathComponentStr = fullPath;
        [self.updataArray addObject:model];
        [self.GatoTableview reloadData];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
