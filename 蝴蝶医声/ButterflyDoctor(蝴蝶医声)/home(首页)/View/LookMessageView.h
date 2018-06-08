//
//  LookMessageView.h
//  TIMChat
//
//  Created by 辛书亮 on 2017/12/23.
//  Copyright © 2017年 AlexiChen. All rights reserved.
//

#import "GatoBaseView.h"
//#import "MineMessageListModel.h"

typedef void(^okButtonBlock)();
@interface LookMessageView : GatoBaseView
@property (nonatomic ,strong) okButtonBlock okButtonBlock;
@property (nonatomic ,strong) UIView * underView;
@property (nonatomic ,strong) UILabel * titleNumber;
@property (nonatomic ,strong) UILabel * contentLabel;
@property (nonatomic ,strong) UIButton * okButton;
@property (nonatomic ,strong) UIButton * returnButton;
- (void)setViewWithTitle:(NSString *)title WithTime:(NSString * )time;
//- (void)setValueWithModel:(MineMessageListModel *)model;

- (void)setValueWithNumber:(NSString *)number WithContent:(NSString * )content;
@end
