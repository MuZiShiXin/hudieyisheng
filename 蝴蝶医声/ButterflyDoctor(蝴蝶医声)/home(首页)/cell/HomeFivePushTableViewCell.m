//
//  HomeFivePushTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HomeFivePushTableViewCell.h"
#import "GatoBaseHelp.h"

#define buttonTag 4181326
@interface HomeFivePushTableViewCell ()
@property (nonatomic ,strong) UIImageView * teamMessage;//组内信息
@property (nonatomic ,strong) UIImageView * AllNumber;//数据统计
@property (nonatomic ,strong) UIImageView * TheArticle;//文章
@property (nonatomic ,strong) UIImageView * MyHelp;//我的助理
@property (nonatomic ,strong) UIImageView * stopWork;//出停诊
@property (nonatomic ,strong) UIImageView * NewMessage;//新消息
@property (nonatomic ,strong) UILabel * redLabel;//图文资讯上方小红点
@end
@implementation HomeFivePushTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeFivePushTableViewCell";
    HomeFivePushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeFivePushTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
+ (CGFloat)getHetigh
{
    return Gato_Height_548_(130) + 20;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    [self addAllViews];
    self.backgroundColor = [UIColor appAllBackColor];
}


-(void)addAllViews
{
    UIView * topFgx = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Gato_Width, 0.5)];
    topFgx.backgroundColor = [UIColor HDViewBackColor];
    [self addSubview:topFgx];
    UIView * topFgx1 = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, Gato_Width, 0.5)];
    topFgx1.backgroundColor = [UIColor HDViewBackColor];
    [self addSubview:topFgx1];
    
    
//    UIView * underFgx = [[UIView alloc]initWithFrame:CGRectMake(0, Gato_Height_548_(130) + 19.5, Gato_Width, 0.5)];
//    underFgx.backgroundColor = [UIColor HDViewBackColor];
//    [self addSubview:underFgx];
    UIView * underFgx1 = [[UIView alloc]initWithFrame:CGRectMake(0, Gato_Height_548_(130) + 10, Gato_Width, 0.5)];
    underFgx1.backgroundColor = [UIColor HDViewBackColor];
    [self addSubview:underFgx1];
    
    
    
    
    
    self.AllNumber.sd_layout.leftSpaceToView(self,0)
    .topSpaceToView(self,10)
    .heightIs(Gato_Height_548_(130))
    .widthIs(Gato_Width_320_(138));
    
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = buttonTag + 1;
    [button1 addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button1];
    button1.sd_layout.leftEqualToView(self.AllNumber)
    .topEqualToView(self.AllNumber)
    .rightEqualToView(self.AllNumber)
    .bottomEqualToView(self.AllNumber);
    
    self.teamMessage.sd_layout.leftSpaceToView(self.AllNumber,0)
    .topSpaceToView(self, 10)
    .widthIs(Gato_Width_320_(92))
    .heightIs(Gato_Height_548_(65));
    
    
    
//    self.NewMessage.sd_layout.leftSpaceToView(self.AllNumber,Gato_Width_320_(72))
//    .topSpaceToView(self,20)
//    .widthIs(Gato_Width_320_(14))
//    .heightIs(Gato_Width_320_(14));
//    GatoViewBorderRadius(self.NewMessage, Gato_Width_320_(14)/ 2, 0, [UIColor redColor]);
//    self.NewMessage.backgroundColor = [UIColor redColor];
    
