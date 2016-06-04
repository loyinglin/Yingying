#import "NSObject+LYUITipsView.h"

#define	DEFAULT_TIPS_BUBBLE_WIDTH		(160.0f)
#define	DEFAULT_TIPS_BUBBLE_HEIGHT		(120.0f)
#define DEFAULT_TIMEOUT_SECONDS			(1.0f)

#define ANIMATION_DURATION				(0.20f)

#pragma mark -

@implementation NSObject(LYUITipsView)

- (LYUITipsView *)presentingTips
{
	return [LYUITipsCenter instance].tipsAppear;
}

- (LYUITipsView *)presentMessageTips:(NSString *)message
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}

	return [[LYUITipsCenter instance] presentMessageTips:message inView:container];
}

- (LYUITipsView *)presentSuccessTips:(NSString *)message
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}
	
	return [[LYUITipsCenter instance] presentSuccessTips:message inView:container];
}

- (LYUITipsView *)presentFailureTips:(NSString *)message
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}
	
	return [[LYUITipsCenter instance] presentFailureTips:message inView:container];
}

- (LYUITipsView *)presentLoadingTips:(NSString *)message
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}
	
	return [[LYUITipsCenter instance] presentLoadingTips:message inView:container];
}

- (LYUITipsView *)presentProgressTips:(NSString *)message
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}
	
	return [[LYUITipsCenter instance] presentProgressTips:message inView:container];
}

- (void)dismissTips
{
	UIView * container = nil;
	
	if ( [self isKindOfClass:[UIView class]] )
	{
		container = (UIView *)self;
	}
	else if ( [self isKindOfClass:[UIViewController class]] )
	{
		container = ((UIViewController *)self).view;
	}

	return [[LYUITipsCenter instance] dismissTipsByOwner:container];
}

@end

#pragma mark -

@interface LYUITipsCenter(Private)
- (void)presentTips:(LYUITipsView *)tips inView:(UIView *)view;
- (void)dismissTips;
- (void)dismissTipsByOwner:(UIView *)parentView;
- (void)dismissTipsLoading;
- (void)performDismissTips;
- (void)didAppearingAnimationDone;
- (void)didDisappearingAnimationDone;
- (void)bounce1ForAppearingAnimationStopped;
- (void)bounce2ForAppearingAnimationStopped;
@end

@interface LYUITipsView(Private)
- (void)didTimeout;
- (void)internalWillAppear;
- (void)internalDidAppear;
- (void)internalWillDisappear;
- (void)internalDidDisappear;
- (void)internalRelayout:(UIView *)parentView;
@end

#pragma mark -

@interface LYUITipsCenter()
{
	UIView *			_defaultContainerView;
	UIButton *			_maskView;
	LYUITipsView *		_tipsAppear;
	LYUITipsView *		_tipsDisappear;
	
	UIImage *			_bubble;
	UIImage *			_messageIcon;
	UIImage *			_successIcon;
	UIImage *			_failureIcon;
}
@end

#pragma mark -

@implementation LYUITipsCenter


+(instancetype) instance
{
    static LYUITipsCenter* test;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[LYUITipsCenter alloc] init];
    });
    return test;
}

@synthesize defaultContainerView = _defaultContainerView;

@synthesize maskView = _maskView;
@synthesize	tipsAppear = _tipsAppear;
@synthesize	tipsDisappear = _tipsDisappear;

@synthesize bubble = _bubble;
@synthesize messageIcon = _messageIcon;
@synthesize successIcon = _successIcon;
@synthesize failureIcon = _failureIcon;

+ (void)setDefaultContainerView:(UIView *)view
{
	[LYUITipsCenter instance].defaultContainerView = view;
}

+ (void)setDefaultMessageIcon:(UIImage *)image
{
	[LYUITipsCenter instance].messageIcon = image;
}

+ (void)setDefaultSuccessIcon:(UIImage *)image
{
	[LYUITipsCenter instance].successIcon = image;
}

+ (void)setDefaultFailureIcon:(UIImage *)image
{
	[LYUITipsCenter instance].failureIcon = image;
}

+ (void)setDefaultBubble:(UIImage *)image
{
	[LYUITipsCenter instance].bubble = image;
}

+ (void)setDefaultLoadingViewFromPlist:(NSString *)fileName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray* data = [[NSArray alloc] initWithContentsOfFile:plistPath];

    [[LYUITipsCenter instance] setArrLoadingView:data];
}

