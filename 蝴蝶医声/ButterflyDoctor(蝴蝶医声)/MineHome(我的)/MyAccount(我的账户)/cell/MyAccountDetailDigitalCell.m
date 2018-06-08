//
//  MyAccountDetailDigitalCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailDigitalCell.h"
#import "GatoBaseHelp.h"

@interface MyAccountDetailDigitalCell ()
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *spending;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end


@implementation MyAccountDetailDigitalCell


-(void)setvalueWithArray:(MyAccountModel *)array
{
    NSMutableArray * dataArray = [NSMutableArray array];
    
    if (!array) {
        [dataArray addObject:@"日期"];
        [dataArray addObject:@"收入(元)"];
        [dataArray addObject:@"支出(元)"];
        [dataArray addObject:@"类型"];
    }else{
        if ([array.costType isEqualToString:@"out"]) {
            [dataArray addObject:[GatoMethods getStringWithLeftStr:array.day WithRightStr:@"日" ]];
            [dataArray addObject:@"----"];
            [dataArray addObject:array.money];
            [dataArray addObject:array.businessType];
        }else if ([array.costType isEqualToString:@"in"]) {
            [dataArray addObject:[GatoMethods getStringWithLeftStr:array.day WithRightStr:@"日" ]];
            [dataArray addObject:array.money];
            [dataArray addObject:@"----"];
            [dataArray addObject:array.businessType];
        }

    }
    self.date.text = dataArray[0];
    self.income.text = dataArray[1];
    self.spending.text = dataArray[2];
    self.type.text = dataArray[3];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
