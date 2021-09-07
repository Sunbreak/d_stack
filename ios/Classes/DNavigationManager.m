#import "DNavigationManager.h"
#import "DFlutterViewController.h"

static inline DNode *createDNode(NSString *routeName) {
    DNode *node = [[DNode alloc] init];
    node.identifier = [[NSUUID UUID] UUIDString];
    node.routeName = routeName;
    return node;
}

@implementation DNode

- (NSDictionary *)toDictionary {
    return @{
        @"identifier": self.identifier,
        @"routeName": self.routeName,
    };
}

@end

@interface DNavigationManager ()

@property (nonatomic, strong, readonly) NSDictionary<NSString *, NativeRoute> *routeMap;
@property (nonatomic, strong, readonly) NSMutableArray<NSMutableArray *> *nodeGroups;

@end

@implementation DNavigationManager

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodeGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)registerRoute:(NSDictionary<NSString *, NativeRoute> *)routeMap {
    _routeMap = [[NSDictionary alloc] initWithDictionary:routeMap];
}

- (void)pushRoute:(NSString *)routeName {
    DNode *node = createDNode(routeName);
    [self putNodeIfAbsent:node];

    NativeRoute nativeRoute = self.routeMap[routeName];
    if (nativeRoute) {
        UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
        navigation.navigationBarHidden = NO;
        [navigation pushViewController:nativeRoute() animated:YES];
    } else {
        UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
        navigation.navigationBarHidden = YES;
        [navigation pushViewController:[[DFlutterViewController alloc] initWithDNode:node] animated:YES];
    }
}

- (NSMutableArray *)findLastGroup:(DNode *)node {
    // TODO reverse
    for (NSMutableArray *group in self.nodeGroups) {
        for (DNode *n in group) {
            if ([n.identifier isEqual:node.identifier]) {
                return group;
            }
        }
    }
    return nil;
}

- (void)putNodeIfAbsent:(DNode *)node {
    NSMutableArray *group = [self findLastGroup:node];
    if (group != nil) return;

    // TODO native page
    if (self.nodeGroups.count <= 0) {
        [self.nodeGroups addObject:[[NSMutableArray alloc] initWithObjects:node, nil]];
    } else {
        [self.nodeGroups.lastObject addObject:node];
    }
}

@end
