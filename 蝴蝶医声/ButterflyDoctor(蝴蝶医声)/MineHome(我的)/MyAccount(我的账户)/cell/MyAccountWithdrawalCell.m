//
//  MyAccountWithdrawalCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountWithdrawalCell.h"

@implementation MyAccountWithdrawalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)withdrawalBtnClicked:(id)sender {
    if (self.PushBlock) {
        self.PushBlock();
    }
}

+ (CGFloat)getHeightForCell {
    return 55.0f;
}

@end
