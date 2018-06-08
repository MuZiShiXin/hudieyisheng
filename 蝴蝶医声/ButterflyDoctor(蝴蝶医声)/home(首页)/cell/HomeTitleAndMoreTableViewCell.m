//
//  HomeTitleAndMoreTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HomeTitleAndMoreTableViewCell.h"
#import "GatoBaseHelp.h"

@interface HomeTitleAndMoreTableViewCell ()
@property(nonatomic ,strong) UILabel * name;
@property(nonatomic ,strong) UILabel * more;
@property (nonatomic ,strong) UIButton * pushButton;
@end
@implementation HomeTitleAndMoreTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeTitleAndMoreTableViewCell";
    HomeTitleAndMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTitleAndMoreTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
+ (CGFloat)getHetigh
{
    return Gato_Width_320_(35);
}
- (void)setValueWithTitle:(NSString *)str
{
    self.name.text = str;
    self.more.text = @"更多";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .widthIs(Gato_Width_320_(160));
    
    self.more.sd_layout.rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0)
    .widthIs(Gato_Width_320_(160));
    
    self.pushButton.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .bottomSpaceToView(self,0);

}
-(void)pushButtonDid
{
    if (self.moreBlock) {
        self.moreBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIButton *)pushButton
{
    if (!_pushButton) {
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushButton addTarget:self action:@selector(pushButtonDid) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pushButton];
    }
    return _pushButton;
}
-(UILabel *)more
{
    if (!_more) {
        _more= [[UILabel alloc]init];
        _more.textColor = [UIColor HDThemeColor];
        _more.font = FONT(30);
        _more.textAlignment = NSTextAlignmentRight;
        [self addSubview:_more];
    }
    return _more;
}
-(UILabel *)name
{
    if (!_name) {
        _name= [[UILabel alloc]init];
        _name.textColor = [UIColor HDBlackColor];
        _name.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self addSubview:_name];
    }
    return _name;
}

@end
