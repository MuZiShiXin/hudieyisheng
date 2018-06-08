//
//  GatoURL.h
//  tongxinbao
//
//  Created by 辛书亮 on 2016/12/15.
//  Copyright © 2016年 辛书亮. All rights reserved.
//

#ifndef GatoURL_h
#define GatoURL_h


//美如那年URL
//#define HTTP @"http://192.168.10.99/v1/"// 本地测试ip
#define HTTP @"http://api.hudieyisheng.com/v1/" // 网络数据
//#define HTTP_WEB @"http://192.168.10.99/"// 本地测试ip
#define HTTP_WEB @"http://api.hudieyisheng.com/" // 网络数据



#define HD_ZNXX  [HTTP stringByAppendingString:@"common/message"]   // 站内消息-列表
#define HD_ZNXX_Remove  [HTTP stringByAppendingString:@"common/message-delete"]   // 站内消息-删除消息
#define HD_ZNXX_read_All  [HTTP stringByAppendingString:@"common/message-all"]   // 一键阅读
#define HD_ZNXX_read_One  [HTTP stringByAppendingString:@"common/message-read"]   // 阅读消息

#define HD_NewApp  [HTTP stringByAppendingString:@"common/get-new-version"]   //获取新版本
#define HD_NewApp_Down  [HTTP stringByAppendingString:@"common/get-active"]   //活跃度上传
#define HD_Home_Welcome  [HTTP stringByAppendingString:@"banner/get-welcome"]   //获取欢迎页面一张医生图片

#define HD_AllTeam  [HTTP stringByAppendingString:@"common/get-doctor-team"]   //  获取医疗组-全部
#define HD_AllTeam_add  [HTTP stringByAppendingString:@"doctor/apply-for-team"]   //  加入指定医疗组
#define HD_Send_Message  [HTTP stringByAppendingString:@"home/send-message"]   //  发送微信公众平台信息
#define HD_Create_history  [HTTP stringByAppendingString:@"home/create-history"]   // 存储聊天记录

#define HD_ZhuCe  [HTTP stringByAppendingString:@"doctor/register"]   // 注册
#define HD_ZhuCe_CODE  [HTTP stringByAppendingString:@"code/register"]   // 注册-获取验证码
#define HD_ZhuCe_CODE_CHECK  [HTTP stringByAppendingString:@"code/check-code"]   // 注册-验证验证码
#define HD_ZhuCe_Doctor  [HTTP stringByAppendingString:@"common/get-hospital"]   // 注册-获取医院列表
#define HD_ZhuCe_Department  [HTTP stringByAppendingString:@"common/get-hospital-department"]   // 注册-获取科室
#define HD_ZhuCe_Work  [HTTP stringByAppendingString:@"common/get-work"]   // 注册-获取职位
#define HD_Denglu  [HTTP stringByAppendingString:@"doctor/login"]   // 登录
#define HD_NewPassword [HTTP stringByAppendingString:@"doctor/reset-password"]   // 修改密码／重置密码
#define HD_NewPassword_Code [HTTP stringByAppendingString:@"code/reset-password"]   // 修改密码／重置密码-验证码
#define HD_Home_Remove_ImageMessage [HTTP stringByAppendingString:@"home/clear-no-read"]   // 清空未读消息


#define HD_Mine_Info  [HTTP stringByAppendingString:@"doctor/person"]   // 我的-信息
#define HD_Mine_Info_data  [HTTP stringByAppendingString:@"doctor/person-view"]   // 我的-个人资料
#define HD_Mine_Info_data_UPdate  [HTTP stringByAppendingString:@"doctor/person-update"]   // 我的-个人资料-更新个人资料
#define HD_Mine_Other_PayPassword  [HTTP stringByAppendingString:@"doctor/set-safe-password"]   // 我的-设置-设置隐私密码
#define HD_Mine_Other_PayPassword_VA  [HTTP stringByAppendingString:@"common/check-safe-password"]   // 验证隐私密码
#define HD_Mine_Card  [HTTP stringByAppendingString:@"doctor/my-card"]   // 我的-我的名片
#define HD_Mine_AddTeamPlease  [HTTP stringByAppendingString:@"doctor/my-team-verify"]   // 我的-加组申请审核
#define HD_Mine_AddTeamPlease_reply  [HTTP stringByAppendingString:@"doctor/my-team-verify-check"]   // 我的-加组申请审核-答复
#define HD_Mine_Level  [HTTP stringByAppendingString:@"doctor/my-gold-level"]   // 我的-蝴蝶等级
#define HD_Mine_Bank_All  [HTTP stringByAppendingString:@"common/get-bank"]   // 我的 银行卡-银行列表
#define HD_Mine_Bank  [HTTP stringByAppendingString:@"doctor/my-account-card"]   // 我的 银行卡-
#define HD_Mine_Bank_ADD  [HTTP stringByAppendingString:@"doctor/my-account-card-add"]   // 我的 银行卡-添加银行卡
#define HD_Mine_Bank_update  [HTTP stringByAppendingString:@"doctor/my-account-card-update"]   // 我的 银行卡-修改银行卡
#define HD_Mine_ButterflyB_Before [HTTP stringByAppendingString:@"doctor/my-gold"]   // 我的 蝴蝶币-历史记录
#define HD_Mine_withdrawal [HTTP stringByAppendingString:@"doctor/my-gold-extract"]   // 我的 蝴蝶币-提现按钮
#define HD_Mine_withdrawal_info [HTTP stringByAppendingString:@"doctor/my-gold-view"]   // 我的 蝴蝶币-提现信息
#define HD_Mine_withdrawal_Data [HTTP stringByAppendingString:@"doctor/my-gold-extract-history"]   // 我的 蝴蝶币-提现明细
#define HD_Mine_Account [HTTP stringByAppendingString:@"doctor/my-account"]   // 我的账户 - 我的
#define HD_Mine_Account_cash [HTTP stringByAppendingString:@"doctor/my-account-cash-detail"]   // 提现明细 - 我的
#define HD_Mine_Password_validation [HTTP stringByAppendingString:@"common/check-password"]   // 登录密码验证


