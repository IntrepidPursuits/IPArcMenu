//
//  IPMenu.m
//  IPMenu
//
//  Created by Patrick Butkiewicz on 12/16/12.
//  Released under the terms of the MIT License
//

#import "IPArcMenu.h"

@implementation IPArcMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Button and Menu Default Settings
        _isShowing = NO;
        _buttonsAppearClockwise = YES;              // Buttons appear from the clockwise direction
        _buttonsContinueSliding = YES;              // Buttons continue their sliding path on hide
        _useSimpleMenu = NO;                        // Use the Curved Style Menu w/Sliding Buttons
        _buttonSize = 32.0;                         // Size of the frame that menu items are placed in
        _buttonAppearanceTime = 0.4;                // Time the appearance animation takes
        _buttonDisappearanceTime = 0.4;             // Time the disappearance animation takes
        _menuPosition = IPMenuPositionTopLeft;  // Position that the menu is placed at
        _buttonOscillationFactor = 2.0;             // Factor for the buttons to construct 'rocking' paths
        
        // Arc Drawing Properties
        _radius = 120.0;                            // Radius of the arc
        _backgroundAlpha = 0.8;                     // Alpha of the background color
        _arcBackgroundColor = [UIColor blackColor]; // Background color of the arc
        
        // UIView Propertys
        [self setBackgroundColor:[UIColor clearColor]]; // Because the menu technically covers the whole window
        [self setAlpha:0.0];
        
    }
    return self;
}

- (void)initializeMenu{
    [self setupMenuItems];
    [self setupMenuButton];
    [self setNeedsDisplay];
}

#pragma mark - Drawing Functions

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, self.backgroundAlpha);
    CGContextSetStrokeColorWithColor(context, self.arcBackgroundColor.CGColor);
    CGContextSetFillColorWithColor(context, self.arcBackgroundColor.CGColor);
    
    CGPoint origin = [self originPoint];
    
    CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextAddArc(context,
                    origin.x,
                    origin.y,
                    self.radius,
                    convertDegreesToRadians((self.buttonsAppearClockwise) ? [self startingAngle] : [self endingAngle]),
                    convertDegreesToRadians((self.buttonsAppearClockwise) ? [self endingAngle] : [self startingAngle]),
                    (self.buttonsAppearClockwise) ? 0 : 1);
    
    CGContextFillPath(context);
}

