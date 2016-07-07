#import "FBSnapshotBase.h"

// Because we cannot make this an abstract class.
// Source: http://stackoverflow.com/questions/23490133/shared-tests-in-xctest-test-suites - read it!
#define DONT_RUN_TEST_IF_PARENT if ([NSStringFromClass([self class]) isEqualToString:@"FBSnapshotBase"]) { return; }

@implementation FBSnapshotBase : FBSnapshotTestCase

UIViewController *parentViewController;

- (void)setUp {
    self.recordAll = NO;
    
    if (self.backingViewController == nil) {
        NSLog(@"Cannot account for size classes: backingViewController == nil");
    } else {
        parentViewController = [[UIViewController alloc] init];
        [parentViewController addChildViewController:self.backingViewController];
    }
    
    [super setUp];
}

- (void)tearDown {
    parentViewController = nil;
    self.backingViewController = nil;
    
    [super tearDown];
}

- (void)snapshotVerifyView:(UIView*)view {
    DONT_RUN_TEST_IF_PARENT
    
    FBSnapshotVerifyView(view, nil);
}

- (void)testIphone4Portrait {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone4PortraitRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone5Portrait {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone5PortraitRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone6Portrait {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone6PortraitRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone6PlusPortrait {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone6PlusPortraitRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone4Landscape {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone4LandscapeRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassCompact;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone5Landscape {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone5LandscapeRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassCompact;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone6Landscape {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone6LandscapeRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassCompact;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIphone6PlusLandscape {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIphone6PlusLandscapeRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassRegular;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassCompact;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadPortrait {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadPortraitRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassRegular;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadLandscape {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadLandscapeRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassRegular;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadMultitaskingLandscapeTwoToOneMain {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadMultitaskingLandscapeTwoToOneMainRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassRegular;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadMultitaskingLandscapeTwoToOneAlt {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadMultitaskingLandscapeTwoToOneAltRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadMultitaskingLandscapeOneToOneMainAndAlt {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadMultitaskingLandscapeOneToOneMainAndAltRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadMultitaskingPortraitOneToOneMain {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadMultitaskingPortraitOneToOneMainRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)testIpadMultitaskingPortraitOneToOneAlt {
    DONT_RUN_TEST_IF_PARENT
    
    CGRect frame = kIpadMultitaskingPortraitOneToOneAltRect;
    UIUserInterfaceSizeClass *horizontalSizeClass = UIUserInterfaceSizeClassCompact;
    UIUserInterfaceSizeClass *verticalSizeClass = UIUserInterfaceSizeClassRegular;
    
    [self configureSutForFrame:frame withHorizontalSizeClass:horizontalSizeClass withVerticalSizeClass:verticalSizeClass];
    FBSnapshotVerifyView(self.sut, nil);
}

- (void)configureSutForFrame:(CGRect)frame withHorizontalSizeClass:(UIUserInterfaceSizeClass *)horizontalSizeClass withVerticalSizeClass:(UIUserInterfaceSizeClass *)verticalSizeClass {
    
    self.sut.frame = frame;
    
    if (self.backingViewController != nil) {
        UITraitCollection *traitCollectionHorizontal = [UITraitCollection traitCollectionWithHorizontalSizeClass:horizontalSizeClass];
        UITraitCollection *traitCollectionVertical = [UITraitCollection traitCollectionWithVerticalSizeClass:verticalSizeClass];
        
        UITraitCollection *traitCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:[NSArray arrayWithObjects:traitCollectionHorizontal, traitCollectionVertical, nil]];
        [parentViewController setOverrideTraitCollection:traitCollection forChildViewController:self.backingViewController];
    }
    
}

- (NSString *)getReferenceImageDirectoryWithDefault:(NSString *)dir {
    NSString *newDir = [super getReferenceImageDirectoryWithDefault:dir];
    return newDir;
}

@end
