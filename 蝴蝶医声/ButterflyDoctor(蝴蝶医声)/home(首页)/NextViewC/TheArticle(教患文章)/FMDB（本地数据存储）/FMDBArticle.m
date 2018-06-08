//
//  FMDBArticle.m
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/5.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "FMDBArticle.h"
#import "FMDB.h"

@interface FMDBArticle ()
{
    FMDatabase *dateBase;
}
@end
@implementation FMDBArticle

//创建数据库
- (BOOL)createDataBaseWithName:(NSString *)name{
    //创建数据库
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    dateBase = [FMDatabase databaseWithPath:[path stringByAppendingString:[NSString stringWithFormat:@"/%@",name]]];
    return [dateBase open];
}
//创建表
- (BOOL)createTableWithDic:(NSArray *)arr{
    NSMutableString *creat = [NSMutableString stringWithString:@"create table if not exists t_user(id integer primary key)"];
    for (NSString *per in arr) {
        if ([per isEqualToString:@"photoImageStrData"]) {
            [creat insertString:[NSString stringWithFormat:@",%@ blob", per] atIndex:creat.length-1];
        }else{
            [creat insertString:[NSString stringWithFormat:@",%@ varchar", per] atIndex:creat.length-1];
        }
        
    }
    return [dateBase executeUpdate:creat];
}
//插入一个model
- (BOOL)insertWithModel:(makeArticleModel *)model
{
    BOOL isBe = [self selectDataWithId:[model.indexPathRow intValue]];
    if (isBe) {
        NSLog(@"id 重复");
        return [self modifyData:model];
    } else {
//        NSString * insertSql = [NSString stringWithFormat:@"insert into t_user(title,indexPathRow,photoImage,type,photoImageStrData,PathComponentStr)  values('%@','%@','%@','%@','%@','%@') ;", model.title, model.indexPathRow, model.photoImage,model.type,model.photoImageStrData,model.PathComponentStr];
//        return [dateBase executeUpdate:insertSql];
        return [dateBase executeUpdate:@"insert into t_user(title,indexPathRow,photoImage,type,photoImageStrData,PathComponentStr)  values(?,?,?,?,?,?) ;",model.title, model.indexPathRow, model.photoImage,model.type,model.photoImageStrData,model.PathComponentStr];
    }

}
- (makeArticleModel *)selectDataWithId:(int)id{
    NSString * sql = [NSString stringWithFormat:@"select * from t_user where indexPathRow = '%d'",id];
    FMResultSet *result = [dateBase executeQuery:sql];
    makeArticleModel *model;
    if ([result next]) {
        model = [self selectDataWithResult:result];
    }
    return model;
}

//修改数据
- (BOOL)updateDataWithModel:(makeArticleModel *)model
{
    NSString *update = [NSString stringWithFormat:@"update t_user set title = '%@',indexPathRow = '%@',photoImage = '%@',type = '%@',photoImageStrData = '%@',PathComponentStr = '%@'", model.title, model.indexPathRow, model.photoImage,model.type,model.photoImageStrData,model.PathComponentStr];
//    return [dateBase executeUpdate:update];
    return [dateBase executeUpdate:@"update t_user set title = ?,indexPathRow = ?,photoImage = ?,type = ?,photoImageStrData = ?,,PathComponentStr = ?", model.title, model.indexPathRow, model.photoImage,model.type,model.photoImageStrData,model.PathComponentStr];
}
/** 根据id修改数据 */
- (BOOL)modifyData:(makeArticleModel *)model
{
    NSString *update = [NSString stringWithFormat:@"update t_user set title = '%@',indexPathRow = '%@',photoImage = '%@',type = '%@',photoImageStrData = '%@' ,PathComponentStr = '%@'WHERE indexPathRow = '%@'", model.title, model.indexPathRow, model.photoImage,model.type,model.photoImageStrData,model.PathComponentStr,model.indexPathRow];
//    return [dateBase executeUpdate:update];
    return [dateBase executeUpdate:@"update t_user set title = ?,indexPathRow = ?,photoImage = ?,type = ?,photoImageStrData = ?,photoImageStrData = ? WHERE indexPathRow = ?", model.title, model.indexPathRow, model.photoImage,model.type,model.photoImageStrData,model.PathComponentStr,model.indexPathRow];
}
//删除表
- (BOOL)deleteDataBase
{
    NSString * delete=@"delete from t_user";
    return [dateBase executeUpdate:delete];
}
//删除一条记录
- (BOOL)deleteDataBaseWithModel:(makeArticleModel *)model
{
    NSString * delete = [NSString stringWithFormat:@"delete from t_user where indexPathRow = '%d'",[model.indexPathRow intValue]];
    return [dateBase executeUpdate:delete];
}
//查询所有的
- (NSArray *)selectAllModels
{
    NSMutableArray *results = [NSMutableArray array];
    NSString * sql = @"select * from t_user";
    FMResultSet *result = [dateBase executeQuery:sql];
    while(result.next){
        makeArticleModel *model = [self selectDataWithResult:result];
        [results addObject:model];
    }
    return results;
}

- (makeArticleModel *)selectDataWithResult:(FMResultSet *)result{
    makeArticleModel *model = [[makeArticleModel alloc] init];
    NSString * indexPathRow = [result stringForColumn:@"indexPathRow"];
    NSString *title = [result stringForColumn:@"title"];
    NSData * imageData = [result dataForColumn:@"photoImageStrData"];
    NSString *type = [result stringForColumn:@"type"];
    NSString *PathComponentStr = [result stringForColumn:@"PathComponentStr"];
    
    model.title = title;
    model.indexPathRow = indexPathRow;
    model.photoImageStrData = imageData;
    model.type = type;
    model.PathComponentStr = PathComponentStr;
    
    return model;
}




@end
