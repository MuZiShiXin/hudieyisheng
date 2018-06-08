//
//  InfoDataPhotoTableViewCell.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDataPhotoTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setValueWithImage:(NSString *)imageStr WithTitle:(NSString *)titleStr;

-(void)setvalueWithPhoto:(UIImage *)photoImage;
-(void)setvalueWithPhotoUrl:(NSString *)photoImageUrl;
@end
