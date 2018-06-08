//
//  MyAccountDetailContactCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailContactCell.h"
#import "GatoBaseHelp.h"

@interface MyAccountDetailContactCell ()
@property (weak, nonatomic) IBOutlet UILabel *shijishouru;
@property (weak, nonatomic) IBOutlet UILabel *shuiqianshouru;
@property (weak, nonatomic) IBOutlet UILabel *yewushouru;
@property (weak, nonatomic) IBOutlet UILabel *shuishou;

@end
@implementation MyAccountDetailContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setValueWithModel:(MyAccountDetailModel *)model
{
    self.shijishouru.text = [GatoMethods getStringWithLeftStr:@"实际收入：" WithRightStr:model.actualIncome];
    self.shuiqianshouru.text = [GatoMethods getStringWithLeftStr:@"税前总收入：" WithRightStr:model.preTaxIncome];
    self.yewushouru.text = [GatoMethods getStringWithLeftStr:@"业务收入：" WithRightStr:model.businessIncome];
    self.shuishou.text = [GatoMethods getStringWithLeftStr:@"缴纳所得税：" WithRightStr:model.payIncomeTax];
}
+ (CGFloat)getHeightForCell {
    return 100.0f;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    UIColor *color = Gato_(240,240,240);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , 0.5));
}


@end
