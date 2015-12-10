//
//  LYAnnotationView.m
//  Yingying
//
//  Created by 林伟池 on 15/12/10.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "LYAnnotationView.h"

@implementation LYAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"CustomMapView" owner:nil options:nil] lastObject];
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

@end
