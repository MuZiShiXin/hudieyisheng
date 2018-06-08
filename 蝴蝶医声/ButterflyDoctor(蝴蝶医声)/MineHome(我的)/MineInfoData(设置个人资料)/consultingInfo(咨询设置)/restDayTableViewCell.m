//
//  restDayTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "restDayTableViewCell.h"
#import "GatoBaseHelp.h"

@interface restDayTableViewCell ()
@property (nonatomic ,strong) UILabel * title;
@property (nonatomic ,strong) UIImageView * selectImage;
@end
@implementation restDayTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"restDayTableViewCell";
    restDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"restDayTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)setValueWithModel:(TitleAndSelectModel *)model
{
    if (model.select == YES) {
        self.selectImage.image = [UIImage imageNamed:@"pathology_selected"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@""];
    }
    self.title.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);
    
    self.selectImage.sd_layout.leftSpaceToView(self, Gato_Width_320_(100))
    .centerYEqualToView(self)
    .widthIs(Gato_Width_320_(12))
    .heightIs(Gato_Height_548_(8));
    //pathology_selected
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.frame = CGRectMake(0, 0, Gato_Width, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIImageView *)selectImage
{
    if (!_selectImage) {
        _selectImage = [[UIImageView alloc]init];
        [self addSubview:_selectImage];
    }
    return _selectImage;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.font = FONT(35);
        _title.textColor = [UIColor HDBlackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_title];
    }
    return _title;
}
@end
