//
//  QMConnect.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/10/23.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMLineDelegate.h"
#import "QMMessage.h"

@class CustomMessage;
@class QMAgent;
@class QMSessionOption;
@class QMEvaluation;


@interface QMConnect : NSObject

+ (void)registerSDKWithAppKey:(NSString *)accessId
                     userName:(NSString *)userName
                       userId:(NSString *)userId
                     deviceId:(NSString *)deviceId;

/**
 注册accessId、初始化SDK:
 
 初始化成功，建立tcp连接，保证移动端消息的接收，如果建立tcp连接失败，会导致消息接收不到
 以通知的方式进行回调
 
 param accessId:  接入客服系统的密钥， 可在客服系统登录平台获取
 param userName:  用户名， 区分用户， 用户名可直接在后台显示
 param userId:    用户ID， 区分用户
 */
+ (void)registerSDKWithAppKey:(NSString *)accessId
                     userName:(NSString *)userName
                       userId:(NSString *)userId;

/**
 注册accessId、初始化SDK:
 
 初始化成功，建立tcp连接，保证移动端消息的接收，如果建立tcp连接失败，会导致消息接收不到
 以代理的方式进行回调
 
 param accessId:  接入客服系统的密钥， 可在客服系统登录平台获取
 param userName:  用户名， 区分用户， 用户名可直接在后台显示
 param userId:    用户ID， 区分用户
 */
+ (void)registerSDKWithAppKey:(NSString *)accessId
                     userName:(NSString *)userName
                       userId:(NSString *)userId
                     delegate:(id<QMKRegisterDelegate>)delegate;

/**
 注销、断开tcp连接
 
 客服人员可收到用户离开的通知
 */
+ (void)logout;

/*
部分用户Cocoapods服务，需要咨询对接是否需要使用
**/
+ (void)setServerToCocoapods;

/**
 自建服务器设置网络地址:
 是不是自建服务器的用户不需要设置此项
 
 param tcpHost:      TCP连接地址
 param tcpPort:      TCP端口号
 param httpPost:     HTTP请求地址
 */
+ (void)setServerAddress:(NSString *)tcpHost
                 tcpPort:(int)tcpPort
                httpPost:(NSString *)httpPost;

/*
 推送的token
 每次启动应用都需要重新设置
 **/
+ (void)setServerToken:(NSData *)deviceToken;

/**
 发起新会话:
 调用此接口、可以拥有与客服对话的能力
 
 param peer:          技能组ID，客服平台配置多个技能组时，需要传入对应的技能组ID，会话才能接入到对应的技能组，
 param successBlock:  接入会话成功回调，回调参数为bool类型，判断后台是否开启问卷调查功能
 param failBlock:     接入会话失败回调，
 */
+ (void)sdkBeginNewChatSession:(NSString *)peerId
                  successBlock:(void (^)(BOOL))success
                     failBlock:(void (^)(NSString *))failure;

/**
 发起新会话:
 调用此接口、可以拥有与客服对话的能力

 @param peerId 技能组ID，客服平台配置多个技能组时，需要传入对应的技能组ID，会话才能接入到对应的技能组，
 @param delegate 设置代理方法
 @param success 接入会话成功回调，回调参数为bool类型，判断后台是否开启问卷调查功能
 @param failure 接入会话失败回调
 */
+ (void)sdkBeginNewChatSession:(NSString *)peerId
                      delegate:(id<QMKServiceDelegate>)delegate
                  successBlock:(void (^)(BOOL))success
                     failBlock:(void (^)(void))failure;


/**
 发起新会话:
 调用此接口、可以拥有与客服对话的能力
 
 param peer:          技能组ID，客服平台配置多个技能组时，需要传入对应的技能组ID，会话才能接入到对应的技能组，
 param params:        @{@"agent":@"8000"} 专属坐席
                      @{@"customField":@{@"姓名":@"李三"}} 自定义字段
 param successBlock:  接入会话成功回调，回调参数为bool类型，判断后台是否开启问卷调查功能
 param failBlock:     接入会话失败回调，
 */
+ (void)sdkBeginNewChatSession:(NSString *)peerId
                        params:(NSDictionary *)params
                  successBlock:(void (^)(BOOL))success
                     failBlock:(void (^)(NSString *))failure;

