//
//  MyAccountBalanceCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountBalanceCell.h"

@interface MyAccountBalanceCell ()
@property (weak, nonatomic) IBOutlet UILabel *balance;

@end


@implementation MyAccountBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setValueWithTitle:(NSString *)countNumber
{
    self.balance.text = countNumber;
}

+ (CGFloat)getHeightForCell {
    return 45.0f;
}

@end
