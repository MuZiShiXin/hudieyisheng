//
//  CityChooseViewController.m
//  yoyo
//
//  Created by YoYo on 16/5/12.
//  Copyright © 2016年 cn.yoyoy.mw. All rights reserved.
//

#import "CityChooseViewController.h"
#import "tishiXiaoShiViewController.h"
#import "GatoBaseHelp.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define RGBA1(r, g, b, a)    [UIColor colorWithRed:r green:g blue:b alpha:a]


@interface CityChooseViewController ()<UITableViewDelegate, UITableViewDataSource>

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
@property (nonatomic,strong) NSMutableArray *bgViews;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,assign) BOOL isFirst1;
@property (nonatomic ,strong) UIView * navView;
@end

@implementation CityChooseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"provinceArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"areaArray"];
}
-(NSMutableArray *)bgViews
{
    if (!_bgViews)
    {
        self.bgViews = [NSMutableArray array];
    }
    
    return _bgViews;
}

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
    [self.view addSubview:self.navView];
    [self addTableView];
}
-(UIView *)navView
{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 64)];;
        _navView.backgroundColor = [UIColor HDThemeColor];
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, Gato_Width_320_(150), Gato_Height_548_(90));
        //    [button setBackgroundColor:[UIColor blueColor]];
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(20, Gato_Height_548_(60),Gato_Width_320_(45), Gato_Height_548_(45))];
        image.image = [UIImage imageNamed:@"nav_back"];
        [button addSubview:image];
        
        UIView * fgx = [[UIView alloc]initWithFrame:CGRectMake(0, 63, Gato_Width, 1)];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [self.navView addSubview:fgx];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, Gato_Width, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(18)];
        label.text = @"选择城市";
        [self.navView addSubview:label];
        [self.navView addSubview:button];
        
        UIButton *queding =  [UIButton buttonWithType:UIButtonTypeSystem];
        //    [button setBackgroundImage:[UIImage imageNamed:@"returnButtonImage"] forState:UIControlStateNormal];
        queding.frame = CGRectMake(Gato_Width - 75, 20, Gato_Width_320_(45), 44);
        //    [button setBackgroundColor:[UIColor blueColor]];
        [queding setTitle:@"确定" forState:UIControlStateNormal];
        [queding setTitleColor:[UIColor YMAppAllColor] forState:UIControlStateNormal];
        [queding addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self.navView addSubview:queding];
        
        image.sd_layout.centerYEqualToView(label);

    }
    return _navView;
}

-(void)buttonDidClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

//赋值
- (void)returnCityInfo:(CityBlock)block
{
    _cityInfo = block;
}

-(void)returnCityInfoArray:(cityArrayBlock)block
{
    _cityInfoArray = block;
}

#pragma mark 创建两个tableView
- (void)addTableView
{
    self.title = @"城市";
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
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_width/4, screen_height - 64) style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    [_mainTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone]; //默认省份选中第一行
    [self.view addSubview:_mainTableView];
    
    _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(screen_width / 4, 64, screen_width * 3 / 4, screen_height - 64) style:UITableViewStylePlain];
    _subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subTableView.dataSource = self;
    _subTableView.delegate = self;
    [self.view addSubview:_subTableView];
    
}

