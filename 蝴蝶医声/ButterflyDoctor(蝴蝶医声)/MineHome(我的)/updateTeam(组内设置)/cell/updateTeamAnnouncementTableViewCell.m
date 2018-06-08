//
//  updateTeamAnnouncementTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "updateTeamAnnouncementTableViewCell.h"
#import "GatoBaseHelp.h"
#import "UIButton+AICategory.h"
@interface updateTeamAnnouncementTableViewCell ()
@property (nonatomic ,strong) UILabel * centerLabel;
@property (nonatomic ,strong) UIButton * pushButton;//展开 收回
@end
@implementation updateTeamAnnouncementTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"updateTeamAnnouncementTableViewCell";
    updateTeamAnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"updateTeamAnnouncementTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(NSString *)model WithZhankai:(NSString *)zhankai
{
    self.centerLabel.text = model;
    if ([zhankai isEqualToString:@"0"]) {
        self.centerLabel.numberOfLines = 2;
        
        [self.pushButton setImage:[UIImage imageNamed:@"下尖头"] forState:UIControlStateNormal];
        [self.pushButton setTitle:@"  查看更多" forState:UIControlStateNormal];
        [self.pushButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:20];
        [self.centerLabel sizeToFit];
        self.height = self.centerLabel.height + Gato_Height_548_(30) + Gato_Height_548_(30);
    }else if ([zhankai isEqualToString:@"1"]){
        self.centerLabel.numberOfLines = 0;
        
        [self.pushButton setImage:[UIImage imageNamed:@"上尖头"] forState:UIControlStateNormal];
        [self.pushButton setTitle:@"  收回查看" forState:UIControlStateNormal];
        [self.pushButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:20];
        [self.centerLabel sizeToFit];
        self.height = self.centerLabel.height + Gato_Height_548_(30) + Gato_Height_548_(30);
    }
    
    
    if (self.centerLabel.numberOfLines <= 2) {
        self.pushButton.hidden = YES;
        self.height = self.centerLabel.height + Gato_Height_548_(30);
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
    
    
    self.centerLabel.frame = CGRectMake(Gato_Width_320_(15), Gato_Height_548_(20), Gato_Width_320_(300), Gato_Height_548_(30));
    
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
    if (self.zhankaigonggaoBlock) {
        self.zhankaigonggaoBlock();
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
        _pushButton.titleLabel.font = FONT(30);
        [_pushButton setTitleColor:[UIColor HDBlackColor] forState:UIControlStateNormal];
        [self addSubview:_pushButton];
    }
    return _pushButton;
}
@end
