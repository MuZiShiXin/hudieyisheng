//
//  lookArticleLittleTitleTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "lookArticleLittleTitleTableViewCell.h"

#import "GatoBaseHelp.h"

@interface lookArticleLittleTitleTableViewCell ()
@property (nonatomic ,strong) UILabel * titleLabel;
@end
@implementation lookArticleLittleTitleTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lookArticleLittleTitleTableViewCell";
    lookArticleLittleTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"lookArticleLittleTitleTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(makeArticleModel *)model
{
    
    self.titleLabel.text = model.title;
    [self.titleLabel updateLayout];
    self.height = self.titleLabel.height > Gato_Height_548_(30) ? self.titleLabel.height + Gato_Width_320_(10) : Gato_Height_548_(30);
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT(36);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.sd_layout.leftSpaceToView(self, Gato_Width_320_(10))
    .rightSpaceToView(self, Gato_Width_320_(10))
    .topSpaceToView(self, Gato_Width_320_(10))
    .autoHeightRatio(0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
