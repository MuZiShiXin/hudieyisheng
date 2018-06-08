//
//  pusNnllTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/1.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import "pusNnllTableViewCell.h"
#import "GatoBaseHelp.h"
@interface pusNnllTableViewCell()
@property(nonatomic,strong) UIView* backView;
@end

@implementation pusNnllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
    _backView.frame=self.contentView.frame;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"pusNnllTableViewCell";
    pusNnllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"pusNnllTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIView*)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        [self addSubview:_backView];
    }
    return _backView;

}
@end

