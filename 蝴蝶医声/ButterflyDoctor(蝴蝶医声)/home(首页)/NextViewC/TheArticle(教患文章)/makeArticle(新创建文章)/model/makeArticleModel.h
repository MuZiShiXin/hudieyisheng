//
//  makeArticleModel.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/7/4.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseModel.h"

@interface makeArticleModel : GatoBaseModel

@property (nonatomic ,strong)NSString * title;
@property (nonatomic ,strong)NSString * indexPathRow;
@property (nonatomic ,strong)UIImage * photoImage;
@property (nonatomic ,strong)NSData * photoImageStrData;//照片data
@property (nonatomic ,strong)NSString * type;//0小标题  1内容  2照片+文字

@property (nonatomic ,strong)NSString * PathComponentStr;//图片路径
@end