- (id)init
{
	self = [super init];
	if ( self )
	{
		_defaultContainerView = nil;
		_tipsAppear = nil;
		_tipsDisappear = nil;

		_maskView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05f];
		
//		[self observeNotification:BeeUIKeyboard.SHOWN];
//		[self observeNotification:BeeUIKeyboard.HIDDEN];
//		[self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
	}
	
	return self;
}

- (void)dealloc
{
//	[self unobserveAllNotifications];
}

//- (void)handleNotification:(NSNotification *)notification
//{
//	if ( [notification is:BeeUIKeyboard.SHOWN] || [notification is:BeeUIKeyboard.HEIGHT_CHANGED] )
//	{
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationBeginsFromCurrentState:YES];
//		[UIView setAnimationDuration:0.2f];
//		[_tipsAppear internalRelayout:_tipsAppear.superview];
//		[_tipsDisappear internalRelayout:_tipsDisappear.superview];
//		[UIView commitAnimations];
//	}
//	else if ( [notification is:BeeUIKeyboard.HIDDEN] )
//	{
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationBeginsFromCurrentState:YES];
//		[UIView setAnimationDuration:0.2f];
//		[_tipsAppear internalRelayout:_tipsAppear.superview];
//		[_tipsDisappear internalRelayout:_tipsDisappear.superview];
//		[UIView commitAnimations];
//	}
//}

- (void)presentTipsView:(LYUITipsView *)tips inView:(UIView *)view
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	if ( nil != _tipsAppear )
	{
		if ( tips == _tipsAppear )
			return;

		if ( NO == _tipsAppear.interrupt )
			return;		
	}
	
	if ( nil == view )
	{
		view = _defaultContainerView;

		if ( nil == view )
		{
			view = [UIApplication sharedApplication].keyWindow;
		}
	}
	
	[tips internalRelayout:view];

	tips.backgroundColor = [UIColor clearColor];
	
	self.tipsDisappear = self.tipsAppear;
	self.tipsAppear = tips;
	
	[_maskView removeFromSuperview];
	[view addSubview:_maskView];
	[view bringSubviewToFront:_maskView];

	_maskView.frame = view.bounds;

	[view addSubview:_tipsAppear];
	[view bringSubviewToFront:_tipsAppear];

// animation
	
	_tipsAppear.alpha = 0.0f;

	if ( _tipsAppear.useScaling )
	{
		_tipsAppear.transform = CGAffineTransformMakeScale( 1.2f, 1.2f );
	}
	
	if ( _tipsAppear.useBounces )
	{
		_tipsAppear.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.001, 0.001 );
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	if ( _tipsAppear.useBounces )
	{
		[UIView setAnimationDuration:(ANIMATION_DURATION / 1.5)];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(bounce1ForAppearingAnimationStopped)];
	}
	else
	{
		[UIView setAnimationDuration:ANIMATION_DURATION];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationDone)];
	}

	_tipsAppear.alpha = 1.0f;
	_tipsDisappear.alpha = 0.0f;

	if ( _tipsAppear.useScaling )
	{
		_tipsAppear.transform = CGAffineTransformMakeScale( 1.0f, 1.0f );
		_tipsDisappear.transform = CGAffineTransformMakeScale( 1.2f, 1.2f );
	}

	if ( _tipsAppear.useBounces )
	{
		_tipsAppear.transform = CGAffineTransformScale( CGAffineTransformIdentity, 1.1f, 1.1f );
	}

	_maskView.alpha = _tipsAppear.useMask ? 1.0f : 0.0f;
	
	[UIView commitAnimations];

	[_tipsAppear internalWillAppear];
	[_tipsDisappear internalWillDisappear];
}

- (void)didAppearingAnimationDone
{
	if ( NO == _tipsAppear.useMask )
	{
		_maskView.alpha = 0.0f;
		[_maskView removeFromSuperview];
	}

	[_tipsDisappear removeFromSuperview];
	_tipsDisappear = nil;
	
	[_tipsAppear internalDidAppear];
	[_tipsDisappear internalDidDisappear];
}

- (void)bounce1ForAppearingAnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:(ANIMATION_DURATION / 2.0f)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2ForAppearingAnimationStopped)];
	
	_tipsAppear.transform = CGAffineTransformScale( CGAffineTransformIdentity, 0.9, 0.9 );
	
	[UIView commitAnimations];
}

