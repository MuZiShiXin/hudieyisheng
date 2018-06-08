//
//  TeamTextViewViewController.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/15.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseViewController.h"
#import "MyTeamModel.h"

typedef void(^updateTeamModel)(MyTeamModel * teamModel);
@interface TeamTextViewViewController : GatoBaseViewController
@property (nonatomic ,strong) updateTeamModel updateTeamModel;

@property (nonatomic ,strong) MyTeamModel * teamModel;

//从首页-组内信息-群组聊天进来的 这时候修改群公告因不能主动刷新环信聊天界面 所以保存成功后应该返回到列表页面  参数 1 返回到指定页面 否则 返回到上一页面
@property (nonatomic ,strong) NSString * HomeTeamCome;
@end
