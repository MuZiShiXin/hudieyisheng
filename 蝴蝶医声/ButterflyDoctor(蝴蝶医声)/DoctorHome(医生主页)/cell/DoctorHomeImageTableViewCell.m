//
//  DoctorHomeImageTableViewCell.m
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/28.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "DoctorHomeImageTableViewCell.h"
#import "GatoBaseHelp.h"

@interface DoctorHomeImageTableViewCell ()
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * top;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * topName;
@property (nonatomic ,strong) UILabel * job;
@property (nonatomic ,strong) UILabel * Cname;
@end
@implementation DoctorHomeImageTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DoctorHomeImageTableViewCell";
    DoctorHomeImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // 从xib中加载cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DoctorHomeImageTableViewCell" owner:nil options:nil] lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setValueWithModel:(DoctorHomeInfoDataModel *)model
{
    if (model) {
        [self.photo sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"mine_bg_default-avatar"]];
        self.name.text = model.name;
        self.job.text = model.work;
        if ([model.paimingNumber isEqualToString:@"1"]) {
            self.top.image = [UIImage imageNamed:@"newtop1"];
            if ([model.paiming isEqualToString:@"1"]) {
                self.topName.text = @"周冠军";
            }else if ([model.paiming isEqualToString:@"2"]){
                self.topName.text = @"月冠军";
            }else if ([model.paiming isEqualToString:@"3"]){
                self.topName.text = @"年冠军";
            }else if ([model.paiming isEqualToString:@"0"]){
                self.topName.text = @"冠军";
            }else{
                self.topName.text = @"";
            }
        }else if ([model.paimingNumber isEqualToString:@"2"]){
            self.top.image = [UIImage imageNamed:@"newtop2"];
            if ([model.paiming isEqualToString:@"1"]) {
                self.topName.text = @"周亚军";
            }else if ([model.paiming isEqualToString:@"2"]){
                self.topName.text = @"月亚军";
            }else if ([model.paiming isEqualToString:@"3"]){
                self.topName.text = @"年亚军";
            }else if ([model.paiming isEqualToString:@"0"]){
                self.topName.text = @"亚军";
            }else{
                self.topName.text = @"";
            }
        }else if ([model.paimingNumber isEqualToString:@"3"]){
            self.top.image = [UIImage imageNamed:@"newtop3"];
            if ([model.paiming isEqualToString:@"1"]) {
                self.topName.text = @"周季军";
            }else if ([model.paiming isEqualToString:@"2"]){
                self.topName.text = @"月季军";
            }else if ([model.paiming isEqualToString:@"3"]){
                self.topName.text = @"年季军";
            }else if ([model.paiming isEqualToString:@"0"]){
                self.topName.text = @"季军";
            }else{
                self.topName.text = @"";
            }
        }else{
            self.top.image = [UIImage imageNamed:@""];
            
        }
        
        self.Cname.text = [NSString stringWithFormat:@"%@-%@",model.hospital,model.hospitalDepartment];
        
    }else{
//        [self.photo sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492494324273&di=4ba7cd03121ff030dabcf4a4553ecc6c&imgtype=0&src=http%3A%2F%2Fpic74.nipic.com%2Ffile%2F20150805%2F12033066_235333091000_2.jpg"] placeholderImage:[UIImage imageNamed:@""]];
//        self.name.text = @"刘诗诗";
//        self.job.text = @"副主任医师";
//        self.top.image = [UIImage imageNamed:@"newtop1"];
//        self.Cname.text = @"黑龙江医大二院·白内障科";
//        self.topName.text = @"周冠军";
    }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.photo.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self,Gato_Height_548_(22))
    .widthIs(Gato_Width_320_(80))
    .heightIs(Gato_Height_548_(80));
    
    GatoViewBorderRadius(self.photo, Gato_Width_320_(40), 0, [UIColor redColor]);
    
    self.top.sd_layout.leftSpaceToView(self,Gato_Width / 2 - Gato_Width_320_(28))
    .topSpaceToView(self.photo,Gato_Height_548_(10))
    .widthIs(Gato_Width_320_(18))
    .heightIs(Gato_Height_548_(14));
    
    self.topName.sd_layout.leftSpaceToView(self.top,Gato_Width_320_(5))
    .topEqualToView(self.top)
    .widthIs(Gato_Width / 2)
    .heightIs(Gato_Height_548_(14));
    
    
    self.Cname.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .bottomSpaceToView(self, Gato_Height_548_(5))
    .autoHeightRatio(0);
    
    
    self.name.sd_layout.leftSpaceToView(self,0)
    .rightSpaceToView(self,Gato_Width / 2 + Gato_Width_320_(10))
    .bottomSpaceToView(self.Cname, Gato_Height_548_(5))
    .heightIs(Gato_Height_548_(20));
    
    self.job.sd_layout.leftSpaceToView(self.name,Gato_Width_320_(10))
    .centerYEqualToView(self.name)
    .heightIs(Gato_Height_548_(8));
    
    [self.job setSingleLineAutoResizeWithMaxWidth:100];
    GatoViewBorderRadius(self.job, 3, 0, [UIColor redColor]);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)Cname
{
    if (!_Cname) {
        _Cname = [[UILabel alloc]init];
        _Cname.textColor = [UIColor HDBlackColor];
        _Cname.font = FONT(32);
        _Cname.textAlignment = NSTextAlignmentCenter;
        _Cname.numberOfLines = 0;
        [self addSubview:_Cname];
    }
    return _Cname;
}
-(UILabel *)topName
{
    if (!_topName) {
        _topName = [[UILabel alloc]init];
        _topName.textColor = [UIColor redColor];
        _topName.font = FONT(32);
        [self addSubview:_topName];
    }
    return _topName;
}
-(UILabel *)job
{
    if (!_job) {
        _job = [[UILabel alloc]init];
        _job.textColor = [UIColor whiteColor];
        _job.font = FONT(32);
        _job.backgroundColor = [UIColor HDTitleRedColor];
        [self addSubview:_job];
    }
    return _job;
}
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor HDBlackColor];
        _name.textAlignment = NSTextAlignmentRight;
        _name.font = FONT_Bold_(34);
        [self addSubview:_name];
    }
    return _name;
}
-(UIImageView *)top
{
    if (!_top) {
        _top = [[UIImageView alloc]init];
        [self addSubview:_top];
    }
    return _top;
}
-(UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc]init];
        [self addSubview:_photo];
    }
    return _photo;
}

@end
