//
//  MyAccountDetailDateCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailDateCell.h"

@interface MyAccountDetailDateCell ()
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation MyAccountDetailDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setValueWithDataTitle:(NSString *)dataTitle
{
    self.date.text = dataTitle;
}
+ (CGFloat)getHeightForCell {
    return 34.0f;
}
@end
