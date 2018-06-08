//
//  IMMessageOneMp3DataViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/3/2.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "GatoBaseView.h"
typedef void(^playerBlock)();
typedef void(^hiddenBlock)();
typedef void(^sendBlock)();
@interface IMMessageOneMp3DataViewController : GatoBaseView
@property(nonatomic ,strong) playerBlock playerBlock;
@property(nonatomic ,strong) hiddenBlock hiddenBlock;
@property(nonatomic ,strong) sendBlock sendBlock;
@property(nonatomic ,strong) UIView * underView;
@property(nonatomic ,strong) UIButton * playerButton;
@property(nonatomic ,strong) UIButton * returnButton;
@property(nonatomic ,strong) UIButton * sendButton;

- (void)addAllView;
@end
