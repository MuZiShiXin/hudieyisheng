//
//  TeamImageView.h
//  ButterflyDoctorVoice
//
//  Created by 辛书亮 on 2017/5/11.
//  Copyright © 2017年 辛书亮. All rights reserved.
//

#import "GatoBaseView.h"
#import "TeamImageModel.h"

typedef void(^imageBlock)(TeamImageModel * model);
@interface TeamImageView : GatoBaseView
@property (nonatomic ,strong) imageBlock imageBlock;

-(void)setValueWithModel:(TeamImageModel * )model;
@end
