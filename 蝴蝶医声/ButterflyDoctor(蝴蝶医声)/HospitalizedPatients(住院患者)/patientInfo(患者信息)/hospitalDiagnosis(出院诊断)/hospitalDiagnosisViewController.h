//
//  hospitalDiagnosisViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/25.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^titleArrayBlock)(NSArray * titleArray);
@interface hospitalDiagnosisViewController : GatoBaseViewController
@property (nonatomic ,strong)titleArrayBlock titleArrayBlock;

@property (nonatomic ,assign) NSInteger  oneForAll;//0 单选  1多选
@end
