//
//  NullLabelTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/20.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "NullLabelTableViewCell.h"
#import "GatoBaseHelp.h"

@interface NullLabelTableViewCell ()
@property (nonatomic ,strong) UILabel * nullLabel;
@end
@implementation NullLabelTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"NullLabelTableViewCell";
    NullLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NullLabelTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setValueWithModel:(NulllabelModel *)model
{
    self.nullLabel.text = model.label;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.nullLabel.sd_layout.leftSpaceToView(self, Gato_Width_320_(15))
    .rightSpaceToView(self, Gato_Width_320_(15))
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
}
+ (CGFloat )getHeightWithNullCellWithTableview:(UITableView *)tableview
{
    if (tableview) {
        return tableview.height;
    }
    return Gato_Height;
}
-(UILabel *)nullLabel
{
    if (!_nullLabel) {
        _nullLabel = [[UILabel alloc]init];
        _nullLabel.font = FONT(34);
        _nullLabel.textAlignment = NSTextAlignmentCenter;
        _nullLabel.numberOfLines = 0;
        [self addSubview:_nullLabel];
    }
    return _nullLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
