//
//  CNBackgroundView.m
//  CNBaseView Example
//
//  Created by cocoa:naut on 24.11.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNBackgroundView.h"

@implementation CNBackgroundView

- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[NSColor controlColor] setFill];
    [path fill];
}

@end
