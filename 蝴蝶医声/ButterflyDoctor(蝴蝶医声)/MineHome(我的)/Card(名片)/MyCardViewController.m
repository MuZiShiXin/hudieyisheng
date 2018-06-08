//
//  MyCardViewController.m
//  butterflyDoctor
//
//  Created by 丰华财经 on 2017/5/3.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "MyCardViewController.h"
#import "GatoBaseHelp.h"
#import "MyCardInfoCell.h"
#import "MyCardShareCell.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "MyCardModel.h"

static NSString* const UMS_THUMB_IMAGE = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496457088&di=2e245b0d4d6a892a4bfb0264623eebaf&imgtype=jpg&er=1&src=http%3A%2F%2Fpic3.16pic.com%2F00%2F46%2F60%2F16pic_4660163_b.jpg";
static NSString* const UMS_WebLink = @"http://www.net5008.com";


@interface MyCardViewController ()<UMSocialShareMenuViewDelegate>
{
    UIImageView * photoImage;
    CGFloat ImageCellHeigth;
}
@property (nonatomic ,strong) MyCardModel * model;
@property (nonatomic ,strong) NSString * UM_Url;
@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Gato_Return
    self.title = @"我的名片";
    self.GatoTableview.height = Gato_Height - NAV_BAR_HEIGHT;
    self.cells = @[[MyCardInfoCell getCellID], [MyCardShareCell getCellID]];
    [self registCells];
    
    [self.view addSubview:self.GatoTableview];
    [self update];
}

-(void)update
{
    self.updateParms = [NSMutableDictionary dictionary];
    [self.updateParms setObject:self.doctorId forKey:@"doctorId"];
    self.model = [[MyCardModel alloc]init];
    [IWHttpTool postWithURL:HD_chat_Team_Card params:self.updateParms success:^(id json) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        NSString * success = [dic objectForKey:@"code"];
        if ([success isEqualToString:@"200"]) {
            [self.model setValuesForKeysWithDictionary:[[dic objectForKey:@"data"] objectForKey:@"info"]];
            self->photoImage = [[UIImageView alloc]init];
            [self->photoImage sd_setImageWithURL:[NSURL URLWithString:self.model.photo] placeholderImage:nil];
            [self.view addSubview:self->photoImage];
            self->photoImage.sd_layout.leftSpaceToView(self.view, 0)
            .topSpaceToView(self.view, 0)
            .widthIs(0)
            .heightIs(0);
        }else{
            NSString * falseMessage = [dic objectForKey:@"message"];
            [self showHint:falseMessage];
        }
        [self.GatoTableview reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;

    if (indexPath.row == 0) {
        MyCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyCardInfoCell getCellID]];
        [cell setValueWithModel:self.model];
        ImageCellHeigth = cell.height;
        return cell;
    } else if (indexPath.row == 1) {
        MyCardShareCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyCardShareCell getCellID]];
        [cell setValues];
        cell.UMSBlock = ^(NSInteger row){
            [weakSelf UMSocialPushWithType:row];
        };
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return ImageCellHeigth;
    } else if (indexPath.row == 1) {
        return [MyCardShareCell getHeightForCell];
    }
    
    
    return 0.0f;
}

-(void)UMSocialPushWithType:(NSInteger )row
{
    NSInteger  UMSocialType = 0;
    switch (row) {
        case 0:
            UMSocialType = UMSocialPlatformType_WechatTimeLine;
            break;
        case 1:
            UMSocialType = UMSocialPlatformType_WechatSession;
            break;
        case 2:
            UMSocialType = UMSocialPlatformType_Sina;
            break;
        case 3:
            UMSocialType = UMSocialPlatformType_QQ;
            break;
        case 4:
            UMSocialType = UMSocialPlatformType_Qzone;
            break;
            
        default:
            
            break;
    }
    
    
    
    
    [self shareWebPageToPlatformType:UMSocialType];
    
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
//    NSString* thumbURL =  self.model.photo;
    NSString * thumbURL = UMS_THUMB_IMAGE;
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.name descr:[NSString stringWithFormat:@"%@-%@-%@",self.model.hospital,self.model.hospitalDepartment,self.model.work] thumImage:photoImage.image];
    
    NSLog(@"PhotoUrl  %@   Image %@",self.model.photo , photoImage.image);
    //设置网页地址
    self.UM_Url = [NSString stringWithFormat:@"http://api.hudieyisheng.com/web/share?doctorId=%@",TOKEN];
    shareObject.webpageUrl = self.UM_Url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        NSString *result = nil;
        if (!error) {
            result = [NSString stringWithFormat:@"Share succeed"];
        }
        else{
            NSMutableString *str = [NSMutableString string];
            if (error.userInfo) {
                for (NSString *key in error.userInfo) {
                    [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
                }
            }
            if (error) {
                result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            }
            else{
                result = [NSString stringWithFormat:@"Share fail"];
            }
        }
        
        [GatoMethods AleartViewWithMessage:result];
        
    }];
}


@end
