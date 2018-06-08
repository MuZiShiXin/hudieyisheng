//
//  SecondViewController.m
//  地址选择器
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 sigxui-001. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CitiesView.h"
#import "GatoBaseHelp.h"
@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *provinces;
    NSDictionary *wholeAera;
    CitiesView *city ;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITableView *rightTableview;
@property (nonatomic ,strong) UIView * navView;
@property (nonatomic ,assign) NSInteger Row;
@property (nonatomic, retain) NSArray *arrayList;
@property (nonatomic ,assign) NSInteger shiRow;
@end

@implementation SecondViewController


- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Gato_Width / 3, Gato_Height - NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.rowHeight = 50;
    }
    return _tableView;
}

- (UITableView *)rightTableview {
    if(!_rightTableview) {
        _rightTableview = [[UITableView alloc] initWithFrame:CGRectMake(Gato_Width / 3, 0, Gato_Width, Gato_Height - NAV_BAR_HEIGHT) style:UITableViewStylePlain];
        _rightTableview.delegate = self;
        _rightTableview.dataSource = self;
        _rightTableview.tag = 1;
        [_rightTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _rightTableview.rowHeight = 50;
    }
    return _rightTableview;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.rightTableview];
    wholeAera = [[NSDictionary alloc]init];
    Gato_Return
    self.Row = 0;
    self.title = @"选择城市";
    if (!self.navigationController) {
        [self.view addSubview:self.navView];
        self.tableView.frame = CGRectMake(0, 64, Gato_Width / 3, Gato_Height - 64);
        self.rightTableview.frame = CGRectMake(Gato_Width / 3, 64, Gato_Width, Gato_Height - 64);
    }


    if (self.sheng) {
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:self.sheng inSection:0];
        [self.tableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:firstPath];
        }
        self.Row = self.sheng;
        
    }
    if (self.shi) {
//        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:self.shi inSection:0];
//        [self.rightTableview selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//        if ([self.rightTableview.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
//            [self.rightTableview.delegate tableView:self.rightTableview didSelectRowAtIndexPath:firstPath];
//        }
        self.shiRow = self.shi;
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.title = @"填写收货地址";
    //self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor blackColor],UITextAttributeFont:[UIFont systemFontOfSize:18]};
    //加载数据
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    self.arrayList = provinces[0][@"cities"];
    if (self.sheng) {
        self.arrayList = provinces[self.sheng][@"cities"];
    }
    //[self.tabBarController.tabBar setHidden:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return provinces.count;
    }else{
        return self.arrayList.count ;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        // NSLog(@"%@",provinces);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = provinces[indexPath.row][@"state"];
        cell.textLabel.font = FONT(36);
        cell.backgroundColor = [UIColor appAllBackColor];
        cell.textLabel.textColor = [UIColor HDBlackColor];
        GatoViewBorderRadius(cell, 0, 0.5, [UIColor HDViewBackColor]);
        if (indexPath.row == self.Row) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor HDThemeColor];
            GatoViewBorderRadius(cell, 0, 0, [UIColor HDViewBackColor]);
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = self.arrayList[indexPath.row][@"city"];
        cell.textLabel.font = FONT(36);
        cell.textLabel.textColor = [UIColor HDBlackColor];
        if (indexPath.row == self.shiRow) {
            cell.textLabel.textColor = [UIColor HDThemeColor];
        }
        return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        self.arrayList = provinces[indexPath.row][@"cities"];
        self.Row = indexPath.row;
        [self.tableView reloadData];
        [self.rightTableview reloadData];

    }else if (tableView == self.rightTableview){
        NSDictionary *dic = @{
                              @"city":self.arrayList[indexPath.row][@"city"],
                              @"province":provinces[self.Row][@"state"]
                              };
        self.blockAddress((NSDictionary *)dic ,self.Row ,indexPath.row);
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
    }
    
    
    
    
    
}

-(void)buttonDidClicked
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }
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
        label.text = @"医生资料";
        label.textColor = [UIColor whiteColor];
        [self.navView addSubview:label];
        [self.navView addSubview:button];
        
        image.sd_layout.centerYEqualToView(label);
    }
    return _navView;
}


@end
