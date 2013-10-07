#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "Extension.h"

#define MyDateTimePickerToolbarHeight 40

// UIViewController -> NSObject
@interface DatePickerViewController : NSObject

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIControl *uiView;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, assign) BOOL showing;

+ (DatePickerViewController *)sharedInstance;

- (void) initDatePicker;

- (void) showDatePicker;

- (void) removeDatePicker;

- (void) dateChanged:(id)sender;

- (void) bgClick:(id)sender;

@end

@implementation DatePickerViewController

@synthesize datePicker;
@synthesize uiView;
@synthesize toolBar;
@synthesize showing;

static DatePickerViewController *sharedInstance = nil;


extern "C" void sendEvent(int type, const char *data);

+ (DatePickerViewController *)sharedInstance {

	if (sharedInstance == nil) {
		sharedInstance = [[DatePickerViewController alloc] init];
	}
	return sharedInstance;

}

- (void) initDatePicker {


}

- (void) showDatePicker {

	trace("showDatePickerPhoto");

	UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];

	if (![self showing]) {

		[self setShowing:YES];

		if (self.uiView==nil) {
			self.uiView = [[UIControl alloc] init];
			//CGRect screenRect = rootView.bounds;
			self.uiView.frame = CGRectMake (0, rootView.bounds.size.height, rootView.bounds.size.width, rootView.bounds.size.height);
			//self.uiView.backgroundColor = [UIColor blackColor];
			//self.uiView.alpha = 0.5;
			[self.uiView addTarget:self action:@selector(bgClick:) forControlEvents:UIControlEventTouchUpInside];
			[rootView addSubview:self.uiView];

			self.datePicker = [[UIDatePicker alloc] init];
			self.datePicker.datePickerMode = UIDatePickerModeDate;
			//self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
			self.datePicker.hidden = NO;
			self.datePicker.date = [NSDate date];
			[self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

			CGRect datePickerFrame = self.datePicker.frame;
			//datePickerFrame.origin.y = rootView.bounds.size.height;
			datePickerFrame.origin.y = rootView.bounds.size.height - datePickerFrame.size.height;
			self.datePicker.frame = datePickerFrame;
			[self.uiView addSubview:self.datePicker];

			UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, self.datePicker.frame.origin.y - MyDateTimePickerToolbarHeight, rootView.bounds.size.width, MyDateTimePickerToolbarHeight)];
			//toolbar.barStyle = UIBarStyleBlackOpaque;
			toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[self.uiView addSubview:toolbar];

			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(donePressed)];
			UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			toolbar.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
		}
		// slide in
		[UIView animateWithDuration:0.3
			animations:^{
				self.uiView.frame = CGRectMake( self.uiView.frame.origin.x,
				0,
				self.uiView.frame.size.width,
				self.uiView.frame.size.height);
			} completion:^(BOOL finished) {

		}];

	}

}

- (void) removeDatePicker {

	if ([self showing]) {

		[self setShowing:NO];

		// slide out
		[UIView animateWithDuration:0.3
			animations:^{
				self.uiView.frame = CGRectMake( self.uiView.frame.origin.x,
				[[[[UIApplication sharedApplication] keyWindow] rootViewController] view].bounds.size.height,
				self.uiView.frame.size.width,
				self.uiView.frame.size.height);
			} completion:^(BOOL finished) {
				sendEvent(1, "remove");
			}];
	}

}

- (void) dateChanged:(id)sender {
	
	NSLog(@"New Date: %@", self.datePicker.date);

	// Use date picker to write out the date in a %Y-%m-%d format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyy-MM-dd"];
	NSString *formatedDate = [df stringFromDate:self.datePicker.date];

	NSLog(@"date: %@", formatedDate);

	// send back
	sendEvent(0, [formatedDate UTF8String]);

}

- (void) bgClick:(id)sender {
	[self removeDatePicker];
}

- (void) donePressed {
	trace("donePressed");
	[self removeDatePicker];
}

- (void) dealloc {

	[uiView release];
	uiView = nil;

	[toolBar release];
	toolBar = nil;

	[datePicker release];
	datePicker = nil;

	[super dealloc];

}

@end

namespace extension {

	//bool isOpen = false;

	bool initDatePicker() {

		[[DatePickerViewController sharedInstance] initDatePicker];
		return true;

	}

	void showDatePicker() {

		[[DatePickerViewController sharedInstance] showDatePicker];

	}

	void removeDatePicker() {

		[[DatePickerViewController sharedInstance] removeDatePicker];

	}
    
}
