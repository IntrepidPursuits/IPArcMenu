//
//  IPAppDelegate.h
//  IPMenu
//
//  Created by Patrick Butkiewicz on 12/16/12.
//  Released under the terms of the MIT License
//

#import <UIKit/UIKit.h>

@class IPViewController;

@interface IPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IPViewController *viewController;

@end
