//
//  CityChooseViewController.m
//  yoyo
//
//  Created by YoYo on 16/5/12.
//  Copyright © 2016年 cn.yoyoy.mw. All rights reserved.
//

#import "SZCityChooseViewController.h"

#import "tishiXiaoShiViewController.h"

#import "GatoBaseHelp.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define RGBA1(r, g, b, a)    [UIColor colorWithRed:r green:g blue:b alpha:a]

@interface SZCityChooseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *mainTableView; //主
@property (strong, nonatomic) UITableView *subTableView; //次
@property (strong, nonatomic) NSMutableArray *cityList; //城市列表
@property (assign, nonatomic) NSInteger selIndex;//主列表当前选中的行
@property (assign, nonatomic) NSIndexPath *subSelIndex;//子列表当前选中的行
@property (assign, nonatomic) BOOL clickRefresh;//是否是点击主列表刷新子列表,系统刚开始默认为NO
@property (copy, nonatomic) NSString *province; //选中的省
@property (copy, nonatomic) NSString *area; //选中的地区
@property (strong, nonatomic) UIButton *sureBtn;//push过来的时候，右上角的确定按钮
@property (nonatomic,strong) NSMutableArray *provinceArray;

@property (nonatomic,strong) NSMutableArray *areaArray;
@property (nonatomic,strong) NSMutableArray *views;
@property (nonatomic,strong) NSMutableArray *labels;
@end

@implementation SZCityChooseViewController

-(NSMutableArray *)views
{
    if (!_views)
    {
        self.views = [NSMutableArray array];
    }
    
    return _views;
}

-(NSMutableArray *)labels
{
    if (!_labels)
    {
        self.labels = [NSMutableArray array];
    }
    
    return _labels;
}

-(instancetype)init
{
    if (self = [super init])
    {
        _provinceArray = [NSMutableArray array];
        _areaArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layOutNaviBar];
    [self addTableView];
}

//赋值
- (void)returnCityInfo:(CityBlock)block
{
    _cityInfo = block;
}

#pragma mark 创建两个tableView
- (void)addTableView
{
    //self.title = @"城市";
    self.view.backgroundColor = [UIColor whiteColor];
    //获取目录下的city.plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    _cityList = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"当前城市" forKey:@"state"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dwCity"])
    {
        [dict setValue:@[[[NSUserDefaults standardUserDefaults] objectForKey:@"dwCity"]] forKey:@"cities"];
    }
    else
    {
        [dict setValue:@[@"定位失败"] forKey:@"cities"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dwCity"])
    {
        [_cityList insertObject:dict atIndex:0];
    }
    
    //刚开始，默认选中第一行
    _selIndex = 0;
    _province = _cityList.firstObject[@"state"]; //赋值
    //tableView
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width / 4, screen_height) style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [_mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone]; //默认省份选中第一行
    [self.view addSubview:_mainTableView];
    
    _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(screen_width / 4, self.navigationController == nil ? 0 : 64, screen_width * 3 / 4, screen_height - (self.navigationController == nil ? 0 : 64)) style:UITableViewStylePlain];
    _subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subTableView.dataSource = self;
    _subTableView.delegate = self;
    [self.view addSubview:_subTableView];
    
}

-(void)layOutNaviBar
{
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(-8, 0, Gato_Width, 44)];
    naviView.backgroundColor = [UIColor clearColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //leftBtn.highlighted = YES;
    leftBtn.frame = CGRectMake(-15, 0, 84, 44);
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [leftBtn addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"icon41"] forState:UIControlStateNormal];
    [naviView addSubview:leftBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Gato_Width/2-50, 0, 100, 44)];
    label.text = @"选择地区";
    label.textColor = [UIColor blackColor];
    [naviView addSubview:label];
    
    /*
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(Gato_Width - 64, 0, 44, 44);
    [rightBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBA1(0, 0.79, 0.91, 1.0) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:rightBtn];
    //rightBtn.hidden = YES;
    _sureBtn = rightBtn;
    */
    self.navigationItem.titleView = naviView;
}


