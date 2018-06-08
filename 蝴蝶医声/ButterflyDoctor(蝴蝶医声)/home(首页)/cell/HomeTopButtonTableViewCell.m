//
//  HomeTopButtonTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HomeTopButtonTableViewCell.h"
#import "GatoBaseHelp.h"

#define buttonTag 4181106
@interface HomeTopButtonTableViewCell ()
@property (nonatomic ,strong) UILabel * redLabel;//图文资讯上方小红点
@end
@implementation HomeTopButtonTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeTopButtonTableViewCell";
    HomeTopButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTopButtonTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
+ (CGFloat)getHeight
{
    return Gato_Height_548_(94);
}
-(void)setValueWithImageMessageCount:(NSString *)count
{
    if (!count) {
        return;
    }
    if ([count integerValue] > 0) {
        self.redLabel.hidden = NO;
        self.redLabel.text = count;
        if ([count integerValue] > 99) {
            [self.redLabel sizeToFit];
        }
    }else{
        self.redLabel.hidden = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self addAllViews];
    
//    self.redLabel.sd_layout.rightSpaceToView(self,Gato_Width_320_(12))
//    .topSpaceToView(self,Gato_Height_548_(15))
//    .widthIs(Gato_Width_320_(14))
//    .heightIs(Gato_Width_320_(14));
    self.redLabel.frame = CGRectMake(Gato_Width - Gato_Width_320_(26), Gato_Height_548_(15), Gato_Width_320_(14), Gato_Height_548_(14));
    [self.redLabel.layer setCornerRadius:(Gato_Width_320_(14) / 2)];\
    [self.redLabel.layer setMasksToBounds:YES];\
    
//    [self.redLabel setSingleLineAutoResizeWithMaxWidth:Gato_Width_320_(50)];
    
//    self.redLabel.text = @"1";
    
//    GatoViewBorderRadius(self.redLabel, Gato_Width_320_(12) / 2, 0, [UIColor redColor]);
}

-(void)buttonTypeBlock:(UIButton *)sender
{
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - buttonTag);
    }
}
-(void)addAllViews
{
    
    NSArray * imageArray = @[@"home_btn_inpatient",@"home_btn_pathology",@"home_btn_follow-up-visit",@"home_btn_consult"];
    NSArray * labelArray = @[@"住院患者",@"等待病理",@"随访",@"图文咨询"];
    for (int i = 0 ; i < 4 ; i ++) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:image];
        
        UILabel * label = [[UILabel alloc]init];
        label.font = FONT(26);
        label.textColor = [UIColor HDBlackColor];
        label.text = labelArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = buttonTag + i;
        [button addTarget:self action:@selector(buttonTypeBlock:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        view.sd_layout.leftSpaceToView(self,i * Gato_Width / 4)
        .topSpaceToView(self,0)
        .bottomSpaceToView(self,0)
        .widthIs(Gato_Width / 4);
        
        image.sd_layout.leftSpaceToView(view,Gato_Width / 4 / 2 - Gato_Width_320_(60)/2)
        .topSpaceToView(view,Gato_Height_548_(13))
        .widthIs(Gato_Width_320_(60))
        .heightEqualToWidth(image);
        
        label.sd_layout.leftSpaceToView(view,0)
        .rightSpaceToView(view,0)
        .topSpaceToView(image,0)
        .heightIs(Gato_Height_548_(15));
        
        button.sd_layout.leftSpaceToView(view,0)
        .rightSpaceToView(view,0)
        .topSpaceToView(view,0)
        .bottomSpaceToView(view,0);
        
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
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width  , Gato_Height_548_(1)));
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(UILabel *)redLabel
{
    if (!_redLabel) {
        _redLabel = [[UILabel alloc]init];
        _redLabel.font = FONT(24);
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.hidden = YES;
        _redLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_redLabel];
    }
    return _redLabel;
}

@end
