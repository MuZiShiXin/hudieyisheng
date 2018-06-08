//
//  bedNumberLeftTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "bedNumberLeftTableViewCell.h"
#import "GatoBaseHelp.h"

@interface bedNumberLeftTableViewCell ()
@property (nonatomic ,strong) UIView * selectView;
@property (nonatomic ,strong) UILabel * name;

@end
@implementation bedNumberLeftTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bedNumberLeftTableViewCell";
    bedNumberLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"bedNumberLeftTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setValueWithName:(NSString *)name WithIndexSelect:(BOOL )select
{
    if (select) {
        self.selectView.backgroundColor = [UIColor HDThemeColor];
        self.name.textColor = [UIColor HDTitleRedColor];
        self.name.backgroundColor = [UIColor appAllBackColor];
    }else{
        self.selectView.backgroundColor = [UIColor clearColor];
        self.name.textColor = [UIColor HDBlackColor];
        self.name.backgroundColor = [UIColor whiteColor];
    }
    self.name.text = name;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectView.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .widthIs(Gato_Width_320_(5))
    .heightIs(Gato_Height_548_(50));
    
    
//    self.name.backgroundColor = [UIColor redColor];
//    GatoViewBorderRadius(self.name, 10, 1, [UIColor greenColor]);
    self.name.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(Gato_Height_548_(50));
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, Gato_Height_548_(49))
    .heightIs(Gato_Height_548_(1));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = FONT(30);
        _name.textColor = [UIColor HDBlackColor];
        [self addSubview:_name];
    }
    return _name;
}
-(UIView *)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.backgroundColor = [UIColor clearColor];
        [self addSubview:_selectView];
    }
    return _selectView;
}

@end