/**
 发起新会话:
 调用此接口、可以拥有与客服对话的能力

 @param peerId 技能组ID，客服平台配置多个技能组时，需要传入对应的技能组ID，会话才能接入到对应的技能组，
 @param option 扩展信息配置 含VIP专属坐席 自定义字段
 @param success 接入会话成功回调，回调参数为bool类型，判断后台是否开启问卷调查功能
 @param failure 接入会话失败回调
 */
+ (void)sdkBeginNewChatSession:(NSString *)peerId
                        option:(QMSessionOption *)option
                  successBlock:(void (^)(BOOL))success
                     failBlock:(void (^)(NSString *))failure;

/**
 发起新会话:
 启用日程管理的用此接口
 
 调用此接口、可以拥有与客服对话的能力、携带参数
 
 param schedule:      日程id
 param processId:     流程id
 param currentNodeId: 入口节点中访客选择的流转节点ID
 param entranceId:    入口节点中的id
 param params:        @{@"agent":@"8000"} 专属坐席
                      @{@"customField":@{@"姓名":@"李三"}} 自定义字段
 param successBlock:  接入会话成功回调，回调参数为bool类型，判断后台是否开启问卷调查功能
 param failBlock:     接入会话失败回调，
 */
+ (void)sdkBeginNewChatSessionSchedule:(NSString *)scheduleId
                             processId:(NSString *)processId
                         currentNodeId:(NSString *)currentNodeId
                            entranceId:(NSString *)entranceId
                                params:(NSDictionary *)params
                          successBlock:(void (^)(BOOL))success
                             failBlock:(void (^)(NSString *))failure;

/**
发起新会话:
启用日程管理vip坐席失败之后用此接口

调用此接口、可以拥有与客服对话的能力、携带参数

param schedule:      日程id
param processId:     流程id
param currentNodeId: 入口节点中访客选择的流转节点ID
param entranceId:    入口节点中的id
param successBlock:  接入会话成功回调，回调参数为bool类型，判断后台是否开启问卷调查功能
param failBlock:     接入会话失败回调，
*/

+ (void)sdkBeginNewChatSessionSchedule:(NSString *)scheduleId
                             processId:(NSString *)processId
                         currentNodeId:(NSString *)currentNodeId
                            entranceId:(NSString *)entranceId
                          successBlock:(void (^)(BOOL))success
                             failBlock:(void (^)(NSString *))failure;
/**
 获取渠道全局配置中 globalSet
 调用此接口获取后台的全局配置信息，注册成功会主动请求一次插入本地plist文件，用户也可以自行调用获取
 
 param successBlock:  成功回调
 param failBlock:     回调失败
 */
+ (void)sdkGetWebchatGlobleConfig:(void (^)(NSDictionary *))success
                        failBlock:(void (^)(void))failure;

/**
 获取渠道全局配置中的 scheduleConfig
 调用此接口获取全局配置中的 scheduleConfig  此接口主要用于开启日程管理需要
 
 param configs:       配置信息
 param successBlock:  成功回调
 param failBlock:     回调失败
 */
+ (void)sdkGetWebchatScheduleConfig:(void (^)(NSDictionary *))success
                          failBlock:(void (^)(void))failure;

/**
 发送文本消息:
 调用此接口、可以发送文本消息，包括文字、表情
 
 param text:            文本消息内容
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)sendMsgText:(NSString *)text
       successBlock:(void (^)(void))success
          failBlock:(void (^)(void))failure;

/**
 发送图片消息:
 调用此接口、可以发送图片消息
 
 param pic:             图片消息内容
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)sendMsgPic:(UIImage *)image
      successBlock:(void (^)(void))success
         failBlock:(void (^)(void))failure;

/**
 发送图片消息:
 调用此接口、可以发送图片消息
 
 param filePath:        图片文件相对路径
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)sendMsgImage:(NSString *)filePath
        successBlock:(void (^)(void))success
           failBlock:(void (^)(void))failure;

/**
 发送语音消息:
 调用此接口、可以发送语音消息
 
 param audio:           语音消息路径 语音名字需要带mp3后缀
 param duration:        语音消息时长
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)sendMsgAudio:(NSString *)audio
            duration:(NSString *)duartion
        successBlock:(void (^)(void))success
           failBlock:(void (^)(void))failure;

/**
 语音转文本接口:
 
 param message:    消息model
 */
