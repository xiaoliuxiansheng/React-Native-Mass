#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate>
@property (nonatomic, strong) UINavigationController *nav;

@property (nonatomic, strong) UIWindow *window;
// 创建一个原生的导航条
@end