- (void)bounce2ForAppearingAnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:(ANIMATION_DURATION / 2.0f)];
	
	_tipsAppear.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)dismissTips
{
	[self performDismissTips];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(performDismissTips) withObject:nil afterDelay:0.3f];
}

- (void)dismissTipsByOwner:(UIView *)parentView
{
	if ( _tipsAppear )
	{
		if ( nil == parentView )
		{
			[self performDismissTips];
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			[self performSelector:@selector(performDismissTips) withObject:nil afterDelay:0.3f];
		}
		else if ( _tipsAppear.superview == parentView )
		{
			[self performDismissTips];
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			[self performSelector:@selector(performDismissTips) withObject:nil afterDelay:0.3f];
		}
	}
}

- (void)performDismissTips
{
	if ( nil == _tipsAppear )
		return;

	self.tipsDisappear = self.tipsAppear;
	self.tipsAppear = nil;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didDisappearingAnimationDone)];

	_tipsDisappear.alpha = 0.0f;

	if ( _tipsDisappear.useScaling )
	{
		_tipsDisappear.transform = CGAffineTransformMakeScale( 1.2f, 1.2f );
	}

	_maskView.alpha = 0.0f;
	
	[UIView commitAnimations];
	
	[_tipsAppear internalWillAppear];
	[_tipsDisappear internalWillDisappear];
}

- (void)didDisappearingAnimationDone
{
	if ( NO == _tipsAppear.useMask )
	{
		_maskView.alpha = 0.0f;
		[_maskView removeFromSuperview];
	}
	
	[_tipsDisappear removeFromSuperview];
	_tipsDisappear = nil;
	
	[_tipsAppear internalDidAppear];
	[_tipsDisappear internalDidDisappear];
}

- (LYUITipsView *)presentMessageTips:(NSString *)message inView:(UIView *)view
{
	BeeUIMessageTipsView * tips = [[BeeUIMessageTipsView alloc] init];
	tips.iconView.image = _messageIcon;
	tips.labelView.text = message;
	[tips presentInView:view];
	return tips;
}

- (LYUITipsView *)presentSuccessTips:(NSString *)message inView:(UIView *)view
{
	BeeUIMessageTipsView * tips = [[BeeUIMessageTipsView alloc] init];
	tips.iconView.image = _successIcon;
	tips.labelView.text = message;
	[tips presentInView:view];
    
    return tips;
}

- (LYUITipsView *)presentFailureTips:(NSString *)message inView:(UIView *)view
{
	BeeUIMessageTipsView * tips = [[BeeUIMessageTipsView alloc] init];
	tips.iconView.image = _failureIcon;
	tips.labelView.text = message;
	[tips presentInView:view];
    
    return tips;
}

- (LYUITipsView *)presentLoadingTips:(NSString *)message inView:(UIView *)view
{
	BeeUILoadingTipsView * tips = [[BeeUILoadingTipsView alloc] init];
	tips.labelView.text = message;
	[tips presentInView:view];
	[tips startAnimating];
    
    return tips;
}

- (LYUITipsView *)presentProgressTips:(NSString *)message inView:(UIView *)view
{
	BeeUIProgressTipsView * tips = [[BeeUIProgressTipsView alloc] init];
	tips.labelView.text = message;
	tips.percent = 0.0f;
	tips.useMask = YES;
	[tips presentInView:view];
    
    return tips;
}

@end

#pragma mark -

@interface LYUITipsView()
{
	NSTimeInterval	_timerSeconds;
	NSTimer *		_timer;
	
	BOOL			_useMask;
	BOOL			_useScaling;
	BOOL			_useBounces;
	BOOL			_interrupt;	// 是否可被打断
	BOOL			_timeLimit;
	BOOL			_exclusive;	// 是否独占模式，其他区域不能点击？
	BOOL			_fullScreen;
}
@end

#pragma mark -

@implementation LYUITipsView

@synthesize timerSeconds = _timerSeconds;

@synthesize useMask = _useMask;
@synthesize useScaling = _useScaling;
@synthesize useBounces = _useBounces;
@synthesize interrupt = _interrupt;
@synthesize timeLimit = _timeLimit;
@synthesize exclusive = _exclusive;
@synthesize fullScreen = _fullScreen;

