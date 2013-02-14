//
//  CNBaseView.m
//
//  Created by cocoa:naut on 23.07.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2012 Frank Gregor, <phranck@cocoanaut.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the “Software”), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import <QuartzCore/QuartzCore.h>
#import "CNBaseView.h"


#if MAC_OS_X_VERSION_MIN_REQUIRED <= MAC_OS_X_VERSION_10_7
@interface NSColor (CNBaseView)
+ (CGColorRef)CIColorToCGColor:(CIColor *)ciColor;
- (CGColorRef)CGColor;
@end

@implementation NSColor (CNBaseView)
+ (CGColorRef)CIColorToCGColor:(CIColor *)ciColor
{
    CGColorSpaceRef colorSpace = [ciColor colorSpace];
    const CGFloat *components = [ciColor components];
    CGColorRef cgColor = CGColorCreate (colorSpace, components);
    CGColorSpaceRelease(colorSpace);
    return cgColor;
}

- (CGColorRef)CGColor
{
    CIColor *ciColor = [[CIColor alloc] initWithColor: self];
    CGColorRef cgColor = [NSColor CIColorToCGColor: ciColor];
    return cgColor;
}
@end
#endif



static const CGFloat animationDuration = 0.30f;
static const CGFloat kDefaultTextboxWidth = 180.0f;
static const CGFloat kDefaultIconVerticalOffset = 10.0f;
static const CGFloat kDefaultIconTextMargin = 10.0f;

static NSColor *defaultTextColor, *defaultShadowColor;
static NSFont *defaultTextFont;

@interface CNBaseView () {
    NSDictionary *_textBoxAttributes;
    NSMutableArray *_childViewStack;
    BOOL _isAnimating;
}
@property (assign, nonatomic) CGRect calculatedTextBoxRect;

- (void)commonConfiguration;
- (NSRect)frameForView:(NSView *)theView withAnimationEffect:(CNChildViewAnimationEffect)effect;
- (BOOL)hasIcon;
-  (BOOL)hasText;
@end

@implementation CNBaseView

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization

+ (void)initialize
{
    defaultTextColor = [NSColor lightGrayColor];
    defaultShadowColor = [NSColor whiteColor];
    defaultTextFont = [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.0f];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonConfiguration];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonConfiguration];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonConfiguration];
    }
    return self;
}

- (id)initWithIcon:(NSImage *)icon text:(NSString *)text
{
    self = [self init];
    if (self) {
        _icon = icon;
        _text = text;
    }
    return self;
}

- (id)initWithIcon:(NSImage *)icon attributedText:(NSAttributedString *)attributedText
{
    self = [self init];
    if (self) {
        _icon = icon;
        _attributedText = attributedText;
    }
    return self;
}

- (void)commonConfiguration
{
    [self setWantsLayer:YES];

    _icon = nil;
    _textBoxWidth = kDefaultTextboxWidth;
    _iconVerticalOffset = kDefaultIconVerticalOffset;
    _iconTextMargin =  kDefaultIconTextMargin;
    _preventDrawingWithSubviews = YES;
    _childViewStack = [NSMutableArray array];
    _isAnimating = NO;
    _text = @"";

    /// the text box
    NSShadow *textShadow = [[NSShadow alloc] init];
    [textShadow setShadowColor: defaultShadowColor];
    [textShadow setShadowOffset: NSMakeSize(0, -1)];

    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSCenterTextAlignment];

    _calculatedTextBoxRect = NSZeroRect;

    /// default text attributes
    _textBoxAttributes = @{
        NSFontAttributeName :               defaultTextFont,
        NSForegroundColorAttributeName :    defaultTextColor,
        NSShadowAttributeName :             textShadow,
        NSParagraphStyleAttributeName :     textStyle,
        NSKernAttributeName :               @0.95f
    };

    _backgroundColor = [NSColor clearColor];
    self.layer.backgroundColor = [_backgroundColor CGColor];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Acessors

