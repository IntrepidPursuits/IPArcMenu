//
//  IPViewController.m
//  IPMenu
//
//  Created by Patrick Butkiewicz on 12/16/12.
//  Released under the terms of the MIT License
//

#import "IPViewController.h"
#import "IPMenu.h"
#import "IPMenuItem.h"

@interface IPViewController () <IPMenuDelegate>
@property (nonatomic, strong) IPMenu *menu;
@property (assign) NSInteger customDebugAngle;
@end

@implementation IPViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setMenu:[[IPMenu alloc] initWithFrame:self.view.frame]];
    
    // Edit the Menu Settings:
//    [self.menu setArcBackgroundColor:[UIColor blackColor]];
//    [self.menu setBackgroundColor:[UIColor clearColor]];
    [self.menu setButtonAppearanceTime:0.4];
    [self.menu setButtonDisappearanceTime:0.4];
//    [self.menu setButtonsContinueSliding:YES];
//    [self.menu setButtonsAppearClockwise:YES];
//    [self.menu setUseSimpleMenu:NO];
//    [self.menu setRadius:120];

    [self.menu setDelegate:(id<IPMenuDelegate>)self];
    [self.menu setMenuPosition:IPMenuPositionBottomLeft];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"menuButton"];
    IPMenuItem *menuButton = [[IPMenuItem alloc] initWithButtonImage:menuButtonImage];
    [self.menu setMenuButton:menuButton];
    
    // Allocate menu buttons and add them to the menu
    UIImage *buttonImage = [UIImage imageNamed:@"menuItem"];
    IPMenuItem *button1 = [[IPMenuItem alloc] initWithButtonImage:buttonImage];
    IPMenuItem *button2 = [[IPMenuItem alloc] initWithButtonImage:buttonImage];
    IPMenuItem *button3 = [[IPMenuItem alloc] initWithButtonImage:buttonImage];
    IPMenuItem *button4 = [[IPMenuItem alloc] initWithButtonImage:buttonImage];
    IPMenuItem *button5 = [[IPMenuItem alloc] initWithButtonImage:buttonImage];
    
    NSArray *buttonArray = [NSArray arrayWithObjects:button1, button2, button3, button4, button5, nil];
    [self.menu setButtons:buttonArray];
    
    // Add the menu as a subview and initialize it
    [self.view addSubview:self.menu];
    [self.menu initializeMenu];
    
    // Debugging Properties
    [self setCustomDebugAngle:359.0];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Debugging Helper Functions

- (IBAction)ChangePosition:(id)sender {
  if(self.menu.menuPosition == IPMenuPositionCustom){
    [self.menu setMenuPosition:IPMenuPositionBottomLeft];
  }else if(self.menu.menuPosition == IPMenuPositionBottomLeft){
    [self.menu setMenuPosition:IPMenuPositionBottomMiddle];
  }else if(self.menu.menuPosition == IPMenuPositionBottomMiddle){
    [self.menu setMenuPosition:IPMenuPositionBottomRight];
  }else if(self.menu.menuPosition == IPMenuPositionBottomRight){
    [self.menu setMenuPosition:IPMenuPositionSideLeft];
  }else if(self.menu.menuPosition == IPMenuPositionSideLeft){
    [self.menu setMenuPosition:IPMenuPositionSideRight];
  }else if(self.menu.menuPosition == IPMenuPositionSideRight){
    [self.menu setMenuPosition:IPMenuPositionTopLeft];
  }else if(self.menu.menuPosition == IPMenuPositionTopLeft){
    [self.menu setMenuPosition:IPMenuPositionTopMiddle];
  }else if(self.menu.menuPosition == IPMenuPositionTopMiddle){
    [self.menu setMenuPosition:IPMenuPositionTopRight];
  }else if(self.menu.menuPosition == IPMenuPositionTopRight){
    [self.menu setMenuPosition:IPMenuPositionCustom];
  }
    
    [self.menu initializeMenu]; // Reconstructs the button paths and arc drawing

}

#pragma mark - IPMenu Delegate Functions

- (void) IPMenu:(IPMenu *)IPMenu didSelectMenuItemAtIndex:(NSInteger)index{
    NSLog(@"Selected Menu Index %d", index);
}

- (void) IPMenu:(IPMenu *)IPMenu didSelectMenuItem:(const IPMenuItem *)menuItem{
    NSLog(@"Did Select Menu item %@", menuItem);
}

- (void) IPMenu:(IPMenu *)IPMenu didFinishHiding:(BOOL)finished{
    if(finished)
        NSLog(@"Delegate: Did Finish Hiding");
}

- (void) IPMenu:(IPMenu *)IPMenu didFinishShowing:(BOOL)finished{
    if(finished)
        NSLog(@"Delegate: Did Finish Showing");
}

// Debug delegate function that returns an arbitrary angle used to experiment :)
- (NSInteger)customDebugArcAngle{
  return self.customDebugAngle;
}

@end