- (id)init
{
	self = [super initWithFrame:CGRectZero];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.timerSeconds = DEFAULT_TIMEOUT_SECONDS;
		self.timeLimit = YES;
		self.interrupt = YES;
		self.fullScreen = NO;
		self.useScaling = YES;
//		self.useBounces = YES;
		
//		[self load];
//		[self performLoad];
	}
	
	return self;
}

- (void)dealloc
{
//	[self unload];
//	[self performUnload];

	[_timer invalidate];
	_timer = nil;

}

- (void)internalWillAppear
{	
	[_timer invalidate];
	_timer = nil;

//	[self sendUISignal:BeeUITipsView.WILL_APPEAR];
}

- (void)internalDidAppear
{	
	[_timer invalidate];
	_timer = nil;

	if ( _timeLimit )
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:self.timerSeconds
												  target:self
												selector:@selector(dismiss)
												userInfo:nil
												 repeats:NO];		
	}	

//	[self sendUISignal:BeeUITipsView.DID_APPEAR];
}

- (void)internalWillDisappear
{
	[_timer invalidate];
	_timer = nil;
	
//	[self sendUISignal:BeeUITipsView.WILL_DISAPPEAR];
}

- (void)internalDidDisappear
{
//	[self sendUISignal:BeeUITipsView.DID_DISAPPEAR];
}

- (void)internalRelayout:(UIView *)parentView
{
	if ( _fullScreen )
	{
		self.frame = parentView.bounds;
	}
	else
	{
		CGRect bound = parentView.bounds;

//		if ( [BeeUIKeyboard instance].shown )
//		{
//			bound.size.height -= [BeeUIKeyboard instance].height;
//			bound.size.height -= parentView.frame.origin.y;
//		}

//		bound.origin.y += 44.0f;
//		bound.size.height -= 44.0f;
//		bound.size.height -= 20.0f;

		CGRect viewFrame;
		viewFrame.origin.x = bound.origin.x + (bound.size.width - DEFAULT_TIPS_BUBBLE_WIDTH) / 2.0f;
		viewFrame.origin.y = bound.origin.y + (bound.size.height - DEFAULT_TIPS_BUBBLE_HEIGHT) / 2.0f;
		viewFrame.size.width = DEFAULT_TIPS_BUBBLE_WIDTH;
		viewFrame.size.height = DEFAULT_TIPS_BUBBLE_HEIGHT;

		self.frame = viewFrame;
	}
}

- (void)presentInView:(UIView *)view
{
	[[LYUITipsCenter instance] presentTipsView:self inView:view];
}

- (void)present
{
	[[LYUITipsCenter instance] presentTipsView:self inView:nil];
}

- (void)dismiss
{
	[_timer invalidate];
	_timer = nil;

	[[LYUITipsCenter instance] dismissTips];
}

@end

#pragma mark -

@interface BeeUIMessageTipsView()
{
	UIImageView *		_bubbleView;
	UIImageView *		_iconView;
	UILabel *			_labelView;
}
@end

#pragma mark -

@implementation BeeUIMessageTipsView

@synthesize bubbleView = _bubbleView;
@synthesize iconView = _iconView;
@synthesize labelView = _labelView;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.useMask = YES;
		self.interrupt = YES;
		self.exclusive = NO;
		self.timeLimit = YES;
		self.timerSeconds = DEFAULT_TIMEOUT_SECONDS;

		_bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = [UIColor clearColor];
		_bubbleView.contentMode = UIViewContentModeCenter;
		if ( [LYUITipsCenter instance].bubble )
		{
//			_bubbleView.image = [LYUITipsCenter instance].bubble.stretched;
		}
		else
		{
			_bubbleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
			_bubbleView.layer.masksToBounds = YES;
			_bubbleView.layer.cornerRadius = 4.0f;
		}
		[self addSubview:_bubbleView];

		_iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_iconView.backgroundColor = [UIColor clearColor];
		_iconView.contentMode = UIViewContentModeCenter;
		[self addSubview:_iconView];

		_labelView = [[UILabel alloc] initWithFrame:CGRectZero];
		
