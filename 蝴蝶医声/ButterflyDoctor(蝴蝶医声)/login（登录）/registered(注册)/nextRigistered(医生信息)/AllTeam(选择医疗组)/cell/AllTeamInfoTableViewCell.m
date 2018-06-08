//
//  AllTeamInfoTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/17.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllTeamInfoTableViewCell.h"
#import "GatoBaseHelp.h"

@interface AllTeamInfoTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * centent;
@end
@implementation AllTeamInfoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AllTeamInfoTableViewCell";
    AllTeamInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllTeamInfoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setValueWithModel:(MyTeamVerifyModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
    self.centent.text = [NSString stringWithFormat:@"%@-%@",model.hospital,model.hospitalDepartment];
    if ([model.select isEqualToString:@"0"]) {
        self.backgroundColor = Gato_(214,235,255);
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.photo.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,Gato_Width_320_(12))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(55/2), 0, [UIColor redColor]);
    
    self.name.sd_layout.leftSpaceToView(self.photo,10)
    .rightSpaceToView(self,10)
    .topSpaceToView(self,Gato_Height_548_(13))
    .heightIs(Gato_Height_548_(30));
    
    self.centent.sd_layout.leftEqualToView(self.name)
    .rightEqualToView(self.name)
    .topSpaceToView(self.name,0)
    .heightIs(Gato_Height_548_(30));
    
   
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
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , 1));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)centent
{
    if (!_centent) {
        _centent = [[UILabel alloc]init];
        _centent.font = FONT(30);
        _centent.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_centent];
    }
    return _centent;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT(30);
        _name.textColor = [UIColor HDBlackColor];
        [self addSubview:_name];
    }
    return _name;
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}


@end
