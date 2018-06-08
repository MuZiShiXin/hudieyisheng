//
//  butterflyLevelTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "butterflyLevelTableViewCell.h"
#import "GatoBaseHelp.h"
#import "LDProgressView.h"
@interface butterflyLevelTableViewCell ()
@property(nonatomic ,strong) UILabel * titlelabel;
@property(nonatomic ,strong) UIImageView * photo;
@property(nonatomic ,strong) UIView * levleNumberView;
@property(nonatomic ,strong) LDProgressView * progressView;
@property(nonatomic ,strong) UILabel * underLabel;

@property (nonatomic ,strong) UIImageView * jiantou;
@property(nonatomic ,strong) UILabel * hudiebi;

@end
@implementation butterflyLevelTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"butterflyLevelTableViewCell";
    butterflyLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"butterflyLevelTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(NSString *)model
{
//    model = @"800";
    self.titlelabel.text = [NSString stringWithFormat:@"我的当前蝴蝶等级 %@",[GatoMethods getButterflyLevelNameWithMonery:model]];
    CGFloat leftX;
    if ([model integerValue] < 1000) {
        self.photo.image = [UIImage imageNamed:@"image_grade2"];
        leftX = [model floatValue] / 1000 < 1 ? [model floatValue] / 1000 * 0.333 : 1;
         self.progressView.progress = [model floatValue] / 1000 < 1 ? [model floatValue] / 1000 * 0.333: 1;
    }else if ([model integerValue] < 5000){
        self.photo.image = [UIImage imageNamed:@"image_grade1"];
        CGFloat pro = ([model floatValue] - 1000.0f ) / 4000.0f * 0.333;
        self.progressView.progress = 0.333 + pro;
        leftX = 0.333 + pro;
    }else if ([model integerValue] < 10000){
        self.photo.image = [UIImage imageNamed:@"image_grade3"];
        CGFloat pro = ([model floatValue] - 5000.0f) / 5000.0f * 0.333;
        self.progressView.progress = 0.666 + pro;
        leftX = 0.666 + pro;
    }else{
        self.photo.image = [UIImage imageNamed:@"image_grade4"];
        self.progressView.progress = 1;
    }
   
    self.jiantou.sd_layout.leftSpaceToView(self.levleNumberView, Gato_Width_320_(14) + Gato_Width_320_(276) * leftX)
    .bottomSpaceToView(self.progressView, Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(16))
    .heightIs(Gato_Height_548_(16));
    
    self.hudiebi.sd_layout.centerXEqualToView(self.jiantou)
    .bottomSpaceToView(self.jiantou, Gato_Height_548_(0))
    .widthIs(Gato_Width_320_(30))
    .heightIs(Gato_Height_548_(15));
    
    self.hudiebi.text = model;
    
    [GatoMethods NSMutableAttributedStringWithLabel:self.titlelabel WithAllString:self.titlelabel.text WithColorString:@"我的当前蝴蝶等级" WithColor:[UIColor HDBlackColor]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor appAllBackColor];
    
    UIView * underView = [[UIView alloc]init];
    underView.backgroundColor = [UIColor whiteColor];
    [self addSubview:underView];
    underView.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(154));
    
    [underView addSubview:self.titlelabel];
    [underView addSubview:self.photo];
    
    self.titlelabel.sd_layout.leftSpaceToView(underView,0)
    .rightSpaceToView(underView,0)
    .topSpaceToView(underView,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(20));
    
    self.photo.sd_layout.centerXEqualToView(underView)
    .topSpaceToView(self.titlelabel,Gato_Height_548_(30))
    .widthIs(Gato_Width_320_(77))
    .heightIs(Gato_Height_548_(58));
    
    self.levleNumberView.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,Gato_Height_548_(154))
    .heightIs(Gato_Height_548_(105));
    
    self.underLabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(19))
    .rightSpaceToView(self,Gato_Width_320_(19))
    .topSpaceToView(self.levleNumberView,Gato_Height_548_(10))
    .minHeightIs(Gato_Height_548_(150))
    .autoHeightRatio(0);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.font = FONT(30);
        _titlelabel.textColor = [UIColor redColor];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titlelabel;
}

-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        
    }
    return _photo;
}

-(UIImageView *)jiantou
{
    if (!_jiantou) {
        _jiantou = [[UIImageView alloc]init];
        _jiantou.image = [UIImage imageNamed:@"下箭头"];
        [self.levleNumberView addSubview:_jiantou];
    }
    return _jiantou;
}
-(UILabel *)hudiebi
{
    if (!_hudiebi) {
        _hudiebi = [[UILabel alloc]init];
        _hudiebi.textColor = [UIColor HDTitleRedColor];
        _hudiebi.textAlignment = NSTextAlignmentCenter;
        _hudiebi.font = FONT(30);
        [self.levleNumberView addSubview:_hudiebi];
    }
    return _hudiebi;
}

