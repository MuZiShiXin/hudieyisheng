//
//  AddStopMessageViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/19.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "releaseStopModel.h"
@interface AddStopMessageViewController : GatoBaseViewController

@property (nonatomic ,assign) BOOL Modify;//default NO  修改
@property (nonatomic ,strong) releaseStopModel * model;
@end
