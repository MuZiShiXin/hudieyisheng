//
//  ModifyArticleDeleteTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "ModifyArticleDeleteTableViewCell.h"
#import "GatoBaseHelp.h"

@interface ModifyArticleDeleteTableViewCell ()
@property (nonatomic ,strong) UILabel * typeLabel;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * timelabel;
@property (nonatomic ,strong) UILabel * drinkingLabel;//引用
@property (nonatomic ,strong) UILabel * readinglabel;//阅读
@property (nonatomic ,strong) UIImageView * zhiding;//置顶图片
@property (nonatomic ,strong) UIButton * deleteButton;
@end
@implementation ModifyArticleDeleteTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ModifyArticleDeleteTableViewCell";
    ModifyArticleDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ModifyArticleDeleteTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(TheArticleModel *)model
{
    self.typeLabel.text = model.type;
    self.nameLabel.text = model.title;
    self.timelabel.text = model.time;
    self.drinkingLabel.text = model.yinyong;
    self.readinglabel.text = model.yuedu;
    
    if ([model.zhiding isEqualToString:@"1"]) {
        _zhiding.image = [UIImage imageNamed:@"home-icon_Stick"];
    }else{
        _zhiding.image = [UIImage imageNamed:@""];
    }
    
    [self.nameLabel updateLayout];
    self.height = self.nameLabel.height + Gato_Height_548_(45);
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    UIColor *color = Gato_(240,240,240);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , 0.5));
}


+(CGFloat)getHeight
{
    return Gato_Height_548_(62);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeLabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,-1)
    .minHeightIs(Gato_Height_548_(15));
    
    [self.typeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    GatoViewBorderRadius(self.typeLabel, 3, 0, [UIColor redColor]);
    
    self.deleteButton.sd_layout.rightSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Width_320_(23))
    .widthIs(Gato_Width_320_(52))
    .heightIs(Gato_Width_320_(20));
    
    
    self.nameLabel.sd_layout.leftEqualToView(self.typeLabel)
    .topSpaceToView(self,Gato_Height_548_(10))
    .rightSpaceToView(self.deleteButton,Gato_Width_320_(12))
    .autoHeightRatio(0)
    .maxHeightIs(Gato_Height_548_(30));
    
    
    self.timelabel.sd_layout.leftEqualToView(self.typeLabel)
    .rightEqualToView(self.nameLabel)
    .topSpaceToView(self.nameLabel,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    self.drinkingLabel.sd_layout.leftEqualToView(self.typeLabel)
    .rightEqualToView(self.nameLabel)
    .topSpaceToView(self.nameLabel,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    self.readinglabel.sd_layout.leftEqualToView(self.typeLabel)
    .rightEqualToView(self.nameLabel)
    .topSpaceToView(self.nameLabel,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    
}
-(void)deleteButtonDidClicked
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(UIImageView *)zhiding
{
    if (!_zhiding) {
        _zhiding = [[UIImageView alloc]init];
        [self addSubview:_zhiding];
    }
    return _zhiding;
}
-(UILabel *)drinkingLabel
{
    if (!_drinkingLabel) {
        _drinkingLabel = [[UILabel alloc]init];
        _drinkingLabel.textColor = [UIColor YMAppAllTitleColor];
        _drinkingLabel.font = FONT(26);
        _drinkingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_drinkingLabel];
    }
    return _drinkingLabel;
}
-(UILabel *)readinglabel
{
    if (!_readinglabel) {
        _readinglabel = [[UILabel alloc]init];
        _readinglabel.textColor = [UIColor YMAppAllTitleColor];
        _readinglabel.font = FONT(26);
        _readinglabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_readinglabel];
    }
    return _readinglabel;
}
-(UILabel *)timelabel
{
    if (!_timelabel) {
        _timelabel = [[UILabel alloc]init];
        _timelabel.textColor = [UIColor YMAppAllTitleColor];
        _timelabel.font = FONT(26);
        [self addSubview:_timelabel];
    }
    return _timelabel;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor HDBlackColor];
        _nameLabel.font = FONT_Bold_(30);
        _nameLabel.numberOfLines = 2;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = Gato_(121,120,120);
        _typeLabel.backgroundColor = [UIColor appAllBackColor];
        _typeLabel.font = FONT(22);
        [self addSubview:_typeLabel];
    }
    return _typeLabel;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"inpatient_btn_remove"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
    }
    return _deleteButton;
}



@end
