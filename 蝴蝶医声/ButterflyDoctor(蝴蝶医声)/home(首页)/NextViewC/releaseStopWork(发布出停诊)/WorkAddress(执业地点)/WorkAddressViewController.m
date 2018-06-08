//
//  WorkAddressViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/19.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "WorkAddressViewController.h"
#import "GatoBaseHelp.h"
#import "newAddressViewController.h"
#import "WorkAddressOldTableViewCell.h"

#define kCellTag 100425111
#define kHuShenKey [NSString stringWithFormat:@"%ld", indexPath.row + kCellTag]

@interface WorkAddressViewController ()
{
    NSMutableDictionary * cellHeightDic;
}
@property (nonatomic ,strong) UIView * addressView;
@property (nonatomic ,strong) UIView * ButtonView;
@property (nonatomic ,strong) UIView * nilView;
@property (nonatomic ,strong) UILabel * addressLabel;
@property (nonatomic ,strong) NSMutableArray * beforeHosptialArray;
@end

@implementation WorkAddressViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Gato_Return
    self.GatoTableview.frame = CGRectMake(0, Gato_Height_548_(125), Gato_Width, Gato_Height - Gato_Height_548_(125));
    [self.view addSubview:self.GatoTableview];
    self.GatoTableview.hidden = YES;
    self.title = @"执业地点";
    cellHeightDic = [NSMutableDictionary dictionary];
    self.beforeHosptialArray = [NSMutableArray array];
    [self newFrame];
    [self updataInfo];
    [self updateAll];
}
-(void)updataInfo
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    
    [IWHttpTool postWithURL:HD_Home_info params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            
            self.addressLabel.text  = [[[dic objectForKey:@"data"] objectForKey:@"info"] objectForKey:@"hospital"];
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)updateAll
{
    
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [IWHttpTool postWithURL:HD_Home_change params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            NSArray * jsonArray = [[dic objectForKey:@"data"] objectForKey:@"info"];
            for (int i = 0 ; i < jsonArray.count; i ++) {
                [self.beforeHosptialArray addObject:[jsonArray[i] objectForKey:@"oldHospital"]];
            }
            
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview.mj_header endRefreshing];
        if (self.beforeHosptialArray.count > 0) {
            self.GatoTableview.hidden = NO;
            [self.GatoTableview reloadData];
            self.nilView.hidden = YES;
        }else{
            self.GatoTableview.hidden = YES;
            self.nilView.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.beforeHosptialArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkAddressOldTableViewCell * cell = [WorkAddressOldTableViewCell cellWithTableView:tableView];
    [cell setValueWithTitle:self.beforeHosptialArray[indexPath.row]];
    NSNumber *value = [NSNumber numberWithFloat:cell.frame.size.height];
    [cellHeightDic setValue:value forKey:kHuShenKey];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *value = [cellHeightDic objectForKey:kHuShenKey];
    CGFloat height = value.floatValue;
    if (height < 1) {
        height = 1;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - 修改执业地点
-(void)chutingzhenButton:(UIButton *)sender
{
    
//    [GatoMethods AleartViewWithMessage:@"请联系医助修改执业地点"];
    [self updataPhoneNumber];
//    newAddressViewController * vc = [[newAddressViewController alloc]init];
//    vc.oldDoctor = self.addressLabel.text;
//    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)updataPhoneNumber
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:@"修改执业地点" forKey:@"content"];
    [IWHttpTool postWithURL:HD_Home_PhoneNumber params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:@"我们已收到您的反馈信息，我们将会在工作时间内与您取得联系" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:nil];
            if ([cancel1 valueForKey:@"titleTextColor"]) {
                [cancel1 setValue:[UIColor HDThemeColor] forKey:@"titleTextColor"];
            }
            [alert1 addAction:cancel1];
            [self showDetailViewController:alert1 sender:nil];
            
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

-(void)newFrame
{
    self.addressView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(Gato_Height_548_(49));
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"home_icon_location"];
    [self.addressView addSubview:image];
    image.sd_layout.leftSpaceToView(self.addressView,Gato_Width_320_(16))
    .topSpaceToView(self.addressView,Gato_Height_548_(18))
    .widthIs(Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(13));
    
    self.addressLabel.sd_layout.leftSpaceToView(image,10)
    .topSpaceToView(self.addressView,0)
    .bottomSpaceToView(self.addressView,0)
    .rightSpaceToView(self.addressView,Gato_Width_320_(15));
    
    
    self.ButtonView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.addressView,- 1)
    .heightIs(Gato_Height_548_(44));
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"修改记录";
    label.font = FONT(30);
    label.textColor = [UIColor YMAppAllTitleColor];
    [self.view addSubview:label];
    label.sd_layout.leftSpaceToView(self.view,Gato_Width_320_(15))
    .rightSpaceToView(self.view,Gato_Width_320_(15))
    .topSpaceToView(self.ButtonView,0)
    .heightIs(30);
    
    self.nilView.sd_layout.leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.ButtonView,Gato_Height_548_(30))
    .heightIs(Gato_Height_548_(120));
    
    
    GatoViewBorderRadius(self.addressView, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.ButtonView, 0, 1, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.nilView, 0, 1, [UIColor appAllBackColor]);
}

-(UIView *)addressView
{
    if (!_addressView) {
        _addressView = [[UIView alloc]init];
        _addressView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_addressView];
    }
    return _addressView;
}
-(UILabel * )addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = FONT(30);
        _addressLabel.textColor = [UIColor HDBlackColor];
        _addressLabel.numberOfLines = 0;
        [self.addressView addSubview:_addressLabel];
    }
    return _addressLabel;
}
-(UIView *)ButtonView
{
    if (!_ButtonView) {
        _ButtonView = [[UIView alloc]init];
        _ButtonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_ButtonView];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"修改执业地点" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor HDThemeColor]];
        [button addTarget:self action:@selector(chutingzhenButton:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = FONT(30);
        [self.ButtonView addSubview:button];
        button.sd_layout.widthIs(Gato_Width_320_(119))
        .topSpaceToView(self.ButtonView,Gato_Height_548_(5))
        .rightSpaceToView(self.ButtonView,Gato_Width_320_(15))
        .bottomSpaceToView(self.ButtonView,Gato_Height_548_(5));
        
        GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
    }
    return _ButtonView;
}
-(UIView *)nilView
{
    if (!_nilView) {
        _nilView = [[UIView alloc]init];
        _nilView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_nilView];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"home_bg_anonymous"];
        [self.nilView addSubview:image];
        image.sd_layout.leftSpaceToView(self.nilView,Gato_Width / 2 - Gato_Width_320_(20))
        .topSpaceToView(self.nilView,Gato_Height_548_(23))
        .widthIs(Gato_Width_320_(40))
        .heightIs(Gato_Height_548_(40));
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"暂无修改记录";
        label.textColor = [UIColor YMAppAllTitleColor];
        label.font = FONT(30);
        label.textAlignment = NSTextAlignmentCenter;
        [self.nilView addSubview:label];
        label.sd_layout.leftSpaceToView(self.nilView,0)
        .rightSpaceToView(self.nilView,0)
        .topSpaceToView(image,10)
        .heightIs(Gato_Height_548_(20));
    }
    
    return _nilView;
}
@end
