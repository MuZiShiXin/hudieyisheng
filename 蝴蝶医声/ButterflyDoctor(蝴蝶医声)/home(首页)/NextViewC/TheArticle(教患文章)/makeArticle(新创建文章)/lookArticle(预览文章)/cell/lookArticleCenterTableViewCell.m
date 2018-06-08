//
//  lookArticleCenterTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "lookArticleCenterTableViewCell.h"

#import "GatoBaseHelp.h"

@interface lookArticleCenterTableViewCell ()
@property (nonatomic ,strong) UILabel * titleLabel;
@end

@implementation lookArticleCenterTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lookArticleCenterTableViewCell";
    lookArticleCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"lookArticleCenterTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(makeArticleModel *)model
{
    self.titleLabel.text = model.title;
    [self.titleLabel sizeToFit];
    self.height = self.titleLabel.height > Gato_Height_548_(30) ? self.titleLabel.height + Gato_Height_548_(20) : Gato_Height_548_(30);
    
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT(34);
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.titleLabel.sd_layout.leftSpaceToView(self, Gato_Width_320_(10))
//    .rightSpaceToView(self, Gato_Width_320_(10))
//    .topSpaceToView(self, Gato_Width_320_(10))
//    .autoHeightRatio(0);
    self.titleLabel.frame = CGRectMake(Gato_Width_320_(10), Gato_Height_548_(10), Gato_Width_320_(300), Gato_Height_548_(30));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
