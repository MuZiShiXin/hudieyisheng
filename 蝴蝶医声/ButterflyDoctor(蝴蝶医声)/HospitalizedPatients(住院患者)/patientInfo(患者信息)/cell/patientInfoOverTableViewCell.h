//
//  patientInfoOverTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^addImageBlock)();
typedef void(^TSHBlock)();
typedef void(^zhenduanBlock)();
typedef void(^dianBlock)(NSInteger str);
typedef void(^deleteButton)(NSInteger row);
typedef void(^imageLookBlock)(UITapGestureRecognizer * tag);
typedef void(^ciyaozhenduanBlock)();

@interface patientInfoOverTableViewCell : UITableViewCell

@property (nonatomic ,strong) addImageBlock addImageBlock;
@property (nonatomic ,strong) TSHBlock TSHBlock;
@property (nonatomic ,strong) zhenduanBlock zhenduanBlock;
@property (nonatomic ,strong) dianBlock dianBlock;
@property (nonatomic ,strong) deleteButton deleteButton;
@property (nonatomic ,strong) imageLookBlock imageLookBlock;
@property (nonatomic ,strong) ciyaozhenduanBlock ciyaozhenduanBlock;
@property (nonatomic ,strong) NSString* selectStr;//分辨选择良性恶性字符串
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setvalueWithImageArray:(NSArray *)imageArray;
-(void)setValueWithTSHStr:(NSString * )tsh WithZhenduan:(NSString *)zhenduan WithCiyaozhenduan:(NSString *)ciyaozhenduan;

-(void)setvalueWithdian131Str:(NSArray *)dianArray;
@end