-(void)popView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 确认选择
-(void)sureAction
{
    if (_cityInfo != nil && _province != nil && _area != nil)
    {
        _cityInfo(_province, _area);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_mainTableView])
    {
        return _cityList.count;
    }
    else
    {
        NSArray *areaList = _cityList[_selIndex][@"cities"];
        return areaList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_mainTableView])
    {
        static NSString *mainCellId = @"mainCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCellId];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        view.backgroundColor = RGBA1(0.97, 0.97, 0.97, 1.0);
        if (indexPath.row == 0)
        {
            view.backgroundColor = RGBA1(0.44, 0.81, 0.98, 1.0);
        }
        [self.views addObject:view];
        [cell.contentView addSubview:view];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, screen_width/4-3, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        label.backgroundColor = RGBA1(0.97, 0.97, 0.97, 1.0);
        label.text = _cityList[indexPath.row][@"state"];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGBA1(0.43, 0.43, 0.43, 1.0);
        if (indexPath.row == 0)
        {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = RGBA1(0.29, 0.77, 0.89, 1.0);
        }
        [self.labels addObject:label];
        [cell.contentView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, screen_width/4-1, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(xuanze:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        /*
        cell.textLabel.text = _cityList[indexPath.row][@"state"];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 43, screen_width / 4-9, 1)];
        view.backgroundColor = RGBA(233, 233, 233, 1);
        [cell.contentView addSubview:view];
         */
        return cell;
    }
    else
    {
        static NSString *subCellId = @"subCellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subCellId];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        NSArray *areaList = _cityList[_selIndex][@"cities"];
        NSString *area = areaList[indexPath.row];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(75, 7, 100, 30);
        btn.layer.cornerRadius = 3.0;
        btn.layer.borderColor = RGBA1(0.8, 0.8, 0.8, 1.0).CGColor;
        btn.layer.borderWidth = 1.0;
        btn.tag = indexPath.row;
        [btn setTitle:area forState:UIControlStateNormal];
        [btn setTitleColor:RGBA1(0.55, 0.55, 0.55, 1.0) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(xzcs:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        for (NSString *cs in _areaArray)
        {
            if ([area isEqualToString:cs])
            {
                btn.selected = YES;
                btn.backgroundColor = RGBA1(0, 0.86, 0.91, 1.0);
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        /*
        NSArray *areaList = _cityList[_selIndex][@"cities"];
        cell.textLabel.text = areaList[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
        if (_subSelIndex == indexPath && _clickRefresh == NO)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 43, screen_width * 3 / 4-10, 1)];
        view.backgroundColor = RGBA(233, 233, 233, 1);
        [cell.contentView addSubview:view];
         */
        return cell;
    }
}

-(void)xzcs:(UIButton *)sender
{
    _area = _cityList[_selIndex][@"cities"][sender.tag]; //赋值
    _clickRefresh = NO;
    if (_cityInfo != nil)
    {
        _cityInfo(_province, _area);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        _sureBtn.hidden = NO;
        sender.selected = !sender.selected;
        
        if(sender.selected)
        {
            if (_provinceArray.count > 2)
            {
                 [tishiXiaoShiViewController showMessage:@"最多选择三个城市" ];
                [_provinceArray removeLastObject];
                [_areaArray removeLastObject];
                return;
            }
            else
            {
                //记录当前选中的位置索引
                [_provinceArray addObject:_province];
                [_areaArray addObject:_area];
                sender.backgroundColor = RGBA1(0, 0.86, 0.91, 1.0);
                [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                //当前选择的打勾
                
            }
        }
        else
        {
            [_provinceArray removeObject:_province];
            [_areaArray removeObject:_area];
            sender.backgroundColor = [UIColor whiteColor];
            [sender setTitleColor:RGBA1(0.55, 0.55, 0.55, 1.0) forState:UIControlStateNormal];
        }
        
        
    }

}

-(void)xuanze:(UIButton *)sender
{
    for (UIView *view in self.views)
    {
        view.backgroundColor = RGBA1(0.97, 0.97, 0.97, 1.0);
    }
    
    UIView *currentView = self.views[sender.tag];
    currentView.backgroundColor = RGBA1(0.44, 0.81, 0.98, 1.0);
    
    for (UILabel *label in self.labels)
    {
        label.backgroundColor = RGBA1(0.97, 0.97, 0.97, 1.0);
        label.textColor = RGBA1(0.43, 0.43, 0.43, 1.0);
    }
    
    UILabel *currentLabel = self.labels[sender.tag];
    currentLabel.backgroundColor = [UIColor whiteColor];
    currentLabel.textColor = RGBA1(0.29, 0.77, 0.89, 1.0);
    _province = _cityList[sender.tag][@"state"]; //赋值
    if (self.navigationController != nil)
    { //不是push过来的
        _sureBtn.hidden = YES;
    }
    _selIndex = sender.tag;
    _clickRefresh = YES;
    [_subTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_mainTableView])
    {
        _province = _cityList[indexPath.row][@"state"]; //赋值
        if (self.navigationController != nil)
        { //不是push过来的
            _sureBtn.hidden = YES;
        }
        _selIndex = indexPath.row;
        _clickRefresh = YES;
        [_subTableView reloadData];
    }
    else
    {
        _area = _cityList[_selIndex][@"cities"][indexPath.row]; //赋值
        
        if (_provinceArray.count > 2)
        {
             [tishiXiaoShiViewController showMessage:@"最多选择三个城市" ];
            return;
        }
        else
        {
            [_provinceArray addObject:_province];
            [_areaArray addObject:_area];
        }
        
        _clickRefresh = NO;
        //之前选中的，取消选择
        UITableViewCell *celled = [tableView cellForRowAtIndexPath:_subSelIndex];
        celled.accessoryType = UITableViewCellAccessoryNone;
        //记录当前选中的位置索引
        _subSelIndex = indexPath;
        //当前选择的打勾
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (self.navigationController == nil)
        { //不是push过来的
            if (_cityInfo != nil)
            {
                _cityInfo(_province, _area);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
