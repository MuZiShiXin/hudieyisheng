//
//  OperationmethodTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "OperationmethodTableViewCell.h"
#import "GatoBaseHelp.h"

@interface OperationmethodTableViewCell ()
@property (nonatomic ,strong) UILabel * title;
@end
@implementation OperationmethodTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OperationmethodTableViewCell";
    OperationmethodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OperationmethodTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setValueWithModel:(OperationmethodModel *)model
{
    self.title.text = model.titleStr;
    if ([model.select isEqualToString:@"1"]) {
        self.backgroundColor = Gato_(214,235,255);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    [self.title updateLayout];
    self.height = self.title.height + Gato_Height_548_(20);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.sd_layout.leftSpaceToView(self,Gato_Width_320_(16))
    .rightSpaceToView(self,Gato_Width_320_(16))
    .topSpaceToView(self,Gato_Height_548_(10))
    .autoHeightRatio(0)
    .minHeightIs(Gato_Width_320_(39));
    
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
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT(32);
        _title.numberOfLines = 0;
        [self addSubview:_title];
    }
    return _title;
}

@end
