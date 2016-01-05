//
//  LYAnnotationView.m
//  Yingying
//
//  Created by 林伟池 on 15/12/10.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYAnnotationView.h"
#import "AllMessage.h"
#import "UIImageView+AFNetworking.h"

@interface LYAnnotationView()
@property (nonatomic , strong) IBOutlet UIImageView* avatarImageView;
@property (nonatomic , strong) IBOutlet UIImageView* genderImageView;

@end

@implementation LYAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"CustomMapView" owner:self options:nil] lastObject];
        [self setBounds:view.bounds];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:view];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)customViewWithGenderIsMalf:(BOOL)isMale AvatarUrl:(NSString *)avatarStr {
    if (isMale) {
        [self.genderImageView setImage:[UIImage imageNamed:@"map_man_location"]];
    }
    else {
        [self.genderImageView setImage:[UIImage imageNamed:@"map_woman_location"]];
    }
    if (avatarStr) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:[LY_MSG_BASE_URL stringByAppendingString:avatarStr]] placeholderImage:[UIImage imageNamed:@"base_avatar"]];
    }
    else {
        [self.avatarImageView setImage:[UIImage imageNamed:@"base_avatar"]];
    }
    
}
@end
