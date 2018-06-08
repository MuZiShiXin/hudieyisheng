//
//  consultingInfoViewController.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "consultingInfoViewController.h"
#import "GatoBaseHelp.h"
#import "PellTableViewSelect.h"
#import "TitleAndSelectModel.h"
#import "restDayTableViewCell.h"
#define buttonTag 5031411
@interface consultingInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
//遵循协议
@property (nonatomic,strong)UIView * PKView;//加载滚轮的view
@property (nonatomic,strong)UIPickerView * pickerView;//自定义pickerview
@property (nonatomic,strong)NSMutableArray * letter;//保存要展示的字母
@property (nonatomic,strong)NSArray * number;//保存要展示的数字

@property (nonatomic ,strong) UILabel * moneryLabel;//价格
@property (nonatomic ,strong) NSString * moneryStr;

@property (nonatomic,strong)UIView * restView;//加载日期view
@property (nonatomic ,strong) UILabel * restDay;//休息日

@property (nonatomic ,strong) NSString *payPriceStr;//咨询价格参数
@property (nonatomic ,strong) NSString *notDisturbStr;//勿扰参数

@end

@implementation consultingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"咨询设置";
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,50,30)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(26);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchprogram) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.view.backgroundColor = [UIColor appAllBackColor];
    
    [self addAllViews];
    //获取需要展示的数据
    [self loadData];
    

    self.moneryLabel.sd_layout.rightSpaceToView(self.view,Gato_Width_320_(30))
    .topSpaceToView(self.view,0)
    .leftSpaceToView(self.view,Gato_Height_548_(100))
    .heightIs(Gato_Height_548_(40));
    
    self.restDay.sd_layout.rightEqualToView(self.moneryLabel)
    .topSpaceToView(self.moneryLabel,0)
    .widthRatioToView(self.moneryLabel,1)
    .heightRatioToView(self.moneryLabel,1);
    
    self.notDisturbStr = self.model.notDisturb;
    self.payPriceStr = self.model.payPrice.length > 0 ? self.model.payPrice : @"9";
    self.moneryLabel.text = [NSString stringWithFormat:@"%@ 元 ／ 3次",self.payPriceStr];
    
    self.updataArray = [NSMutableArray array];
    NSArray * titleArray = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    for (int i = 1 ; i < 8; i ++) {
        TitleAndSelectModel * model = [[TitleAndSelectModel alloc]init];
        model.title = titleArray[i - 1];
        if ([self.model.notDisturb containsString:[NSString stringWithFormat:@"%d",i ]] || [self.model.notDisturb containsString:titleArray[i - 1]]) {
           model.select = YES;
        }else{
           model.select = NO;
        }
        model.titleId = [NSString stringWithFormat:@"%d",i];
        [self.updataArray addObject:model];
    }
    
    
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"1"withString:@"每周一"];
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"2"withString:@"每周二"];
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"3"withString:@"每周三"];
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"4"withString:@"每周四"];
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"5"withString:@"每周五"];
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"6"withString:@"每周六"];
    self.model.notDisturb = [self.model.notDisturb stringByReplacingOccurrencesOfString:@"7"withString:@"每周日"];
    self.restDay.text = self.model.notDisturb;
   
    
    
}

