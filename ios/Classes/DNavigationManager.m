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
@property (nonatomic, strong, readonly) NSMapTable<NSString *, UIViewController *> *weakControllers;

@end

@implementation DNodeGroup

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nodes = [[NSMutableArray alloc] init];
        _weakControllers = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                                     valueOptions:NSPointerFunctionsWeakMemory
                                                         capacity:0];
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
        [group.weakControllers setObject:viewController forKey:node.identifier];

        UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
        [navigation pushViewController:viewController animated:YES];
    } else {
        if (group.weakControllers.count == 0) {
            UIViewController *viewController = [[DFlutterViewController alloc] initWithDNode:node];
            [group.weakControllers setObject:viewController forKey:node.identifier];

            UINavigationController *navigation = UIApplication.sharedApplication.keyWindow.rootViewController;
            [navigation pushViewController:viewController animated:YES];
        } else {
            [DStackPlugin.shared activateFlutterNode:node];
        }
    }
}

- (void)pop {
    // TODO nodeGroups empty
    DNodeGroup *lastGroup = self.nodeGroups.lastObject;
    DNode *lastNode = lastGroup.nodes.lastObject;

    if (lastNode.type == kTypeNative    // native popTo native/flutter or OUTSIDE
        || lastGroup.nodes.count == 1   // last flutter popTo native or OUTSIDE
    ) {
        UIViewController *weakController = [lastGroup.weakControllers objectForKey:lastNode.identifier];
        [lastGroup.nodes removeObject:lastNode];
        if (lastGroup.nodes.count == 0) {
            [self.nodeGroups removeObject:lastGroup];
        }
        if (weakController != nil) {
            [lastGroup.weakControllers removeObjectForKey:lastNode.identifier];
            [weakController.navigationController popViewControllerAnimated:YES];
        }
    } else {
        // flutter popTo flutter
        DNode *preNode = lastGroup.nodes[lastGroup.nodes.count - 2];
        [lastGroup.nodes removeObject:lastNode];
        // TODO removeFlutterNodes:lastNode;
        [DStackPlugin.shared activateFlutterNode:preNode];
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
