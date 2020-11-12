//
//  QMChatRoomViewController.h
//  IMSDK-OC
//
//  Created by HCF on 16/3/9.
//  Copyright © 2016年 HCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMLineSDK/QMLineSDK.h>

@class QMChatRoomInputView;
@class TCMessageManagerFaceView;
@class addBackgroudView;
@class QMChatRoomMoreView;
@class QMRecordIndicatorView;
@class QMChatRoomEvaluationView;
@class QMChatRoomAssociationInputView;
@class QMChatRoomBottomListView;

@interface QMChatRoomViewController : UIViewController

@property (nonatomic, strong) UITableView *chatTableView; // 消息列表

@property (nonatomic, strong) QMChatRoomInputView *chatInputView; // 输入工具条

@property (nonatomic, strong) TCMessageManagerFaceView *faceView; // 表情面板

@property (nonatomic, strong) QMChatRoomMoreView *addView; // 扩展面板

@property (nonatomic, strong) QMRecordIndicatorView *indicatorView; // 录音动画

@property (nonatomic, strong) QMChatRoomEvaluationView *evaluationView;//人工满意度评价

@property (nonatomic, strong) QMChatRoomAssociationInputView *associationView;//xbot联想输入面板

@property (nonatomic, strong) QMChatRoomBottomListView *bottomView;//xbot底部推荐

@property (nonatomic, strong) UIActivityIndicatorView *indicatorViews;

@property (nonatomic, strong) UIView *coverView;//蒙版

@property (nonatomic, strong) UIButton *manualButotn; // 转人工

@property (nonatomic, strong) UIButton *logoutButton; // 注销

@property (nonatomic, copy) NSString *peerId; // 技能组ID

@property (nonatomic, copy) NSString *scheduleId; //日程id

@property (nonatomic, copy) NSString *processId; //流程id

@property (nonatomic, copy) NSString *currentNodeId; //入口节点中访客选择的流转节点id

@property (nonatomic, copy) NSString *entranceId; //入口节点中_id

@property (nonatomic, copy) NSString *processType; //流程中节点类型 (人工 机器人 …)

@property (nonatomic, copy) NSArray * LeaveArray; //日程管理的留言数据

@property (nonatomic, copy) NSString *avaterStr; // 用户头像

@property (nonatomic, assign) BOOL isAutoBreak; // 是否开启定时关闭会话功能

@property (nonatomic, assign) BOOL isRobot;

@property (nonatomic, assign) BOOL isOpenSchedule; //是否开启日程管理

@property (nonatomic, assign) NSInteger breakDuration; // 访客无响应断开时长

@property (nonatomic, assign) NSInteger breakTipsDuration; // 断开前提示时长

@property (nonatomic, copy) NSString *tips; // 断开提示语

@property (nonatomic, copy) NSString *msg; // 未开启留言提示

@property (nonatomic, copy) NSString *leaveMsg; // 留言提示语 后台未配置显示默认

@property (nonatomic, assign) BOOL isPush; // 判断是否为正常页面跳转

@property (nonatomic, strong) QMEvaluation *evaluation;//满意度

@property (nonatomic, strong) QMEvaluats *evaluats;//满意度评价详情

@property (nonatomic, strong) NSMutableDictionary *heightCaches; // cell高度缓存

- (void)sendFileMessageWithName: (NSString *)fileName AndSize: (NSString *)fileSize AndPath: (NSString *)filePath;

@end
