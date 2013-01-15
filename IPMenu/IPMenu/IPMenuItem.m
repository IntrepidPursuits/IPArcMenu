//
//  IPMenuItem.m
//  IPMenu
//
//  Created by Patrick Butkiewicz on 12/17/12.
//  Released under the terms of the MIT License
//

#import "IPMenuItem.h"

@implementation IPMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithButtonImage:(UIImage *)image{
    self = [super init];
    if(self){
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self setClipsToBounds:YES];
    [self setContentMode:UIViewContentModeCenter];
}

@end
