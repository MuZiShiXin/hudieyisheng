//
//  AtOnePersonViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/6/12.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "MyTeamMemberModel.h"

typedef void(^ATInfoBlock)(MyTeamMemberModel * teamMemberModel);
@interface AtOnePersonViewController : GatoBaseViewController
@property (nonatomic ,strong) ATInfoBlock ATInfoBlock;
@property (nonatomic ,strong) NSArray * teamInfoArray;
@end
