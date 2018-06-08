//
//  AreaView.m
//  CitySelected
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 sigxui-001. All rights reserved.
//

#import "YSCAreaView.h"
#import "GatoBaseHelp.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YSCAreaView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat topY;
}
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic, copy) NSArray *arrayList;
@end

@implementation YSCAreaView

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topY, SCREEN_WIDTH-100, SCREEN_HEIGHT - 64 - topY) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(100, topY, SCREEN_WIDTH-100, SCREEN_HEIGHT - topY);
        self.arrayList = [[NSArray alloc]init];
    }
    return self;
}
-(void)navControllerWithHeight:(BOOL )navController//默认0  如果1 高度+64
{
    if (self.navController) {
        topY = 0;
    }else{
        topY = 0;
    }
    self.frame = CGRectMake(100, topY, SCREEN_WIDTH-100, SCREEN_HEIGHT - topY);
    self.tableView.frame = CGRectMake(0, topY, SCREEN_WIDTH-100, SCREEN_HEIGHT - 64 - topY);
}
-(void)getArea:(NSArray *)areas
{
    self.arrayList = areas;
    [self addSubview:self.tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.arrayList[indexPath.row];
    cell.textLabel.font = FONT(32);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      NSLog(@"%@",self.arrayList[indexPath.row]);
    NSDictionary *dic = @{
                          @"area":self.arrayList[indexPath.row]
                          };
      self.block((NSMutableDictionary *)dic);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
