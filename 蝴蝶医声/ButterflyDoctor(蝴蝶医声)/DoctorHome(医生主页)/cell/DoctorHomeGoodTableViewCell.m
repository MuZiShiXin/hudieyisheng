//
//  DoctorHomeGoodTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "DoctorHomeGoodTableViewCell.h"
#import "GatoBaseHelp.h"

@interface DoctorHomeGoodTableViewCell ()
@property (nonatomic ,strong) UILabel * centerLabel;
@property (nonatomic ,strong) UIButton * pushButton;//展开 收回

@end
@implementation DoctorHomeGoodTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DoctorHomeGoodTableViewCell";
    DoctorHomeGoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorHomeGoodTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(NSString *)model WithZhankai:(NSString *)zhankai
{
    
    
    if (model || model.length > 1) {
        self.centerLabel.text = model;
    }else{
         self.centerLabel.text = @"擅长： ";
    }
    
    [GatoMethods setLineSpaceWithString:self.centerLabel  WithSpacing:2];
    if ([zhankai isEqualToString:@"0"]) {
        self.centerLabel.numberOfLines = 2;
//        self.centerLabel.height = Gato_Height_548_(30);
        [self.pushButton setImage:[UIImage imageNamed:@"下尖头"] forState:UIControlStateNormal];
//        [self.centerLabel updateLayout];
        [self.centerLabel sizeToFit];
        self.height = self.centerLabel.height + Gato_Height_548_(42) + Gato_Height_548_(50);
    }else if ([zhankai isEqualToString:@"1"]){
        self.centerLabel.numberOfLines = 0;
//        self.centerLabel.sd_layout.maxHeightIs(Gato_Height_548_(9999));
        [self.pushButton setImage:[UIImage imageNamed:@"上尖头"] forState:UIControlStateNormal];
//        [self.centerLabel updateLayout];
        [self.centerLabel sizeToFit];
        self.height = self.centerLabel.height + Gato_Height_548_(42) + Gato_Height_548_(50);
    }
    

   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * topFgx = [[UIView alloc]init];
    topFgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:topFgx];
    topFgx.sd_layout.leftSpaceToView(self, -1)
    .rightSpaceToView(self, -1)
    .topSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(10));
    GatoViewBorderRadius(topFgx, 0, Gato_Height_548_(0.1), [UIColor HDViewBackColor]);
    
    
//    UIView * fgx1 = [[UIView alloc]init];
//    fgx1.backgroundColor = [UIColor HDViewBackColor];
//    [self addSubview:fgx1];
//    fgx1.sd_layout.leftSpaceToView(self,-1)
//    .rightSpaceToView(self,-1)
//    .bottomEqualToView(self)
//    .heightIs(Gato_Height_548_(0.1));
    
    
    UIImageView * image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"honor_icon_The-bottle"];
    [self addSubview:image];
    image.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(topFgx,Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(11));
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"专业擅长";
    label.font = FONT_Bold_(34);
    label.textColor = [UIColor HDBlackColor];
    [self addSubview:label];
    label.sd_layout.leftSpaceToView(image ,Gato_Width_320_(5))
    .centerYEqualToView(image)
    .rightSpaceToView(self,Gato_Width_320_(10))
    .heightIs(Gato_Height_548_(20));
    
    
//    self.centerLabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(10))
//    .rightSpaceToView(self,Gato_Width_320_(10))
//    .topSpaceToView(self,Gato_Height_548_(42))
//    .autoHeightRatio(0)
//    .maxHeightIs(Gato_Height_548_(30));
    
    self.centerLabel.frame = CGRectMake(Gato_Width_320_(10), Gato_Height_548_(52), Gato_Width_320_(300), Gato_Height_548_(30));
    
    self.pushButton.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .heightIs(Gato_Height_548_(30));
    
    [self.pushButton setImage:[UIImage imageNamed:@"下尖头"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)pushButtonDid:(UIButton *)sender
{
    if (self.zhankaiBlock) {
        self.zhankaiBlock();
    }
}

-(UILabel *)centerLabel
{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.font = FONT(32);
        _centerLabel.textColor = [UIColor HDBlackColor];
        _centerLabel.numberOfLines = 2;
        [self addSubview:_centerLabel];
    }
    return _centerLabel;
}
-(UIButton *)pushButton
{
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushButton addTarget:self action:@selector(pushButtonDid:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pushButton];
    }
    return _pushButton;
}
@end
