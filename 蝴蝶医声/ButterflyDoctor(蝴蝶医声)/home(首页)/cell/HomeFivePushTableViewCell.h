//
//  HomeFivePushTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/18.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FiveButtonBlock)(NSInteger row);
@interface HomeFivePushTableViewCell : UITableViewCell
@property (nonatomic ,strong) FiveButtonBlock FiveButtonBlock;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)getHetigh;

-(void)teamMessageNumberWithCount:(NSString *)messageNumber;

@end
