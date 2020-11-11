#import 'QMLineManager.h'
// 导入跳转的页面
#import "QMHomeViewController.h"
#import "AppDelegate.h"
#import <React/RCTLog.h>
@implementation QMLineManager

RCT_EXPORT_MODULE();

// RCT_EXPORT_METHOD(RNOpenOneVC:(NSString *)msg){
//
//   NSLog(@"RN传入原生界面的数据为:%@",msg);
//   //主要这里必须使用主线程发送,不然有可能失效
//   dispatch_async(dispatch_get_main_queue(), ^{
//     QMHomeViewController *one = [[QMHomeViewController alloc]init];
//
//     AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//     [app.nav pushViewController:one animated:YES];
//   });
// }
RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

@end