//		if ( IOS7_OR_LATER )
//		{
//			_labelView.font = [UIFont systemFontOfSize:13.0f];
//		}
//		else
		{
			_labelView.font = [UIFont systemFontOfSize:17.0f];
		}
			
        _labelView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _labelView.textAlignment = NSTextAlignmentCenter;
		_labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
        _labelView.lineBreakMode = NSLineBreakByClipping;
		_labelView.numberOfLines = 2;
        [self addSubview:_labelView];
	}
	
	return self;
}

- (void)dealloc
{
	[_bubbleView removeFromSuperview];


	[_iconView removeFromSuperview];


	[_labelView removeFromSuperview];

}

- (void)internalRelayout:(UIView *)parentView
{
	[super internalRelayout:parentView];

	_bubbleView.frame = self.bounds;
	
	if ( _iconView.image )
	{
		CGRect iconFrame = self.bounds;
		iconFrame.origin.y += 3.0f;
		iconFrame.size.height -= 30.0f;
		_iconView.frame = iconFrame;

		CGRect labelFrame;
		labelFrame.size.width = self.bounds.size.width;
		labelFrame.size.height = 60.0f;
		labelFrame.origin.x = 0.0f;
		labelFrame.origin.y = self.bounds.size.height - labelFrame.size.height + 6.0f;
		_labelView.frame = CGRectInset(labelFrame, 5.0f, 0.0f);
	}
	else
	{
		_labelView.frame = CGRectInset(self.bounds, 5.0f, 0.0f);
	}	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
	
	[self dismiss];
}

@end

#pragma mark -

@interface BeeUILoadingTipsView()
{
	UIImageView *				_bubbleView;
	UIActivityIndicatorView *	_indicator;
	UILabel *					_labelView;
}
@end

#pragma mark -

@implementation BeeUILoadingTipsView

@synthesize bubbleView = _bubbleView;
@synthesize labelView = _labelView;
@synthesize indicator = _indicator;

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.useMask = YES;
//		self.interrupt = NO;
		self.exclusive = YES;
		self.timeLimit = NO;

		_bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = [UIColor clearColor];
		_bubbleView.contentMode = UIViewContentModeCenter;
		if ( [LYUITipsCenter instance].arrLoadingView )
		{
            NSMutableArray* arrImg = [NSMutableArray array];
            for (NSString* imgName in [LYUITipsCenter instance].arrLoadingView) {
                UIImage* image = [UIImage imageNamed:imgName];
                [arrImg addObject:image];
            }
            [_bubbleView setAnimationImages:arrImg];
            [_bubbleView setAnimationRepeatCount:1000];
            [_bubbleView setAnimationDuration:arrImg.count * 0.25];
//            
//            UIImage* tmp = [LYUITipsCenter instance].bubble;
//            CGFloat leftCap = floorf(tmp.size.width / 2.0f);
//            CGFloat topCap = floorf(tmp.size.height / 2.0f);
//            _bubbleView.image = [tmp stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
		}
		else
		{
			_bubbleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
			_bubbleView.layer.masksToBounds = YES;
			_bubbleView.layer.cornerRadius = 4.0f;
		}
		[self addSubview:_bubbleView];
		
		_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		_indicator.backgroundColor = [UIColor clearColor];
		[self addSubview:_indicator];

		_labelView = [[UILabel alloc] initWithFrame:CGRectZero];
//		
//		if ( IOS7_OR_LATER )
//		{
//			_labelView.font = [UIFont systemFontOfSize:13.0f];
//		}
//		else
		{
			_labelView.font = [UIFont boldSystemFontOfSize:13.0f];
		}
		
        _labelView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _labelView.textAlignment = NSTextAlignmentCenter;
		_labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
        _labelView.lineBreakMode = NSLineBreakByClipping;
        _labelView.numberOfLines = 2;
        [self addSubview:_labelView];
	}

	return self;
}

- (void)dealloc
{
	[_bubbleView removeFromSuperview];
	
	
	[_indicator removeFromSuperview];

	
	[_labelView removeFromSuperview];

}

