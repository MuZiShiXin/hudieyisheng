//
//  MyAccountDetailInfoCell.h
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/4.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "XibBaseCell.h"

typedef void(^PushBlock)();
@interface MyAccountDetailInfoCell : XibBaseCell

@property (nonatomic ,strong) PushBlock PushBlock;

-(void)setValueWithShou:(NSString *)shou WithChu:(NSString *)chu;
@end
