/**
 !! 随便弄了一下，只是为了 目前项目的使用.过几天会 完善
 !! 加入单例等
 
 有问题可以联系 邮箱 asiosldh@163.com
 QQ               872304636
 
 */




#import <UIKit/UIKit.h>


@interface PellTableViewSelect : UIView
/**
 *  创建一个弹出下拉控件
 *
 *  @param frame      尺寸
 *  @param selectData 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animate    是否动画弹出
 */
+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate;

/*
 frame:添加背景view的坐标
 selectData;选择控件的数据源
 action     点击回调方法
 animate    是否动画弹出
 imagename 背景图片
 button1 按钮1
 button1Frame 按钮1坐标
 button2 按钮2
 button2Frame 按钮2坐标
 label 文本
 labelFrame 文本坐标
 markimageView 图中图
 markimageViewFrame 图中图坐标
 */
+ (void)addPellViewSelectWithWindowFrame:(CGRect)frame
                              selectData:(NSArray *)selectData
                         backgroundImage:(UIImage *)imagename
                                 button1:(UIButton *)button1
                            button1Frame:(CGRect)button1Frame
                                 button2:(UIButton *)button2
                            button2Frame:(CGRect)button2Frame
                                   label:(UILabel *)label
                              labelFrame:(CGRect)labelFrame
                           markimageView:(UIImageView * )markimageView
                      markimageViewFrame:(CGRect)markimageViewFrame
                                  action:(void(^)(NSInteger index))action animated:(BOOL)animate;

/**
 *  创建一个弹出view
 *
 *  @param UIview      需要添加的view
 *  @param frame 选    添加view的坐标（存储在底层view的frame）
 *  @param viewFrame   底层view的坐标
 *  @param animate    是否动画弹出
 */
+ (void)addPellTableViewSelectWithwithView:(UIView *)UIview
                                WindowFrame:(CGRect)frame
                             WithViewFrame:(CGRect)viewFrame
                                selectData:(NSArray *)selectData
                                action:(void(^)(NSInteger index))action animated:(BOOL)animate;
//
+ (void)addPellTableViewSelectWithwithView:(UIView *)UIview
                               WindowFrame:(CGRect)frame
                             WithViewFrame:(CGRect)viewFrame
                                selectData:(NSArray *)selectData
                   WithBackgroundViewAlpha:(CGFloat)alpha
                                    action:(void(^)(NSInteger index))action animated:(BOOL)animate;

//设置界面提一次提示
+ (void)addPellViewSelectWithWindowFrame:(CGRect)frame
                              selectData:(NSArray *)selectData
                          withimageView1:(UIImageView * )imageView1
                     markimageViewFrame1:(CGRect)markimageViewFrame1
                          withImageView2:(UIImageView *)imageView2
                     markimageViewFrame2:(CGRect)markimageViewFrame2
                             withbutton1:(UIButton * )button1
                        withbuttonframe1:(CGRect)buttonframe1
                             withbutton2:(UIButton *)button2
                        withbuttonframe2:(CGRect)buttonframe2
                                  action:(void(^)(NSInteger index))action animated:(BOOL)animate;


/**
 *  手动隐藏
 */

/**
 *  YM选择区号专用
 *
 *  @param frame      尺寸
 *  @param selectData 选择控件的数据源
 *  @param action     点击回调方法
 *  @param animate    是否动画弹出
 */
+ (void)YMaddPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                    rightData:(NSArray *)rightData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate;

/**
 *  YM淘美街-全部项目-创建一个弹出view
 *
 *  @param UIview      需要添加的view
 *  @param frame 选    添加view的坐标（存储在底层view的frame）
 *  @param viewFrame   底层view的坐标
 *  @param animate    是否动画弹出
 *  @param clectButton 点击按钮
 */
+ (void)addPellTableViewSelectWithwithView:(UIView *)UIview
                               WindowFrame:(CGRect)frame
                             WithViewFrame:(CGRect)viewFrame
                                selectData:(NSArray *)selectData
                                WithButton:(UIButton *)clectButton
                                    action:(void(^)(NSInteger index))action animated:(BOOL)animate;


+ (void)hiden;
/**
 医患弹出页面
 */
+ (void)WindowFrame:(CGRect)frame WithViewFrame:(CGRect)viewFrame selectData:(NSArray *)selectData action:(void(^)(NSInteger index))action animated:(BOOL)animate;

@end
