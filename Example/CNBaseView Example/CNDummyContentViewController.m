//
//  CNDummyContentViewController.m
//  CNBaseView Example
//
//  Created by cocoa:naut on 23.11.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//

#import "CNDummyContentViewController.h"
#import "CNBaseView.h"

@interface CNDummyContentViewController ()

@end

@implementation CNDummyContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.view.layer.backgroundColor = [[NSColor controlBackgroundColor] CGColor];
	}

	return self;
}

@end
