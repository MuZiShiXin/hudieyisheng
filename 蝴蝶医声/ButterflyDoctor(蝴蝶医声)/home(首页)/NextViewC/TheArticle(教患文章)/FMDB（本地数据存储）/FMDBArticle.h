//
//  FMDBArticle.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "makeArticleModel.h"
@interface FMDBArticle : NSObject

//创建数据库
- (BOOL)createDataBaseWithName:(NSString *)name;
//创建表
- (BOOL)createTableWithDic:(NSArray *)arr;
//插入一个model
- (BOOL)insertWithModel:(makeArticleModel *)model;
//删除表
- (BOOL)deleteDataBase;
//删除一条记录
- (BOOL)deleteDataBaseWithModel:(makeArticleModel *)model;
//查询所有的
- (NSArray *)selectAllModels;
//查询一条记录
- (makeArticleModel *)selectDataWithId:(int)id;

//修改数据
- (BOOL)updateDataWithModel:(makeArticleModel *)model;

/** 修改数据 */
- (BOOL)modifyData:(makeArticleModel *)model;

@end
