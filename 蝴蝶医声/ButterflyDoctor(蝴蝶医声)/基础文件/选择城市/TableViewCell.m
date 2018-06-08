//
//  TableViewCell.m
//  TFSearchBar
//
//  Created by TF_man on 16/5/19.
//  Copyright © 2016年 TF_man. All rights reserved.
//
//屏幕宽和高
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define RGBA1(r, g, b, a)                    [UIColor colorWithRed:r green:g blue:b alpha:a]
#import "TableViewCell.h"

@implementation TableViewCell

- (void)setCellArr:(NSArray *)cellArr{
    
    _cellArr = cellArr;
    CGFloat w = (kScreenWidth-30)/3;
    for (int i = 0; i < cellArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+i%3*w, 15+i/3*45, w-15, 30);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:cellArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.layer.cornerRadius = 2.0;
        btn.layer.borderColor = RGBA1(0.6, 0.6, 0.6, 1).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_sections == 0)
        {
            [btn setImage:[UIImage imageNamed:@"a26"] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        }
        
        [self addSubview:btn];
    }
    
}

//检测是何种原因导致定位失败
//- (void)locationManager: (CLLocationManager *)manager
//       didFailWithError: (NSError *)error {
//    
//    NSString *errorString;
//    [manager stopUpdatingLocation];
//    NSLog(@"Error: %@",[error localizedDescription]);
//    switch([error code]) {
//        case kCLErrorDenied:
//            //Access denied by user
//            errorString = @"Access to Location Services denied by user";
//            //Do something...
//            [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"请打开该app的位置服务!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//            break;
//        case kCLErrorLocationUnknown:
//            //Probably temporary...
//            errorString = @"Location data unavailable";
//            [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"位置服务不可用!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//            //Do something else...
//            break;
//        default:
//            errorString = @"An unknown error has occurred";
//            [[[UIAlertView alloc] initWithTitle:@"提示：" message:@"定位发生错误!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
//            break;
//    }
//}

- (void)btnClick:(UIButton *)btn{
    
//    NSLog(@"btnClick---%@",btn.titleLabel.text);
    [self.delegate TableViewSelectorIndix:btn.titleLabel.text];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSections:(NSInteger)sections
{
    _sections = sections;
}

@end
