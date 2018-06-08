//
//  TeamInfoMessageTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "TeamInfoMessageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface TeamInfoMessageTableViewCell ()
@property (nonatomic ,strong)UIView * underView;
@property (nonatomic ,strong)UILabel * title;
@property (nonatomic ,strong)UILabel * centerLabel;
@property (nonatomic ,strong)UISwitch * switchButton;

@end
@implementation TeamInfoMessageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TeamInfoMessageTableViewCell";
    TeamInfoMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamInfoMessageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)setValueWithTitle:(NSString *)title WithType:(NSInteger )type WithCenter:(NSString *)centerlabel
{
    
    self.underView.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(32));
    GatoViewBorderRadius(self.underView, 0, Gato_Height_548_(0.5), [UIColor HDViewBackColor]);
    
    self.title.text = title;
    
    self.title.sd_layout.leftSpaceToView(self.underView,Gato_Width_320_(15))
    .topSpaceToView(self.underView,0)
    .bottomSpaceToView(self.underView,0)
    .widthIs(Gato_Width_320_(250));
    
    
    if (type == 0) {
        UIView * fgx = [[UIView alloc]init];
        fgx.backgroundColor = [UIColor HDViewBackColor];
        [self addSubview:fgx];
        fgx.sd_layout.leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(Gato_Height_548_(0.1));
        
        if (centerlabel.length > 0) {
            self.centerLabel.text = @"点击查看";
        }else{
            self.centerLabel.text = @"未设置";
        }
        
        self.centerLabel.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(20))
        .leftSpaceToView(self.underView,Gato_Width_320_(20))
        .topSpaceToView(self.underView,Gato_Height_548_(0))
        .heightIs(Gato_Height_548_(32));
        [self.centerLabel updateLayout];
        UIImageView * jiantou = [[UIImageView alloc]init];
        jiantou.image = [UIImage imageNamed:@"more"];
        [self.underView addSubview:jiantou];
        jiantou.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(8))
        .centerYEqualToView(self.underView)
        .widthIs(Gato_Width_320_(7))
        .heightIs(Gato_Height_548_(12));
        
        self.switchButton.hidden = YES;
    }else if (type == 1){
        self.centerLabel.hidden = YES;
        self.switchButton.sd_layout.rightSpaceToView(self.underView,Gato_Width_320_(20))
        .centerYEqualToView(self.underView)
        .widthIs(Gato_Width_320_(35))
        .heightIs(Gato_Height_548_(20));
    }else if (type == 2){
        self.centerLabel.hidden = YES;
        self.switchButton.hidden = YES;
    }
    
}
-(void)setValueWithGroupPush:(BOOL)groupPushBOOL
{
    [self.switchButton setOn:groupPushBOOL];
    self.switchButton.on = groupPushBOOL;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor appAllBackColor];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (self.switchBlock) {
        self.switchBlock(isButtonOn);
    }
    if (isButtonOn) {
        NSLog(@"CEll-是") ;
    }else {
        NSLog(@"CELL-否") ;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)underView
{
    if (!_underView) {
        _underView = [[UIView alloc]init];
        _underView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_underView];
    }
    return _underView;
}
-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT(32);
        [self.underView addSubview:_title];
    }
    return _title;
}
-(UILabel *)centerLabel
{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc]init];
        _centerLabel.textAlignment = NSTextAlignmentRight;
        _centerLabel.font = FONT(30);
        [self.underView addSubview:_centerLabel];
    }
    return _centerLabel;
}
-(UISwitch *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton setOn:NO];
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.underView addSubview:_switchButton];
    }
    return _switchButton;
}


@end
