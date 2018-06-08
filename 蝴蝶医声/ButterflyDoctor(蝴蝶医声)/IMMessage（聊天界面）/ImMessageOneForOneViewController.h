//
//  ImMessageOneForOneViewController.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/9.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "EaseUI.h"
#import "HospitalizedPatientInfoModel.h"
#import "AfterDischargeModel.h"
#import "ImageMessageModel.h"
@interface ImMessageOneForOneViewController : EaseMessageViewController<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>
@property (nonatomic ,strong) HospitalizedPatientInfoModel * model;
@property (nonatomic ,strong) AfterDischargeModel * afterModel;
@property (nonatomic ,strong) ImageMessageModel * messageModel;



- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;
@end