// Uses the starting and ending angles to create UIBezierPaths for each IPArcMenuItem
//   The UIBezierPath's are stored as a property of the IPArcMenuItem
- (void)setupMenuItems{
    if(self.buttons.count == 0) return;
    
    // The change in degrees between buttons on the arc
    double changeInAngle = [self degreesInArc] / (self.buttons.count + 1);
    
    // Angle (in degrees) where the arc begins
    double startAngle = (self.buttonsAppearClockwise) ? [self startingAngle] : [self endingAngle];
    double endAngle = (self.buttonsAppearClockwise) ? [self endingAngle] : [self startingAngle];
    
    // Angle which will be used to place buttons along the arc
    double buttonDestinationAngle = startAngle;
    double hiddenOriginAngle = startAngle;
    double hiddenDestinationAngle = endAngle;
    
    // Point which defines the center of the 'circle' used by the arc
    CGPoint centerPointOfCircle = [self originPoint];
    
    // Apples unit circle is flipped to match the flipped coordinates. This sets destination/origin angles appropriately
    if(self.buttonsAppearClockwise){
        hiddenOriginAngle = fmodf((startAngle - changeInAngle), degreesInCircle);
        hiddenDestinationAngle = fmodf((endAngle + changeInAngle), degreesInCircle);
    }else{
        hiddenOriginAngle = fmodf((startAngle + changeInAngle), degreesInCircle);
        hiddenDestinationAngle = fmodf((endAngle - changeInAngle), degreesInCircle);
    }
    
    for (IPArcMenuItem *menuItem in self.buttons) {
        [menuItem setFrame:CGRectMake(0, 0, self.buttonSize, self.buttonSize)];
        
        if(self.buttonsAppearClockwise)
            buttonDestinationAngle = fmodf((buttonDestinationAngle + changeInAngle), degreesInCircle);
        else
            buttonDestinationAngle = fmodf((buttonDestinationAngle - changeInAngle), degreesInCircle);
        
        // CGPoint on the arc which the button will end at after 'showing'
        [menuItem setDestinationPointOnArc:CGPointMake(centerPointOfCircle.x + (cos(convertDegreesToRadians(buttonDestinationAngle)) * self.radius),
                                                       centerPointOfCircle.y + (sin(convertDegreesToRadians(buttonDestinationAngle)) * self.radius))];
        
        // CGPoint on the arc which the button will slide to in order to 'hide'
        [menuItem setHiddenDestinationPoint:CGPointMake(centerPointOfCircle.x + (cos(convertDegreesToRadians(hiddenDestinationAngle)) * self.radius),
                                                        centerPointOfCircle.y + (sin(convertDegreesToRadians(hiddenDestinationAngle)) * self.radius))];
        
        // CGPoint on the arc which the button will begin its path from to 'show'
        [menuItem setOriginPoint:CGPointMake(centerPointOfCircle.x + (cos(convertDegreesToRadians(hiddenOriginAngle)) * self.radius),
                                             centerPointOfCircle.y + (sin(convertDegreesToRadians(hiddenOriginAngle)) * self.radius))];
        
        if (self.useSimpleMenu)
            [menuItem setCenter:[self originPointForMenuButton]];
        else
            [menuItem setCenter:menuItem.originPoint];
        
        // Setup the path for buttons to appear along
        UIBezierPath *appearancePath = [UIBezierPath bezierPath];
        double limit = 0.5;
        double currentFactor = self.buttonOscillationFactor;
        double newerAngle = 0;
        double lastAngle = hiddenOriginAngle;
        BOOL usePositive = YES;
        
        // Creates the harmonic rocking effect along the appearance path.
        while (fabs(currentFactor) >= limit){
            if(usePositive){
                if(self.buttonsAppearClockwise) newerAngle = buttonDestinationAngle + currentFactor; else newerAngle = buttonDestinationAngle - currentFactor;
            }else{
                if(self.buttonsAppearClockwise) newerAngle = buttonDestinationAngle - currentFactor; else newerAngle = buttonDestinationAngle + currentFactor;
            }
            
            [appearancePath addArcWithCenter:centerPointOfCircle
                                      radius:self.radius
                                  startAngle:convertDegreesToRadians(lastAngle)
                                    endAngle:convertDegreesToRadians(newerAngle)
                                   clockwise:(usePositive) ? self.buttonsAppearClockwise : !self.buttonsAppearClockwise];
            
            usePositive = !usePositive;
            lastAngle = newerAngle;
            currentFactor = currentFactor / 2.0;
        }
        
        [menuItem setAppearancePath:appearancePath];
        
        // Setup the path for buttons to disappear along.
        UIBezierPath *continuousDisappearancePath = [UIBezierPath bezierPath];
        UIBezierPath *reverseDisappearancePath = [UIBezierPath bezierPath];
        
        [continuousDisappearancePath addArcWithCenter:centerPointOfCircle
                                               radius:self.radius
                                           startAngle:convertDegreesToRadians(buttonDestinationAngle)
                                             endAngle:convertDegreesToRadians(hiddenDestinationAngle)
                                            clockwise:self.buttonsAppearClockwise];
        
        [reverseDisappearancePath addArcWithCenter:centerPointOfCircle
                                            radius:self.radius
                                        startAngle:convertDegreesToRadians(buttonDestinationAngle)
                                          endAngle:convertDegreesToRadians(hiddenOriginAngle)
                                         clockwise:!self.buttonsAppearClockwise];
        
        
        [menuItem setContinuousDisappearancePath:continuousDisappearancePath];
        [menuItem setReverseDisappearancePath:reverseDisappearancePath];
        
        // Add Menu's target to self. self.didPressMenuItem will handle reporting back to the delegate
        [menuItem addTarget:self action:@selector(didPressMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        
        // Finally add the button as a subview of the menu
        [self addSubview:menuItem];
    }
    
}

- (void) setupMenuButton{
    // Setup the menu button
    
    if(!_menuButton){
        IPArcMenuItem *newMenuButton = [[IPArcMenuItem alloc] init];
        _menuButton = newMenuButton;
    }
    
    [_menuButton setFrame:[self CGRectFromPoint:[self originPointForMenuButton] withSize:self.buttonSize]];
    [_menuButton addTarget:self action:@selector(adjustMenu) forControlEvents:UIControlEventTouchUpInside];
    
    // Add menu button to view
    if(self.menuButton.superview == nil){
        [self.superview addSubview:_menuButton];
        [self.superview bringSubviewToFront:_menuButton];
    }
}

#pragma mark - Menu Delegate Handler Functions

- (void) didPressMenuItem:(IPArcMenuItem *)menuItem{
    
    [self specialHideCurveMenuWithMenuItem:menuItem];
    
    // Report button touch back to the delegate
    if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didSelectMenuItemAtIndex:)]){
        [self.delegate IPArcMenu:self didSelectMenuItemAtIndex:[self.buttons indexOfObject:menuItem]];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didSelectMenuItem:)]){
        [self.delegate IPArcMenu:self didSelectMenuItem:menuItem];
    }
    
}

