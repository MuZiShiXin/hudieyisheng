//
//  HomeInfoTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "HomeInfoTableViewCell.h"
#import "GatoBaseHelp.h"

@interface HomeInfoTableViewCell ()
@property (nonatomic ,strong) UIImageView * underImage;
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UILabel * name;//姓名
@property (nonatomic ,strong) UILabel * TheHospital;//所属医院
@property (nonatomic ,strong) UILabel * TheClass;// 科室
@property (nonatomic ,strong) UILabel * allPeople;//总患者
@property (nonatomic ,strong) UILabel * onepeople;//今日患者
@property (nonatomic ,strong) UILabel * work;//职称
@end
@implementation HomeInfoTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeInfoTableViewCell";
    HomeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeInfoTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(HomeInfoModel *)model
{
    if (model) {
        if (![model.isVerify isEqualToString:@"1"]) {
            UILabel * label = [[UILabel alloc]init];
//            label.text = @"账号审核中";
            label.font = FONT(30);
            label.textColor = [UIColor HDBlackColor];
            [self addSubview:label];
            label.sd_layout.leftSpaceToView(self.photo, 0)
            .rightSpaceToView(self, 0)
            .topEqualToView(self.name)
            .heightRatioToView(self.name, 1);
            
            label.textAlignment = NSTextAlignmentCenter;
        }
        [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"default_Photo"]];
        self.name.text = [NSString stringWithFormat:@"%@  %@",model.name,model.work];
        self.TheHospital.text = [NSString stringWithFormat:@"%@",model.hospital];
        self.TheClass.text = ModelNull(model.hospitalDepartment);
//        self.allPeople.text = [NSString stringWithFormat:@"患者总量：%@",model.patientAllCount];
//        self.onepeople.text = [NSString stringWithFormat:@"今日患者：%@",model.patientTodayCount];
//        self.work.text = model.work;
        
        [GatoMethods setLineSpaceWithString:self.TheHospital WithSpacing:3];
    }
}

+(CGFloat)getHeight
{
    return Gato_Height_548_(96);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.underImage.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,0)
    .heightIs(Gato_Height_548_(96));
    
    
    self.photo.sd_layout.leftSpaceToView(self.underImage,Gato_Width_320_(13))
    .topSpaceToView(self.underImage,Gato_Height_548_(12))
    .widthIs(Gato_Width_320_(74))
    .heightIs(Gato_Height_548_(74));
    
    GatoViewBorderRadius(self.photo, 5, 0.5, [UIColor appAllBackColor]);

    self.name.sd_layout.leftSpaceToView(self.photo,Gato_Width_320_(13))
    .topSpaceToView(self.underImage, Gato_Height_548_(18))
    .heightIs(Gato_Height_548_(24));
    
    [self.name setSingleLineAutoResizeWithMaxWidth:300];
    
    self.work.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
    .topSpaceToView(self.underImage, Gato_Height_548_(18))
    .heightIs(Gato_Height_548_(8));
    [self.work setSingleLineAutoResizeWithMaxWidth:100];
    
    GatoViewBorderRadius(self.work, 3, 0, [UIColor redColor]);
    
    self.TheHospital.sd_layout.leftEqualToView(self.name)
    .rightSpaceToView(self.underImage,Gato_Width_320_(15))
    .topSpaceToView(self.name,Gato_Height_548_(5))
    .autoHeightRatio(0);
    
    self.TheClass.sd_layout.leftEqualToView(self.name)
    .topSpaceToView(self.TheHospital, Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    [self.TheClass setSingleLineAutoResizeWithMaxWidth:Gato_Width_320_(200)];
    
    
    
    self.allPeople.sd_layout.leftEqualToView(self.name)
    .bottomEqualToView(self.photo)
    .widthIs(Gato_Width_320_(100))
    .heightRatioToView(self.name,1);
    
    self.onepeople.sd_layout.rightSpaceToView(self.underImage, Gato_Width_320_(15))
    .topEqualToView(self.allPeople)
    .widthIs(Gato_Width_320_(100))
    .heightRatioToView(self.allPeople,1);
    
    if (Gato_Mine_Info)
    {
        HomeInfoModel * model = [[HomeInfoModel alloc]init];
        [model setValuesForKeysWithDictionary:Gato_Mine_Info];
        [self setValueWithModel:model];
    }
}

-(UILabel *)work
{
    if (!_work) {
        _work = [[UILabel alloc]init];
        _work.textColor = [UIColor whiteColor];
        _work.backgroundColor = [UIColor HDOrangeColor];
        _work.font = FONT(30);
        [self addSubview:_work];
    }
    return _work;
}


-(UILabel *)allPeople
{
    if (!_allPeople) {
        _allPeople = [[UILabel alloc]init];
        _allPeople.textColor = [UIColor HDBlackColor];
        _allPeople.font = FONT(28);
        [self.underImage addSubview:_allPeople];
    }
    return _allPeople;
}

-(UILabel *)onepeople
{
    if (!_onepeople) {
        _onepeople = [[UILabel alloc]init];
        _onepeople.textColor = [UIColor HDBlackColor];
        _onepeople.font = FONT(28);
        _onepeople.textAlignment = NSTextAlignmentRight;
        [self.underImage addSubview:_onepeople];
    }
    return _onepeople;
}
-(UILabel *)TheClass
{
    if (!_TheClass) {
        _TheClass = [[UILabel alloc]init];
        _TheClass.textColor = [UIColor HDBlackColor];
        _TheClass.font = FONT(30);
        _TheClass.textAlignment = NSTextAlignmentLeft;
        [self.underImage addSubview:_TheClass];
    }
    return _TheClass;
}
-(UILabel *)TheHospital
{
    if (!_TheHospital) {
        _TheHospital = [[UILabel alloc]init];
        _TheHospital.textColor = [UIColor HDBlackColor];
        _TheHospital.font = FONT(30);
        _TheHospital.numberOfLines = 0;
        [self.underImage addSubview:_TheHospital];
    }
    return _TheHospital;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor HDBlackColor];
        _name.font = FONT_Bold_(32);
        [self.underImage addSubview:_name];
    }
    return _name;
}

-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        _photo.image = [UIImage imageNamed:@"default_Photo"];
        [self.underImage addSubview:_photo];
    }
    return _photo;
}
-(UIImageView *)underImage
{
    if (!_underImage) {
        _underImage = [[UIImageView alloc]init];
        _underImage.image = [UIImage imageNamed:@"home_bg"];
        [self addSubview:_underImage];
    }
    return _underImage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
