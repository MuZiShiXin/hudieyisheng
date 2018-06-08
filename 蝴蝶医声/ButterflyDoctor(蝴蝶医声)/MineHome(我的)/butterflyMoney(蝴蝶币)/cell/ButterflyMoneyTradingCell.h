//
//  ButterflyMoneyTradingCell.h
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "XibBaseCell.h"
#import "ButterflyMoneryBeforeModel.h"
#import "withdrawaInfoModel.h"
@interface ButterflyMoneyTradingCell : XibBaseCell

//蝴蝶币获得cell
-(void)setValueWithModel:(ButterflyMoneryBeforeModel * )model;
//提现记录cell
-(void)setValueWithDataModel:(withdrawaInfoModel * )model;
@end
