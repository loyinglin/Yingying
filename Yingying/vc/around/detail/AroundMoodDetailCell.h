//
//  AroundMoodDetailCell.h
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundMoodDetailCell : UITableViewCell

@property (nonatomic , strong) IBOutlet UILabel*    myMoodContentLabel;
@property (nonatomic , strong) IBOutlet UILabel*    myUserNameLabel;
@property (nonatomic , strong) IBOutlet UILabel*    myDateLabel;
@property (nonatomic , strong) IBOutlet UIImageView*    myAvatarImageView;
@property (nonatomic , strong) IBOutlet UILabel*    myPriceLabel;
@property (nonatomic , strong) IBOutlet UILabel*    myResNameLabel;

@property (nonatomic , strong) NSArray* myImagesArr;

@end
