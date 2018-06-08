//
//  SQXXTableViewCell.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2018/6/2.
//  Copyright © 2018年 辛书亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^addImageBlock)();
typedef void(^deleteButton)(NSInteger row);
typedef void(^dicArrayBlock)(NSMutableArray * DicArray);
typedef void(^imageLookBlock)(UITapGestureRecognizer * tag);
@interface SQXXTableViewCell : UITableViewCell
@property (nonatomic ,strong) addImageBlock addImageBlock;
@property (nonatomic ,strong) deleteButton deleteButton;
@property (nonatomic ,strong) dicArrayBlock dicArrayBlock;
@property (nonatomic ,strong) imageLookBlock imageLookBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setvalueWithImageArray:(NSArray *)imageArray;
-(void)setvaleueBRAFArray:(NSArray*)BRAFArray;
@end
