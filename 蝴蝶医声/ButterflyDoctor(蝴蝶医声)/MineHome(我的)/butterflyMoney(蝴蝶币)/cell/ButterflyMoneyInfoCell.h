//
//  ButterflyMoneyInfoCell.h
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "XibBaseCell.h"


typedef void(^tixianBlock)();
@interface ButterflyMoneyInfoCell : XibBaseCell
@property (nonatomic ,strong) tixianBlock tixianBlock;

-(void)setvalueWithMonery:(NSString *)string;
@end
