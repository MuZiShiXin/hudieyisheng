//
//  patientInfoNoteModel.h
//  butterflyDoctor
//
//  Created by 辛书亮 on 2017/4/24.
//  Copyright © 2017年 孟小猫. All rights reserved.
//

#import "GatoBaseModel.h"

@interface patientInfoNoteModel : GatoBaseModel


@property (nonatomic ,copy) NSString * UserCaseId;//1; 患者病历id
@property (nonatomic ,copy) NSString * age;//45; 病患年龄
@property (nonatomic ,copy) NSString * bedNumber;//26; 病床号
@property (nonatomic ,copy) NSString * bedTime;//"2017\U5e745\U670811\U65e5"; 入院时间
@property (nonatomic ,copy) NSString * caseNo;//""; 病例号
@property (nonatomic ,copy) NSString * diagnose;//0; 入院诊断
@property (nonatomic ,copy) NSString * lDiagnose;//""; 出院诊断
@property (nonatomic ,strong) NSArray * lImg;//    ( 出院图片
@property (nonatomic ,copy) NSString * lRadioactiveIodine;//""; 碘131治疗
@property (nonatomic ,copy) NSString * lTshNoS;//"";未手术TSH
@property (nonatomic ,copy) NSString * lTshS;//"";手术TSH
@property (nonatomic ,copy) NSString * labor;//0;分娩
@property (nonatomic ,copy) NSString * morbidity;//1;亲属甲状腺病发史
@property (nonatomic ,copy) NSString * name;//"\U738b\U6bc51"; 姓名
@property (nonatomic ,copy) NSString * photo;//"http://192.168.10.99/img/defaultPhoto.jpg"; 头像
@property (nonatomic ,copy) NSString * pushId;//"";文章消息推送id
@property (nonatomic ,copy) NSString * rad;//1;放射性检查史
@property (nonatomic ,copy) NSString * remark;//"";备注
@property (nonatomic ,strong) NSArray * sImg;// = 术中图片
@property (nonatomic ,copy) NSString * sMultiFoci;//""; 多发病灶
@property (nonatomic ,copy) NSString * sThyroid;//"";腺外侵及
@property (nonatomic ,copy) NSString * sTumourLocation;//""; 肿瘤位置
@property (nonatomic ,copy) NSString * sTunica;//"";被膜侵及
@property (nonatomic ,copy) NSString * sWay;//"";手术方式
@property (nonatomic ,copy) NSString * sex;//"\U7537";性别
@property (nonatomic ,copy) NSString * bmi;//体重

@property (nonatomic ,copy) NSString * secondarylDiagnose;//次要诊断
@property (nonatomic ,copy) NSString * tshTopInt;
@property (nonatomic ,copy) NSString * tshUnderInt;
@end
