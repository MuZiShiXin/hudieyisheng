//
//  bedNumberRightTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "bedNumberRightTableViewCell.h"
#import "GatoBaseHelp.h"
@implementation bedNumberRightTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bedNumberRightTableViewCell";
    bedNumberRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"bedNumberRightTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setValueWithNameArray:(NSArray *)nameArray
{
    for (UIView * view in self.subviews) {
        [view removeAllSubviews];
    }
    for (int i = 0 ; i < nameArray.count; i ++) {
        
        CGFloat viewx = Gato_Width_320_(10);
        CGFloat viewy = Gato_Height_548_(10);
        CGFloat width = Gato_Width_320_(40);
        CGFloat height = Gato_Height_548_(40);
        
        CGFloat forX = i % 4;
        CGFloat forY = i / 4;
        
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        view.sd_layout.leftSpaceToView(self, viewx + forX * Gato_Width_320_(50))
        .topSpaceToView(self, viewy + forY * Gato_Height_548_(50))
        .widthIs(width)
        .heightIs(height);
        
        GatoViewBorderRadius(view, 3, 1, [UIColor HDViewBackColor]);
        
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor HDBlackColor];
        label.font = FONT(30);
        label.numberOfLines = 0;
        [view addSubview:label];
        label.sd_layout.leftSpaceToView(view, 0)
        .rightSpaceToView(view, 0)
        .topSpaceToView(view, 0)
        .bottomSpaceToView(view, 0);
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = nameArray[i];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonWithBlock:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = FONT(0);
        [view addSubview:button];
        button.sd_layout.leftSpaceToView(view, 0)
        .rightSpaceToView(view, 0)
        .topSpaceToView(view, 0)
        .bottomSpaceToView(view, 0);
    }
}
-(void)buttonWithBlock:(UIButton *)sender
{
    if (self.CellBedNumberStrBlock) {
        self.CellBedNumberStrBlock(sender.titleLabel.text);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
