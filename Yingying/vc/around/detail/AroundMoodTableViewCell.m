//
//  AroundMoodTableViewCell.m
//  Yingying
//
//  Created by 林伟池 on 15/12/31.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMoodTableViewCell.h"
#import "AllMessage.h"
#import "UIImageView+AFNetworking.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
@interface AroundMoodTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic , strong) IBOutlet UICollectionView*   myImagesCollectionView;

@property (nonatomic , strong) IBOutlet NSLayoutConstraint* myHeightConstraint;
@end

@implementation AroundMoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.myImagesArr = @[];
//    self.autoresizingMask
    
    @weakify(self);
    [RACObserve(self.myImagesCollectionView, contentSize) subscribeNext:^(id x) {
        @strongify(self);
        self.myHeightConstraint.constant = self.myImagesCollectionView.contentSize.height;
        [self layoutIfNeeded];
    }];
    
    [RACObserve(self, myImagesArr) subscribeNext:^(id x) {
        @strongify(self);
//        self.myHeightConstraint.constant = 110 * self.myImagesArr.count;
        [self.myImagesCollectionView reloadData];
        [self layoutIfNeeded];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - view init


#pragma mark - ibaction

#pragma mark - ui

- (void)customCellWithMoodInfo:(MoodInfo *)info {
    if (info) {
        self.myMoodContent.text = info.moodContent;
        self.myImagesArr = info.attachs;
        if (info.headUrl) {
            [self.myAvatarImageview setImageWithURL:[NSURL URLWithString:[LY_MSG_BASE_URL stringByAppendingString:info.headUrl]]];
        }
        else {
            [self.myAvatarImageview setImage:[UIImage imageNamed:@"base_avatar"]];
        }
        if (info.type.boolValue) {
            [self.myTypeImageView setImage:[UIImage imageNamed:@"base_status_esay"]];
        }
        else {
            [self.myTypeImageView setImage:[UIImage imageNamed:@"base_status_mood"]];
        }
        self.myCommentCountLabel.text = [NSString stringWithFormat:@"%@", info.comment_size];
        self.myForwardCountLabel.text = [NSString stringWithFormat:@"%@", info.forward_size];
        self.mySendDateLabel.text = info.sendDate;
        self.myUsernameLabel.text = info.username;
    }
}


#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myImagesArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* ret = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView* imageView = [ret viewWithTag:10];
    if (imageView) {
        [imageView setImageWithURL:[[NSURL alloc] initWithString:[LY_MSG_BASE_URL stringByAppendingString:self.myImagesArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"map_avatar"]];
    }
    
    return ret;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    size.width = self.myImagesCollectionView.bounds.size.width / 3 - 10;
    
    size.height = 100;
    
    if (self.myImagesArr.count == 1) {
        size.width *= 2;
        size.height *= 1.5;
    }
    
    return size;
}

#pragma mark - notify

- (void)customNotify {
    
}

@end
