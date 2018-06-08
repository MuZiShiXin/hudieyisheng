//
//  updateTeamTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/16.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "updateTeamTableViewCell.h"
#import "GatoBaseHelp.h"
#import "GatoWorkLabel.h"

@interface updateTeamTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * teamGod;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) GatoWorkLabel * work;//职称
@property (nonatomic ,strong) UILabel * hospital;
@end
@implementation updateTeamTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"updateTeamTableViewCell";
    updateTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"updateTeamTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

-(void)setValueWithModel:(MyTeamMemberModel *)model WithGodPhone:(NSString *)phone
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@""]];
    self.name.text = model.name;
    self.work.text = model.work;
    self.hospital.text = model.hospital;
    
    self.work.frame = CGRectMake(CGRectGetMaxX(self.name.frame) + Gato_Width_320_(90), Gato_Height_548_(23), Gato_Width_320_(100), CGRectGetHeight(self.name.frame));
    [self.work sizeToFit];
    
    if ([model.phone isEqualToString:phone]) {
        self.teamGod.image = [UIImage imageNamed:@"qunzhu"];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.photo.sd_layout.leftSpaceToView(self, Gato_Width_320_(15))
    .topSpaceToView(self, Gato_Height_548_(15))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    GatoViewBorderRadius(self.photo, Gato_Width_320_(55) / 2, 1, [UIColor HDViewBackColor]);
    
    self.teamGod.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .widthIs(Gato_Width_320_(40))
    .heightIs(Gato_Height_548_(40));
    
    self.name.sd_layout.leftSpaceToView(self.photo, Gato_Width_320_(10))
    .topSpaceToView(self, Gato_Height_548_(22.5))
    .heightIs(Gato_Height_548_(20));
    [self.name setSingleLineAutoResizeWithMaxWidth:100];
    
    self.hospital.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.name, 0)
    .rightSpaceToView(self, Gato_Width_320_(15))
    .minHeightIs(Gato_Height_548_(20))
    .autoHeightRatio(0);
    
    
    GatoViewBorderRadius(self.work, 3, 0, [UIColor redColor]);
    
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = [UIColor HDViewBackColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.1, rect.size.width  , Gato_Height_548_(1)));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}
-(UIImageView *)teamGod
{
    if (!_teamGod) {
        _teamGod = [[UIImageView alloc]init];
        [self addSubview:_teamGod];
    }
    return _teamGod;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor HDBlackColor];
        _name.font = FONT(34);
        [self addSubview:_name];
    }
    return _name;
}
-(GatoWorkLabel *)work
{
    if (!_work) {
        _work = [[GatoWorkLabel alloc]init];
        _work.textColor = [UIColor whiteColor];
        _work.backgroundColor = [UIColor HDOrangeColor];
        _work.font = FONT(30);
        [self addSubview:_work];
    }
    return _work;
}
-(UILabel *)hospital
{
    if (!_hospital) {
        _hospital = [[UILabel alloc]init];
        _hospital.textColor = [UIColor YMAppAllTitleColor];
        _hospital.font = FONT(30);
        _hospital.numberOfLines = 0;
        [self addSubview:_hospital];
    }
    return _hospital;
}


@end
