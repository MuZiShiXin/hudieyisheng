//
//  addnewteamViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/21.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseViewController.h"

typedef void(^returnUpdateHttp)();
@interface addnewteamViewController : GatoBaseViewController
@property (nonatomic ,strong) returnUpdateHttp returnUpdateHttp;
@end
