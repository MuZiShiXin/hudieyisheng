//
//  ButterflyMoneyInfoCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ButterflyMoneyInfoCell.h"
#import "GatoBaseHelp.h"

@interface ButterflyMoneyInfoCell ()
@property (weak, nonatomic) IBOutlet UIButton *tixianButton;
@property (weak, nonatomic) IBOutlet UILabel *monery;

@end
@implementation ButterflyMoneyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    GatoViewBorderRadius(self.tixianButton, 3, 1, [UIColor HDThemeColor]);
}
-(void)setvalueWithMonery:(NSString *)string
{
    
    self.monery.text = [NSString stringWithFormat:@"%@个",ModelNull(string)];
}
- (IBAction)tixianButton:(UIButton *)sender {
    if (self.tixianBlock) {
        self.tixianBlock();
    }
}

+ (CGFloat)getHeightForCell {
    return 128.0f;
}

@end