+ (void)sendMsgAudioToText:(CustomMessage *)message
              successBlock:(void (^)(void))success
                 failBlock:(void (^)(void))failure;

/**
 发送文件消息:
 调用此接口、可以发送文件消息
 
 param fileName:        文件名称
 param filePath:        沙盒文件相对路径
 param fileSize:        文件大小
 param progress:        上传进度回调
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)sendMsgFile:(NSString *)fileName
           filePath:(NSString *)filePath
           fileSize:(NSString *)fileSize
     progressHander:(void (^)(float))progress
       successBlock:(void (^)(void))success
          failBlock:(void (^)(void))failure;

/**
 发送商品信息消息:
 调用此接口、可以发送商品信息消息
 
 param message:         消息字典
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)sendMsgCardInfo:(NSDictionary *)message
           successBlock:(void (^)(void))success
              failBlock:(void (^)(void))failure;

/**
 下载消息中的文件：
 
 param message:         消息实例
 param localFilePath:   沙盒文件相对路径
 param progress:        下载进度回调
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)downloadFileWithMessage:(CustomMessage *)message
                  localFilePath:(NSString *)filePath
                 progressHander:(void (^)(float))progress
                   successBlock:(void (^)(void))success
                      failBlock:(void (^)(NSString *))failure;

/**
 消息重发:
 调用此接口、将未发送的消息重新发送

 @param message 消息内容
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)resendMessage:(CustomMessage *)message
         successBlock:(void (^)(void))success
            failBlock:(void (^)(void))failure;

/**
 封装消息模型:
 目前只支持新增的评价类型消息(不支持文本、语音、图片等)
 */
+ (CustomMessage *)createMessageOfInvestigations;

/**
 获取数据库信息:
 调用此接口、获取数据库信息
 
 param num            : 单次获取消息数目(无默认值)
 param [CustomMessage]: 返回消息数组
 */
+ (NSArray<CustomMessage *> *)getDataFromDatabase:(int)number;

/**
 获取数据库接口、相同的accessId的数据库中的全部消息
 调用此接口、获取数据库下同一个accessid下的全部信息
 
 param num            : 单次获取消息数目(无默认值)
 param [CustomMessage]: 返回消息数组
 */
+ (NSArray<CustomMessage *> *)getAccessidAllDataFormDatabase:(int)number;

/**
 获取数据库接口、相同的userId的数据库中的全部消息
 调用此接口、获取数据库下同一个userId下的全部信息
 
 param num            : 单次获取消息数目(无默认值)
 param [CustomMessage]: 返回消息数组
 */
+ (NSArray<CustomMessage *> *)getUserIdDataFormDatabase:(int)number;

/**
 获取单条数据库信息:
 调用此接口、获取数据库一条记录、用于消息重发
 
 param messageId:       消息ID
 param [CustomMessage]: 返回消息数组
 */
+ (NSArray<CustomMessage *> *)getOneDataFromDatabase:(NSString *)messageId;

/**
 删除单条数据库信息:
 用此接口、删除数据路一条记录、只能删除本地消息
 
 param message:  消息
 */
+ (void)removeDataFromDataBase:(NSString *)messageId;

/**
 修改语音状态接口:
 将语音由未读取状态变为已读取状态
 
 param messageId:  消息ID
 */
+ (void)changeAudioMessageStatus:(NSString *)messageId;

/**
 撤回消息接口:
 将发送的消息撤回,该接口只用于客服撤回消息
 
 param messageId:  消息ID
 */
+ (void)changeDrawMessageStatus:(NSString *)messageId;

/**
 查询Mp3消息:
 查询MP3类型文件的消息的大小
 
 param messageId:  消息ID
 */
+ (NSString *)queryMp3FileMessageSize:(NSString *)messageId;

/**
 修改Mp3消息:
 修改MP3类型文件的消息的大小
 
 param messageId:  消息ID
 param fileSize:   文件大小
 */
+ (void)changeMp3FileMessageSize:(NSString *)messageId
                        fileSize:(NSString *)fileSize;

