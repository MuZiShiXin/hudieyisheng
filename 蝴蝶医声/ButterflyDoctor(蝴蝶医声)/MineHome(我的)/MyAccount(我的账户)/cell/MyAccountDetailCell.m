//
//  MyAccountDetailCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailCell.h"
#import "MyAccountDetailDateCell.h"
#import "MyAccountDetailDigitalCell.h"
#import "MyAccountModel.h"
@interface MyAccountDetailCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic)   IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *time;
@end


@implementation MyAccountDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *cells = @[
                       [MyAccountDetailDateCell    getCellID],
                       [MyAccountDetailDigitalCell getCellID]
                       ];
    for (NSString *identyfier in cells) {
        UINib *nib = [UINib nibWithNibName:identyfier bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:identyfier];
    }
    
    // Initialization code
}

#pragma mark 赋值
- (void)setValueWithArray:(NSArray *)array {
    if (self.dataArray != array) {
        self.dataArray = array;
        [self.tableView reloadData];
    }
}

- (void)setValueWithTime:(NSString *)time
{
    if (self.time != time) {
        self.time = time;
        [self.tableView reloadData];
    }
}
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MyAccountDetailDateCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailDateCell getCellID]];
        [cell setValueWithDataTitle:self.time];
        return cell;
    } else if (indexPath.row == 1) {
        MyAccountDetailDigitalCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailDigitalCell getCellID]];
        [cell setvalueWithArray:nil];
        return cell;
    } else {
        MyAccountDetailDigitalCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyAccountDetailDigitalCell getCellID]];
        MyAccountModel * model = [[MyAccountModel alloc]init];
        [model setValuesForKeysWithDictionary: self.dataArray[indexPath.row - 2]];
        [cell setvalueWithArray:model];
        return cell;
    }
    
    
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyAccountDetailDateCell getHeightForCell];
}



#pragma mark 获取高度
+ (CGFloat)getHeightWithArray:(NSArray *)dataArray {
    return 34.0 * (dataArray.count+2) + 8;
}

@end
