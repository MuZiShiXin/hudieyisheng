//
//  AtOnePersonTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/12.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "AtOnePersonTableViewCell.h"
#import "GatoBaseHelp.h"

@interface AtOnePersonTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UILabel * name;
@end
@implementation AtOnePersonTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AtOnePersonTableViewCell";
    AtOnePersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AtOnePersonTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(MyTeamMemberModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.photo.sd_layout.leftSpaceToView(self, Gato_Width_320_(15))
    .topSpaceToView(self, Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(35))
    .heightIs(Gato_Height_548_(35));
    
    
    self.name.sd_layout.leftSpaceToView(self.photo, Gato_Width_320_(10))
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self, Gato_Width_320_(15));
    
    
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = [UIColor HDViewBackColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT(26);
        _name.textColor = [UIColor HDBlackColor];
        [self addSubview:_name];
    }
    return _name;
}

@end
