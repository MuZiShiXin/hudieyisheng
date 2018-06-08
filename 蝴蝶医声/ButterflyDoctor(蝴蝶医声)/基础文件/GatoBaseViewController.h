//
//  GatoBaseViewController.h
//  meiqi
//
//  Created by 辛书亮 on 2016/10/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GatoBaseViewController : UIViewController
@property (nonatomic,strong)UITableView * GatoTableview;//基础tableveiw文件
@property (nonatomic ,strong) NSMutableArray * updataArray;
@property (nonatomic ,strong) NSMutableDictionary * updateParms;
@property (nonatomic ,assign) BOOL firstBool;//标记首次进入页面 默认 yes
@property (nonatomic, strong) NSArray *cells;
#pragma mark 注册cell
- (void)registCells;

@end
