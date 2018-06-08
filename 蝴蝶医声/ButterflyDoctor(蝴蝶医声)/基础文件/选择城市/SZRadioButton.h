//
//  EIRadioButton.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZRadioButtonDelegate;

@interface SZRadioButton : UIButton {
    NSString                        *_groupId;
    BOOL                            _checked;

}

@property(nonatomic, assign)id<SZRadioButtonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic,strong) NSString *type;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol SZRadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(SZRadioButton *)radio groupId:(NSString *)groupId;

@end
