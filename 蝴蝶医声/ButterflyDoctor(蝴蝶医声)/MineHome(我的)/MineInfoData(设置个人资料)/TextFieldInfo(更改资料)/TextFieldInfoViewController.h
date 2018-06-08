//
//  TextFieldInfoViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "MineInfoDataModel.h"
typedef void(^baocunBlock)(NSString * str);
@interface TextFieldInfoViewController : GatoBaseViewController

@property (nonatomic ,strong)baocunBlock baocunBlock;

@property (nonatomic ,strong) MineInfoDataModel * model;
@property (nonatomic ,strong) NSString * titleStr;
@property (nonatomic ,strong) NSString * textFieldText;//默认内容
@property (nonatomic ,assign) BOOL FieldOrView;//默认yes=field no = view
@end
