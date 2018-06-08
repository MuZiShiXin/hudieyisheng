//
//  MyAccountDetailHeaderView.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyAccountDetailHeaderView.h"

@interface MyAccountDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *headerText;

@end


@implementation MyAccountDetailHeaderView


- (void)setText:(NSString *)text {
    if (![text isEqualToString:_text]) {
        _text = text;
        self.headerText.text = text;
    }
}


@end
