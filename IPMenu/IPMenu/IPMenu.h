//
//  IPMenu.h
//  IPMenu
//
//  Created by Patrick Butkiewicz on 12/16/12.
//  Released under the terms of the MIT License
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IPMenuItem.h"

static const double degreesInCircle = 360.0;
static const double menuButtonOffset = 20.0;
static const double convertDegreesToRadians(const double degrees){ return ((degrees) / 180.0 * M_PI); }
static const double convertRadiansToDegrees(const double radians){ return ((radians) * (180.0 / M_PI)); }
static NSString * kIPMenuHideShowMenuAnimations = @"hideShowMenuAnimationKey";
static NSString * kIPMenuShowMenuAnimation = @"kShowMenuAnimation";
static NSString * kIPMenuHideMenuAnimation = @"kHideMenuAnimation";

// Typedef of possible Positions for the menu to be placed on screen
typedef enum {
    IPMenuPositionTopLeft,
    IPMenuPositionTopMiddle,
    IPMenuPositionTopRight,
    IPMenuPositionSideLeft,
    IPMenuPositionSideRight,
    IPMenuPositionBottomLeft,
    IPMenuPositionBottomMiddle,
    IPMenuPositionBottomRight,
    IPMenuPositionCustom
} IPMenuPosition;

// Protocol Declaration for the Menu's delegate
@class IPMenu;
@protocol IPMenuDelegate <NSObject>
- (void) IPMenu:(IPMenu *)IPMenu didSelectMenuItemAtIndex:(NSInteger)index;
@optional
- (void) IPMenu:(IPMenu *)IPMenu didSelectMenuItem:(IPMenuItem *) menuItem;
- (void) IPMenu:(IPMenu *)IPMenu didFinishHiding:(BOOL)finished;
- (void) IPMenu:(IPMenu *)IPMenu didFinishShowing:(BOOL)finished;
- (NSInteger) customDebugArcAngle;
@end


@interface IPMenu : UIView

// Menu Settings
@property (nonatomic, weak) id<IPMenuDelegate> delegate;
@property (nonatomic) IPMenuPosition menuPosition;
@property (nonatomic) BOOL isShowing;
@property (nonatomic) BOOL buttonsAppearClockwise;
@property (nonatomic) BOOL buttonsContinueSliding;
@property (nonatomic) BOOL useSimpleMenu;

// Arc Drawing Properties
@property (nonatomic) double radius;
@property (nonatomic) double backgroundAlpha;
@property (nonatomic) UIColor *arcBackgroundColor;

// Buttons and Button Settings
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic) double buttonSize;
@property (nonatomic) double buttonOscillationFactor;
@property (nonatomic) double buttonAppearanceTime;
@property (nonatomic) double buttonDisappearanceTime;

// Public Functions
- (void)adjustMenu;
- (void)showMenuWithAnimation:(BOOL)animated;
- (void)hideMenuWithAnimation:(BOOL)animated;
- (void)initializeMenu;
@end
