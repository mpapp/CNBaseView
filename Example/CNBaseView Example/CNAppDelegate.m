//
//  CNAppDelegate.m
//  CNBaseView Example
//
//  Created by cocoa:naut on 23.11.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"
#import "CNDummyContentViewController.h"

static NSString *kDefaultEmptyMessageString;
static NSImage *kDefaultIcon;

@interface CNAppDelegate () {
    CNChildViewAnimationEffect _animationEffect;
}
@end

@implementation CNAppDelegate

+ (void)initialize
{
    kDefaultEmptyMessageString = @"Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.";
    kDefaultIcon = [NSImage imageNamed:@"IconFlower"];
}

- (void)awakeFromNib
{
    self.demoView.textBoxWidth = 350;
    [self.textBoxWidthSlider setFloatValue:self.demoView.textBoxWidth];
    [self.textBoxWidthSlider setNeedsDisplay];
    
    self.demoView.iconVerticalOffset = 15;
    [self.iconOffsetSlider setFloatValue:self.demoView.iconVerticalOffset];
    [self.iconOffsetSlider setNeedsDisplay];

    self.demoView.iconTextMargin = 10;
    [self.iconTextMarginSlider setFloatValue:self.demoView.iconTextMargin];
    [self.iconTextMarginSlider setNeedsDisplay];

    [self.animationEffectPopupButton removeAllItems];
    [self.animationEffectPopupButton addItemsWithTitles:@[NSLocalizedString(@"--", @""),
                                                          NSLocalizedString(@"Fade In", @""),
                                                          NSLocalizedString(@"Slide In from Top Edge", @""),
                                                          NSLocalizedString(@"Slide In from Right Edge", @""),
                                                          NSLocalizedString(@"Slide In from Bottom Edge", @""),
                                                          NSLocalizedString(@"Slide In from Left Edge", @"")]];
    [self.animationEffectPopupButton selectItemAtIndex:1];
    _animationEffect = (CNChildViewAnimationEffect)[self.animationEffectPopupButton indexOfSelectedItem];

    [self addIconCheckboxAction:nil];
    [self addMessageCheckboxAction:nil];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions

- (IBAction)addIconCheckboxAction:(id)sender
{
    self.demoView.icon = ([self.addIconCheckbox state] == NSOnState ? kDefaultIcon : nil);
    [self.demoView setNeedsDisplay:YES];
}

- (IBAction)addMessageCheckboxAction:(id)sender
{
    self.demoView.text = ([self.addMessageCheckbox state] == NSOnState ? kDefaultEmptyMessageString : nil);
}
- (IBAction)addViewCheckboxAction:(id)sender
{
    if ([self.addViewCheckbox state] == NSOnState) {
        CNDummyContentViewController *contentController = [[CNDummyContentViewController alloc] initWithNibName:@"CNDummyContentView" bundle:nil];
        contentController.view.frame = self.demoView.frame;
        
        [self.demoView pushChildView:contentController.view
                 withAnimationEffect:_animationEffect
              usingCompletionHandler:nil];
    } else {
        [self.demoView popChildViewWithAnimationEffect:_animationEffect
                                usingCompletionHandler:nil];
    }
    [self.demoView setNeedsDisplay:YES];
}

- (IBAction)textBoxWidthSliderAction:(id)sender
{
    self.demoView.textBoxWidth = [self.textBoxWidthSlider floatValue];
}

- (IBAction)iconOffsetSliderAction:(id)sender
{
    self.demoView.iconVerticalOffset = [self.iconOffsetSlider floatValue];
}

- (IBAction)iconTextMarginSliderAction:(id)sender
{
    self.demoView.iconTextMargin = [self.iconTextMarginSlider floatValue];
}

- (IBAction)preventDrawingCheckboxAction:(id)sender
{
    self.demoView.preventDrawingWithSubviews = [self.preventDrawingCheckbox state];
}

- (IBAction)animationEffectPopupButtonAction:(id)sender
{
    _animationEffect = (CNChildViewAnimationEffect)[self.animationEffectPopupButton indexOfSelectedItem];
}

@end