-(UIView *)levleNumberView
{
    if (!_levleNumberView) {
        _levleNumberView = [[UIView alloc]init];
        _levleNumberView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_levleNumberView];
        
        NSArray * topA = @[@"0",@"1000",@"5000",@"10000"];
        NSArray * underA = @[@"铜",@" 银",@" 金",@" 钻石"];
        for (int i = 0 ; i < 4 ; i ++) {
            UILabel * topLabel = [[UILabel alloc]init];
            topLabel.text = topA[i];
            topLabel.font = FONT(26);
            [self.levleNumberView addSubview:topLabel];
            topLabel.sd_layout.leftSpaceToView(self.levleNumberView, i * ((Gato_Width - Gato_Width_320_(80)) / 3) + Gato_Width_320_(22))
            .topSpaceToView(self.levleNumberView,Gato_Height_548_(0))
            .widthIs((Gato_Width - Gato_Width_320_(44)) / 3)
            .heightIs(Gato_Height_548_(30));
            
            UILabel * underLabel = [[UILabel alloc]init];
            underLabel.text = underA[i];
            underLabel.font = FONT(28);
            [self.levleNumberView addSubview:underLabel];
            underLabel.sd_layout.leftSpaceToView(self.levleNumberView, i * ((Gato_Width - Gato_Width_320_(80)) / 3) + Gato_Width_320_(22))
            .topSpaceToView(self.levleNumberView,Gato_Height_548_(70))
            .widthIs((Gato_Width - Gato_Width_320_(44)) / 3)
            .heightIs(Gato_Height_548_(30));
            
            if (i == 3) {
                topLabel.sd_layout.leftSpaceToView(self.levleNumberView, i * ((Gato_Width - Gato_Width_320_(80)) / 3) + Gato_Width_320_(30))
                .topSpaceToView(self.levleNumberView,Gato_Height_548_(0))
                .widthIs((Gato_Width - Gato_Width_320_(74)) / 3)
                .heightIs(Gato_Height_548_(30));
                underLabel.sd_layout.leftSpaceToView(self.levleNumberView, i * ((Gato_Width - Gato_Width_320_(80)) / 3) + Gato_Width_320_(30))
                .topSpaceToView(self.levleNumberView,Gato_Height_548_(70))
                .widthIs((Gato_Width - Gato_Width_320_(74)) / 3)
                .heightIs(Gato_Height_548_(30));
            }
//            if (i == 3) {
//                topLabel.textAlignment = NSTextAlignmentRight;
//                underLabel.textAlignment = NSTextAlignmentRight;
//            }else if (i == 2 || i == 1){
//                topLabel.textAlignment = NSTextAlignmentCenter;
//                underLabel.textAlignment = NSTextAlignmentCenter;
//            }
        }
        
        
        self.progressView = [[LDProgressView alloc] init];
        self.progressView.color = [UIColor colorWithRed:0.73f green:0.10f blue:0.00f alpha:1.00f];
        self.progressView.animate = @NO;
        self.progressView.type = LDProgressGradient;
        self.progressView.showText = @NO;
        self.progressView.background = [[UIColor appAllBackColor] colorWithAlphaComponent:0.8];
        [self.levleNumberView addSubview:self.progressView];
        
        self.progressView.sd_layout.leftSpaceToView(self.levleNumberView,Gato_Width_320_(22))
        .rightSpaceToView(self.levleNumberView,Gato_Width_320_(22))
        .topSpaceToView(self.levleNumberView,Gato_Height_548_(59))
        .heightIs(Gato_Height_548_(10));
        
        
    }
    return _levleNumberView;
}

-(UILabel *)underLabel
{
    if (!_underLabel) {
        _underLabel = [[UILabel alloc]init];
        _underLabel.numberOfLines = 0;
        _underLabel.textColor = [UIColor YMAppAllTitleColor];
        _underLabel.text = @"什么是蝴蝶等级:\n\n       蝴蝶等级是“蝴蝶医声”根据患者对医生的真实评价设置的医生等级进阶体系，直观的现实医生工作成效。蝴蝶等级共分为铜蝴蝶、银蝴蝶、金蝴蝶和钻石蝴蝶四个等级。依据医生现有的蝴蝶币的数量对应不同等级，等级越高代表患者对医生的综合评价越高及认可度越高，从而更加容易被患者关注。医生起始等级为铜蝴蝶，蝴蝶币积累到1000枚晋级到银蝴蝶，蝴蝶币积累到5000枚晋级到金蝴蝶，蝴蝶币积累到10000枚晋级到钻石蝴蝶。";
        _underLabel.font = FONT(32);
        [self addSubview:_underLabel];
    }
    return _underLabel;
}
@end