#define HD_HonorHome  [HTTP stringByAppendingString:@"doctor/ranking-list"]   // 荣誉排行榜 - 荣誉

#define HD_Doctor_home  [HTTP stringByAppendingString:@"doctor/ranking-list-view"]   // 医生主页
#define HD_Doctor_home_articles  [HTTP stringByAppendingString:@"doctor/ranking-list-articles"]   // 医生主页-全部文章
#define HD_Doctor_home_comments  [HTTP stringByAppendingString:@"doctor/ranking-list-comments"]   // 医生主页-全部评论



#define HD_Home_Old_Payprice  [HTTP stringByAppendingString:@"doctor/get-pay-price"]   // 图文资讯上次价格
#define HD_Home_Payprice  [HTTP stringByAppendingString:@"doctor/set-pay-price"]   // 图文资讯设置价格
#define HD_Home_Banner  [HTTP stringByAppendingString:@"banner/get-banner"]   // 首页轮播图／荣誉轮播图
#define HD_Home_info  [HTTP stringByAppendingString:@"home/for-head"]   // 获取头部个人信息 - 首页
#define HD_Home_info_Doctor  [HTTP stringByAppendingString:@"home/for-hot-doctor"]   // 获取热门医生 - 首页
#define HD_Home_info_Article  [HTTP stringByAppendingString:@"home/article-index"]   //  患教文章 - 首页
#define HD_Home_info_Article_All  [HTTP stringByAppendingString:@"home/article-library"]   // 患教文库 - 首页
#define HD_Home_info_Article_Add  [HTTP stringByAppendingString:@"home/article-create"]   // 文章创建 - 首页
#define HD_Home_info_Article_Delete  [HTTP stringByAppendingString:@"home/article-delete"]   // 文章删除 - 首页
#define HD_Home_PhoneNumber  [HTTP stringByAppendingString:@"home/assistant"]   // 首页-医疗助理电话
#define HD_Home_notice  [HTTP stringByAppendingString:@"home/notice"]   //  停诊公告列表
#define HD_Home_notice_add  [HTTP stringByAppendingString:@"home/notice-create"]   // 发布停诊公告
#define HD_Home_notice_New  [HTTP stringByAppendingString:@"home/notice-update"]   // 修改停诊公告
#define HD_Home_patient_All  [HTTP stringByAppendingString:@"home/patient-wait-case"]   // 等待病理列表
#define HD_Home_visit_All  [HTTP stringByAppendingString:@"home/patient-visit"]   // 随访患者 - 首页
#define HD_Home_visit_ComeBefore  [HTTP stringByAppendingString:@"home/recall-patient"]   // 召回患者 - 首页