/**
 插入商品信息展示数据
 
 param message:  消息字典
 */
+ (void)insertCardInfoData:(NSDictionary *)message type:(NSString *)type;

/**!
 提示: Use the (insertCardInfoData: type:) instead
 */
+ (void)insertCardInfoData:(NSDictionary *)message __attribute__((deprecated));

/*
 删除商品信息展示消息
 */
+ (void)deleteCardTypeMessage;
+ (void)deleteCardTypeMessage:(NSString *)type;

/**
 变更商品信息展示消息时间
 
 param time:  消息时间
 */
+ (void)changeCardTypeMessageTime:(NSString *)time;

/**
 语音转文本是否显示

 param status:  是否显示 @”0“不显示   @”1“显示
 param messageId:  消息id  (messageId传@”all“时是隐藏所有已经转的语音----用于退出聊天页面再次进入的时候)
 */
+ (void)changeVoiceTextShowoOrNot:(NSString *)status message:(NSString *)messageId;

/**
查询语音转文字的状态
0不展示  1展示  2正在翻译中…
@param messageId 消息id
*/
+ (NSString *)queryVoiceTextStatusWithmessageId:(NSString *)messageId;

/**
 请求人工服务:
 调用此接口、请求人工服务(如后台开启智能机器人功能、默认为机器人服务器)
 
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkConvertManual:(void (^)(void))success
               failBlock:(void (^)(void))failure;

/**
 请求人工服务：带技能组id
 用于机器人问答自动调用转人工服务
 
 param peerId:  技能组id
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkConvertManualWithPeerId:(NSString *)peerId
                      successBlock:(void (^)(void))success
                         failBlock:(void (^)(void))failure;

/**
 其他坐席服务授权
 
 专属坐席未在线的情况下，是否接受其他坐席的服务
 
 param peer:          技能组ID, 详见beginSession接口
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkAcceptOtherAgentWithPeer:(NSString *)peer
                       successBlock:(void (^)(void))success
                          failBlock:(void (^)(void))failure;

/**
 获取满意度评价信息:
 用于满意度调查
 
 param investigateArray: 评价信息
 param successBlock:     成功回调
 param failureBlock :    失败回调
 */
+ (void)sdkGetInvestigate:(void (^)(NSArray<NSDictionary *> *))success
             failureBlock:(void (^)(void))failure;

/**
 获取满意度评价信息:
 用于满意度调查 自定义标题和感谢语
 
 param investigateArray: 评价信息
 param successBlock:     成功回调
 param failureBlock :    失败回调
 */

+ (void)newSDKGetInvestigate:(void (^)(QMEvaluation *))success
                failureBlock:(void (^)(void))failure;

/**
取消满意度评价:
获取服务器timestamp时间戳
param successBlock:     成功回调
param failureBlock :    失败回调
*/
+ (void)sdkGetServerTime:(void (^)(NSString *))success
            failureBlock:(void (^)(void))failure;

/**
查询满意度评价是否超时:
params 参数
param successBlock:     成功回调
param failureBlock :    失败回调
*/
+ (void)sdkCheckImCsrTimeoutParams:(NSDictionary *)params
                          success:(void (^)(void))success
                     failureBlock:(void (^)(void))failure;

/**
 获取技能组信息:
 开始会话前选择技能组进入
 
 param investigateArray: 评价信息
 param successBlock:     成功回调
 param failureBlock:     失败回调
 */
+ (void)sdkGetPeers:(void (^)(NSArray<NSDictionary *> *))success
       failureBlock:(void (^)(void))failure;

/**
 获取未读消息数接口
 
 param accessId:  接入客服系统的密钥， 可在客服系统登录平台获取
 param userName:  用户名， 区分用户， 用户名可直接在后台显示
 param userId:    用户ID， 区分用户
 param successBlock:     成功回调
 param failureBlock :    失败回调
 */
+ (void)sdkGetUnReadMessage:(NSString *)accessId
                   userName:(NSString *)userName
                     userId:(NSString *)userId
               successBlock:(void (^)(NSInteger))success
                  failBlock:(void (^)(void))failure;

