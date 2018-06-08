//
//  ImMessageOneTipTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/8/21.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "ImMessageOneTipTableViewCell.h"
#import "GatoBaseHelp.h"

@interface ImMessageOneTipTableViewCell ()
@property (nonatomic ,strong) UILabel * title;
@end
@implementation ImMessageOneTipTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ImMessageOneTipTableViewCell";
    ImMessageOneTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImMessageOneTipTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setValueWithTitle:(NSString *)titleStr
{
    self.title.sd_layout.leftSpaceToView(self, Gato_Width_320_(15))
    .rightSpaceToView(self, Gato_Width_320_(15))
    .topSpaceToView(self, Gato_Height_548_(5))
    .bottomSpaceToView(self, Gato_Height_548_(5));
    GatoViewBorderRadius(self.title, 5, 1,Gato_(225, 225, 225));
    
    self.title.text = titleStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT(30);
        _title.numberOfLines = 0;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.backgroundColor = Gato_(225, 225, 225);
        _title.textColor = [UIColor HDBlackColor];
        [self addSubview:_title];
    }
    return _title;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
