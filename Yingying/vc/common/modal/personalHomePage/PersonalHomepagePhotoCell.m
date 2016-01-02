//
//  PersonalHomepagePhotoCell.m
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "PersonalHomepagePhotoCell.h"
#import "UIImageView+AFNetworking.h"
#import "LYNotifyCenter.h"

@interface PersonalHomepagePhotoCell()

@property (nonatomic , strong) NSArray* myImageViewsArr;
@property (nonatomic , strong) NSArray* myIndexsArr;

@end

@implementation PersonalHomepagePhotoCell

- (void)awakeFromNib {
    // Initialization code
    self.myImageViewsArr = @[self.myImageView0, self.myImageView1, self.myImageView2, self.myImageView3];
    for (UIImageView* imageView in self.myImageViewsArr) {
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];

        [imageView addGestureRecognizer:tap];
    }
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    long index = tap.view.tag;
    LYLog(@"click %ld", index);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_PERSONAL_HOMEPAGE_ADD_PHOTO object:nil userInfo:@{NOTIFY_UI_PERSONAL_HOMEPAGE_ADD_PHOTO:@(index)}];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)customViewWithIndexArr:(NSArray *)indexArr UrlArr:(NSArray *)imageUrlArr {
    for (int i = 0; i < self.myImageViewsArr.count;  ++i) {
        UIImageView* imageView = self.myImageViewsArr[i];
        if (i < indexArr.count && i < imageUrlArr.count) {
            NSNumber* index = indexArr[i];
            NSString* url = imageUrlArr[i];
            imageView.hidden = NO;
            if (index.integerValue >= 0) {
                [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"finance_avatar"]];
            }
            else {
                [imageView setImage:[UIImage imageWithContentsOfFile:url]];
            }
            imageView.tag = index.integerValue;
        }
        else {
            imageView.hidden = YES;
        }
    }
}

@end
