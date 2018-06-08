//
//  SearchViewController.m
//  TFSearchBar
//
//  Created by TF_man on 16/5/18.
//  Copyright © 2016年 TF_man. All rights reserved.
//

//RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBA1(r, g, b, a)                    [UIColor colorWithRed:r green:g blue:b alpha:a]
//屏幕宽和高
#define screenWidth ([UIScreen mainScreen].bounds.size.width)
#define screenHeight ([UIScreen mainScreen].bounds.size.height)

#import "SearchController.h"
#import "TableViewCell.h"
#import "SZRadioButton.h"
#import "GatoBaseHelp.h"
#import "GatoReturnButton.h"

@interface SearchController ()<UITableViewDataSource,UITableViewDelegate,TFTableViewDlegate,UITextFieldDelegate>

@property (strong, nonatomic) UIView *statusBar;

@property (strong, nonatomic) NSMutableArray *allDataSource;/**<整个数据源*/

@property (strong, nonatomic) NSMutableArray *allData;/**<一维整个数*/

@property (strong, nonatomic) NSMutableArray *resultData;/**<一维查找的结果*/

@property (strong, nonatomic) NSMutableArray *indexDataSource;/**<索引数据源*/

@property (nonatomic,strong)UITableView *tv;

@property (nonatomic,strong)UITableView *tv2;

@property (nonatomic,strong) NSUserDefaults *ud;
@property (nonatomic,strong) NSMutableArray *allcitys;
@property (nonatomic,strong) NSMutableArray *chaxuns;
//@property (nonatomic,strong) NSString *chaxunStr;


@end

@implementation SearchController

-(NSMutableArray *)chaxuns
{
    if (!_chaxuns)
    {
        self.chaxuns = [NSMutableArray array];
    }
    
    return _chaxuns;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _ud = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏左侧按钮
    GatoReturnButton *returnButton = [[GatoReturnButton alloc] initWithTarget:self IsAccoedingBar:YES];
    self.navigationItem.leftBarButtonItem = returnButton;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-50, 0, 100, 20)];
    label.text = @"选择城市";
//    label.textColor = [UIColor whiteColor];
    //label.font = [UIFont systemFontOfSize:15.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = label;
    
//    [self.tv setTableHeaderView:self.searchController.searchBar];
    
    //添加UITableView
    [self.view addSubview:self.tv2];
  /*
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, 50)];
    searchView.backgroundColor = RGBA1(0.6, 0.6, 0.6, 1);
    
    UIView *searchView1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, screenWidth - 40, 30)];
    searchView1.backgroundColor = [UIColor whiteColor];
    searchView1.layer.cornerRadius = 15.0;
    searchView1.layer.masksToBounds = YES;
    [searchView addSubview:searchView1];
    
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 15, 15)];
    searchImageView.image = [UIImage imageNamed:@"icon39"];
    [searchView1 addSubview:searchImageView];
    
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, screenWidth - 40, 20)];
    searchTextField.placeholder = @"请输入城市名称或手写字母查询";
    searchTextField.delegate = self;
    searchTextField.font = [UIFont systemFontOfSize:12.0];
    searchTextField.returnKeyType = UIReturnKeySearch;
    [searchView1 addSubview:searchTextField];
    
    [self.view addSubview:searchView];
*/
    //添加UITableView
    [self.view addSubview:self.tv];
    
//    self.tv.sectionIndexColor = [UIColor brownColor];
    self.tv.sectionIndexBackgroundColor = RGBA(235, 235, 235, 0);
//    self.tv.sectionIndexTrackingBackgroundColor = [UIColor blueColor];
    
    [self GetDataFromPlistFiles];
    
    
    
    
    
}



#pragma mark -------懒加载

- (UITableView *)tv{
    
    if (!_tv) {
        
        _tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight) style:UITableViewStyleGrouped];
        _tv.delegate = self;
        _tv.dataSource = self;
        
        _tv.sectionFooterHeight = 0;
        _tv.sectionHeaderHeight = 0;
        [_tv registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCellID"];
        
        
    }
    
    return _tv;
}

- (UITableView *)tv2{
    
    if (!_tv2) {
        
        _tv2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight)];
        _tv2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tv2.delegate = self;
        _tv2.dataSource = self;
   
    }
    
    return _tv2;
}

#pragma mark -------从plist文件获取数据

