#import "DNavigationManager.h"
#import "DFlutterViewController.h"
#import "DStackPlugin.h"

#pragma - mark DNode

const int kTypeFlutter = 0;
const int kTypeNative = 0;

static inline DNode *createDNode(NSString *routeName, int type) {
    DNode *node = [[DNode alloc] init];
    node.identifier = [[NSUUID UUID] UUIDString];
    node.routeName = routeName;
    node.type = type;
    return node;
}

@implementation DNode

- (NSDictionary *)toDictionary {
    return @{
        @"identifier": self.identifier,
        @"routeName": self.routeName,
        @"type": @(self.type),
    };
}

@end

#pragma - mark DNodeGroup

@interface DNodeGroup : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<DNode *> *nodes;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, UIViewController *> *viewControllers; // TODO weak

@end

@implementation DNodeGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nodes = [[NSMutableArray alloc] init];
        _viewControllers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end

#pragma - mark DNavigationManager

@interface DNavigationManager ()

@property (nonatomic, strong, readonly) NSDictionary<NSString *, NativeRoute> *routeMap;
@property (nonatomic, strong, readonly) NSMutableArray<DNodeGroup *> *nodeGroups;

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
    NativeRoute nativeRoute = self.routeMap[routeName];
    DNode *node = createDNode(routeName, nativeRoute ? kTypeNative : kTypeFlutter);
    [self addNodeOrGroup:node];
    DNodeGroup *group = self.nodeGroups.lastObject;

    if (nativeRoute) {
        UIViewController *viewController = nativeRoute();
        group.viewControllers[node.identifier] = viewController;

        UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
        navigation.navigationBarHidden = NO;
        [navigation pushViewController:viewController animated:YES];
    } else {
        if (group.viewControllers.count == 0) {
            UIViewController *viewController = [[DFlutterViewController alloc] initWithDNode:node];
            group.viewControllers[node.identifier] = viewController;

            UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
            navigation.navigationBarHidden = YES;
            [navigation pushViewController:viewController animated:YES];
        } else {
            [DStackPlugin.shared activateFlutterNode:node];
        }
    }
}

- (DNode *)findTopNode:(DNode *)node {
    // TODO reverse
    for (DNodeGroup *group in self.nodeGroups) {
        for (DNode *n in group.nodes) {
            if ([n.identifier isEqual:node.identifier]) {
                return group.nodes.lastObject;
            }
        }
    }
    return nil;
}

- (void)addNodeOrGroup:(DNode *)node {
    if (self.nodeGroups.count <= 0) {
        DNodeGroup *group = [[DNodeGroup alloc] init];
        [group.nodes addObject:node];
        [self.nodeGroups addObject:group];
    } else {
        DNodeGroup *lastGroup = self.nodeGroups.lastObject;
        if (lastGroup.nodes.firstObject.type == node.type) {
            [lastGroup.nodes addObject:node];
        } else {
            DNodeGroup *group = [[DNodeGroup alloc] init];
            [group.nodes addObject:node];
            [self.nodeGroups addObject:group];
        }
    }
}

@end
