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

#import "CNBaseView.h"


static const CGFloat kDefaultTextboxWidth = 350.0f;
static const CGFloat kDefaultIconVerticalOffset = 10.0f;
static const CGFloat kDefaultIconTextMargin = 10.0f;

static NSColor *defaultTextColor, *defaultShadowColor;
static NSFont *defaultTextFont;

@interface CNBaseView () {
    CGRect _calculatedTextBoxRect;
    NSDictionary *_textBoxAttributes;
}
- (void)commonConfiguration;
- (void)calculateTextBoxLines;
@end

@implementation CNBaseView

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization

+ (void)initialize
{
    defaultTextColor = [NSColor colorWithDeviceRed:0.731 green:0.731 blue:0.731 alpha:1.000];
    defaultShadowColor = [NSColor whiteColor];
    defaultTextFont = [NSFont fontWithName:@"HelveticaNeue-Medium" size:19.0f];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonConfiguration];
        [self calculateTextBoxLines];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonConfiguration];
        [self calculateTextBoxLines];
    }
    return self;
}

- (void)commonConfiguration
{
    _icon = nil;
    _textBoxWidth = kDefaultTextboxWidth;
    _iconVerticalOffset = kDefaultIconVerticalOffset;
    _iconTextMargin =  kDefaultIconTextMargin;

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
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Acessors

- (void)setText:(NSString *)theText
{
    if (![_text isEqualToString:theText]) {
        _text = nil;
        _text = theText;
        _attributedText = [[NSAttributedString alloc] initWithString:_text attributes:_textBoxAttributes];
        [self calculateTextBoxLines];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if (![_text isEqualToString:attributedText.string]) {
        _attributedText = nil;
        _attributedText = attributedText;
        _text = _attributedText.string;
        _textBoxAttributes = [_attributedText attributesAtIndex:0 effectiveRange:NULL];
        [self calculateTextBoxLines];
    }
}

- (void)setTextBoxWidth:(CGFloat)textBoxWidth
{
    if (_textBoxWidth != textBoxWidth) {
        _textBoxWidth = textBoxWidth;
        [self calculateTextBoxLines];
    }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Helper

- (void)calculateTextBoxLines
{
    if (![_text isEqualToString:@""]) {
        _calculatedTextBoxRect = [_text boundingRectWithSize:NSMakeSize(_textBoxWidth, 0)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:_textBoxAttributes];
    }
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Drawing

- (void)drawRect:(NSRect)dirtyRect
{
    if ([[self subviews] count] > 0) {
        return;
    }
    
    CGFloat textBoxOriginX = (NSWidth(dirtyRect) - self.textBoxWidth) / 2;
    CGFloat textBoxOriginY;

    CGRect imageRect = CGRectZero;
    if (self.icon) {
        imageRect = NSMakeRect((dirtyRect.size.width - self.icon.size.width) / 2,
                               (dirtyRect.size.height - self.icon.size.height) / 2 + self.iconVerticalOffset,
                               self.icon.size.width,
                               self.icon.size.height);
        [self.icon drawAtPoint:imageRect.origin fromRect:dirtyRect operation:NSCompositeSourceAtop fraction:1.0f];
        textBoxOriginY = NSMinY(imageRect) - NSHeight(_calculatedTextBoxRect) - self.iconTextMargin;

    } else {
        textBoxOriginY = (NSHeight(dirtyRect) - NSHeight(_calculatedTextBoxRect)) / 2;
    }

    if (![self.text isEqualToString:@""]) {
        _calculatedTextBoxRect.origin = NSMakePoint(textBoxOriginX, textBoxOriginY);
        [self.text drawInRect:_calculatedTextBoxRect withAttributes:_textBoxAttributes];
    }
}

@end
