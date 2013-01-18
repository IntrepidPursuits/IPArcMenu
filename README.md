This Project Has Been Moved
=============
-------------

For the most up-to-date code, please visit [our new repository](https://github.com/IntrepidPursuits/IPArcMenu)


IPArcMenu
=============
-------------

IPArcMenu is an iOS drop-in class, inspired by the Path menu system, that provides all the code needed for an elegant menu interface. The class allows the menu to be placed at 8 different places on the iPhone screen. All calculations for drawing, button placement, and animation are handled by the class and require no work on the programmers behalf.

+[![](http://i.imgur.com/9CslH.gif)](http://i.imgur.com/9CslH)
+[![](http://i.imgur.com/hSyo9.gif)](http://i.imgur.com/hSyo9)
+[![](http://i.imgur.com/NrV34.gif)](http://i.imgur.com/NrV34)


------------
Requirements
============

IPArcMenu has been tested on iOS version 5.0, 5.1, and 6.0 and is built using ARC. It depends on the following frameworks, which should already be included with Xcode.

- Foundation.framework
- CoreGraphics.framework
- UIKit.framework
- QuartzCore.framework

You will need LLVM 3.0 or later in order to build IPArcMenu. 

------------------------------------
Adding IPArcMenu to your project
====================================

Source files
------------

The simplest way to add IPArcMenu to your project is to directly add the following files to your project:
- IPArcMenu.h
- IPArcMenu.m
- IPArcMenuItem.h
- IPArcMenuItem.m

To do this you can perform these steps:

1. Download the [latest code](https://github.com/ButkiewiczP/IPArcMenu) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag-and-drop the 4 files listed above into your project. Make sure to select "Copy items into destination's group folder" when asked if the IPArcMenu files weren't extracted to your project's folder.
3. Include IPArcMenu wherever you may need it with '#import "IPArcMenu.h" 


Static library
--------------

Currently, static library building for IPArcMenu is not supported.

-----
Usage
=====

There's an example of using IPArcMenu in the default project. To actually get the menu
working requires very little code as most of the menu's default settings can be used. 

The bare minimum code required to get IPArcMenu functioning is the following:

    IPArcMenu *menu = [[IPArcMenu alloc] initWithFrame:self.view.frame];
    [menu setDelegate:(id<IPArcMenuDelegate>)self];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"menuButton"];
    IPArcMenuItem *menuButton = [[IPArcMenuItem alloc] initWithButtonImage:menuButtonImage];
    [menu setMenuButton:menuButton];
    
    UIImage *buttonImage = [UIImage imageNamed:@"menuItem"];
    IPArcMenuItem *button1 = [[IPArcMenuItem alloc] initWithButtonImage:buttonImage];
    ...
    NSArray *buttonArray = [NSArray arrayWithObjects:button1, ..., nil];
    [menu setButtons:buttonArray];

    [self.view addSubview:menu];
    [menu initializeMenu];

In this instance, the default settings from the IPArcMenu's initWithFrame: are used for the
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

**Project Renamed** on 01/18/2013
**Project Moved** on 01/17/2013
**Initial Working Release** on 01/15/2013