- (void)internalRelayout:(UIView *)parentView
{
	[super internalRelayout:parentView];

	_bubbleView.frame = self.bounds;
	
	CGRect indicatorFrame;
	indicatorFrame.size.width = 14.0f;
	indicatorFrame.size.height = 14.0f;
	indicatorFrame.origin.x = (self.bounds.size.width - indicatorFrame.size.width) / 2.0f;
	indicatorFrame.origin.y = (self.bounds.size.height - indicatorFrame.size.height) / 2.0f - 10.0f;
	_indicator.frame = indicatorFrame;

	CGRect labelFrame;
	labelFrame.size.width = self.bounds.size.width;
	labelFrame.size.height = 60.0f;
	labelFrame.origin.x = 0.0f;
	labelFrame.origin.y = self.bounds.size.height - labelFrame.size.height;
	_labelView.frame = CGRectInset(labelFrame, 5.0f, 0.0f);	
}

-(void)startAnimating
{
    if ([LYUITipsCenter instance].arrLoadingView) {
        [self.bubbleView startAnimating];
    }
    else{
        [self.indicator startAnimating];
    }
}
@end

#pragma mark -

@implementation BeeUIProgressTipsView

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.useMask = YES;
//		self.interrupt = NO;
		self.exclusive = YES;
		self.timeLimit = NO;

		_bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = [UIColor clearColor];
		_bubbleView.contentMode = UIViewContentModeCenter;
		if ( [LYUITipsCenter instance].bubble )
		{
//			_bubbleView.image = [LYUITipsCenter instance].bubble.stretched;
		}
		else
		{
			_bubbleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
			_bubbleView.layer.masksToBounds = YES;
			_bubbleView.layer.cornerRadius = 4.0f;
		}
		[self addSubview:_bubbleView];
		
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		_indicator.backgroundColor = [UIColor clearColor];
		[self addSubview:_indicator];

        _indicator.hidden = YES;
		
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor clearColor];
        [self addSubview:_progressView];
        
        _labelView = [[UILabel alloc] initWithFrame:CGRectZero];
//		if ( IOS7_OR_LATER )
//		{
//			_labelView.font = [UIFont systemFontOfSize:13.0f];
//		}
//		else
		{
			_labelView.font = [UIFont boldSystemFontOfSize:13.0f];
		}
		
        _labelView.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _labelView.textAlignment = NSTextAlignmentCenter;
		_labelView.textColor = [UIColor whiteColor];
        _labelView.backgroundColor = [UIColor clearColor];
        _labelView.lineBreakMode = NSLineBreakByClipping;
        _labelView.numberOfLines = 2;
        
        [self addSubview:_labelView];
	}
	
	return self;
}

- (void)dealloc
{
	[_bubbleView removeFromSuperview];
	
	
	[_indicator removeFromSuperview];
	
	
	[_progressView removeFromSuperview];
	
	
	[_labelView removeFromSuperview];
}

- (CGFloat)percent
{
	return _progressView.progress;
}

- (void)setPercent:(CGFloat)p
{
	if ( p >= 0.f && p < 1.f )
	{
		if ( !_indicator.hidden )
		{
			_indicator.hidden = YES;
			[_indicator stopAnimating];
		}
        
		_progressView.hidden = NO;
	}
	else
	{
		_progressView.hidden = YES;
		_progressView.progress = 0;
		
		_indicator.hidden = NO;
		[_indicator startAnimating];
	}

	_progressView.progress = p;
}

- (void)internalRelayout:(UIView *)parentView
{
	[super internalRelayout:parentView];
    
	_bubbleView.frame = self.bounds;
    
	CGRect progressRect;
	progressRect.size.width = self.bounds.size.width - 40.0f;
	progressRect.size.height = 20.0f;
	progressRect.origin.x = (self.bounds.size.width - progressRect.size.width) / 2.0f;
	progressRect.origin.y = (self.bounds.size.height - 20.0f - 20.0f) / 2.0f;
	_progressView.frame = progressRect;
    
	CGRect labelFrame;
	labelFrame.size.width = self.bounds.size.width;
	labelFrame.size.height = 60.0f;
	labelFrame.origin.x = 0.0f;
	labelFrame.origin.y = self.bounds.size.height - labelFrame.size.height;
	_labelView.frame = CGRectInset(labelFrame, 5.0f, 0.0f);
    
	CGRect indicatorFrame;
	indicatorFrame.size.width = 14.0f;
	indicatorFrame.size.height = 14.0f;
	indicatorFrame.origin.x = (self.bounds.size.width - indicatorFrame.size.width) / 2.0f;
	indicatorFrame.origin.y = (self.bounds.size.height - indicatorFrame.size.height - 20.f) / 2.0f;
	_indicator.frame = indicatorFrame;
}

@end
