//
//  TitleAndSelectModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface TitleAndSelectModel : GatoBaseModel
@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,strong) NSString * titleId;
@property (nonatomic ,assign) BOOL select;
@end
