//
//  AroundMessageDetailController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/5.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMoodDetailViewModel.h"
#import "AroundMessageDetailController.h"
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
    LYLog(@"favorite");
}

- (IBAction)onComment:(id)sender {
    LYLog(@"comment");
    self.myInputTextField.text = @""; //评论完清空
    [self.myInputTextField resignFirstResponder];
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
        ret = 4;
    }
    return ret;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        UILabel* moodContentLabel = (UILabel *)[cell viewWithTag:10];
        moodContentLabel.text = self.myViewModel.myMoodInfo.moodContent;
    }
    else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"comment" forIndexPath:indexPath];
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
