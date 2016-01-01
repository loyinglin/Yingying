//
//  AroundMessageDetailController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMoodDetailViewModel.h"
#import "AroundMessageDetailController.h"
#import "AroundMoodDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "AllMessage.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface AroundMessageDetailController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , strong) IBOutlet UITableView*    myTableView;
@property (nonatomic , strong) IBOutlet UIButton*       myFavoriteButton;
//@property (nonatomic , strong) IBOutlet UILabel*        myMoodContentLabel;

@property (nonatomic , strong) IBOutlet UIView* myInputView;
@property (nonatomic , strong) IBOutlet UITextField* myInputTextField;
@property (nonatomic , strong) IBOutlet NSLayoutConstraint* myConstraint;

@property (nonatomic , strong) AroundMoodDetailViewModel* myViewModel;
@end

@implementation AroundMessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    @weakify(self);
    RAC(self.myViewModel, myCommentString) = self.myInputTextField.rac_textSignal;
    [RACObserve(self.myViewModel, myCommentInfoArr) subscribeNext:^(id x) {
        @strongify(self);
        [self.myTableView reloadData];
        [self updateMyFavoriteButton];
    }];
    
    [self customView];
    [self setupNotify];
    [self.myViewModel updateGetMoodComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

- (void)setMoodInfo:(MoodInfo *)moodInfo {
    if (!self.myViewModel) { //还没初始化
        self.myViewModel = [AroundMoodDetailViewModel new];
    }
    self.myViewModel.myMoodInfo = moodInfo;
}

- (void)customView {
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 5.0f)]; //顶部留白
    
    self.myTableView.estimatedRowHeight = 100;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        [self.tabBarController.tabBar setHidden:YES];
    }
}

#pragma mark - ibaction

- (IBAction)onPay:(id)sender {
    [self performSegueWithIdentifier:@"open_message_detail_pay_board" sender:self];
}

- (IBAction)onFavorite:(id)sender {
    @weakify(self);
    [[self.myViewModel requestMoodZan] subscribeCompleted:^{
        LYLog(@"ACBC");
        @strongify(self);
        if (self.myViewModel.myMoodInfo.isZan && self.myViewModel.myMoodInfo.isZan.boolValue) {
            self.myViewModel.myMoodInfo.isZan = @(0);
        }
        else {
            self.myViewModel.myMoodInfo.isZan = @(1);
        }
        [self updateMyFavoriteButton];
    }];
}

- (void)updateMyFavoriteButton {
    NSNumber* zan = self.myViewModel.myMoodInfo.isZan;
    if (zan && zan.boolValue) {
        [self.myFavoriteButton setBackgroundImage:[UIImage imageNamed:@"icon_message_detail_favorite"] forState:UIControlStateNormal];
    }
    else {
        [self.myFavoriteButton setBackgroundImage:[UIImage imageNamed:@"icon_message_detail_favorited"] forState:UIControlStateNormal];
    }
}

- (IBAction)onComment:(id)sender {
    @weakify(self);
    [[self.myViewModel requestCommentWithSourceCommentId:nil] subscribeCompleted:^{
        @strongify(self);
        self.myInputTextField.text = @""; //评论完清空
        [self.myInputTextField resignFirstResponder];
        [self.myViewModel updateGetMoodComment];
    }];
}

#pragma mark - ui

#pragma mark - delegate

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long ret = 0;
    if (section == 0) {
        ret = 1;
    }
    else {
        if (self.myViewModel && self.myViewModel.myCommentInfoArr) {
            ret = self.myViewModel.myCommentInfoArr.count;
        }
        ++ret;
    }
    return ret;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        AroundMoodDetailCell* item = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell = item;
        if (self.myViewModel.myMoodInfo.type.integerValue == 0) {
            item.myPriceLabel.hidden = item.myResNameLabel.hidden = YES;
        }
        else {
            item.myPriceLabel.hidden = item.myResNameLabel.hidden = NO;
            item.myPriceLabel.text = [NSString stringWithFormat:@"%@", self.myViewModel.myMoodInfo.price];
            item.myResNameLabel.text = self.myViewModel.myMoodInfo.name;
        }
        item.myImagesArr = self.myViewModel.myMoodInfo.attachs;
        item.myDateLabel.text = self.myViewModel.myMoodInfo.sendDate;
        item.myMoodContentLabel.text = self.myViewModel.myMoodInfo.moodContent;

    }
    else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
            UILabel* commentTitleLabel = (UILabel *)[cell viewWithTag:10];
            if (commentTitleLabel) {
                commentTitleLabel.text = [NSString stringWithFormat:@"评论（%ld）", [self tableView:self.myTableView numberOfRowsInSection:1] - 1];
            }
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
            UILabel* nameLabel = (UILabel *)[cell viewWithTag:10];
            UILabel* timeLabel = (UILabel *)[cell viewWithTag:20];
            UILabel* commentLabel = (UILabel *)[cell viewWithTag:30];
            UIImageView* avatarImageView = (UIImageView *)[cell viewWithTag:40];
            CommentInfo* info = [self.myViewModel getCommentInfoByIndex:indexPath.row - 1];
            if (info) {
                timeLabel.text = info.comment_date;
                nameLabel.text = info.username;
                commentLabel.text = info.comment_source;
                if (info.thumburl) {
                    [avatarImageView setImageWithURL:[NSURL URLWithString:[LY_MSG_BASE_URL stringByAppendingString:info.thumburl]]];
                }
            }
        }
    }
    
    // Configure the cell...
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - notify

#define INTERVAL_KEYBOARD 10

- (void)setupNotify {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//        LYLog(@"kb height %f", kbHeight); 
        
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//        CGFloat offset = (self.myInputView.frame.origin.y + self.myInputView.frame.size.height + INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//        double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(kbHeight > 0) {
//            [UIView animateWithDuration:duration animations:^{
                self.myConstraint.constant = kbHeight;
//                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        double duration = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //视图下沉恢复原状
        [UIView animateWithDuration:duration animations:^{
            self.myConstraint.constant = 0;
//            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }];
}

@end
