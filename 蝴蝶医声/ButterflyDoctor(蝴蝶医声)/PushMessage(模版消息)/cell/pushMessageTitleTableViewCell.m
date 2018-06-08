//
//  pushMessageTitleTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "pushMessageTitleTableViewCell.h"
#import "GatoBaseHelp.h"

@interface pushMessageTitleTableViewCell ()
@property (nonatomic ,strong) UILabel * titlelabel;
@property (nonatomic ,strong) UILabel * time;
@property (nonatomic ,strong) UILabel * centerLable;
@end
@implementation pushMessageTitleTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"pushMessageTitleTableViewCell";
    pushMessageTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"pushMessageTitleTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setvalueWithModel:(pushMessageTitleModel * )model
{
    self.titlelabel.text = model.title;
    self.time.text = [NSString stringWithFormat:@"创建于%@",model.time];
    self.centerLable.text = model.center;
    
//    [self.centerLable updateLayout];
    [self.centerLable sizeToFit];
    self.height = self.centerLable.height + Gato_Height_548_(80);
    
    NSLog(@"end   \nself.height %.2f \n self.titlelabel.height %.2f  \n self.centerLable.height %.2f",self.height,self.titlelabel.height,self.centerLable.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titlelabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(30));
    
    self.time.sd_layout.leftEqualToView(self.titlelabel)
    .rightEqualToView(self.titlelabel)
    .topSpaceToView(self.titlelabel,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
//    self.centerLable.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
//    .rightSpaceToView(self,Gato_Width_320_(13))
//    .topSpaceToView(self,Gato_Height_548_(75))
//    .autoHeightRatio(0)
//    .minHeightIs(Gato_Width_320_(30));
    
    self.centerLable.frame = CGRectMake(Gato_Width_320_(13), Gato_Height_548_(75), Gato_Width_320_(294), Gato_Height_548_(30));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.font = FONT(32);
        _time.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_time];
    }
    return _time;
}

-(UILabel *)centerLable
{
    if (!_centerLable) {
        _centerLable = [[UILabel alloc]init];
        _centerLable.font = FONT(32);
        _centerLable.textColor = [UIColor HDBlackColor];
        _centerLable.numberOfLines = 0;
        [self addSubview:_centerLable];
    }
    return _centerLable;
}
-(UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.font = FONT_Bold_(36);
        _titlelabel.textColor = [UIColor HDBlackColor];
        _titlelabel.numberOfLines = 0;
        [self addSubview:_titlelabel];
    }
    return _titlelabel;
}



@end