- (void)setText:(NSString *)theText
{
    if (![_text isEqualToString:theText]) {
        _text = nil;
        _text = (theText == nil ? @"" : theText);
        _attributedText = [[NSAttributedString alloc] initWithString:_text attributes:_textBoxAttributes];
        [self setNeedsDisplay:YES];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if (attributedText != nil && ![_text isEqualToString:attributedText.string]) {
        _attributedText = nil;
        _attributedText = attributedText;
        _text = _attributedText.string;
        _textBoxAttributes = [_attributedText attributesAtIndex:0 effectiveRange:NULL];
        [self setNeedsDisplay:YES];
    }
}

- (void)setTextBoxWidth:(CGFloat)textBoxWidth
{
    if (_textBoxWidth != textBoxWidth) {
        _textBoxWidth = textBoxWidth;
        [self setNeedsDisplay:YES];
    }
}

- (CGRect)calculatedTextBoxRect
{
    if (_text != nil && ![_text isEqualToString:@""]) {
        _calculatedTextBoxRect = [_text boundingRectWithSize:NSMakeSize(_textBoxWidth, 0)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:_textBoxAttributes];
    }
    return _calculatedTextBoxRect;
}

- (void)setIconVerticalOffset:(CGFloat)iconVerticalOffset
{
    if (_iconVerticalOffset != iconVerticalOffset) {
        _iconVerticalOffset = iconVerticalOffset;
        [self setNeedsDisplay:YES];
    }
}

- (void)setIconTextMargin:(CGFloat)iconTextMargin
{
    if (_iconTextMargin != iconTextMargin) {
        _iconTextMargin = iconTextMargin;
        [self setNeedsDisplay:YES];
    }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.layer.backgroundColor = [backgroundColor CGColor];
    [self.layer setNeedsDisplay];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Helper

- (NSRect)frameForView:(NSView *)theView withAnimationEffect:(CNChildViewAnimationEffect)effect
{
    NSRect frame = self.bounds;
    switch (effect) {
        case CNChildViewAnimationEffectSlideTop:    frame.origin.y = NSMaxY(self.frame) - [[self window] contentBorderThicknessForEdge:NSMaxYEdge]; break;
        case CNChildViewAnimationEffectSlideRight:  frame.origin.x = NSMaxX(self.frame); break;
        case CNChildViewAnimationEffectSlideBottom: frame.origin.y = NSMinY(self.frame) - NSHeight(self.frame) - [[self window] contentBorderThicknessForEdge:NSMinYEdge]; break;
        case CNChildViewAnimationEffectSlideLeft:   frame.origin.x = NSMinX(self.frame) - NSWidth(self.frame); break;
        default:
            break;
    }
    return frame;
}

- (BOOL)hasIcon
{
    return self.icon != nil;
}

-  (BOOL)hasText
{
    return (self.text != nil && ![self.text isEqualToString:@""]);
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSView

- (void)drawRect:(NSRect)rect
{
    if ([[self subviews] count] > 0 && self.preventDrawingWithSubviews && !_isAnimating)
        return;

    NSRect dirtyRect = self.bounds;
    CGFloat textBoxOriginX = (NSWidth(dirtyRect) - NSWidth(self.calculatedTextBoxRect)) / 2;
    CGFloat textBoxOriginY = NSNotFound;

    CGRect imageRect = CGRectZero;
    if ([self hasIcon]  && [self hasText]) {
        imageRect = NSMakeRect((dirtyRect.size.width - self.icon.size.width) / 2,
                               (dirtyRect.size.height - self.icon.size.height) / 2 + self.iconVerticalOffset,
                               self.icon.size.width,
                               self.icon.size.height);
        [self.icon drawAtPoint:imageRect.origin fromRect:dirtyRect operation:NSCompositeSourceOver fraction:1.0f];

        textBoxOriginY = NSMinY(imageRect) - NSHeight(self.calculatedTextBoxRect) - self.iconTextMargin;

    } else if ([self hasIcon]) {
        imageRect = NSMakeRect((dirtyRect.size.width - self.icon.size.width) / 2,
                               (dirtyRect.size.height - self.icon.size.height) / 2,
                               self.icon.size.width,
                               self.icon.size.height);
        [self.icon drawAtPoint:imageRect.origin fromRect:dirtyRect operation:NSCompositeSourceOver fraction:1.0f];

    } else {
        textBoxOriginY = (NSHeight(dirtyRect) - NSHeight(self.calculatedTextBoxRect)) / 2;
    }

    if (![self.text isEqualToString:@""]) {
        _calculatedTextBoxRect.origin = NSMakePoint(textBoxOriginX, textBoxOriginY);
        [self.text drawInRect:_calculatedTextBoxRect withAttributes:_textBoxAttributes];
    }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Handling Subviews

- (void)pushChildView:(NSView *)childView withAnimationEffect:(CNChildViewAnimationEffect)effect usingCompletionHandler:(void(^)(void))completionHandler
{
    [self addSubview:childView];
    [_childViewStack addObject:childView];

    if (effect == CNChildViewAnimationEffectFade)
        [childView setAlphaValue:0.0f];

    childView.frame = [self frameForView:childView withAnimationEffect:effect];

    _isAnimating = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = (effect != CNChildViewAnimationEffectNone ? animationDuration : 0.0f);
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

        switch (effect) {
            case CNChildViewAnimationEffectFade:        [[childView animator]  setAlphaValue:1.0f]; break;
            case CNChildViewAnimationEffectSlideTop:
            case CNChildViewAnimationEffectSlideRight:
            case CNChildViewAnimationEffectSlideBottom:
            case CNChildViewAnimationEffectSlideLeft:   [[childView animator] setFrame:self.bounds]; break;
            default:
                break;
        }

    } completionHandler:^{
        _isAnimating = NO;
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)popChildViewWithAnimationEffect:(CNChildViewAnimationEffect)effect usingCompletionHandler:(void(^)(void))completionHandler
{
    NSView *lastChildView = [_childViewStack lastObject];
    __block NSRect childViewFrame;

    _isAnimating = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = (effect != CNChildViewAnimationEffectNone ? animationDuration : 0.0f);
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

        if (effect == CNChildViewAnimationEffectFade)
            [[lastChildView animator] setAlphaValue:0.0f];

        childViewFrame = [self frameForView:lastChildView withAnimationEffect:effect];
        [[lastChildView animator] setFrame:childViewFrame];
        
    } completionHandler:^{
        _isAnimating = NO;
        [lastChildView removeFromSuperview];
        if (completionHandler) {
            completionHandler();
        }
    }];
}

@end