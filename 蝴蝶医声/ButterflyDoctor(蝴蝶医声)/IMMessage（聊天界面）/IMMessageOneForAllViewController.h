//
//  IMMessageOneForAllViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "EaseUI.h"
#import "MyTeamModel.h"

@interface IMMessageOneForAllViewController : EaseMessageViewController<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>
@property (nonatomic ,strong) NSString * groupId;

@property (nonatomic ,strong) MyTeamModel * teamModel;
@end
