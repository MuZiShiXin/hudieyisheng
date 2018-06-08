//
//  WorkAddressOldTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/18.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "WorkAddressOldTableViewCell.h"
#import "GatoBaseHelp.h"

@interface WorkAddressOldTableViewCell ()
@property (nonatomic ,strong) UILabel * oldAddress;
@end
@implementation WorkAddressOldTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WorkAddressOldTableViewCell";
    WorkAddressOldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WorkAddressOldTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)setValueWithTitle:(NSString *)model
{
    self.oldAddress.text = model;
    [self.oldAddress updateLayout];
    self.height = self.oldAddress.height + Gato_Height_548_(10);
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = Gato_(240,240,240);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , Gato_Height_548_(1)));
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.oldAddress.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .rightSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self,Gato_Height_548_(5))
    .minHeightIs(Gato_Height_548_(20))
    .autoHeightRatio(0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(UILabel *)oldAddress
{
    if (!_oldAddress) {
        _oldAddress = [[UILabel alloc]init];
        _oldAddress.font = FONT(26);
        _oldAddress.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_oldAddress];
    }
    return _oldAddress;
}
@end
