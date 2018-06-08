//
//  patientInfoSurgeryMessageTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientInfoNoteModel.h"

typedef void(^addImageBlock)();
typedef void(^MoerButton)();
typedef void(^dicArrayBlock)(NSMutableArray * DicArray);
typedef void(^deleteButton)(NSInteger row);
typedef void(^imageLookBlock)(UITapGestureRecognizer * tag);
typedef void(^selectSegmented)(NSString* str);
typedef void(^libajiezhuanyiBlock)();
@interface patientInfoSurgeryMessageTableViewCell : UITableViewCell
@property (nonatomic ,strong) addImageBlock addImageBlock;
@property (nonatomic ,strong) MoerButton MoerButton;
@property (nonatomic ,strong) dicArrayBlock dicArrayBlock;
@property (nonatomic ,strong) deleteButton deleteButton;
@property (nonatomic ,strong) imageLookBlock imageLookBlock;
@property (nonatomic ,strong) NSString* selectStr;//分辨选择良性恶性字符串
@property (nonatomic ,strong) selectSegmented selectSegmented;
@property (nonatomic ,strong) libajiezhuanyiBlock linbajiezhuanyiBlock;//淋巴结转移Block


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setvalueWithImageArray:(NSArray *)imageArray;
-(void)setvalueWithMoryButtonStr:(NSString *)str;

-(void)setValueWithinfoArray:(NSArray *)infoArray;

-(void)setValueWithModel:(patientInfoNoteModel *)model;
@end