#pragma mark - 保存信息
-(void)searchprogram
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:TOKEN forKey:@"token"];
    [self.updateParms setObject:@"" forKey:@"photo"];
    [self.updateParms setObject:self.model.name forKey:@"name"];
    [self.updateParms setObject:self.model.sex forKey:@"sex"];
    [self.updateParms setObject:self.model.birthday forKey:@"birthday"];
    [self.updateParms setObject:ModelNull(self.model.isBirthday) forKey:@"isBirthday"];
    [self.updateParms setObject:ModelNull(self.model.introduction) forKey:@"introduction"];
    [self.updateParms setObject:ModelNull(self.model.speciality) forKey:@"speciality"];
    [self.updateParms setObject:ModelNull(self.model.workAddress) forKey:@"workAddress"];
    [self.updateParms setObject:ModelNull(self.payPriceStr)  forKey:@"payPrice"];
    [self.updateParms setObject:ModelNull(self.notDisturbStr) forKey:@"notDisturb"];
    [self.updateParms setObject:self.model.payPriceSet forKey:@"payPriceSet"];
    [IWHttpTool postWithURL:HD_Mine_Info_data_UPdate params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            if (self.payPriceBlock) {
                self.payPriceBlock(self.payPriceStr,self.notDisturbStr);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.updataArray.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    restDayTableViewCell * cell = [restDayTableViewCell cellWithTableView:tableView];
    TitleAndSelectModel * model = [[TitleAndSelectModel alloc]init];
    model = self.updataArray[indexPath.row];
    [cell setValueWithModel:model];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Gato_Height_548_(35);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TitleAndSelectModel * model = [[TitleAndSelectModel alloc]init];
    model = self.updataArray[indexPath.row];
    model.select = !model.select;
    [self.updataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [self.GatoTableview reloadData];
}



#pragma mark 加载数据
-(void)loadData
{
    self.letter = [NSMutableArray array];
    //需要展示的数据以数组的形式保存、
    for (int i = 0 ; i < 30; i ++) {
        NSString * str = [NSString stringWithFormat:@"%d9",i];
        if ([str isEqualToString:@"09"]) {
            str = @"9";
        }
        [self.letter addObject:str];
    }
    self.number = @[@"元 / 3次"];
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.letter.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = self.number.count;
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.letter[row];
            break;
        case 1:
            title = self.number[row];
            break;
        default:
            break;
    }
    
    return title;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
//选中时回调的委托方法，在此方法中实现省份和城市间的联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.moneryStr = [NSString stringWithFormat:@"%@%@",self.letter[row],self.number[0]];
    self.payPriceStr = [NSString stringWithFormat:@"%@",self.letter[row]];
}

-(void)leftButtonDid
{
    [PellTableViewSelect hiden];
}

-(void)rightButtonDid
{
    if (self.moneryStr) {
        self.moneryLabel.text = self.moneryStr;
    }else{
        self.payPriceStr = @"9";
        self.moneryLabel.text = @"9元／3次";
    }
    
    [PellTableViewSelect hiden];
}



-(void)addAllViews
{
    NSArray * titleArra = @[@"付费咨询价格设置",@"勿扰模式"];
    
    for (int i = 0 ; i < 2 ; i ++) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view.sd_layout.leftSpaceToView(self.view,0)
        .rightSpaceToView(self.view,0)
        .topSpaceToView(self.view,i * Gato_Height_548_(40))
        .heightIs(Gato_Height_548_(40));
        
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor HDBlackColor];
        label.font = FONT_Bold_(26);
        label.text = titleArra[i];
        [view addSubview:label];
        
        label.sd_layout.leftSpaceToView(view,Gato_Width_320_(15))
        .topSpaceToView(view,0)
        .widthIs(Gato_Width_320_(150))
        .heightIs(Gato_Height_548_(40));
        
        UIImageView * jiantou = [[UIImageView alloc]init];
        jiantou.image = [UIImage imageNamed:@"more"];
        [view addSubview:jiantou];
        jiantou.sd_layout.rightSpaceToView(view,Gato_Width_320_(10))
        .centerYEqualToView(view)
        .widthIs(Gato_Width_320_(7))
        .heightIs(Gato_Height_548_(12));
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + buttonTag;
        [view addSubview:button];
        button.sd_layout.leftSpaceToView(view,0)
        .rightSpaceToView(view,0)
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0);
        
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor appAllBackColor];
        [view addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(view,0)
        .rightSpaceToView(view,0)
        .bottomSpaceToView(view,0)
        .heightIs(Gato_Height_548_(0.5));
    }
}

-(void)buttonDidClicked:(UIButton *)sender
{
    if (sender.tag - buttonTag == 0) {
        //价格
//        [PellTableViewSelect addPellTableViewSelectWithwithView:self.PKView
//                                                    WindowFrame:CGRectMake(0, 0,Gato_Width_320_(274), Gato_Height_548_(240))
//                                                  WithViewFrame:CGRectMake(Gato_Width_320_(24), Gato_Height_548_(141), Gato_Width_320_(274), Gato_Height_548_(240))
//                                                     selectData:nil
//                                                         action:^(NSInteger index) {
//                                                             ;
//                                                         } animated:YES];
        
        UIActionSheet * sexSheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"9元／3次",@"19元／3次",@"29元／3次",@"39元／3次",@"49元／3次",@"59元／3次",@"69元／3次",@"79元／3次",@"89元／3次",@"99元／3次",@"109元／3次",@"119元／3次",@"129元／3次",@"139元／3次",@"149元／3次",@"159元／3次",@"169元／3次",@"179元／3次",@"189元／3次",@"199元／3次",@"209元／3次",@"219元／3次",@"229元／3次",@"239元／3次",@"249元／3次",@"259元／3次",@"269元／3次",@"279元／3次",@"289元／3次",@"299元／3次", nil];
        [sexSheet showInView:self.view];
    }else{
        //日期
        [PellTableViewSelect addPellTableViewSelectWithwithView:self.restView
                                                    WindowFrame:CGRectMake(0, 0,Gato_Width_320_(274), Gato_Height / 2)
                                                  WithViewFrame:CGRectMake(Gato_Width_320_(24), Gato_Height / 2, Gato_Width_320_(274), Gato_Height / 2)
                                                     selectData:nil
                                                         action:^(NSInteger index) {
                                                             ;
                                                         } animated:YES];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 30) {
        
    }else{
        NSArray * array = @[@"9元／3次",@"19元／3次",@"29元／3次",@"39元／3次",@"49元／3次",@"59元／3次",@"69元／3次",@"79元／3次",@"89元／3次",@"99元／3次",@"109元／3次",@"119元／3次",@"129元／3次",@"139元／3次",@"149元／3次",@"159元／3次",@"169元／3次",@"179元／3次",@"189元／3次",@"199元／3次",@"209元／3次",@"219元／3次",@"229元／3次",@"239元／3次",@"249元／3次",@"259元／3次",@"269元／3次",@"279元／3次",@"289元／3次",@"299元／3次"];
        self.moneryLabel.text = array[buttonIndex];
        NSRange range = [array[buttonIndex] rangeOfString:@"元／3次"];
        NSString *subStr = [array[buttonIndex] substringToIndex:range.location];
        self.payPriceStr = subStr;
    }
}

