#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import "DNavigationManager.h"

@interface DFlutterViewController : FlutterViewController

#pragma mark - NS_UNAVAILABLE
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithEngine:(FlutterEngine *)engine
                       nibName:(NSString *)nibName
                        bundle:(NSBundle *)nibBundle NS_UNAVAILABLE;
- (instancetype)initWithProject:(FlutterDartProject *)project
                        nibName:(NSString *)nibName
                         bundle:(NSBundle *)nibBundle NS_UNAVAILABLE;
- (instancetype)initWithProject:(FlutterDartProject *)project
                   initialRoute:(NSString *)initialRoute
                        nibName:(NSString *)nibName
                         bundle:(NSBundle *)nibBundle NS_UNAVAILABLE;

- (instancetype)initWithDNode:(DNode *)node;

@end