/**
 提交满意度调查信息
 
 param name:          评价信息
 param value:         评价信息ID
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitInvestigate:(NSString *)name
                       value:(NSString *)value
                successBlock:(void (^)(void))success
                   failBlock:(void (^)(void))failure;

/**
 提交满意度评价 包含二级n标题和备注
 
 param name:          评价信息
 param value:         评价信息ID
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkNewSubmitInvestigate:(NSString *)name
                          value:(NSString *)value
                     radioValue:(NSArray *)radioValue
                         remark:(NSString *)remark
                   successBlock:(void (^)(void))success
                      failBlock:(void (^)(void))failure;

/**
 留言接口
 
 客服离线状态下，未配置机器人客服或转人工客服时，可进行留言操作
 
 param peer:          技能组
 param phone:         联系电话
 param Email:         联系邮箱
 param message:       留言内容
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitLeaveMessage:(NSString *)peer
                        phone:(NSString *)phone
                        Email:(NSString *)email
                      message:(NSString *)message
                 successBlock:(void (^)(void))success
                    failBlock:(void (^)(void))failure;

/**
 留言接口
 
 客服离线状态下，未配置机器人客服或转人工客服时，可进行留言操作
 
 param peer:          技能组
 param information:   联系信息
 param leavesgFields: 自定义联系字段
 param message:       留言内容
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitLeaveMessageWithInformation:(NSString *)peer
                                 information:(NSDictionary *)information
                              leavemsgFields:(NSArray<NSDictionary*> *)leavemsgFields
                                     message:(NSString *)message
                                successBlock:(void (^)(void))success
                                   failBlock:(void (^)(void))failure;

/**
 机器人反馈
 
 param isUseful:      是否有帮助
 param questionId:    问题ID
 param messageId:     消息Id
 param robotType:     机器人类型
 parma robotId:       机器人ID
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitRobotFeedback:(BOOL)isUseful
                    questionId:(NSString *)questionId
                     messageId:(NSString *)messageId
                     robotType:(NSString *)robotType
                       robotId:(NSString *)robotId
                    robotMsgId:(NSString *)robotMsgId
                  successBlock:(void (^)(void))success
                     failBlock:(void (^)(void))failure;

/**
 智能机器人评价
 
 param robotId:          机器人id
 param satisfaction:     评价选项
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitIntelligentRobotSatisfaction:(NSString *)satisfaction
                                 satisfaction:(NSString *)satisfaction
                                 successBlock:(void (^)(void))success
                                    failBlock:(void (^)(void))failure;

/**
 xbot机器人反馈
 
 param isUseful:      是否有帮助
 param messageId:     消息Id
 parma robotId:       机器人ID
 param oriquestion:   访客问题
 param question:      标准问题
 param answer:        答案
 param confidence:    置信度
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitXbotRobotFeedback:(BOOL)isUseful
                           message:(CustomMessage *)message
                      successBlock:(void (^)(void))success
                         failBlock:(void (^)(void))failure;

/**
 xbot机器人评价
 
 param satisfaction:     评价选项
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitXbotRobotSatisfaction:(NSString *)satisfaction
                          successBlock:(void (^)(void))success
                             failBlock:(void (^)(void))failure;

/**
 xbot联想功能
 
 param text 联想文本
 param cateIds xbot机器人cateIds
 param robotId 机器人id
 param robotType 机器人类型
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)sdkSubmitXbotRobotAssociationInput:(NSString *)text
                                   cateIds:(NSArray *)cateIds
                                   robotId:(NSString *)robotId
                                 robotType:(NSString *)robotType
                              successBlock:(void (^)(NSArray *))success
                                 failBlock:(void (^)(void))failure;

/**
 客服是否说话
 目前用于满意度评价按钮
 param successBlock:  成功回调
 param failBlock:     失败回调
 */
+ (void)customerServiceIsSpeek:(void (^)(void))success
                     failBlock:(void (^)(void))failure;

/**
 是否启用留言功能
 
 全局配置：
 启用留言功能，坐席不在线跳转到留言面板进行留言
 未启用留言功能，坐席不在线，不会跳转至留言面板
 */
+ (BOOL)allowedLeaveMessage;

/**
 留言提示窗口信息
 
 全局配置：
 未启用留言状态下，弹出的提示内容
 */