-(void)quedingTableviewButton
{
    NSString * dayStr;
    NSInteger notDisurbInt = 0;//累计如果等于updataArray。count  那么说明晴空数据
    for (int i = 0 ; i < self.updataArray.count ; i ++) {
        TitleAndSelectModel * model = [[TitleAndSelectModel alloc]init];
        model = self.updataArray[i];
        if (model.select == YES) {
            if (dayStr.length > 0) {
                dayStr = [NSString stringWithFormat:@"%@,%@",dayStr,model.title];
                self.notDisturbStr = [NSString stringWithFormat:@"%@,%@",self.notDisturbStr,model.titleId];
            }else{
                dayStr = model.title;
                self.notDisturbStr = model.titleId;
            }
        }else{
            notDisurbInt ++;
        }
    }
    if (notDisurbInt == self.updataArray.count) {
        self.notDisturbStr = @"";
    }else{
        self.notDisturbStr = [NSString stringWithFormat:@"%@,",self.notDisturbStr];
    }
    
    self.restDay.text = dayStr;
    [PellTableViewSelect hiden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)PKView
{
    if (!_PKView) {
        _PKView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height_548_(240))];
        _PKView.backgroundColor = [UIColor whiteColor];
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        leftButton.titleLabel.font = FONT(30);
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonDid) forControlEvents:UIControlEventTouchUpInside];
        [self.PKView addSubview:leftButton];
        leftButton.sd_layout.leftSpaceToView(self.PKView,0)
        .topSpaceToView(self.PKView,0)
        .widthIs(Gato_Width_320_(80))
        .heightIs(Gato_Height_548_(40));
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        rightButton.titleLabel.font = FONT(30);
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButtonDid) forControlEvents:UIControlEventTouchUpInside];
        [self.PKView addSubview:rightButton];
        rightButton.sd_layout.rightSpaceToView(self.PKView,0)
        .topSpaceToView(self.PKView,0)
        .widthIs(Gato_Width_320_(80))
        .heightIs(Gato_Height_548_(40));
        
        
        // 初始化pickerView
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, Gato_Height_548_(40),Gato_Width_320_(274), Gato_Height_548_(200))];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [self.PKView addSubview:self.pickerView];
        
        //指定数据源和委托
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        
        self.PKView.backgroundColor = [UIColor HDThemeColor];
        [self.view addSubview:_PKView];
        
        GatoViewBorderRadius(self.PKView, 5, 0, [UIColor redColor]);
    }
    return _PKView;
}

-(UILabel *)moneryLabel
{
    if (!_moneryLabel) {
        _moneryLabel = [[UILabel alloc]init];
        _moneryLabel.font = FONT(26);
        _moneryLabel.textColor = [UIColor YMAppAllTitleColor];
        _moneryLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:_moneryLabel];
    }
    return _moneryLabel;
}
-(UILabel *)restDay
{
    if (!_restDay) {
        _restDay = [[UILabel alloc]init];
        _restDay.font = FONT(26);
        _restDay.textAlignment = NSTextAlignmentRight;
        _restDay.textColor = [UIColor YMAppAllTitleColor];
        [self.view addSubview:_restDay];
    }
    return _restDay;
}

-(UIView *)restView
{
    if (!_restView) {
        _restView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, Gato_Height / 2)];
        _restView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_restView];
        
        self.GatoTableview.sd_layout.leftSpaceToView(self.restView,0)
        .widthIs(Gato_Width_320_(274))
        .topSpaceToView(self.restView,Gato_Height_548_(0))
        .heightIs(Gato_Height / 2 - Gato_Height_548_(50));
        [self.restView addSubview:self.GatoTableview];
        GatoViewBorderRadius(self.GatoTableview, 5, 0, [UIColor redColor]);
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确 定" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(quedingTableviewButton) forControlEvents:UIControlEventTouchUpInside];
        [self.restView addSubview:button];
        button.sd_layout.leftSpaceToView(self.restView,0)
        .rightSpaceToView(self.restView,0)
        .topSpaceToView(self.GatoTableview,Gato_Height_548_(10))
        .heightIs(Gato_Height_548_(35));
        
        GatoViewBorderRadius(button, 5, 0, [UIColor redColor]);
    }
    return _restView;
}
@end
