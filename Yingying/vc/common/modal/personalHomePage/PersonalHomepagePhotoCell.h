//
//  PersonalHomepagePhotoCell.h
//  Yingying
//
//  Created by 林伟池 on 16/1/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalHomepagePhotoCell : UITableViewCell

@property (nonatomic , strong) IBOutlet UIImageView* myImageView0;
@property (nonatomic , strong) IBOutlet UIImageView* myImageView1;
@property (nonatomic , strong) IBOutlet UIImageView* myImageView2;
@property (nonatomic , strong) IBOutlet UIImageView* myImageView3;


- (void)customViewWithIndexArr:(NSArray *)indexArr UrlArr:(NSArray *)imageUrlArr;
@end
