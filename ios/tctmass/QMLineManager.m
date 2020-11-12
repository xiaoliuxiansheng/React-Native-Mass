// 导入跳转的页面
#import "QMHomeViewController.h"
#import "AppDelegate.h"
#import "QMLineManager.h"
#import <React/RCTLog.h>
#import <QMLineSDK/QMLineSDK.h>
#import "QMChatRoomViewController.h"
@implementation QMLineManager
RCT_EXPORT_MODULE();
 RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
 {
   dispatch_async(dispatch_get_main_queue(), ^{
//     第一种写法
     QMHomeViewController *one = [[QMHomeViewController alloc]init];
      AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [app.nav pushViewController:one animated:YES];
//     QMHomeViewController *one = [[QMHomeViewController alloc]init];
//      AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//     [app.nav setNavigationBarHidden:NO animated:YES];
//     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//           [app.nav pushViewController:one animated:YES];
//         });
    });
 }
@end
