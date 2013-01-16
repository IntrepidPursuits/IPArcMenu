IPMenu
=============
-------------

IPMenu is an iOS drop-in class, inspired by the Path menu system, that provides all the code needed for an elegant menu interface. The class allows the menu to be placed at 8 different places on the iPhone screen. All calculations for drawing, button placement, and animation are handled by the class and require no work on the programmers behalf.

+[![](http://i.imgur.com/9CslH.gif)](http://i.imgur.com/9CslH)
+[![](http://i.imgur.com/hSyo9.gif)](http://i.imgur.com/hSyo9)
+[![](http://i.imgur.com/NrV34.gif)](http://i.imgur.com/NrV34)


------------
Requirements
============

IPMenu has been tested on iOS version 5.0, 5.1, and 6.0 and is built using ARC. It depends on the following frameworks, which should already be included with Xcode.

- Foundation.framework
- CoreGraphics.framework
- UIKit.framework
- QuartzCore.framework

You will need LLVM 3.0 or later in order to build IPMenu. 

------------------------------------
Adding IPMenu to your project
====================================

Source files
------------

The simplest way to add IPMenu to your project is to directly add the following files to your project:
- IPMenu.h
- IPMenu.m
- IPMenuItem.h
- IPMenuItem.m

To do this you can perform these steps:

1. Download the [latest code](https://github.com/ButkiewiczP/IPMenu) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag-and-drop the 4 files listed above into your project. Make sure to select "Copy items into destination's group folder" when asked if the IPMenu files weren't extracted to your project's folder.
3. Include IPMenu wherever you may need it with '#import "IPMenu.h" 


Static library
--------------

Currently, static library building for IPMenu is not supported.

-----
Usage
=====

There's an example of using IPMenu in the default project. To actually get the menu
working requires very little code as most of the menu's default settings can be used. 

The bare minimum code required to get IPMenu functioning is the following:

    IPMenu *menu = [[IPMenu alloc] initWithFrame:self.view.frame];
    [menu setDelegate:(id<IPMenuDelegate>)self];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"menuButton"];
    IPMenuItem *menuButton = [[IPMenuItem alloc] initWithButtonImage:menuButtonImage];
    [menu setMenuButton:menuButton];
    
    UIImage *buttonImage = [UIImage imageNamed:@"menuItem"];
    IPMenuItem *button1 = [[IPMenuItem alloc] initWithButtonImage:buttonImage];
    ...
    NSArray *buttonArray = [NSArray arrayWithObjects:button1, ..., nil];
    [menu setButtons:buttonArray];

    [self.view addSubview:menu];
    [menu initializeMenu];

In this instance, the default settings from the IPMenu's initWithFrame: are used for the
menu. At any point if you wish to change the settings on the menu, you MUST call 
[menu initializeMenu] afterwards. initializeMenu reconstructs the show/hide paths for each 
of the buttons.  

-------
License
=======

This code is distributed under the terms and conditions of the MIT license. 

----------
Change-log
==========

**Initial Working Release** on 01/15/2013