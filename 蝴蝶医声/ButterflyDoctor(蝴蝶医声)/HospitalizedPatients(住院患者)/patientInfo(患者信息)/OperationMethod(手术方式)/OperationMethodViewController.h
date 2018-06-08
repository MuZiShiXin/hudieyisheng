//
//  OperationMethodViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"
@class OperationmethodModel;

typedef void(^titleBlock)(OperationmethodModel * model);

@interface OperationMethodViewController : GatoBaseViewController
@property (nonatomic ,strong) titleBlock titleBlock;


@end