// TODO: CAAnimation Delegate Functions
//- (void)animationDidStart:(CAAnimation *)anim{
//
//
//}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//
//}

#pragma mark - Public Hide/Show Functions

- (void)adjustMenu{
    if(self.isShowing){
        [self hideMenuWithAnimation:YES];
    }else{
        [self showMenuWithAnimation:YES];
    }
}

- (void)showMenuWithAnimation:(BOOL)animated{
    if(self.useSimpleMenu){
        [self showSimpleMenuWithAnimation:animated];
    }else{
        [self showCurveMenuWithAnimation:animated];
    }
}

- (void)hideMenuWithAnimation:(BOOL)animated{
    if(self.useSimpleMenu){
        [self hideSimpleMenuWithAnimation:animated];
    }else{
        [self hideCurveMenuWithAnimation:animated];
    }
}

#pragma mark - Private Hide/Show Functions

// Hide/Show Functions for the 'curved' menu type
- (void) showCurveMenuWithAnimation:(BOOL)animated{
    
    if(animated){ // Animated Show
        
        int showCount = 0;
        double trueShowTime = self.buttonAppearanceTime * ((self.buttons.count > 5) ? 5 : self.buttons.count);
        [CATransaction begin];
        for (IPArcMenuItem *menuItem in self.buttons) {
            CALayer *buttonlayer = menuItem.layer;
            [buttonlayer removeAllAnimations];
            [self.layer addSublayer:buttonlayer];
            
            // Animations to Show and Move along path
            CAKeyframeAnimation *buttonPositionAnimation = [self positionAnimationWithPath:menuItem.appearancePath];
            CABasicAnimation *buttonAlphaAnimation =  [self opacityAnimationWithOpacity:1.0];
            
            // Animation Group
            CAAnimationGroup *buttonAnimationGroup = [CAAnimationGroup animation];
            [buttonAnimationGroup setDuration:(trueShowTime / ++showCount)];
            [buttonAnimationGroup setRemovedOnCompletion:NO];
            [buttonAnimationGroup setFillMode:kCAFillModeForwards];
            [buttonAnimationGroup setAnimations:[NSArray arrayWithObjects:buttonPositionAnimation, buttonAlphaAnimation, nil]];
            [buttonAnimationGroup setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [buttonlayer addAnimation:buttonAnimationGroup forKey:kIPMenuHideMenuAnimation];
            [self.layer addSublayer:buttonlayer];
            [buttonlayer setPosition:menuItem.destinationPointOnArc];
        }
        [CATransaction commit];
        
        // Show Menu Animation
        // TODO: Convert to Core-Animation?
        // Currently not core-animation because of an issue where no menu buttons
        // were able to be touched if the animation set opacity
        [UIView animateWithDuration:self.buttonAppearanceTime animations:^(void){
            [self setAlpha:1.0];
        }completion:^(BOOL finished) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didFinishShowing:)])
                [self.delegate IPArcMenu:self didFinishShowing:finished];
        }];
        
    }else{  // Non-Animated Show
        for (IPArcMenuItem *menuItem in self.buttons) {
            [menuItem setCenter:menuItem.destinationPointOnArc];
        }
        [self setAlpha:1.0];
    }
    
    [self setIsShowing:YES];
    
}

