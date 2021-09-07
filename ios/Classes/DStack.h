#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

FOUNDATION_EXPORT NSString * const EngineId;

typedef UIViewController *(^NativeRoute)(void);

@interface DStack: NSObject

@property (class, nonatomic, readonly) DStack *shared;

@property (nonatomic) FlutterEngine *flutterEngine;

- (instancetype)init NS_UNAVAILABLE;

- (void)initialize;

- (void)registerRoute:(NSDictionary<NSString *, NativeRoute> *)routeMap;

- (void)pushRoute:(NSString *)routeName;

@end