+ (NSString *)leaveMessageAlert;

/**
 留言标题
 
 全局配置：
 启用留言状态下，展示留言板标题
 */
+ (NSString *)leaveMessageTitle;

/**
 留言内容占位
 
 全局配置：
 启用留言状态下，展示在留言板输入框的占位提醒
 */
+ (NSString *)leaveMessagePlaceholder;

/**
 留言自定义配置
 
 全局配置:
 后台留言板联系方式自定义字段
 */
+ (NSArray *)leaveMessageContactInformation;

/**
 是否启用用户无响应会话自动关闭功能
 
 全局配置：
 用户长时间未给坐席发送消息，自动关闭当前会话 并退出聊天界面，需要后台正确配置 提示和断开时间
 */
+ (BOOL)allowedBreakSession;

/**
 自动关闭会话提示语
 
 全局配置：
 后台配置的提示语，在断开前进行提示
 */
+ (NSString *)breakSessionAlert;

/**
 自动关闭会话时间
 
 全局配置：
 从开始新的会话、或用户发送一条消息开始计时
 */
+ (int)breakSessionDuration;

/**
 自动关闭会话提示时间
 
 全局配置:
 关闭会话前进行的提示的时间，从开始新的会话、或用户发送一条消息开始计时
 */
+ (int)breakSessionAlertDuration;

/**
 判断是否启用机器人
 */
+ (BOOL)allowRobot;

/**
 机器人的类型
 此方法必须是在启用机器人后使用
 小七   7mbot
 小陌   7mbot_ai
 xbot  xbot
 云秘   yunmi
 智齿   sobot
 */
+ (NSString *)sdkRobotType;

/**
 转人工按钮是否显示
 */
+ (BOOL)manualButtonStatus;

/**
 与服务器连接状态

 @param connected 已连接
 @param connecting 连接中/重连中
 @param disconnect 断开连接
 */
+ (void)statusWithConneted:(void (^)(void))connected
                connecting:(void (^)(void))connecting
                       dis:(void (^)(void))disconnect;

/**
 会话定时断开
 调用此接口、可以再客户在一定时间没有新消息的时候断开会话
 
 param successBlock:  成功回调
 param failBlock:     回调失败
 */
+ (void)sdkChatTimerBreaking:(void (^)(NSDictionary *))success
                   failBlock:(void (^)(void))failure;

/**
 排队数提示文案
 */
+ (NSArray *)sdkQueueMessage;

/**
 是否开启访客先说话才接入
 */
+ (BOOL)customerAccessAfterMessage;

/**
 xbot底部推荐数据
 */
+ (NSArray *)xbotBottomList:(NSString *)type;

/*
 应用杀死时事件处理
 **/
+ (void)applicationWillTerminateHandle;


/**
获取常见问题
*/
+ (void)sdkGetCommonQuestion:(void (^)(NSArray *))completion failure:(void(^)(NSString *))failure;

/**
获取常见问题第二联
*/
+ (void)sdkGetSubCommonQuestionWithcid:(NSString *)cid completion:(void (^)(NSArray *))completion failure:(void(^)(NSString *))failure;

+ (void)sdkGetCommonDataWithParams:(NSDictionary *)params completion:(void (^)(id))completion failure:(void (^)(NSError *))failure;

+ (void)changeAllCardMessageHidden;
+ (void)changeCardMessageType:(QMMessageCardReadType)type messageId:(NSString *)messageId;


/**
退出登录，取消推送
 */
+ (void)sdkLogoutAction:(void(^)(BOOL, NSString *))completion;

+ (CustomMessage *)createAndInsertMessageToDBWithMessageType: (NSString *)type filePath: (NSString *)filePath content: (NSString *)content metaData: (NSDictionary *)metaData;

/**
 定时断开会话消息提醒
 */
+ (void)sdkSendBreakTipMessage;

/**
 系统消息头像
 */
+ (NSString *)sdkSystemMessageIcon;

/**
 消费未读消息
 */
+ (void)sdkDealImMsg;

/**
 自定义对方撤回消息的文案
 
 默认文案：对方撤回一条消息
 可用于国际化适配和自定义文案
 */
+ (void)WithdrawMessageText:(NSString *)text;

@end
