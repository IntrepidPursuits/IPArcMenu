//
//  IPArcMenuItem.h
//  IPMenu
//
//  Created by Patrick Butkiewicz on 12/17/12.
//  Released under the terms of the MIT License
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IPArcMenuItem : UIButton

@property (nonatomic, strong) UIBezierPath *appearancePath;
@property (nonatomic, strong) UIBezierPath *continuousDisappearancePath;
@property (nonatomic, strong) UIBezierPath *reverseDisappearancePath;

@property (nonatomic, assign) CGPoint destinationPointOnArc;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, assign) CGPoint hiddenDestinationPoint;

- (id)initWithButtonImage:(UIImage *)image;
@end