- (void) hideCurveMenuWithAnimation:(BOOL)animated{
    
    if(animated){   // Animated Hide
        for (IPArcMenuItem *menuItem in self.buttons) {
            CALayer *buttonlayer = menuItem.layer;
            
            // Animation to move button position along path
            CAKeyframeAnimation *buttonPositionAnimation;
            if(self.buttonsContinueSliding){
                buttonPositionAnimation = [self positionAnimationWithPath:menuItem.continuousDisappearancePath];
            }else{
                buttonPositionAnimation = [self positionAnimationWithPath:menuItem.reverseDisappearancePath];
            }
            //Animation to hide the button
            CABasicAnimation *buttonAlphaAnimation =  [self opacityAnimationWithOpacity:0.0];
            
            // Animation Group
            CAAnimationGroup *buttonAnimationGroup = [CAAnimationGroup animation];
            [buttonAnimationGroup setDuration:self.buttonDisappearanceTime];
            [buttonAnimationGroup setRemovedOnCompletion:NO];
            [buttonAnimationGroup setFillMode:kCAFillModeForwards];
            [buttonAnimationGroup setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [buttonAnimationGroup setAnimations:[NSArray arrayWithObjects:buttonPositionAnimation, buttonAlphaAnimation, nil]];
            [buttonlayer addAnimation:buttonAnimationGroup forKey:kIPMenuHideMenuAnimation];
            [self.layer addSublayer:buttonlayer];
            [buttonlayer setPosition:menuItem.hiddenDestinationPoint];
        }
        
        [UIView animateWithDuration:self.buttonDisappearanceTime animations:^(void){
            [self setAlpha:0];
        }completion:^(BOOL finished) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didFinishHiding:)])
                [self.delegate IPArcMenu:self didFinishHiding:finished];
        }];
        
    }else{  // Non-Animated Hide
        
        for (IPArcMenuItem *menuItem in self.buttons) {
            [menuItem setCenter:menuItem.originPoint];
        }
        [self setAlpha:0];
        
    }
    
    [self setIsShowing:NO];
    
}

- (void) specialHideCurveMenuWithMenuItem:(IPArcMenuItem *)menuItem{
    BOOL selectedButtonFound = NO;
    
    for (IPArcMenuItem *button in self.buttons) {
        CALayer *buttonLayer = button.layer;
        CAAnimationGroup *buttonAnimationGroup = [CAAnimationGroup animation];
        CAKeyframeAnimation *buttonPositionAnimation = [CAKeyframeAnimation animation];
        CABasicAnimation *shrinkAnimation = [self shrinkAnimation];
        
        if([button isEqual:menuItem]){
            [buttonLayer addAnimation:[self blowupAnimationGroup] forKey:kIPMenuHideShowMenuAnimations];
            [buttonLayer setPosition:button.originPoint];
            selectedButtonFound = YES;
        }else{
            if(selectedButtonFound){
                buttonPositionAnimation = [self positionAnimationWithPath:button.continuousDisappearancePath];
            }else{
                buttonPositionAnimation = [self positionAnimationWithPath:button.reverseDisappearancePath];
            }
            
            buttonAnimationGroup = [CAAnimationGroup animation];
            [buttonAnimationGroup setDuration:self.buttonDisappearanceTime];
            [buttonAnimationGroup setRemovedOnCompletion:NO];
            [buttonAnimationGroup setFillMode:kCAFillModeForwards];
            [buttonAnimationGroup setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [buttonAnimationGroup setAnimations:[NSArray arrayWithObjects:buttonPositionAnimation, shrinkAnimation, nil]];
            
            [buttonLayer addAnimation:buttonAnimationGroup forKey:kIPMenuHideShowMenuAnimations];
            [self.layer addSublayer:buttonLayer];
            [buttonLayer setPosition:menuItem.hiddenDestinationPoint];
        }
    }
    
    [UIView animateWithDuration:self.buttonDisappearanceTime animations:^(void){
        [self setAlpha:0];
    }completion:^(BOOL finished) {
        [self setIsShowing:NO];
        if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didFinishHiding:)])
            [self.delegate IPArcMenu:self didFinishHiding:finished];
    }];
    
}

