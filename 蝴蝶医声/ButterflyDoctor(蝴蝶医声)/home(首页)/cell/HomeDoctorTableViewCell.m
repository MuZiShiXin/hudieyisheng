//
//  HomeDoctorTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HomeDoctorTableViewCell.h"
#import "GatoBaseHelp.h"
#import "GatoWorkLabel.h"
@interface HomeDoctorTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;//头像
@property (nonatomic ,strong) UILabel * name;//名字
@property (nonatomic ,strong) GatoWorkLabel * work;//职称
@property (nonatomic ,strong) UIImageView * ranking;//排名图标
@property (nonatomic ,strong) UIImageView * rankingName;//排名名字
@property (nonatomic ,strong) UILabel * hospital;//所属医院+科室
@property (nonatomic ,weak) UILabel * allPeople;//总治疗人数
@property (nonatomic ,strong) UILabel * satisfaction;//满意度
@property (nonatomic ,strong) UILabel * level;//等级
@property (nonatomic ,strong) UILabel * centerText;//擅长项目介绍
@end
@implementation HomeDoctorTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeDoctorTableViewCell";
    HomeDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeDoctorTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setValueWithModel:(HonorHomeModel *)model WithTitle:(NSInteger )row
{
    self.name.text = model.name;
    self.work.text = model.work;
    if (row == 0) {
        self.ranking.image = [UIImage imageNamed:@"newtop1"];
        self.rankingName.image = [UIImage imageNamed:@"home_icon_title"];
    }else if (row == 1){
        self.ranking.image = [UIImage imageNamed:@"newtop2"];
        self.rankingName.image = [UIImage imageNamed:@"home_icon_runner-up"];
    }else if (row == 2){
        self.ranking.image = [UIImage imageNamed:@"newtop3"];
        self.rankingName.image = [UIImage imageNamed:@"home_icon_third-winner-in-contest"];
    }else{
        self.ranking.image = [UIImage imageNamed:@""];
        self.rankingName.image = [UIImage imageNamed:@""];
    }
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
    self.hospital.text = [NSString stringWithFormat:@"%@-%@",model.hospital,model.hospitalDepartment];
    self.allPeople.text = [NSString stringWithFormat:@"患者量:%@人",model.patientAllCount ];
    self.satisfaction.text = [NSString stringWithFormat:@"满意度:%@",model.satisfied ];
    self.level.text = [NSString stringWithFormat:@"蝴蝶等级:%@",[GatoMethods getButterflyLevelNameWithMonery:model.goldCount] ];
    self.centerText.text = [NSString stringWithFormat:@"擅长：%@",model.speciality ];
    
    self.work.frame = CGRectMake(CGRectGetMaxX(self.name.frame) + Gato_Width_320_(85), Gato_Height_548_(16), Gato_Width_320_(100), CGRectGetHeight(self.name.frame));
    [self.work sizeToFit];
    
}
+ (CGFloat)getHetigh
{
    return Gato_Width_320_(160);
}

- (void)setValueWithTitle:(NSInteger )row
{
    
    
    
    if (row == 0) {
        self.name.text = @"刘丽丽";
        self.work.text = @"主任医师";
        self.ranking.image = [UIImage imageNamed:@"newtop1"];
        self.rankingName.image = [UIImage imageNamed:@"home_icon_title"];
    }else if (row == 1){
        self.name.text = @"刘美美";
        self.work.text = @"副主任医师";
        self.ranking.image = [UIImage imageNamed:@"newtop2"];
        self.rankingName.image = [UIImage imageNamed:@"home_icon_runner-up"];
    }else if (row == 2){
        self.name.text = @"刘诗诗";
        self.work.text = @"副主任医师";
        self.ranking.image = [UIImage imageNamed:@"newtop3"];
        self.rankingName.image = [UIImage imageNamed:@"home_icon_third-winner-in-contest"];
    }else{
        self.name.text = @"刘思托罗佛斯基";
        self.work.text = @"医师";
        self.ranking.image = [UIImage imageNamed:@""];
        self.rankingName.image = [UIImage imageNamed:@""];
    }
    self.hospital.text = @"黑龙江医大二院·白内障科";
    self.allPeople.text = @"患者量8425人";
    self.satisfaction.text = @"满意度：97%";
    self.level.text = @"蝴蝶等级：钻石";
    self.centerText.text = @"擅长：专治白内障，擅长高度近视、糖尿病、青光眼合并 白内障等复杂疾病的诊断和治。";
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
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width  , 1));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photo.sd_layout.leftSpaceToView(self,Gato_Width_320_(13))
    .topSpaceToView(self,Gato_Height_548_(16))
    .widthIs(Gato_Width_320_(55))
    .heightIs(Gato_Height_548_(55));
    
    GatoViewBorderRadius(self.photo, Gato_Height_548_(55 / 2), 0, [UIColor redColor]);
    
    self.name.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(12))
    .topEqualToView(self.photo)
    .heightIs(Gato_Height_548_(20));
    
    [self.name setSingleLineAutoResizeWithMaxWidth:100];
    
