IPMenu
=============
-------------

IPMenu is an iOS drop-in class, inspired by the Path menu system, that provides all the code needed for an elegant menu interface. The class allows the menu to be placed at 8 different places on the iPhone screen. All calculations for drawing, button placement, and animation are handled by the class and require no work on the programmers behalf.

[![](http://dl.dropbox.com/u/378729/MBProgressHUD/1-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/1.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/2-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/2.png)
[![](http://dl.dropbox.com/u/378729/MBProgressHUD/3-thumb.png)](http://dl.dropbox.com/u/378729/MBProgressHUD/3.png)

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
1. Download the [latest code](https://github.com/matej/MBProgressHUD/downloads) or add the repository as a git submodule to your git-tracked project.

2. Open your project in Xcode, then drag-and-drop the 4 files listed above into your project. Make sure to select "Copy items into destination's group folder" when asked if the IPMenu files weren't extracted to your project's folder.

3. Include IPMenu wherever you may need it with '#import "IPMenu.h" 


Static library
--------------

Currently static library building for IPMenu is not supported.

-----
Usage
=====

// TODO

-------
License
=======

This code is distributed under the terms and conditions of the MIT license. 

----------
Change-log
==========

**Initial release** on 01/15/2013