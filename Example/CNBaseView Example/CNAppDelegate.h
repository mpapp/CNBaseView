//
//  CNAppDelegate.h
//  CNBaseView Example
//
//  Created by cocoa:naut on 23.11.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNBaseView.h"

@interface CNAppDelegate : NSObject <NSApplicationDelegate>
@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet CNBaseView *demoView;
@property (strong) IBOutlet NSButton *addIconCheckbox;
@property (strong) IBOutlet NSButton *addMessageCheckbox;
@property (strong) IBOutlet NSButton *addViewCheckbox;
@property (strong) IBOutlet NSSlider *textBoxWidthSlider;
@property (strong) IBOutlet NSSlider *iconOffsetSlider;
@property (strong) IBOutlet NSSlider *iconTextMarginSlider;
@property (strong) IBOutlet NSTextView *textView;


- (IBAction)addIconCheckboxAction:(id)sender;
- (IBAction)addMessageCheckboxAction:(id)sender;
- (IBAction)addViewCheckboxAction:(id)sender;
- (IBAction)textBoxWidthSliderAction:(id)sender;
- (IBAction)iconOffsetSliderAction:(id)sender;
- (IBAction)iconTextMarginSliderAction:(id)sender;

@end
