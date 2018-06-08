//
//  chooseBankViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

@class ChooseBankSonModel;

typedef void(^bankName)(ChooseBankSonModel * model);
@interface chooseBankViewController : GatoBaseViewController

@property (nonatomic ,strong) bankName bankName;
@property (nonatomic ,strong)NSString * cityname;
@end
