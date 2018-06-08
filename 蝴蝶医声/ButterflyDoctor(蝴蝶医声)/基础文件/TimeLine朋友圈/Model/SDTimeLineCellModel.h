//
//  SDTimeLineCellModel.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <Foundation/Foundation.h>

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel;

@interface SDTimeLineCellModel : NSObject

@property (nonatomic, copy) NSString *iconName; //头像
@property (nonatomic, copy) NSString *name;//昵称
@property (nonatomic, copy) NSString *msgContent; //回复帖子内容
@property (nonatomic, strong) NSArray *picNamesArray;  //给空

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<SDTimeLineCellLikeItemModel *> *likeItemsArray; //给空
@property (nonatomic, strong) NSArray<SDTimeLineCellCommentItemModel *> *commentItemsArray; //对用son

@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;


@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pid;//评论id
@property (nonatomic, copy) NSString *liker;//评论点赞数
@property (nonatomic, copy) NSString *is_liker;//评论是否点赞
@property (nonatomic, copy) NSString *time;
@end


@interface SDTimeLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@end


@interface SDTimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString; //回复评论 - 内容

@property (nonatomic, copy) NSString *firstUserName; //回复评论 - 回复人昵称
@property (nonatomic, copy) NSString *firstUserId; //回复评论- 回复人id

@property (nonatomic, copy) NSString *secondUserName; //回复评论- 被回复人昵称
@property (nonatomic, copy) NSString *secondUserId; //回复评论-被回复人id
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *to_type;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *pid;//评论id


@end