#pragma mark 确认选择
-(void) sureAction
{
    if (_cityInfoArray != nil && _provinceArray != nil && _areaArray != nil)
    {
        if (_provinceArray.count > 3 && _areaArray.count > 3)
        {
            
            [tishiXiaoShiViewController showMessage:@"最多可选择三个城市"];
            [_provinceArray removeAllObjects];
            [_areaArray removeAllObjects];
        }
        else
        {
            _cityInfoArray(_provinceArray,_areaArray);
            [_provinceArray removeAllObjects];
            [_areaArray removeAllObjects];
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(3, 0, screen_width/4-3, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        bgView.backgroundColor = RGBA1(0.97, 0.97, 0.97, 1.0);;
        [cell.contentView addSubview:bgView];
        [self.bgViews addObject:bgView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, screen_width/4-3, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
        label.backgroundColor = [UIColor clearColor];
        label.text = _cityList[indexPath.row][@"state"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = RGBA1(0.43, 0.43, 0.43, 1.0);
        
        UIView *prView = [[UIView alloc]initWithFrame:CGRectMake(screen_width/4-15, 18, 8, 8)];
        prView.backgroundColor = RGBA1(0, 0.74, 0.84, 1.0);
        prView.layer.cornerRadius = 4;
        prView.layer.masksToBounds = YES;
        prView.hidden = YES;
        [bgView addSubview:prView];
        
        if ([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"provinceArray"])
        {
            NSMutableArray *provinceArray = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"provinceArray"];
            
            if (!_isFirst)
            {
                _isFirst = YES;
                for (NSInteger i = 0; i < provinceArray.count; i++)
                {
                    [_provinceArray addObject:provinceArray[i]];
                    
                    if ([label.text isEqualToString:provinceArray[i]])
                    {
                        prView.hidden = NO;
                    }
                }
            }
            else
            {
                for (NSInteger i = 0; i < provinceArray.count; i++)
                {
                    if ([label.text isEqualToString:provinceArray[i]])
                    {
                        prView.hidden = NO;
                    }
                }
            }
            
        }
        
        if (indexPath.row == 0)
        {
            bgView.backgroundColor = [UIColor whiteColor];
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
        btn.frame = CGRectMake(75, 7, 80, 30);
        btn.layer.cornerRadius = 13.0;
        btn.layer.borderColor = RGBA1(0.8, 0.8, 0.8, 1.0).CGColor;
        btn.layer.borderWidth = 1.0;
        btn.tag = indexPath.row;
        [btn setTitle:area forState:UIControlStateNormal];
        [btn setTitleColor:RGBA1(0.55, 0.55, 0.55, 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [btn addTarget:self action:@selector(xzcs:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        if ([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"areaArray"])
        {
            NSArray *areaArray = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"areaArray"];
            
            if (!_isFirst1)
            {
                _isFirst1 = YES;
                for (NSInteger i = 0; i < areaArray.count; i++)
                {
                    [_areaArray addObject:areaArray[i]];
                }
            }
            
        }
        
        for (NSString *cs in _areaArray)
        {
            if ([area isEqualToString:cs])
            {
                btn.selected = YES;
                btn.backgroundColor = RGBA1(0, 0.86, 0.91, 1.0);
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
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
                [tishiXiaoShiViewController showMessage:@"最多选择三个城市"];
                //[_provinceArray removeLastObject];
                //[_areaArray removeLastObject];
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
                NSLog(@" add_areaArray %@",_areaArray);
            }
        }
        else
        {
            NSInteger index = 0;
            for (NSInteger i = 0; i < _areaArray.count; i++)
            {
                if ([_area isEqualToString:_areaArray[i]])
                {
                    index = i;
                }
                
            }
            if (![_area isEqualToString:_areaArray[index]]) {
                return;
            }
            [_provinceArray removeObjectAtIndex:index];
            [_areaArray removeObjectAtIndex:index];
            NSLog(@" remove_areaArray %@",_areaArray);
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
        label.textColor = RGBA1(0.43, 0.43, 0.43, 1.0);
    }
    
    UILabel *currentLabel = self.labels[sender.tag];
    currentLabel.textColor = RGBA1(0.29, 0.77, 0.89, 1.0);
    
    for (UIView *bgView in self.bgViews)
    {
        bgView.backgroundColor = RGBA1(0.97, 0.97, 0.97, 1.0);
    }
    
    UIView *currentBgView = self.bgViews[sender.tag];
    currentBgView.backgroundColor = [UIColor whiteColor];
    
    _province = _cityList[sender.tag][@"state"]; //赋值
    if (self.navigationController != nil)
    { //不是push过来的
        _sureBtn.hidden = YES;
    }
    _selIndex = sender.tag;
    _clickRefresh = YES;
    [_subTableView reloadData];
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        _clickRefresh = NO;
        if (_cityInfo != nil)
        {
            _cityInfo(_province, _area);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            _sureBtn.hidden = NO;
            
            if (_provinceArray.count > 2)
            {
                [tishiXiaoShiViewController showMessage:@"最多选择三个城市"];
                [_provinceArray removeLastObject];
                [_areaArray removeLastObject];
                return;
            }
            else
            {
                //记录当前选中的位置索引
                [_provinceArray addObject:_province];
                [_areaArray addObject:_area];
                _subSelIndex = indexPath;
                
            }
            
        }
        
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