//    self.work.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
//    .centerYEqualToView(self.name)
//    .heightIs(Gato_Height_548_(8));
//    
//    [self.work setSingleLineAutoResizeWithMaxWidth:150];
    
    
    
    GatoViewBorderRadius(self.work, 3, 0, [UIColor redColor]);
    
    self.ranking.sd_layout.leftSpaceToView(self.work,Gato_Width_320_(10))
    .topEqualToView(self.photo)
    .widthIs(Gato_Width_320_(18))
    .heightIs(Gato_Height_548_(14));
    
    self.rankingName.sd_layout.rightSpaceToView(self,Gato_Width_320_(29))
    .topEqualToView(self.photo)
    .widthIs(Gato_Width_320_(37))
    .heightIs(Gato_Height_548_(18));
    
    UIImageView * jt = [[UIImageView alloc]init];
    jt.image = [UIImage imageNamed:@"more"];
    [self addSubview:jt];
    jt.sd_layout.leftSpaceToView(self.rankingName,Gato_Width_320_(10))
    .topEqualToView(self.rankingName)
    .bottomEqualToView(self.rankingName)
    .widthIs(Gato_Width_320_(7));
    
    
    self.hospital.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.name,10)
    .rightSpaceToView(self,Gato_Width_320_(10))
    .minHeightIs(Gato_Height_548_(20))
    .autoHeightRatio(0);
    
    self.allPeople.sd_layout.leftEqualToView(self.photo)
    .rightEqualToView(self.hospital)
    .topSpaceToView(self.photo,15)
    .heightRatioToView(self.name,1);
    
    self.satisfaction.sd_layout.leftEqualToView(self.photo)
    .rightEqualToView(self.hospital)
    .topSpaceToView(self.photo,15)
    .heightRatioToView(self.name,1);
    
    self.level.sd_layout.leftEqualToView(self.photo)
    .rightEqualToView(self.hospital)
    .topSpaceToView(self.photo,15)
    .heightRatioToView(self.name,1);
    
    self.centerText.sd_layout.leftEqualToView(self.allPeople)
    .rightEqualToView(self.allPeople)
    .topSpaceToView(self.allPeople,Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(40));
              
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)centerText
{
    if (!_centerText) {
        _centerText = [[UILabel alloc]init];
        _centerText.textColor = [UIColor HDBlackColor];
        _centerText.font = FONT(30);
        _centerText.numberOfLines = 2;
        [self addSubview:_centerText];
    }
    return _centerText;
}

-(UILabel *)satisfaction
{
    if (!_satisfaction) {
        _satisfaction = [[UILabel alloc]init];
        _satisfaction.textColor = [UIColor HDTitleRedColor];
        _satisfaction.font = FONT(30);
        _satisfaction.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_satisfaction];
    }
    return _satisfaction;
}
-(UILabel *)level
{
    if (!_level) {
        _level = [[UILabel alloc]init];
        _level.textColor = [UIColor HDTitleRedColor];
        _level.font = FONT(30);
        _level.textAlignment = NSTextAlignmentRight;
        [self addSubview:_level];
    }
    return _level;
}
-(UILabel *)allPeople
{
    if (!_allPeople) {
        UILabel *allPeople  =[[UILabel alloc]init];
        allPeople.textColor = [UIColor HDTitleRedColor];
        allPeople.font = FONT(30);
        [self addSubview:allPeople];
        
        _allPeople = allPeople;
    }
    return _allPeople;
}
-(UILabel *)hospital
{
    if (!_hospital) {
        _hospital = [[UILabel alloc]init];
        _hospital.textColor = [UIColor YMAppAllTitleColor];
        _hospital.font = FONT(30);
        _hospital.numberOfLines = 0;
        [self addSubview:_hospital];
    }
    return _hospital;
}

-(GatoWorkLabel *)work
{
    if (!_work) {
        _work = [[GatoWorkLabel alloc]init];
        _work.textColor = [UIColor whiteColor];
        _work.backgroundColor = [UIColor HDOrangeColor];
        _work.font = FONT(30);
        [self addSubview:_work];
    }
    return _work;
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.font = FONT_Bold_(32);
        [self addSubview:_name];
    }
    return _name;
}

-(UIImageView *)ranking
{
    if (!_ranking) {
        _ranking = [[UIImageView alloc]init];
        [self addSubview:_ranking];
    }
    return _ranking;
}
-(UIImageView *)rankingName
{
    if (!_rankingName) {
        _rankingName = [[UIImageView alloc]init];
        [self addSubview:_rankingName];
    }
    return _rankingName;
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.image = [UIImage imageNamed:@"default_Photo"];
        [self addSubview:_photo];
    }
    return _photo;
}



@end
