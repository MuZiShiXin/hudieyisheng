//
//  IMMessageOneMp3DataViewController.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/3/2.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import "IMMessageOneMp3DataViewController.h"
#import "UIButton+AICategory.h"
@interface IMMessageOneMp3DataViewController ()

@end

@implementation IMMessageOneMp3DataViewController

-(void)addAllView
{
    self.underView = [[UIView alloc]init];
    self.underView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.underView];
    self.underView.sd_layout.leftSpaceToView(self, Gato_Width_320_(35))
    .rightSpaceToView(self, Gato_Width_320_(35))
    .centerYEqualToView(self)
    .heightIs(120);
    GatoViewBorderRadius(self.underView, 5, 0, [UIColor appAllBackColor]);
    
    self.playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playerButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self.playerButton setTitle:@"试听" forState:UIControlStateNormal];
    [self.playerButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.playerButton.titleLabel.font = FONT(36);
    [self.playerButton addTarget:self action:@selector(playerButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.underView addSubview:self.playerButton];
    self.playerButton.sd_layout.leftSpaceToView(self.underView, 0)
    .topSpaceToView(self.underView, Gato_Height_548_(20))
    .widthIs(Gato_Width_320_(250) / 3)
    .bottomSpaceToView(self.underView, 0);
    [self.playerButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:70];
    
    self.returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnButton setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [self.returnButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.returnButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.returnButton.titleLabel.font = FONT(36);
    [self.returnButton addTarget:self action:@selector(returnButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.underView addSubview:self.returnButton];
    self.returnButton.sd_layout.leftSpaceToView(self.underView, Gato_Width_320_(250) / 3)
    .topSpaceToView(self.underView, Gato_Height_548_(20))
    .widthIs(Gato_Width_320_(250) / 3)
    .bottomSpaceToView(self.underView, 0);
    [self.returnButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:70];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor HDThemeColor] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = FONT(36);
    [self.sendButton addTarget:self action:@selector(sendButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.underView addSubview:self.sendButton];
    self.sendButton.sd_layout.leftSpaceToView(self.underView, Gato_Width_320_(250) / 3 * 2)
    .topSpaceToView(self.underView, Gato_Height_548_(20))
    .widthIs(Gato_Width_320_(250) / 3)
    .bottomSpaceToView(self.underView, 0);
    [self.sendButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:70];
}

- (void)playerButtonDidClicked
{
    if (self.playerBlock) {
        self.playerBlock();
    }
}
- (void)returnButtonDidClicked
{
    if (self.hiddenBlock) {
        self.hiddenBlock();
    }
}
- (void)sendButtonDidClicked
{
    if (self.sendBlock) {
        self.sendBlock();
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
