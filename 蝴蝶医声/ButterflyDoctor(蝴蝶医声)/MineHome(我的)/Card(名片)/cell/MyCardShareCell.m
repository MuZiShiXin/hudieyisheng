//
//  MyCardShareCell.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyCardShareCell.h"
#import "MyCardShareView.h"

@implementation MyCardShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setValues {
    __weak typeof(self) weakSelf = self;
    NSArray *texts = @[@"朋友圈", @"微信好友", @"新浪微博", @"QQ好友", @"QQ空间"];
    NSArray * imageS = @[@"mine_logo_Circle-of-Friends",@"mine_logo_WeChat",@"mine_logo_microblog",@"mine_logo_QQ",@"mine_logo_Qzone"];
    for (int i = 0; i < 5; i++) {
        MyCardShareView *view = [self viewWithTag:100+i];
        view.UMBlock = ^(){
            if (weakSelf.UMSBlock) {
                weakSelf.UMSBlock(i);
            }
        };
        [view setValueWithImg:imageS[i] withText:texts[i]];
    }
}

+ (CGFloat)getHeightForCell {
    return 194.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
