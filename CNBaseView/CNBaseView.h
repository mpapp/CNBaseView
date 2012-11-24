//
//  CNBaseView.h
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

#import <Cocoa/Cocoa.h>


typedef enum {
    CNChildViewAnimationEffectNone = 0,
    CNChildViewAnimationEffectFade,
    CNChildViewAnimationEffectSlideTop,
    CNChildViewAnimationEffectSlideRight,
    CNChildViewAnimationEffectSlideBottom,
    CNChildViewAnimationEffectSlideLeft
} CNChildViewAnimationEffect;


@interface CNBaseView : NSView

#pragma mark View Creation
/** @name View Creation */

/**
 Creates and return an `CNBaseView` instance that is displaying the given icon and text.
 
 The text is displayed as an attributed string with the internal default text attributes:
 
    NSFontAttributeName :               [NSFont fontWithName:@"HelveticaNeue-Medium" size:18.0f],
    NSForegroundColorAttributeName :    [NSColor lightGrayColor],
    NSShadowAttributeName :             white shadow color with a shadow offset (0, -1),
    NSParagraphStyleAttributeName :     defaultParagraphStyle with alignment NSCenterTextAlignment,
    NSKernAttributeName :               @0.95f

 @param icon    An `NSImage` object containing the icon.
 @param text    An `NSString` object containing the text message.
 */
- (id)initWithIcon:(NSImage *)icon text:(NSString *)text;

/**
 Creates and return an `CNBaseView` instance that is displaying the given icon and the attributed text.

 @param icon    An `NSImage` object containing the icon.
 @param text    An `NSAttributedString` object containing the text message with all the attributes you want.
 */
- (id)initWithIcon:(NSImage *)icon attributedText:(NSAttributedString *)attributedText;



#pragma mark - View Content
/** @name View Content */

/**
 An image that is shown centered of the view.
 */
@property (strong, nonatomic) NSImage *icon;

/**
 A string with a message.
 
 This string will be show below the icon in a distance of the value by iconTextMargin.
 */
@property (strong, nonatomic) NSString *text;

/**
 An attributed string with a message.

 This string will be show below the icon in a distance of the value set by iconTextMargin.
 */
@property (strong, nonatomic) NSAttributedString *attributedText;



#pragma mark - View Behavior
/** @name View Behavior */

/**
 Float value to define the width of the text box rectangle.
 
 The height of the text box rectangle is calculated automatically.<br />
 The default value is `350.0f`.
 */
@property (assign, nonatomic) CGFloat textBoxWidth;

/**
 Float value to define a vertical offset for the icons view point.
 
 The default value is `10.0f`.
 */
@property (assign, nonatomic) CGFloat iconVerticalOffset;

/**
 Float value to define the distance between icon and text message.
 
 The distance is measured from the bottom icon edge (NSMinY(iconRect)) to the top text box edge (NSMaxY(textRect)).<br />
 The default value is `10.0f`.
 */
@property (assign, nonatomic) CGFloat iconTextMargin;

/**
 Property with a boolean value that indicates whether `CNBaseView` should draw an icon and text if there are subviews present or not.
 
 Normally you will add subviews to this view that acts as a root view. If `CNBaseView` is detecting just one subview it will 
 prevent drawing the icon and text. This is the default behavior.<br />
 But sometimes you may would like to `CNBaseView` keep drawing its icon and text message even if there are subviews or not. In this
 case you have to set it to `NO'.
 
 @param preventDrawingWithSubviews  `YES` (default value) will stop drawing the icon and text if there are subviews available. `NO` will always draw the icon and text.
 */
@property (assign) BOOL preventDrawingWithSubviews;


#pragma mark - Handling Subviews
/** @name Handling Subviews */

/**
 Pushs in another view as subview using the defined animation effect.
 
 There are several animation effects available:
 
    typedef enum {
        CNChildViewAnimationEffectNone = 0,
        CNChildViewAnimationEffectFade,
        CNChildViewAnimationEffectSlideTop,
        CNChildViewAnimationEffectSlideRight,
        CNChildViewAnimationEffectSlideBottom,
        CNChildViewAnimationEffectSlideLeft
    } CNChildViewAnimationEffect;
 
 `CNChildViewAnimationEffectNone`<br />
 The child view will be shown immediatly without an animation effect. It abolishes the setting of preventDrawingWithSubviews, the icon and text are not drawn.

 `CNChildViewAnimationEffectFade`<br />
 The child view will fade in.

 `CNChildViewAnimationEffectSlideTop`<br />
 The child view will silde in from the top edge downwards.

 `CNChildViewAnimationEffectSlideRight`<br />
 The child view will silde in from the right edge to the left.

 `CNChildViewAnimationEffectSlideBottom`<br />
 The child view will silde in from the bottom edge upwards.

 `CNChildViewAnimationEffectSlideLeft`<br />
 The child view will silde in from left edge to the right.

 After the animation is done the completionHandler is executed.

 @note If you decide to use one of these effects and the value of preventDrawingWithSubviews is set to `NO` then you have to ensure that
 your pushing child view has an opaque background. Otherwise the drawn icon and text message will show through.
 */
- (void)pushChildView:(NSView *)childView withAnimationEffect:(CNChildViewAnimationEffect)effect usingCompletionHandler:(void(^)(void))completionHandler;

/**
 Pops the child view and updates the display.
 
 @warning There is still a drawing bug if animation effect is one of the sliding effects!
 */
- (void)popChildViewWithAnimationEffect:(CNChildViewAnimationEffect)effect usingCompletionHandler:(void(^)(void))completionHandler;

@end
