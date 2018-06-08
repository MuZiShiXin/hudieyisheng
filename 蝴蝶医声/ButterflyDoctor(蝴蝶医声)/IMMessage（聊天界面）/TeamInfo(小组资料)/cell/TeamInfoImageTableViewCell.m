//
//  TeamInfoImageTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "TeamInfoImageTableViewCell.h"
#import "GatoBaseHelp.h"
#import "TeamImageView.h"
@interface TeamInfoImageTableViewCell ()
@property (nonatomic ,strong) UIButton * AllorOne;//展开收回按钮
@property (nonatomic ,strong) UILabel * titleLabel;
@end
@implementation TeamInfoImageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TeamInfoImageTableViewCell";
    TeamInfoImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamInfoImageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)setValueWithModelArray:(NSArray *)modelArray Withzhankai:(BOOL)selete
{
    __weak typeof(self) weakSelf = self;

    NSMutableArray * AccordingArray = [NSMutableArray array];
    self.AllorOne.selected = selete;
    
    
    
    if (selete == YES) {
        AccordingArray = modelArray;
        [self.AllorOne setTitle:@"关闭查看更多医生成员" forState:UIControlStateNormal];
    }else{
        [self.AllorOne setTitle:@"查看更多医生成员" forState:UIControlStateNormal];
        if (modelArray.count < 10) {
            for (int i = 0 ; i < modelArray.count ; i ++) {
                [AccordingArray addObject:modelArray[i]];
            }
        }else{
            for (int i = 0 ; i < 10 ; i ++) {
                [AccordingArray addObject:modelArray[i]];
            }
        }
    }
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[TeamImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    
    for (int i = 0 ; i < AccordingArray.count ; i ++) {
        
        CGFloat y = i / 5 * Gato_Height_548_(72) + Gato_Height_548_(45);
        CGFloat x = i % 5 * Gato_Width / 5;
        TeamImageModel * model = [[TeamImageModel alloc]init];
        model = AccordingArray[i];
        TeamImageView * view = [[TeamImageView alloc]init];
        [view setValueWithModel:model];
        [self addSubview:view];
        view.sd_layout.leftSpaceToView(self,x)
        .topSpaceToView(self,y)
        .widthIs(Gato_Width / 5)
        .heightIs(Gato_Height_548_(72));
        
        view.imageBlock = ^(TeamImageModel * imageBlock){
            if (weakSelf.imageBlock) {
                weakSelf.imageBlock(imageBlock);
            }
        };
    }
    
    CGFloat height = AccordingArray.count / 5 * Gato_Height_548_(72);
    if (AccordingArray.count % 5 > 0) {
        height += Gato_Height_548_(72);
    }
    if (modelArray.count < 10) {
        self.AllorOne.hidden = YES;
        height += Gato_Height_548_(10);
    }else{
        self.AllorOne.hidden = NO;
        height += Gato_Height_548_(40);
    }
    
    self.height = height + Gato_Height_548_(45);
    
    self.AllorOne.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,height)
    .heightIs(Gato_Height_548_(30));
    
    
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self, Gato_Height_548_(10))
    .heightIs(Gato_Height_548_(20));
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:Gato_Width];
    
    GatoViewBorderRadius(self.titleLabel, 0, 1, [UIColor HDThemeColor]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)allorOneButtonDid
{
    if (self.AllorOne.selected == YES) {
        self.AllorOne.selected = NO;
        [self.AllorOne setTitle:@"关闭查看更多医生成员" forState:UIControlStateNormal];
    }else{
        self.AllorOne.selected = YES;
        [self.AllorOne setTitle:@"查看更多医生成员" forState:UIControlStateNormal];
    }
    if (self.zhankaiBlock) {
        self.zhankaiBlock(self.AllorOne.selected);
    }
}

-(UIButton *)AllorOne
{
    if (!_AllorOne) {
        _AllorOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [_AllorOne setTitle:@"查看更多医生成员" forState:UIControlStateNormal];
        _AllorOne.selected = NO;
        [_AllorOne setTitleColor:[UIColor YMAppAllTitleColor] forState:UIControlStateNormal];
        _AllorOne.titleLabel.font = FONT(30);
        [_AllorOne addTarget:self action:@selector(allorOneButtonDid) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_AllorOne];
    }
    return _AllorOne;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = FONT(30);
        _titleLabel.text = @"医生组成员";
        _titleLabel.textColor = [UIColor HDThemeColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
