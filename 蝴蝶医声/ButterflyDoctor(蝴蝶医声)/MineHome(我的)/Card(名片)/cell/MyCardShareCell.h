//
//  MyCardShareCell.h
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "XibBaseCell.h"


typedef void(^UMSBlock)(NSInteger row);
@interface MyCardShareCell : XibBaseCell
@property (nonatomic ,strong) UMSBlock UMSBlock;

- (void)setValues;

@end
