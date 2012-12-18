//
//  CNDummyContentViewController.m
//  CNBaseView Example
//
//  Created by cocoa:naut on 23.11.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNDummyContentViewController.h"

@interface CNDummyContentViewController ()

@end

@implementation CNDummyContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.layer.backgroundColor = [[self class] NSColorToCGColor:[NSColor controlBackgroundColor]];
    }
    
    return self;
}

+ (CGColorRef)CIColorToCGColor:(CIColor *)ciColor
{
    CGColorSpaceRef colorSpace = [ciColor colorSpace];
    const CGFloat *components = [ciColor components];
    CGColorRef cgColor = CGColorCreate (colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    return cgColor;
}

+ (CGColorRef)NSColorToCGColor:(NSColor *)nsColor
{
    CIColor *ciColor = [[CIColor alloc] initWithColor: nsColor];
    CGColorRef cgColor = ([[self class] CIColorToCGColor:ciColor]);
    return cgColor;
}

@end
