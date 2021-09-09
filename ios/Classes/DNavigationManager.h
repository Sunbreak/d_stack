#import <Foundation/Foundation.h>
#import "DStack.h"

@interface DNode : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *routeName;
@property (nonatomic, assign) int type;

- (NSDictionary *)toDictionary;

@end

@interface DNavigationManager : NSObject

@property (class, nonatomic, readonly) DNavigationManager *shared;

- (instancetype)init NS_UNAVAILABLE;

- (void)registerRoute:(NSDictionary<NSString *, NativeRoute> *)routeMap;

- (void)pushRoute:(NSString *)routeName;

- (void)pop;

- (DNode *)findTopNode:(DNode *)node;

@end
