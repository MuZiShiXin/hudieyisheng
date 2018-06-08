//
//  patientInfoImageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "patientInfoImageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface patientInfoImageTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@end
@implementation patientInfoImageTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"patientInfoImageTableViewCell";
    patientInfoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"patientInfoImageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setValueWithImageUrl:(NSString *)imageUrl
{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
//    zhanweitu
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.photo.sd_layout.leftSpaceToView(self,Gato_Width / 2 - Gato_Width_320_(40))
    .topSpaceToView(self,Gato_Height_548_(20))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(80));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(40), 0, [UIColor redColor]);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(UIImageView * )photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}
@end