// Hide/Show Functions for 'simple' menu type
- (void) showSimpleMenuWithAnimation:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:self.buttonAppearanceTime animations:^(void){
            for (IPArcMenuItem *button in self.buttons) {
                [button setAlpha:1.0];
                [button setCenter:button.destinationPointOnArc];
            }
            [self setAlpha:1.0];
        }completion:^(BOOL finished) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didFinishShowing:)])
                [self.delegate IPArcMenu:self didFinishShowing:finished];
        }];
        
    }else{
        for (IPArcMenuItem *button in self.buttons) {
            [button setAlpha:1.0];
            [button setCenter:button.destinationPointOnArc];
        }
        [self setAlpha:1.0f];
    }
    
    [self setIsShowing:YES];
}

- (void) hideSimpleMenuWithAnimation:(BOOL)animated{
    if(animated){
        [UIView animateWithDuration:self.buttonDisappearanceTime animations:^(void){
            for (IPArcMenuItem *button in self.buttons) {
                [button setAlpha:0];
                [button setCenter:[self originPointForMenuButton]];
            }
            [self setAlpha:0];
        }completion:^(BOOL finished) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(IPMenu:didFinishHiding:)])
                [self.delegate IPArcMenu:self didFinishHiding:finished];
        }];
    }else{
        for(IPArcMenuItem *button in self.buttons){
            [button setAlpha:0.0];
            [button setCenter:[self originPointForMenuButton]];
        }
        [self setAlpha:0.0];
    }
    
    [self setIsShowing:NO];
    
}

#pragma mark - Calculation Helper Functions

- (double) degreesInArc{
    switch (self.menuPosition) {
        case IPMenuPositionBottomLeft:
        case IPMenuPositionBottomRight:
        case IPMenuPositionTopLeft:
        case IPMenuPositionTopRight:
            return 90.0;
            break;
        case IPMenuPositionBottomMiddle:
        case IPMenuPositionSideLeft:
        case IPMenuPositionSideRight:
        case IPMenuPositionTopMiddle:
            return 180.0;
            break;
        case IPMenuPositionCustom:
            return [self.delegate customDebugArcAngle];
            break;
        default:
            return 90.0;
            break;
    }
}

#pragma mark - Position and Angle Helper Functions

- (double) startingAngle{
    switch (self.menuPosition) {
        case IPMenuPositionSideLeft:
        case IPMenuPositionBottomLeft:
            return 270.0;
            break;
        case IPMenuPositionBottomMiddle:
        case IPMenuPositionBottomRight:
            return 180.0;
            break;
        case IPMenuPositionTopRight:
        case IPMenuPositionSideRight:
            return 90.0;
            break;
        case IPMenuPositionTopLeft:
        case IPMenuPositionTopMiddle:
        case IPMenuPositionCustom:
            return 0;
        default:
            break;
    }
}

- (double) endingAngle{
    switch (self.menuPosition) {
        case IPMenuPositionBottomLeft:
        case IPMenuPositionBottomMiddle:
            return 0;
            break;
        case IPMenuPositionBottomRight:
        case IPMenuPositionSideRight:
            return 270.0;
            break;
        case IPMenuPositionSideLeft:
        case IPMenuPositionTopLeft:
            return 90.0;
            break;
        case IPMenuPositionTopMiddle:
        case IPMenuPositionTopRight:
            return 180.0;
            break;
        case IPMenuPositionCustom:
            return [self.delegate customDebugArcAngle];
            break;
        default:
            break;
    }
}

- (CGPoint) originPoint{
    double midYPoint = CGRectGetMidY(self.bounds);
    double midXPoint = CGRectGetMidX(self.bounds);
    double windowHeight = self.bounds.size.height;
    double windowWidth = self.bounds.size.width;
    
    switch (self.menuPosition) {
        case IPMenuPositionBottomLeft:
            return CGPointMake(0, windowHeight);
            break;
        case IPMenuPositionBottomMiddle:
            return CGPointMake(midXPoint, windowHeight);
            break;
        case IPMenuPositionBottomRight:
            return CGPointMake(windowWidth, windowHeight);
            break;
        case IPMenuPositionSideLeft:
            return CGPointMake(0, midYPoint);
            break;
        case IPMenuPositionSideRight:
            return CGPointMake(windowWidth, midYPoint);
            break;
        case IPMenuPositionTopLeft:
            return CGPointMake(0, 0);
            break;
        case IPMenuPositionTopMiddle:
            return CGPointMake(midXPoint, 0);
            break;
        case IPMenuPositionTopRight:
            return CGPointMake(windowWidth, 0);
            break;
        case IPMenuPositionCustom:
            return CGPointMake(windowWidth/2, windowHeight/2);
            break;
        default:
            break;
    }
}

