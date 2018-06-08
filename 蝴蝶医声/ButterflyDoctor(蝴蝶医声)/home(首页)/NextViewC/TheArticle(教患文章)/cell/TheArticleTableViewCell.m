//
//  TheArticleTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "TheArticleTableViewCell.h"
#import "GatoBaseHelp.h"

@interface TheArticleTableViewCell ()
@property (nonatomic ,strong) UILabel * typeLabel;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * timelabel;
@property (nonatomic ,strong) UILabel * drinkingLabel;//引用
@property (nonatomic ,strong) UILabel * readinglabel;//阅读
@property (nonatomic ,strong) UIImageView * zhiding;//置顶图片
@end
@implementation TheArticleTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TheArticleTableViewCell";
    TheArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TheArticleTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(TheArticleModel *)model
{
    
    if ([model isKindOfClass:[TheArticleModel class]]) {
        self.typeLabel.text = [GatoMethods getButterflyarticlesTypeWithType:model.classify.length > 0 ? model.classify : @"0"];
        if ([model.isVerify isEqualToString:@"-1"]) {
            self.nameLabel.text = [NSString stringWithFormat:@"[已驳回]%@",model.title];
            [GatoMethods NSMutableAttributedStringWithLabel:self.nameLabel WithAllString:self.nameLabel.text WithColorString:@"[已驳回]" WithColor:[UIColor redColor]];
        }else if ([model.isVerify isEqualToString:@"0"]){
            self.nameLabel.text = [NSString stringWithFormat:@"[审核中]%@",model.title];
            [GatoMethods NSMutableAttributedStringWithLabel:self.nameLabel WithAllString:self.nameLabel.text WithColorString:@"[审核中]" WithColor:[UIColor orangeColor]];
        }else{
            self.nameLabel.text = model.title;
        }
        
        self.timelabel.text = [NSString stringWithFormat:@"%@发表",model.time];
        if ([model.quoteCount isEqualToString:@"0"]) {
            model.quoteCount = @"暂无";
        }
        self.drinkingLabel.text = [NSString stringWithFormat:@"%@引用",model.quoteCount];
        if ([model.click isEqualToString:@"0"]) {
            self.readinglabel.text = @"暂无阅读";
        }else{
            self.readinglabel.text = [NSString stringWithFormat:@"%@人已读",model.click];
        }
        
        
        if ([model.isTop isEqualToString:@"1"]) {
            _zhiding.image = [UIImage imageNamed:@"home-icon_Stick"];
        }else{
            _zhiding.image = [UIImage imageNamed:@""];
        }
        
        [self.nameLabel updateLayout];
        self.height = self.nameLabel.height + Gato_Height_548_(45);
    }
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
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , Gato_Height_548_(0.5)));
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
    
    self.nameLabel.sd_layout.leftEqualToView(self.typeLabel)
    .topSpaceToView(self,Gato_Height_548_(20))
    .rightSpaceToView(self,Gato_Width_320_(12))
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
    
    self.zhiding.sd_layout.rightSpaceToView(self,Gato_Width_320_(12))
    .topSpaceToView(self,0)
    .widthIs(Gato_Width_320_(26))
    .heightIs(Gato_Height_548_(12));
    
    
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
        _drinkingLabel.font = FONT(30);
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
        _readinglabel.font = FONT(30);
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
        _timelabel.font = FONT(30);
        [self addSubview:_timelabel];
    }
    return _timelabel;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor HDBlackColor];
        _nameLabel.font = FONT_Bold_(34);
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
        _typeLabel.font = FONT(28);
        [self addSubview:_typeLabel];
    }
    return _typeLabel;
}


@end
