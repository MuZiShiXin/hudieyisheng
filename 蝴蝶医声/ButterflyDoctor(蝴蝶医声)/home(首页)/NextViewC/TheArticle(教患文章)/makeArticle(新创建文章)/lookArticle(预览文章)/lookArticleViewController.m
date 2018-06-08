//
//  lookArticleViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "lookArticleViewController.h"
#import "GatoBaseHelp.h"
#import "makeArticleModel.h"
#import "lookArticleTitleTableViewCell.h"
#import "lookArticleLittleTitleTableViewCell.h"
#import "lookArticleCenterTableViewCell.h"
#import "lookArticleImageTableViewCell.h"
#define kCellTag 10201705
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]
@interface lookArticleViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *lastImageView;
@property (nonatomic, assign)CGRect originalFrame;
@property (nonatomic, assign)BOOL isDoubleTap;


@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,strong) NSMutableDictionary * cellHeightDic;
@end

@implementation lookArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
    self.cellHeightDic = [NSMutableDictionary dictionary];
    self.GatoTableview.frame = CGRectMake(0, 64, Gato_Width, Gato_Height - 64);\
    [self.view addSubview:self.GatoTableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        lookArticleTitleTableViewCell * cell = [lookArticleTitleTableViewCell cellWithTableView:tableView];
        [cell setValueWithTitle:self.titleStr];
        NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
        [self.cellHeightDic setValue:value forKey:kHuShenKey];
        return cell;
    }else{
        
        makeArticleModel * model = [[makeArticleModel alloc]init];
        model = self.dateArray[indexPath.row - 1];
        
        if ([model.type isEqualToString:@"0"]) {
            lookArticleLittleTitleTableViewCell * cell = [lookArticleLittleTitleTableViewCell cellWithTableView:tableView];
            [cell setValueWithModel:model];
            NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
            [self.cellHeightDic setValue:value forKey:kHuShenKey];
            return cell;
        }else if ([model.type isEqualToString:@"1"]){
            lookArticleCenterTableViewCell * cell = [lookArticleCenterTableViewCell cellWithTableView:tableView];
            [cell setValueWithModel:model];
            NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
            [self.cellHeightDic setValue:value forKey:kHuShenKey];
            return cell;
        }else if ([model.type isEqualToString:@"2"]){
            lookArticleImageTableViewCell * cell = [lookArticleImageTableViewCell cellWithTableView:tableView];
            [cell setValueWithModel:model];
            cell.buttonImageBlock = ^(UITapGestureRecognizer *tap) {
                [weakSelf showZoomImageView:tap];
            };
            NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
            [self.cellHeightDic setValue:value forKey:kHuShenKey];
            return cell;
        }
        
    }
    
    Gato_tableviewcell_new
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *value = [self.cellHeightDic objectForKey:kHuShenKey];
    CGFloat height = value.floatValue;
    if (height < 1) {
        height = 1;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)buttonDidClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
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



-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 64)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(60), 64);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];

        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(Gato_Width_320_(16), Gato_Height_548_(25),Gato_Width_320_(11), Gato_Height_548_(18))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];

        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, 63, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];

        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Gato_Width, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(40);
        label.text = @"预览";
        label.textColor = [UIColor whiteColor];
        [self.navView addSubview:label];
        [self.navView addSubview:button];
image.sd_layout.centerYEqualToView(label);

    }
    return _navView;
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
