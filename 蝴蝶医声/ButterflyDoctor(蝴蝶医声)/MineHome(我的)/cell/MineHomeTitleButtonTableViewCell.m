//
//  MineHomeTitleButtonTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MineHomeTitleButtonTableViewCell.h"
#import "GatoBaseHelp.h"

@interface MineHomeTitleButtonTableViewCell ()
@property (nonatomic ,strong) UIImageView * image;
@property (nonatomic ,strong) UILabel * title;
@property (nonatomic ,strong) UIImageView * jiantou;
@property (nonatomic ,strong) UILabel * AddTeamNumber;//加组人数量
@property (nonatomic ,strong) UIView * fgx;

@end
@implementation MineHomeTitleButtonTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MineHomeTitleButtonTableViewCell";
    MineHomeTitleButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineHomeTitleButtonTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithImage:(NSString *)imageStr WithTitle:(NSString *)titleStr
{
    self.image.image = [UIImage imageNamed:imageStr];
    self.title.text = titleStr;
}
-(void)setValueWithTeamNumber:(NSString *)numberstr
{
    self.AddTeamNumber.hidden = NO;
    self.AddTeamNumber.text = numberstr;
}

-(void)fgxHidden
{
    self.fgx.hidden = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.image.sd_layout.leftSpaceToView(self,Gato_Width_320_(11))
    .topSpaceToView(self,Gato_Height_548_(11))
    .widthIs(Gato_Width_320_(18))
    .heightIs(Gato_Height_548_(18));
    
    self.title.sd_layout.leftSpaceToView(self.image,Gato_Width_320_(10))
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .rightSpaceToView(self,Gato_Width_320_(30));
    
    
    self.jiantou.sd_layout.rightSpaceToView(self,Gato_Width_320_(10))
    .centerYEqualToView(self)
    .widthIs(Gato_Width_320_(7))
    .heightIs(Gato_Height_548_(12));
    
    self.fgx = [[UIView alloc]init];
    self.fgx.backgroundColor = [UIColor HDViewBackColor];
    [self addSubview:self.fgx];
    self.fgx.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(0.5));
    
    
    self.AddTeamNumber.sd_layout.rightSpaceToView(self, Gato_Width_320_(30))
    .centerYEqualToView(self)
    .widthIs(Gato_Width_320_(15))
    .heightIs(Gato_Width_320_(15));
    GatoViewBorderRadius(self.AddTeamNumber, Gato_Width_320_(15) / 2, 0, [UIColor redColor]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)jiantou
{
    if (!_jiantou) {
        _jiantou = [[UIImageView alloc]init];
        _jiantou.image = [UIImage imageNamed:@"more"];
        [self addSubview:_jiantou];
    }
    return _jiantou;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT(34);
        _title.textColor = [UIColor HDBlackColor];
        [self addSubview:_title];
    }
    return _title;
}
-(UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]init];
        [self addSubview:_image];
    }
    return _image;
}
-(UILabel *)AddTeamNumber
{
    if (!_AddTeamNumber) {
        _AddTeamNumber = [[UILabel alloc]init];
        _AddTeamNumber.backgroundColor = [UIColor HDTitleRedColor];
        _AddTeamNumber.textColor = [UIColor whiteColor];
        _AddTeamNumber.font = FONT(30);
        _AddTeamNumber.hidden = YES;
        _AddTeamNumber.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_AddTeamNumber];
    }
    return _AddTeamNumber;
}

@end
