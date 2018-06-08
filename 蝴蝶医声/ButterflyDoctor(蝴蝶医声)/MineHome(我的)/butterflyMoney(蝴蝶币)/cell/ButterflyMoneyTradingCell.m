//
//  ButterflyMoneyTradingCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ButterflyMoneyTradingCell.h"
#import "GatoBaseHelp.h"

@interface ButterflyMoneyTradingCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *monery;

@end
@implementation ButterflyMoneyTradingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)getHeightForCell {
    return 67.0f;
}
-(void)setValueWithModel:(ButterflyMoneryBeforeModel * )model
{
    self.title.text = model.title;
    self.time.text = model.time;
    self.monery.text = model.medalGold;
}
-(void)setValueWithDataModel:(withdrawaInfoModel * )model
{

    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    UIColor *color = Gato_(211,210,210);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width , 0.5));
}


@end
