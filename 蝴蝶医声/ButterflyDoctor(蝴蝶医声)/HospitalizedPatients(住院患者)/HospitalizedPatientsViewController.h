//
//  HospitalizedPatientsViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/22.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

@interface HospitalizedPatientsViewController : GatoBaseViewController

@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UIImageView * photo;
@property (nonatomic ,strong) UIImageView * sex;
@property (nonatomic ,strong) UIImageView * jiantou;
@property (nonatomic ,strong) UILabel * name;
@property (nonatomic ,strong) UILabel * age;
@property (nonatomic ,strong) UILabel * chuanghao;
@property (nonatomic ,strong) UILabel * binganhao;
@property (nonatomic ,strong) UILabel * ruyuanshijian;
@property (nonatomic ,strong) UILabel * ruyuanzhenduan;
@property (nonatomic ,strong) UIButton * yihuangoutong;
@property (nonatomic ,strong) UIButton * chuyuan;
@property (nonatomic ,strong) UIButton * dengdaibingli;
@property (nonatomic ,strong) UIButton * pushButton;
@property (nonatomic ,strong) UIButton * myHZButton;//我的患者 按钮


-(void)mobanButton;

-(void)searchButton;

@end
