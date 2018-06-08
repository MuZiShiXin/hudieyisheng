//
//  WithdrawainfoTableViewCell.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/16.
//  strongright © 2017年 辛书亮. All rights reserved.
//

#import "WithdrawainfoTableViewCell.h"
#import "GatoBaseHelp.h"

@interface WithdrawainfoTableViewCell ()
@property (nonatomic ,strong) UILabel *beginTime;//申请时间
@property (nonatomic ,strong) UILabel *endTime;//到账时间( 判断审核通过后显示 )
@property (nonatomic ,strong) UILabel *goldCount;//申请的蝴蝶币数
@property (nonatomic ,strong) UILabel *actualAmount;//兑现的实际金额
@property (nonatomic ,strong) UILabel *isVerify;//审核
@end
@implementation WithdrawainfoTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WithdrawainfoTableViewCell";
    WithdrawainfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WithdrawainfoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)setValueWithModel:(withdrawaInfoModel *)model
{
    self.actualAmount.text = [NSString stringWithFormat:@"提现的实际金额：%@",model.actualAmount];
    self.beginTime.text = [NSString stringWithFormat:@"申请时间：%@",model.beginTime];
    self.endTime.text = [NSString stringWithFormat:@"到账时间：%@",model.endTime];
    self.goldCount.text = [NSString stringWithFormat:@"提现的蝴蝶币数：%@",model.goldCount];
    if ([model.isVerify isEqualToString:@"-1"]) {
        self.isVerify.text = @"审核未通过";
    }else if ([model.isVerify isEqualToString:@"0"]){
        self.isVerify.text = @"审核中";
    }else{
        self.isVerify.text = @"已完成";
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView * underView = [[UIView alloc]init];
    underView.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:underView];
    underView.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(10));
    
    self.actualAmount.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(underView,0)
    .rightSpaceToView(self,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(20));
    
    UIView * fgx = [[UIView alloc]init];
    fgx.backgroundColor = [UIColor appAllBackColor];
    [self addSubview:fgx];
    fgx.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self.actualAmount,0)
    .heightIs(Gato_Height_548_(1));
    
    self.goldCount.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(fgx,0)
    .rightSpaceToView(self,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(20));
    
    self.beginTime.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self.goldCount,0)
    .rightSpaceToView(self,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(20));
    
    self.endTime.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(self.beginTime,0)
    .rightSpaceToView(self,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(20));
    
    self.isVerify.sd_layout.leftSpaceToView(self,Gato_Width_320_(15))
    .topSpaceToView(underView,0)
    .rightSpaceToView(self,Gato_Width_320_(15))
    .heightIs(Gato_Height_548_(20));
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)actualAmount
{
    if (!_actualAmount) {
        _actualAmount = [[UILabel alloc]init];
        _actualAmount.font = FONT(32);
        _actualAmount.textColor = [UIColor HDBlackColor];
        [self addSubview:_actualAmount];
    }
    return _actualAmount;
}
-(UILabel *)isVerify
{
    if (!_isVerify) {
        _isVerify = [[UILabel alloc]init];
        _isVerify.font = FONT(32);
        _isVerify.textColor = [UIColor HDTitleRedColor];
        _isVerify.textAlignment = NSTextAlignmentRight;
        [self addSubview:_isVerify];
    }
    return _isVerify;
}
-(UILabel *)beginTime
{
    if (!_beginTime) {
        _beginTime = [[UILabel alloc]init];
        _beginTime.font = FONT(30);
        _beginTime.textColor = [UIColor YMAppAllTitleColor];
        
        [self addSubview:_beginTime];
    }
    return _beginTime;
}
-(UILabel *)endTime
{
    if (!_endTime) {
        _endTime = [[UILabel alloc]init];
        _endTime.font = FONT(30);
        _endTime.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_endTime];
    }
    return _endTime;
}
-(UILabel *)goldCount
{
    if (!_goldCount) {
        _goldCount = [[UILabel alloc]init];
        _goldCount.font = FONT(30);
        _goldCount.textColor = [UIColor YMAppAllTitleColor];
        [self addSubview:_goldCount];
    }
    return _goldCount;
}
@end
