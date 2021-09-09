#import "DFlutterViewController.h"
#import "DStack.h"
#import "DStackPlugin.h"

@interface DFlutterViewController ()

@property (nonatomic, strong, readwrite) DNode *rootNode;

@end

@implementation DFlutterViewController

- (instancetype)initWithDNode:(DNode *)node {
    self = [super initWithEngine:DStack.shared.flutterEngine nibName:nil bundle:nil];
    if (self) {
        _rootNode = node;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self attachToEngine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self attachToEngine];
    DNode *topNode = [DNavigationManager.shared findTopNode:self.rootNode];
    [DStackPlugin.shared activateFlutterNode:topNode];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:^{
        if (completion != nil) completion();
        [self detachFromEngine];
    }];
}

- (void)attachToEngine {
    if (DStack.shared.flutterEngine.viewController != self) {
        DStack.shared.flutterEngine.viewController = self;
    }
}

- (void)detachFromEngine {
    if (DStack.shared.flutterEngine.viewController == self) {
        DStack.shared.flutterEngine.viewController = nil;
    }
}

@end
