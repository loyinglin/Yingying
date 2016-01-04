//
//  AroundMoodTableViewCell.h
//  Yingying
//
//  Created by 林伟池 on 15/12/31.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Yingying.h"

@interface AroundMoodTableViewCell : UITableViewCell

@property (nonatomic , strong) IBOutlet UILabel*    myMoodContent;
@property (nonatomic , strong) IBOutlet UILabel*    myUsernameLabel;
@property (nonatomic , strong) IBOutlet UILabel*    myCommentCountLabel;
@property (nonatomic , strong) IBOutlet UILabel*    myForwardCountLabel;
@property (nonatomic , strong) IBOutlet UILabel*    mySendDateLabel;
@property (nonatomic , strong) IBOutlet UIImageView* myAvatarImageview;
@property (nonatomic , strong) IBOutlet UIImageView* myTypeImageView;

@property (nonatomic , strong) NSArray* myImagesArr;

- (void)customCellWithMoodInfo:(MoodInfo *)info;

@end
