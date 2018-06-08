//
//  MyTeamAuditTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/6.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyTeamAuditTableViewCell.h"
#import "GatoBaseHelp.h"

@interface MyTeamAuditTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * levle;
@property (nonatomic ,strong) UILabel * time;
@property (nonatomic ,strong) UIButton * tongyi;
@property (nonatomic ,strong) UIButton * bohui;
@end
@implementation MyTeamAuditTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MyTeamAuditTableViewCell";
    MyTeamAuditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTeamAuditTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(MyTeamAuditPleaseModel *)model
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:ModelNull( model.photo)] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.name.text = model.name;
    self.levle.text = model.work;
    self.time.text = [NSString stringWithFormat:@"申请时间：%@",model.time];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photo.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Height_548_(16))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    
    GatoViewBorderRadius(self.photo, Gato_Height_548_(55 / 2), 0, [UIColor redColor]);
    
    self.name.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(12))
    .topSpaceToView(self,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(20));
    
    [self.name setSingleLineAutoResizeWithMaxWidth:100];
    
    self.levle.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(5))
    .topEqualToView(self.name)
    .autoHeightRatio(0);
    
    [self.levle setSingleLineAutoResizeWithMaxWidth:100];
    GatoViewBorderRadius(self.levle, 3, 1, [UIColor HDTitleRedColor]);
    
    self.time.sd_layout.rightSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self.name, Gato_Height_548_(5))
    .leftEqualToView(self.name)
    .heightRatioToView(self.name,1);
    
    self.tongyi.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.time,Gato_Height_548_(5))
    .widthIs(Gato_Width_320_(108))
    .heightIs(Gato_Height_548_(30));
    
    self.bohui.sd_layout.leftSpaceToView(self.tongyi,Gato_Width_320_(15))
    .topSpaceToView(self.time,Gato_Height_548_(5))
    .widthIs(Gato_Width_320_(108))
    .heightIs(Gato_Height_548_(30));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)tongyiButton
{
    if (self.tongyiBlock) {
        self.tongyiBlock();
    }
}
-(void)bohuiButton
{
    if (self.bohuiBlock) {
        self.bohuiBlock();
    }
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
        _name.font = FONT_Bold_(32);
        [self addSubview:_name];
    }
    return _name;
}
-(UILabel *)levle
{
    if (!_levle) {
        _levle = [[UILabel alloc]init];
        _levle.textColor = [UIColor whiteColor];
        _levle.backgroundColor = [UIColor HDTitleRedColor];
        _levle.font = FONT(30);
        [self addSubview:_levle];
    }
    return _levle;
}
-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = [UIColor YMAppAllTitleColor];
//        _time.textAlignment = NSTextAlignmentRight;
        _time.font = FONT(30);
        [self addSubview:_time];
    }
    return _time;
}
-(UIButton *)tongyi
{
    if (!_tongyi) {
        _tongyi = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tongyi setTitle:@"同意" forState:UIControlStateNormal];
        _tongyi.titleLabel.font = FONT(32);
        [_tongyi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tongyi setBackgroundImage:[UIImage imageNamed:@"lansebeijing"] forState:UIControlStateNormal];
        [_tongyi addTarget:self action:@selector(tongyiButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tongyi];
    }
    return _tongyi;
}
-(UIButton *)bohui
{
    if (!_bohui) {
        _bohui = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bohui setTitle:@"驳回" forState:UIControlStateNormal];
        _bohui.titleLabel.font = FONT(32);
        [_bohui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bohui setBackgroundImage:[UIImage imageNamed:@"zisebeijing"] forState:UIControlStateNormal];
        [_bohui addTarget:self action:@selector(bohuiButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bohui];
    }
    return _bohui;
}
@end
