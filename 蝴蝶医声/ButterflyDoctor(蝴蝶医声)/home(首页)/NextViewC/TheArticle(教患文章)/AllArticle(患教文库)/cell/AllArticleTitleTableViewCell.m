//
//  AllArticleTitleTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "AllArticleTitleTableViewCell.h"
#import "GatoBaseHelp.h"

@interface AllArticleTitleTableViewCell ()
@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel * nameLabel;
@property (nonatomic ,strong) UILabel * yinyonglabel;
@end
@implementation AllArticleTitleTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AllArticleTitleTableViewCell";
    AllArticleTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AllArticleTitleTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(AllArticleModel *)model WithNowType:(NSInteger )nowType
{
    self.titleLabel.text = model.title;
    self.nameLabel.text = [NSString stringWithFormat:@"作者：%@ - %@",model.author,model.hospitalDepartment];
    if ([model.quoteCount isEqualToString:@"0"]) {
        model.quoteCount = @"暂无";
    }
    
    if (nowType == 0) {
        self.yinyonglabel.text = [NSString stringWithFormat:@"%@引用",model.quoteCount];
    }else if (nowType == 1){
        if ([model.click isEqualToString:@"0人"]) {
            self.yinyonglabel.text = @"暂无阅读";
        }else{
            self.yinyonglabel.text = [NSString stringWithFormat:@"%@已读",model.click];
        }
        
    }else if (nowType == 2){
        self.yinyonglabel.text = [NSString stringWithFormat:@"%@",model.time];
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
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , 0.5));
}

+(CGFloat)getHeight
{
    return Gato_Height_548_(60);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.sd_layout.leftSpaceToView(self,Gato_Width_320_(10))
    .rightSpaceToView(self,Gato_Width_320_(10))
    .topSpaceToView(self,Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(20));
    
    self.nameLabel.sd_layout.leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel,0)
    .heightIs(Gato_Height_548_(20));
    
    self.yinyonglabel.sd_layout.leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel,0)
    .heightIs(Gato_Height_548_(20));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor YMAppAllTitleColor];
        _nameLabel.font = FONT(34);
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor HDBlackColor];
        _titleLabel.font = FONT_Bold_(34);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)yinyonglabel
{
    if (!_yinyonglabel) {
        _yinyonglabel = [[UILabel alloc]init];
        _yinyonglabel.textColor = [UIColor HDTitleRedColor];
        _yinyonglabel.font = FONT(30);
        _yinyonglabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_yinyonglabel];
    }
    return _yinyonglabel;
}

@end
