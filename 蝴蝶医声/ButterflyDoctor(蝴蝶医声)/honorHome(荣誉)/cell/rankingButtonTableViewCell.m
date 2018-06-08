//
//  rankingButtonTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "rankingButtonTableViewCell.h"
#import "GatoBaseHelp.h"

@interface rankingButtonTableViewCell ()
@property (nonatomic ,strong) UIButton * zhou;
@property (nonatomic ,strong) UIButton * yue;
@property (nonatomic ,strong) UIButton * nian;
@property (nonatomic ,strong) UIImageView * underImage;
@end
@implementation rankingButtonTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"rankingButtonTableViewCell";
    rankingButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"rankingButtonTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithRank:(NSString *)rank
{
    if ([rank isEqualToString:@"1"]) {
        [self ButtonBlock:self.zhou];
    }else if ([rank isEqualToString:@"2"]){
        [self ButtonBlock:self.yue];
    }else if ([rank isEqualToString:@"3"]){
        [self ButtonBlock:self.nian];
    }
}

-(void)ButtonBlock:(UIButton *)sender
{
    NSInteger row = 0;
    if (sender == self.zhou) {
        row = 1;
        self.underImage.image = [UIImage imageNamed:@"honor_bg1"];
    }else if (sender == self.yue){
        row = 2;
        self.underImage.image = [UIImage imageNamed:@"honor_bg2"];
    }else if (sender == self.nian){
        row = 3;
        self.underImage.image = [UIImage imageNamed:@"honor_bg3"];
    }
    
    [self.zhou setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.yue setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [self.nian setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.rankingBlcok) {
        self.rankingBlcok(row);
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.backgroundColor = [UIColor appAllBackColor];
    
    self.underImage.sd_layout.leftSpaceToView(self,Gato_Width_320_(16))
    .rightSpaceToView(self,Gato_Width_320_(16))
    .topSpaceToView(self,Gato_Height_548_(5))
    .bottomSpaceToView(self,Gato_Height_548_(5));
    
    self.zhou.sd_layout.leftSpaceToView(self,Gato_Width_320_(16))
    .topEqualToView(self.underImage)
    .widthRatioToView(self.underImage,0.334)
    .heightRatioToView(self.underImage,1);
    
    self.yue.sd_layout.leftSpaceToView(self.zhou,0)
    .topEqualToView(self.underImage)
    .widthRatioToView(self.underImage,0.334)
    .heightRatioToView(self.underImage,1);
    
    self.nian.sd_layout.leftSpaceToView(self.yue,0)
    .topEqualToView(self.underImage)
    .widthRatioToView(self.underImage,0.334)
    .heightRatioToView(self.underImage,1);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)underImage
{
    if (!_underImage) {
        _underImage = [[UIImageView alloc]init];
        _underImage.image = [UIImage imageNamed:@"honor_bg1"];
        [self addSubview:_underImage];
    }
    return _underImage;
}
-(UIButton *)zhou
{
    if (!_zhou) {
        _zhou = [UIButton buttonWithType:UIButtonTypeCustom];
        _zhou.titleLabel.font = FONT(26);
        [_zhou setTitle:@"周排行" forState:UIControlStateNormal];
        [_zhou setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zhou addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_zhou];
    }
    return _zhou;
}
-(UIButton *)yue
{
    if (!_yue) {
        _yue = [UIButton buttonWithType:UIButtonTypeCustom];
        _yue.titleLabel.font = FONT(26);
        [_yue setTitle:@"月排行" forState:UIControlStateNormal];
        [_yue setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        [_yue addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_yue];
    }
    return _yue;
}
-(UIButton *)nian
{
    if (!_nian) {
        _nian = [UIButton buttonWithType:UIButtonTypeCustom];
        _nian.titleLabel.font = FONT(26);
        [_nian setTitle:@"年排行" forState:UIControlStateNormal];
        [_nian setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        [_nian addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nian];
    }
    return _nian;
}


@end