//    self.redLabel.sd_layout.leftSpaceToView(self.AllNumber,Gato_Width_320_(72))
//    .topSpaceToView(self,20)
//    .widthIs(Gato_Width_320_(14))
//    .heightIs(Gato_Width_320_(14));
    self.redLabel.frame = CGRectMake(Gato_Width_320_(210),20, Gato_Width_320_(14), Gato_Width_320_(14));
    GatoViewBorderRadius(self.redLabel, Gato_Width_320_(14) / 2, 0, [UIColor clearColor]);
    
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = buttonTag;
    [button addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    button.sd_layout.leftEqualToView(self.teamMessage)
    .topEqualToView(self.teamMessage)
    .rightEqualToView(self.teamMessage)
    .bottomEqualToView(self.teamMessage);
    
    
    self.TheArticle.sd_layout.leftSpaceToView(self.teamMessage,0)
    .topEqualToView(self.AllNumber)
    .widthIs(Gato_Width_320_(92))
    .heightIs(Gato_Height_548_(65));
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = buttonTag + 2;
    [button2 addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    button2.sd_layout.leftEqualToView(self.TheArticle)
    .topEqualToView(self.TheArticle)
    .rightEqualToView(self.TheArticle)
    .bottomEqualToView(self.TheArticle);
    
    self.stopWork.sd_layout.leftSpaceToView(self.AllNumber,0)
    .topSpaceToView(self.teamMessage,0)
    .widthIs(Gato_Width_320_(92))
    .heightIs(Gato_Height_548_(65));
    
    UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.tag = buttonTag + 4;
    [button4 addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button4];
    button4.sd_layout.leftEqualToView(self.stopWork)
    .topEqualToView(self.stopWork)
    .rightEqualToView(self.stopWork)
    .bottomEqualToView(self.stopWork);
    
    
    self.MyHelp.sd_layout.leftSpaceToView(self.stopWork,0)
    .topSpaceToView(self.teamMessage,0)
    .widthIs(Gato_Width_320_(92))
    .heightIs(Gato_Height_548_(65));
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag = buttonTag + 3;
    [button3 addTarget:self action:@selector(ButtonBlock:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button3];
    button3.sd_layout.leftEqualToView(self.MyHelp)
    .topEqualToView(self.MyHelp)
    .rightEqualToView(self.MyHelp)
    .bottomEqualToView(self.MyHelp);
    
    
    
    GatoViewBorderRadius(self.teamMessage, 1, 0.5, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.AllNumber, 1, 0.5, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.TheArticle, 1, 0.5, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.MyHelp, 1, 0.5, [UIColor appAllBackColor]);
    GatoViewBorderRadius(self.stopWork,1, 0.5, [UIColor appAllBackColor]);
    
    
    
}

-(void)teamMessageNumberWithCount:(NSString *)messageNumber
{
    if ([messageNumber integerValue] > 0) {
        self.NewMessage.hidden = NO;
    }else{
        self.NewMessage.hidden = YES;
    }
    if ([messageNumber integerValue] > 0) {
        self.redLabel.hidden = NO;
        self.redLabel.text = messageNumber;
        if ([messageNumber integerValue] > 99) {
            [self.redLabel sizeToFit];
        }
    }else{
        self.redLabel.hidden = YES;
    }
}

-(void)ButtonBlock:(UIButton *)sender
{
    if (self.FiveButtonBlock) {
        self.FiveButtonBlock(sender.tag - buttonTag);
    }
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



-(UIImageView *) NewMessage
{
    if (!_NewMessage) {
        _NewMessage = [[UIImageView alloc]init];
//        _NewMessage.image = [UIImage imageNamed:@"home_pre_unread-message"];
        _NewMessage.hidden = YES;
        [self addSubview:_NewMessage];
    }
    return _NewMessage;
}
-(UIImageView *) AllNumber
{
    if (!_AllNumber) {
        _AllNumber = [[UIImageView alloc]init];
        _AllNumber.image = [UIImage imageNamed:@"shujutongji"];
        [self addSubview:_AllNumber];
    }
    return _AllNumber;
}
-(UIImageView *) TheArticle
{
    if (!_TheArticle) {
        _TheArticle = [[UIImageView alloc]init];
        _TheArticle.image = [UIImage imageNamed:@"1huanjiaowenzhang"];
        [self addSubview:_TheArticle];
    }
    return _TheArticle;
}
-(UIImageView *) MyHelp
{
    if (!_MyHelp) {
        _MyHelp = [[UIImageView alloc]init];
        _MyHelp.image = [UIImage imageNamed:@"1wodeyizhu"];
        [self addSubview:_MyHelp];
    }
    return _MyHelp;
}
-(UIImageView *) stopWork
{
    if (!_stopWork) {
        _stopWork = [[UIImageView alloc]init];
        _stopWork.image = [UIImage imageNamed:@"1chutingzhen"];
        [self addSubview:_stopWork];
    }
    return _stopWork;
}
-(UIImageView *) teamMessage
{
    if (!_teamMessage) {
        _teamMessage = [[UIImageView alloc]init];
        _teamMessage.image = [UIImage imageNamed:@"1zuneixinxi"];
        [self addSubview:_teamMessage];
    }
    return _teamMessage;
}



@end
