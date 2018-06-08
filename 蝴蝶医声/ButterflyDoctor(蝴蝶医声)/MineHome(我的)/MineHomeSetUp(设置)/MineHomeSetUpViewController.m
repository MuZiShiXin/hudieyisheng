//
//  MineHomeSetUpViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MineHomeSetUpViewController.h"
#import "GatoBaseHelp.h"
#import "InfoDataTitleTableViewCell.h"
#import "forgetPasswordViewController.h"
#import "PayPasswordViewController.h"
#import "PayLoginPasswordViewController.h"
#import "AllTitleWebViewController.h"
@interface MineHomeSetUpViewController ()
@property (nonatomic ,strong) NSArray * titleArray;
@property (nonatomic ,strong) NSMutableArray * centerArray;
@property (nonatomic ,strong) NSString * huancun;
@end

@implementation MineHomeSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    Gato_TableView
    self.title = @"设置";
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    NSString * GatoTime = Gato_Chche_Time;
    
    if ([timeString integerValue] - [GatoTime integerValue] > 3600) {
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        self.huancun = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:docPath]];
    }else{
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        self.huancun = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:docPath] * (([timeString floatValue] - [GatoTime floatValue]) / 3600 )];
    }
    
    self.titleArray = @[@"密码设置",@"安全密码设置",@"当前版本",@"清除缓存",@"服务条款",@"关于我们"];
    self.centerArray = [NSMutableArray array];
    [self.centerArray addObject:@""];
    [self.centerArray addObject:@""];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [self.centerArray addObject:app_Version];
    [self.centerArray addObject:self.huancun];
    [self.centerArray addObject:@""];
    [self.centerArray addObject:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Gato_Height_548_(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:Gato_CGRectMake(0, 0, Gato_Width, Gato_Height_548_(10))];
    view.backgroundColor = [UIColor appAllBackColor];
    
    UIView * fgx0 = [[UIView alloc]init];
    fgx0.backgroundColor = [UIColor HDViewBackColor];
    [view addSubview:fgx0];
    fgx0.sd_layout.leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .topSpaceToView(view,0)
    .heightIs(Gato_Height_548_(0.5));
    
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor HDViewBackColor];
    [view addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    .topSpaceToView(view,Gato_Height_548_(9.5))
    .heightIs(Gato_Height_548_(0.5));
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    InfoDataTitleTableViewCell * cell = [InfoDataTitleTableViewCell cellWithTableView:tableView];
    [cell setValueWithCenter:self.centerArray[indexPath.section]];
    [cell setValueWithImage:nil WithTitle:self.titleArray[indexPath.section]];
    if (indexPath.section == 2 || indexPath.section == 3) {
        [cell jiantouHidden];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(40);
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //密码设置
        forgetPasswordViewController * vc = [[forgetPasswordViewController alloc]init];
        vc.titleStr = @"修改密码";
        [self presentViewController:vc animated:YES completion:nil];
    }else if (indexPath.section == 1){
        //安全密码设置
        PayLoginPasswordViewController * vc = [[PayLoginPasswordViewController alloc]init];
        vc.comeWhere = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        //清理缓存
        [self putBufferBtnClicked:nil];
    }else if (indexPath.section == 4){
        //服务条款
        AllTitleWebViewController * vc = [[AllTitleWebViewController alloc]init];
        vc.WebType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 5){
        //关于我们
        AllTitleWebViewController * vc = [[AllTitleWebViewController alloc]init];
        vc.WebType = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//清除缓存按钮的点击事件
- (void)putBufferBtnClicked:(UIButton *)btn{
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    
    NSString *message = [NSString stringWithFormat:@"缓存%@，删除缓存", self.huancun];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        self.huancun = [NSString stringWithFormat:@"0.00M"];
        [self.centerArray replaceObjectAtIndex:3 withObject:self.huancun];
        [self.GatoTableview reloadData];
//        [self cleanCaches:docPath];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
        [[NSUserDefaults standardUserDefaults] setObject:timeString forKey:GET_cache_time];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    self.huancun = [NSString stringWithFormat:@"%.2fM",[self folderSizeAtPath:path]];
    [self.centerArray replaceObjectAtIndex:3 withObject:self.huancun];
    [self.GatoTableview reloadData];
}


@end
