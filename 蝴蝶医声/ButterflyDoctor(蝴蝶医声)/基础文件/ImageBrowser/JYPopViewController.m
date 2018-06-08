//
//  JYPopViewController.m
//  FilmBaiXiaoSheng
//
//  Created by XT on 16/9/7.
//  Copyright © 2016年 XT-Fyn-Lz-Jy. All rights reserved.
//

#import "JYPopViewController.h"

@interface JYPopViewController ()

@end

@implementation JYPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.userInteractionEnabled = YES;
    NSURL *imageURL =[NSURL URLWithString:[self.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"NoPictures.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
}

//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
//    
//    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"action1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"点击事件1");
//    }];
//    
//    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"action2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        NSLog(@"点击事件2");
//    }];
//    
//    // 当然事件多的话也能添加分组
////            UIPreviewActionGroup *group = [UIPreviewActionGroup actionGroupWithTitle:@"分组一" style:UIPreviewActionStyleDefault actions:@[action1, action2]];
////            return @[group];
//    return @[action1, action2];
//}

@end
