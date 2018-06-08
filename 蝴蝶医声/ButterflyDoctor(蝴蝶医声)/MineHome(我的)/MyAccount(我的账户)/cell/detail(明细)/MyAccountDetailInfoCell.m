//
//  MyAccountDetailInfoCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailInfoCell.h"
#import "GatoBaseHelp.h"


@interface MyAccountDetailInfoCell ()
@property (strong, nonatomic)  UILabel *income;
@property (strong, nonatomic)  UILabel *spending;
@property (strong, nonatomic)  UILabel *total;
@property (strong, nonatomic)  UIButton *yinhangkaButton;

@end


@implementation MyAccountDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.income.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self,Gato_Width_320_(5))
    .heightIs(Gato_Width_320_(30));
    
    self.total.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self.income,0)
    .heightIs(Gato_Width_320_(30));
    
    self.yinhangkaButton.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self.total,Gato_Width_320_(10))
    .heightIs(Gato_Width_320_(35));
    
    
    GatoViewBorderRadius(self.yinhangkaButton, 3, 0, [UIColor redColor]);
}
-(void)setValueWithShou:(NSString *)shou WithChu:(NSString *)chu
{
    self.income.text = [GatoMethods getStringWithLeftStr:@"收入账户待汇款：" WithRightStr:shou];
    self.total.text = [GatoMethods getStringWithLeftStr:@"累计已汇款：" WithRightStr:chu];
    
    [GatoMethods NSMutableAttributedStringWithLabel:self.income WithAllString:self.income.text WithColorString:@"收入账户待汇款：" WithColor:[UIColor HDBlackColor]];
    
    [GatoMethods NSMutableAttributedStringWithLabel:self.total WithAllString:self.total.text WithColorString:@"累计已汇款：" WithColor:[UIColor HDBlackColor]];
}

- (void)checkCardBtnClicked:(id)sender {
    if (self.PushBlock) {
        self.PushBlock();
    }
}

+ (CGFloat)getHeightForCell {
    return Gato_Height_548_(115);
}

-(UILabel *)income
{
    if (!_income) {
        _income = [[UILabel alloc]init];
        _income.font = FONT(34);
        _income.textColor = [UIColor HDTitleRedColor];
        [self addSubview:_income];
    }
    return _income;
}
-(UILabel *)total
{
    if (!_total) {
        _total = [[UILabel alloc]init];
        _total.font = FONT(34);
        _total.textColor = [UIColor HDTitleRedColor];
        [self addSubview:_total];
    }
    return _total;
}
-(UIButton * )yinhangkaButton
{
    if (!_yinhangkaButton) {
        _yinhangkaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yinhangkaButton setTitle:@"查看我的提现银行卡" forState:UIControlStateNormal];
        [_yinhangkaButton setBackgroundColor:[UIColor HDThemeColor]];
        [_yinhangkaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yinhangkaButton.titleLabel.font = FONT(34);
        [_yinhangkaButton addTarget:self action:@selector(checkCardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_yinhangkaButton];
    }
    return _yinhangkaButton;
}
@end
