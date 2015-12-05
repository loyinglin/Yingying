#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#pragma mark -

@class LYUITipsView;

@interface NSObject(LYUITipsView)

- (LYUITipsView *)presentingTips;

- (LYUITipsView *)presentMessageTips:(NSString *)message;
- (LYUITipsView *)presentSuccessTips:(NSString *)message;
- (LYUITipsView *)presentFailureTips:(NSString *)message;
- (LYUITipsView *)presentLoadingTips:(NSString *)message;
- (LYUITipsView *)presentProgressTips:(NSString *)message;

- (void)dismissTips;

@end

#pragma mark -

@interface LYUITipsView : UIView

@property (nonatomic, assign) NSTimeInterval			timerSeconds;
@property (nonatomic, assign) BOOL						useMask;
@property (nonatomic, assign) BOOL						useScaling;
@property (nonatomic, assign) BOOL						useBounces;
@property (nonatomic, assign) BOOL						interrupt;
@property (nonatomic, assign) BOOL						timeLimit;
@property (nonatomic, assign) BOOL						exclusive;
@property (nonatomic, assign) BOOL						fullScreen;

- (void)present;
- (void)presentInView:(UIView *)view;
- (void)dismiss;

@end

#pragma mark -

@interface BeeUIMessageTipsView : LYUITipsView
@property (nonatomic, retain) UIImageView *				bubbleView;
@property (nonatomic, retain) UIImageView *				iconView;
@property (nonatomic, retain) UILabel *					labelView;
@end

#pragma mark -

@interface BeeUILoadingTipsView : LYUITipsView
@property (nonatomic, retain) UIImageView *				bubbleView;
@property (nonatomic, retain) UIActivityIndicatorView *	indicator;
@property (nonatomic, retain) UILabel *					labelView;

-(void)startAnimating;

@end

#pragma mark -

@interface BeeUIProgressTipsView : LYUITipsView
@property (nonatomic, retain) UIImageView *				bubbleView;
@property (nonatomic, retain) UIProgressView *			progressView;
@property (nonatomic, retain) UIActivityIndicatorView *	indicator;
@property (nonatomic, retain) UILabel *					labelView;
@property (nonatomic, assign) CGFloat					percent;
@end

#pragma mark -

@interface LYUITipsCenter : NSObject

@property (nonatomic, retain) UIView *					defaultContainerView;
@property (nonatomic, retain) UIView *					maskView;
@property (nonatomic, retain) LYUITipsView *			tipsAppear;
@property (nonatomic, retain) LYUITipsView *			tipsDisappear;

@property (nonatomic, retain) UIImage *					bubble;
@property (nonatomic , retain) NSArray*                 arrLoadingView;
@property (nonatomic, retain) UIImage *					messageIcon;
@property (nonatomic, retain) UIImage *					successIcon;
@property (nonatomic, retain) UIImage *					failureIcon;

+(instancetype)instance;

+ (void)setDefaultContainerView:(UIView *)view;
+ (void)setDefaultMessageIcon:(UIImage *)image;
+ (void)setDefaultSuccessIcon:(UIImage *)image;
+ (void)setDefaultFailureIcon:(UIImage *)image;
+ (void)setDefaultBubble:(UIImage *)image;
+ (void)setDefaultLoadingViewFromPlist:(NSString*)fileName;

- (void)dismissTips;
- (void)dismissTipsByOwner:(UIView *)parentView;

- (LYUITipsView *)presentMessageTips:(NSString *)message inView:(UIView *)view;
- (LYUITipsView *)presentSuccessTips:(NSString *)message inView:(UIView *)view;
- (LYUITipsView *)presentFailureTips:(NSString *)message inView:(UIView *)view;
- (LYUITipsView *)presentLoadingTips:(NSString *)message inView:(UIView *)view;
- (LYUITipsView *)presentProgressTips:(NSString *)message inView:(UIView *)view;

@end
