//
//  CNAppDelegate.m
//  CNBaseView Example
//
//  Created by cocoa:naut on 23.11.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"

static NSString *kDefaultEmptyMessageString;
static NSImage *kDefaultIcon;

@implementation CNAppDelegate

+ (void)initialize
{
    kDefaultEmptyMessageString = @"Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.";
    kDefaultIcon = [NSImage imageNamed:@"IconFlower"];
}

- (void)awakeFromNib
{
    self.demoView.textBoxWidth = 400;
    [self.textBoxWidthSlider setFloatValue:self.demoView.textBoxWidth];
    [self.textBoxWidthSlider setNeedsDisplay];
    
    self.demoView.iconVerticalOffset = 15;
    [self.iconOffsetSlider setFloatValue:self.demoView.iconVerticalOffset];
    [self.iconOffsetSlider setNeedsDisplay];

    self.demoView.iconTextMargin = 10;
    [self.iconTextMarginSlider setFloatValue:self.demoView.iconTextMargin];
    [self.iconTextMarginSlider setNeedsDisplay];

    self.textView.string = @"Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. A small river named Duden flows by their place and supplies it with the necessary regelialia. It is a paradisematic country, in which roasted parts of sentences fly into your mouth. Even the all-powerful Pointing has no control about the blind texts it is an almost unorthographic life One day however a small line of blind text by the name of Lorem Ipsum decided to leave for the far World of Grammar. The Big Oxmox advised her not to do so, because there were thousands of bad Commas, wild Question Marks and devious Semikoli, but the Little Blind Text didn’t listen. She packed her seven versalia, put her initial into the belt and made herself on the way. When she reached the first hills of the Italic Mountains, she had a last view back on the skyline of her hometown Bookmarksgrove, the headline of Alphabet Village and the subline of her own road, the Line Lane. Pityful a rethoric question ran over her cheek, then she continued her way. On her way she met a copy. The copy warned the Little Blind Text, that where it came from it would have been rewritten a thousand times and everything that was left from its origin would be the word 'and' and the Little Blind Text should turn around and return to its own, safe country.";

    [self addIconCheckboxAction:nil];
    [self addMessageCheckboxAction:nil];
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper

- (void)centerTextView
{
    CGRect contentFrame = self.demoView.frame;
    CGRect textViewFrame = NSMakeRect((NSWidth(contentFrame) - 500) / 2,
                                      (NSHeight(contentFrame) - 200) / 2,
                                      500, 200);
    CNLogForRect(textViewFrame);
    [[self.textView enclosingScrollView] setFrame:textViewFrame];
    self.textView.frame = textViewFrame;
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
    self.demoView.text = ([self.addMessageCheckbox state] == NSOnState ? kDefaultEmptyMessageString : @"");
    [self.demoView setNeedsDisplay:YES];
}
- (IBAction)addViewCheckboxAction:(id)sender
{
    if ([self.addViewCheckbox state] == NSOnState) {
        [self centerTextView];
        [self.demoView addSubview:self.textView];
    } else {
        [self.textView removeFromSuperview];
    }
    [self.demoView setNeedsDisplay:YES];
}

- (IBAction)textBoxWidthSliderAction:(id)sender
{
    self.demoView.textBoxWidth = [self.textBoxWidthSlider floatValue];
    [self.demoView setNeedsDisplay:YES];
}

- (IBAction)iconOffsetSliderAction:(id)sender
{
    self.demoView.iconVerticalOffset = [self.iconOffsetSlider floatValue];
    [self.demoView setNeedsDisplay:YES];
}

- (IBAction)iconTextMarginSliderAction:(id)sender
{
    self.demoView.iconTextMargin = [self.iconTextMarginSlider floatValue];
    [self.demoView setNeedsDisplay:YES];
}

@end
