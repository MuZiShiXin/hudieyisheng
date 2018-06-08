//
//  choosebankTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/19.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "choosebankTableViewCell.h"
#import "GatoBaseHelp.h"

@interface choosebankTableViewCell ()
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UIImageView * iconImage;
@end
@implementation choosebankTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"choosebankTableViewCell";
    choosebankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"choosebankTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)setValueWithModel:(ChooseBankSonModel *)model
{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"logo"]];
    self.name.text = model.name;
    
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT(34);
        [self addSubview:_name];
    }
    return _name;
}
-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        [self addSubview:_iconImage];
    }
    return _iconImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.sd_layout.leftSpaceToView(self, Gato_Width_320_(15))
    .centerYEqualToView(self)
    .widthIs(Gato_Width_320_(25))
    .heightIs(Gato_Height_548_(25));
    
    self.name.sd_layout.leftSpaceToView(self.iconImage, Gato_Width_320_(10))
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self, Gato_Width_320_(15));
    
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor HDViewBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self, Gato_Width_320_(15))
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(0.5));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
