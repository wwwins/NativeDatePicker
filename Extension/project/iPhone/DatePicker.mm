#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "Extension.h"


// UIViewController -> NSObject
@interface DatePickerViewController : NSObject

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIControl *bgView;
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
@synthesize bgView;
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

		self.bgView = [[UIControl alloc] init];
		self.bgView.frame = rootView.bounds;
		self.bgView.backgroundColor = [UIColor blackColor];
		self.bgView.alpha = 0.5;
		[self.bgView addTarget:self action:@selector(bgClick:) forControlEvents:UIControlEventTouchUpInside];
		[rootView addSubview:self.bgView];

		self.datePicker = [[UIDatePicker alloc] init];
		self.datePicker.datePickerMode = UIDatePickerModeDate;
		//self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		self.datePicker.hidden = NO;
		self.datePicker.date = [NSDate date];
		[self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];

		CGRect datePickerFrame = self.datePicker.frame;
		datePickerFrame.origin.y = rootView.bounds.size.height;
		//datePickerFrame.origin.y = rootView.bounds.size.height - datePickerFrame.size.height;
		self.datePicker.frame = datePickerFrame;
		[rootView addSubview:self.datePicker];
		// slide in
		[UIView animateWithDuration:0.3 
			animations:^{
				self.datePicker.frame = CGRectMake( self.datePicker.frame.origin.x,
						self.datePicker.frame.origin.y - datePickerFrame.size.height,
						self.datePicker.frame.size.width,
						self.datePicker.frame.size.height);
			} completion:^(BOOL finished) {

			}];
	}

}

- (void) removeDatePicker {

	if ([self showing]) {

		[self setShowing:NO];

		[self.bgView removeFromSuperview];

		// slide out
		[UIView animateWithDuration:0.3
			animations:^{
				self.datePicker.frame = CGRectMake( self.datePicker.frame.origin.x,
						[[[[UIApplication sharedApplication] keyWindow] rootViewController] view].bounds.size.height,
						self.datePicker.frame.size.width,
						self.datePicker.frame.size.height);
			} completion:^(BOOL finished) {
				[self.datePicker removeFromSuperview];
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

- (void) dealloc {

	[bgView release];
	bgView = nil;

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
