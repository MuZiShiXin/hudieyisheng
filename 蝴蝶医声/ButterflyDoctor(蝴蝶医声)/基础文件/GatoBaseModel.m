//
//  GatoBaseModel.m
//  meiqi
//
//  Created by 辛书亮 on 2016/11/9.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "GatoBaseModel.h"
#import <objc/runtime.h>


@implementation GatoBaseModel
#pragma mark
+(instancetype)modelWithDic:(NSDictionary *)dic{
    id model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}


#pragma mark 没有字断
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}





#pragma mark 赋值
-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    
    if (![keyedValues.class isSubclassOfClass:[NSDictionary class]] || !keyedValues || keyedValues.count == 0) {
        return;
    }
    unsigned int useCount ,outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (const Ivar *p = ivars; p < ivars + outCount; p++) {
        Ivar const ivar = *p;
        //获取变量名
        NSString *varName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([varName.class isSubclassOfClass:[NSNull class]] || !varName) {
            return;
        }
        if ([varName isKindOfClass:[NSNull class]] || !varName) {
            return;
        }
        //获取变量值
        id varValue = [self valueForKey:varName];
        if ([[varValue class] isSubclassOfClass:[NSNull class]]) {
            return;
        }
        
        //如果是直接包含此名称的
        if ([keyedValues.allKeys containsObject:varName]) {
            varValue = [keyedValues objectForKey:varName];
            useCount++;
        }else{
            NSString *tmp_varName = [self removeFirstUnderlined:varName];
            if ([keyedValues.allKeys containsObject:tmp_varName]) {
                varValue = [keyedValues objectForKey:tmp_varName];
                useCount++;
            }
        }
        NSString *className = [NSString stringWithUTF8String:object_getClassName(varValue)];
        if ([className containsString:@"Number"]) {
            NSString *str = [NSString stringWithFormat:@"%.2f",[varValue floatValue]];
            varValue = [NSNumber numberWithFloat:[str floatValue]];
        }
        [self setValue:varValue forKey:varName];
    }
}



//两个辅助方法

/*
 *  移除掉第一个下划线
 */
-(NSString *)removeFirstUnderlined:(NSString *)str
{
    if ([[str substringToIndex:1] isEqual:@"_"]) {
        return [str substringFromIndex:1];
    }
    return str;
}

/*
 *  获取所有属性
 */
- (NSArray*)PRopertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}


#pragma mark 把所有属性置空
-(void)setValueWithNull{
    for (NSString *key in [self PRopertyKeys]) {
        [self setValue:nil forKey:key];
    }
}


//将Model转换为字典

/*
 *  转换为字典
 */
-(NSDictionary *)convertToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [self PRopertyKeys]) {
        id propertyValue = [self valueForKey:key];
        [dic setObject:propertyValue forKey:key];
    }
    
    return dic;
}

@end