#define HD_Home_Web_statistics  [HTTP_WEB stringByAppendingString:@"web/all-statistics"]   // 数据统计 - 全科数据
#define HD_Home_Web_statistics_One  [HTTP_WEB stringByAppendingString:@"web/group-statistics"]   // 数据统计 - 单组统计
#define HD_Home_MZ_ALL  [HTTP stringByAppendingString:@"home/out-call"]   // 门诊列表
#define HD_Home_MZ_Add_new  [HTTP stringByAppendingString:@"home/out-call-create"]   // 门诊列表-新增
#define HD_Home_MZ_Add_update  [HTTP stringByAppendingString:@"home/out-call-update"]   // 门诊列表-修改
#define HD_Home_MZ_delete  [HTTP stringByAppendingString:@"home/out-call-delete"]   // 门诊列表-删除
#define HD_Home_TWZX_WD [HTTP stringByAppendingString:@"home/image-text-no-read"]   // 图文资讯-未读
#define HD_Home_TWZX_All [HTTP stringByAppendingString:@"home/image-text-all"]   // 图文资讯-全部
#define HD_Home_TWZX_Text [HTTP stringByAppendingString:@"home/image-text"]   // 图文资讯-未回复消息
#define HD_Home_TWZX_Number [HTTP stringByAppendingString:@"home/get-image-text-count"]   // 图文资讯-未读数
#define HD_Home_NumberImage_AllTeam [HTTP stringByAppendingString:@"common/get-my-team"]   // 数据统计-全部组

#define HD_Home_change  [HTTP stringByAppendingString:@"home/change"]   // 修改职业地点记录 - 首页
#define HD_Home_change_new  [HTTP stringByAppendingString:@"home/change-create"]   // 发布修改职业地点 - 首页
#define HD_ModifyArticle_Old  [HTTP stringByAppendingString:@"home/template"]   // 读取模板设置 - 首页
#define HD_ModifyArticle_New  [HTTP stringByAppendingString:@"home/template-update"]   // 模板设置 - 首页

#define HD_Article_Web_Center  [HTTP_WEB stringByAppendingString:@"web/article-view"]   // 文章详细页 - 首页
#define HD_Article_Quote  [HTTP stringByAppendingString:@"home/quote-insert"]   // 文章引用
#define HD_Article_Quote_remove  [HTTP stringByAppendingString:@"home/quote-remove"]   // 文章引用
#define HD_Article_TOP  [HTTP stringByAppendingString:@"home/article-set-top"]   // 文章置顶
#define HD_Article_TOP_Down  [HTTP stringByAppendingString:@"home/article-set-down"]   // 取消文章置顶

#define HD_chat_myTeam  [HTTP stringByAppendingString:@"doctor/my-team"]   // 我的医疗组 - 我的
#define HD_chat_Team_gonggao  [HTTP stringByAppendingString:@"doctor/my-team-group-notice-update"]   //更新群组公告 - 我的
#define HD_chat_Team_Delete  [HTTP stringByAppendingString:@"doctor/my-team-group-leave"]   //退出群
#define HD_chat_Team_DeleteOne  [HTTP stringByAppendingString:@"doctor/remove-group-member"]   //删除群个人
#define HD_chat_Team_Card  [HTTP stringByAppendingString:@"doctor/team-card"]   //获取医疗组名片


#define HD_Surgery  [HTTP stringByAppendingString:@"home/patient-surgery"]   //术后出院 - 首页
#define HD_patient_all  [HTTP stringByAppendingString:@"home/patient"]   //住院患者 - 首页
#define HD_patient_Mine  [HTTP stringByAppendingString:@"home/patient-mine"]   //住院患者 - 标记我的患者操作

#define HD_patient_delete  [HTTP stringByAppendingString:@"home/patient-delete"]   //住院患者 - 删除患者
#define HD_patient_info  [HTTP stringByAppendingString:@"home/patient-view"]   //住院患者 - 患者信息
#define HD_patientAndDoctor_chat  [HTTP stringByAppendingString:@"home/patient-communication"]   //住院患者 - 医患沟通
#define HD_patientAndDoctor_chat_remainingNumber [HTTP stringByAppendingString:@"home/get-patient-communication-count"]   // 获取患者与医生沟通次数 - 首页

#define HD_NoSurgery_Out [HTTP stringByAppendingString:@"home/patient-no-surgery"]   // 未术后出院 - 首页
//#define HD_Surgery_Info [HTTP stringByAppendingString:@"home/perfection"]   // 完善患者信息
#define HD_Surgery_Info [HTTP stringByAppendingString:@"home/perfection-stream"]   // 完善患者信息

#define HD_Guanyuwomen  [HTTP stringByAppendingString:@"common/about-us"]   // 关于我们
#define HD_Fuwutiaokuan  [HTTP stringByAppendingString:@"common/service"]   // 用户服务条款
#define HD_Fuwutiaokuan_ZC  [HTTP stringByAppendingString:@"common/register-service"]   // 注册服务条款
#define HD_Get_Phone  [HTTP stringByAppendingString:@"common/get-service-tel"]   //获取客户电话

#define HD_OUT_TOKEN @"http://api.hudieyisheng.com/v1/doctor/login-out"//退出登录

#define HD_Home_Banner_Content_ID  [HTTP stringByAppendingString:@"banner/get-banner-by-id"]   //点击轮播图 根据id请求 conter内容


#endif /* GatoURL_h */