- (void)GetDataFromPlistFiles{
    
    self.allDataSource = [NSMutableArray array];
    self.indexDataSource = [NSMutableArray array];
    self.allData = [NSMutableArray array];
    self.resultData = [NSMutableArray array];
    self.allcitys = [NSMutableArray array];
    //
    NSString *plistPath2 = [[NSBundle mainBundle]pathForResource:@"Property List" ofType:@"plist"];
    NSDictionary *dic2 = [[NSDictionary alloc]initWithContentsOfFile:plistPath2];
    /*
    NSArray *arr2 = [dic2 allKeys];
    arr2 = [arr2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    for (NSString *str  in arr2) {
        
        [self.indexDataSource addObject:str];
        NSArray *array = dic2[str];
        NSLog(@"%@",array);
        [self.allDataSource addObject:array];

    }
    */
#pragma mark 定位城市
    [self.indexDataSource addObject:@"定位城市"];
    [self.allDataSource addObject:@[_dwCity]];
    [self.allData addObjectsFromArray:@[_dwCity]];
    NSDictionary *dict = [_ud objectForKey:@"visitCity"];
    NSArray *array = [dict allValues];
    
    if (array != nil)
    {
        [self.indexDataSource addObject:@"最近访问城市"];
        [self.allDataSource addObject:array];
        [self.allData addObjectsFromArray:array];
    }
    else
    {
        [self.indexDataSource addObject:@"最近访问城市"];
        [self.allDataSource addObject:@[]];
        [self.allData addObjectsFromArray:@[]];
    }
    
    [self.indexDataSource addObject:@"热门城市"];
    NSArray *array1 = dic2[@"热门城市"];
    [self.allDataSource addObject:array1];
    [self.allData addObjectsFromArray:array1];
    
    //所有的城市
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"cityDictionary" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];

    NSArray *arr = [dic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    for (NSString *str  in arr) {

        [self.indexDataSource addObject:str];
        NSArray *array = dic[str];
        [self.allDataSource addObject:array];
        [self.allData addObjectsFromArray:array];
        [self.allcitys addObjectsFromArray:array];
     
    }

    [self.tv reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.tv2)
    {
        
        return 1;
        
    }
    return self.allDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tv2) {
        
        return self.resultData.count;
        
    }else{
        
        
        if (section > 2) {
            
            NSArray *array = self.allDataSource[section];
            
            return array.count;
            
        }else{
            
            return 1;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tv2) {
        
        static NSString *cellID = @"cellID2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        cell.backgroundColor = RGBA1(0.96, 0.96, 0.96, 1.0);
        cell.textLabel.text = self.resultData[indexPath.row];
        CALayer *layer = [[CALayer alloc]init];
        layer.frame = CGRectMake(0, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 1, screenWidth, 1);
        layer.backgroundColor = RGBA(233, 233, 233, 1).CGColor;
        [cell.contentView.layer addSublayer:layer];
        
        return cell;
        
    }
    else
    {
        
        if (indexPath.section > 2)
        {
            
            static NSString *cellID = @"cellID";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                
            }
            cell.backgroundColor = [UIColor whiteColor];
            NSArray *array = self.allDataSource[indexPath.section];
//            NSLog(@"%ld",(long)indexPath.section);
            cell.textLabel.text = array[indexPath.row];
            cell.textLabel.font = FONT(24);
            return cell;
            
        }else{
            
            TableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            cell.delegate = self;
            cell.sections = indexPath.section;
            NSArray *array = self.allDataSource[indexPath.section];
            cell.cellArr = array;
            return cell;
        }
        
        
    }

}

