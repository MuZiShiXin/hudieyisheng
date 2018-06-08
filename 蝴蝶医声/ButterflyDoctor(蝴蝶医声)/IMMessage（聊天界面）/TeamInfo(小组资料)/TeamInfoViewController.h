//
//  TeamInfoViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "MyTeamModel.h"
@interface TeamInfoViewController : GatoBaseViewController

@property (nonatomic ,strong) NSString * groupId;
@property (nonatomic ,strong) MyTeamModel * teamModel;
@end