// Function returns the CGPoint at which the center of the menu button
- (CGPoint) originPointForMenuButton{
    CGPoint menuButtonPoint = [self originPoint];
    switch (self.menuPosition) {
        case IPMenuPositionBottomLeft:
            return CGPointMake(menuButtonPoint.x + menuButtonOffset, menuButtonPoint.y - menuButtonOffset);
            break;
        case IPMenuPositionBottomMiddle:
            return CGPointMake(menuButtonPoint.x, menuButtonPoint.y - menuButtonOffset);
            break;
        case IPMenuPositionBottomRight:
            return CGPointMake(menuButtonPoint.x - menuButtonOffset, menuButtonPoint.y - menuButtonOffset);
            break;
        case IPMenuPositionSideLeft:
            return CGPointMake(menuButtonPoint.x + menuButtonOffset, menuButtonPoint.y);
            break;
        case IPMenuPositionSideRight:
            return CGPointMake(menuButtonPoint.x - menuButtonOffset, menuButtonPoint.y);
            break;
        case IPMenuPositionTopLeft:
            return CGPointMake(menuButtonPoint.x + menuButtonOffset, menuButtonPoint.y + menuButtonOffset);
            break;
        case IPMenuPositionTopMiddle:
            return CGPointMake(menuButtonPoint.x, menuButtonPoint.y + menuButtonOffset);
            break;
        case IPMenuPositionTopRight:
            return CGPointMake(menuButtonPoint.x - menuButtonOffset, menuButtonPoint.y + menuButtonOffset);
            break;
        case IPMenuPositionCustom:
            return CGPointMake(menuButtonPoint.x, menuButtonPoint.y);
        default:
            break;
    }
}

- (CGRect) CGRectFromPoint:(CGPoint)p withSize:(double)size{
    return CGRectMake(p.x - (size/2.0), p.y - (size/2.0), size, size);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // If the hitView in THIS view, return nil and allow hitTest:withEvent: to
    // continue traversing the hierarchy to find the underlying view.
    if (hitView == self) {
        return nil;
    }
    // else return the hitView (ie one of this view's buttons)
    return hitView;
}

#pragma mark - CAAnimation Helper Functions

- (CAKeyframeAnimation *)positionAnimationWithPath:(UIBezierPath *)path{
    
    CAKeyframeAnimation *buttonAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [buttonAnimation setRemovedOnCompletion:NO];
    [buttonAnimation setFillMode:kCAFillModeForwards];
    [buttonAnimation setPath:path.CGPath];
    [buttonAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    return buttonAnimation;
}

- (CABasicAnimation *)opacityAnimationWithOpacity:(double)alpha{
    
    CABasicAnimation* buttonFadeAnimation =  [CABasicAnimation animationWithKeyPath:@"alpha"];
    [buttonFadeAnimation setRemovedOnCompletion:NO];
    [buttonFadeAnimation setFillMode:kCAFillModeForwards];
    [buttonFadeAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [buttonFadeAnimation setToValue:[NSNumber numberWithFloat:alpha]];
    
    return buttonFadeAnimation;
}

- (CABasicAnimation *)shrinkAnimation{
    
    CABasicAnimation *buttonScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [buttonScaleAnimation setRemovedOnCompletion:NO];
    [buttonScaleAnimation setFillMode:kCAFillModeForwards];
    [buttonScaleAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [buttonScaleAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)]];
    
    return buttonScaleAnimation;
}

- (CAAnimationGroup *)blowupAnimationGroup{
    CABasicAnimation *opacityAnimation = [self opacityAnimationWithOpacity:0.0];
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [scaleAnimation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)]];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:[NSArray arrayWithObjects: scaleAnimation, opacityAnimation, nil]];
    [animationGroup setDuration:self.buttonDisappearanceTime];
    [animationGroup setFillMode:kCAFillModeForwards];
    [animationGroup setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    return animationGroup;
}

@end