//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    if (tableView == self.tv) {
        
        NSMutableArray *mutArr = [NSMutableArray array];
        [mutArr addObjectsFromArray:(NSArray *)self.indexDataSource];
        [mutArr replaceObjectAtIndex:0 withObject:@"定位"];
        [mutArr replaceObjectAtIndex:1 withObject:@"最近"];
        [mutArr replaceObjectAtIndex:2 withObject:@"热门"];
        
        return mutArr;
    }else{
        
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[TableViewCell class]])
    {
        NSMutableDictionary *dict = [_ud objectForKey:@"visitCity"];
        
        NSString *str = [dict objectForKey:cell.textLabel.text];
        
        if (str == nil)
        {
            if (dict == nil)
            {
                NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
                [dict1 setValue:cell.textLabel.text forKey:cell.textLabel.text];
                [_ud setObject: dict1 forKey:@"visitCity"];
            }
            else
            {
                NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
                NSArray *values = [dict allValues];
                for (NSInteger i = 0; i < values.count; i++)
                {
                    [dict1 setValue:values[i] forKey:values[i]];
                }
                
                [dict1 setValue:cell.textLabel.text forKey:cell.textLabel.text];
                [_ud removeObjectForKey:@"visitCity"];
                [_ud setObject: dict1 forKey:@"visitCity"];
            }
            
        }
        
        [UIView animateWithDuration:0.5 animations:^
        {
            //[_searchBar resignFirstResponder];
            
        } completion:^(BOOL finished)
        {
            if (self.succeed)
            {
                self.succeed(cell.textLabel.text);
            }
            [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:GET_CITY];
            [self.navigationController popToRootViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:^
//            {
//            }];
        }];
        
        
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tv) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        view.backgroundColor = RGBA1(0.93, 0.93, 0.93, 1.0);;
        UILabel *lb = [UILabel new];
        lb.center = CGPointMake(25, 10);
        lb.text = self.indexDataSource[section];
        lb.textColor = RGBA1(0.4, 0.4, 0.4, 1);
        lb.font = [UIFont systemFontOfSize:12.0];
        [lb sizeToFit];
        [view addSubview:lb];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
    if (indexPath.section > 2) {
        
        return 40;
        
    }else{
        
        NSArray *array = self.allDataSource[indexPath.section];
        return array.count/3*45+60;
        
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tv2) {
        
        return 0.001;
    }
    return 30;
}


#pragma mark - UISearchDelegate

- (void)cancelBtnClick{
    
   
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark -------TFTableViewDlegate

- (void)TableViewSelectorIndix:(NSString *)str
{
    NSMutableDictionary *dict = [_ud objectForKey:@"visitCity"];
    
    NSString *cityStr = [dict objectForKey:str];
    
    if (cityStr == nil)
    {
        if (dict == nil)
        {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            [dict1 setValue:str forKey:str];
            [_ud setObject: dict1 forKey:@"visitCity"];
        }
        else
        {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
            NSArray *values = [dict allValues];
            for (NSInteger i = 0; i < values.count; i++)
            {
                [dict1 setValue:values[i] forKey:values[i]];
            }
            
            [dict1 setValue:str forKey:str];
            [_ud removeObjectForKey:@"visitCity"];
            [_ud setObject: dict1 forKey:@"visitCity"];
        }
        
    }

    [[NSUserDefaults standardUserDefaults] setObject:str forKey:GET_CITY];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        
        if (self.succeed) {
            self.succeed(str);
        }
//
//    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.tv2.hidden = NO;
    [self.resultData removeAllObjects];
    
    if ([string isEqualToString:@""])
    {
        
        [self.chaxuns removeLastObject];
        
        if (self.chaxuns.count == 0)
        {
            self.tv2.hidden = YES;
            return YES;
        }

    }
    else
    {
        if (string.length > 1)
        {
            for (NSInteger i = 0; i < string.length; i++)
            {
                [self.chaxuns addObject:[string substringWithRange:NSMakeRange(i, 1)]];
            }
        }
        else
        {
            [self.chaxuns addObject:string];
        }
        
    }
    NSString *str;
    if (self.chaxuns.count > 1)
    {
        str = self.chaxuns[0];
        
        for (NSInteger i = 1; i < self.chaxuns.count; i++)
        {
            str = [NSString stringWithFormat:@"%@%@",str,self.chaxuns[i]];
        }
        //_chaxunStr = str;
    }
    else
    {
        str = self.chaxuns[0];
        //_chaxunStr = self.chaxuns[0];
    }
    
    //一维查找
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", str];
//    NSLog(@"%@",textField.text);
    NSArray *filterdArray = [self.allcitys filteredArrayUsingPredicate:predicate];
    
//    NSLog(@"%lu",(unsigned long)filterdArray.count);
    
    [self.resultData addObjectsFromArray:filterdArray];
    
    [self.view bringSubviewToFront:self.tv2];
    [self.tv2 reloadData];

    return YES;
}

/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.resultData removeAllObjects];
    //一维查找
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", textField.text];
    
    NSArray *filterdArray = [(NSArray *)self.allData filteredArrayUsingPredicate:predicate];
    
    [self.resultData addObjectsFromArray:filterdArray];
    
    [self.view bringSubviewToFront:self.tv2];
    [self.tv2 reloadData];

    return YES;
}
*/


//-(CLLocationManager *)locationManager
//{
//    if (!_locationManager) {
//        _locationManager = [[CLLocationManager alloc] init];
//        
//        //设置代理
//        
//        _locationManager.delegate = self;
//        
//        //定位精度
//        
//        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    }
//    return _locationManager;
//}

@end
