//
//  TitleButtonView.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseView.h"
typedef enum : NSUInteger {
    enum_all,
    enum_checking,
    enum_unfinished,
    enum_finished,
    enum_refund,
    enum_other,
} ENUM_BTN_TYPE;

@protocol TitleButtonViewDelegate <NSObject>

- (void)headerBtnClicked:(ENUM_BTN_TYPE)type;

@end


@interface TitleButtonView : GatoBaseView

@property (nonatomic, weak) id<TitleButtonViewDelegate> delegate;
+ (TitleButtonView *)instanceTextView;

-(void)setTitleWithArray:(NSArray *)titleArray;

//主动点击按钮
- (void)buttonType:(NSInteger )type;
@end
