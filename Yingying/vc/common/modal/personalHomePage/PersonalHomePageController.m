//
//  PersonalHomePageController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/8.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "PersonalHomePageController.h"
#import "PersonalHomePageViewModel.h"
#import "PersonalHomepagePhotoCell.h"
#import "LYColor.h"
#import "FriendModel.h"
#import "UserModel.h"
#import "CDUserFactory.h"
#import "LYNotifyCenter.h"
#import "UIView+LYModify.h"
#import "ChatDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "AroundMoodTableViewCell.h"
#import "UIViewController+YingyingNavigationItem.h"

typedef NS_ENUM(NSInteger, LYHOMEPAGE) {
    ly_photo,
    ly_information,
    ly_message
};

typedef NS_ENUM(NSInteger, LYINFORMATION) {
    ly_avatar,
    ly_nickname,
    ly_gender,
    ly_userphone,
};


@interface PersonalHomePageController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic , strong) IBOutlet UITableView* myTableView;

@property (nonatomic , strong) IBOutlet UIView* myBottomView;
@property (nonatomic , strong) IBOutlet UIView* myFriendView;
@property (nonatomic , strong) IBOutlet UIView* myPopView;
@property (nonatomic , strong) UIBarButtonItem* myTempBarButtonItem;

@property (nonatomic , assign) BOOL isAvatar;
@property (nonatomic , assign) BOOL isSelf;

@property (nonatomic , strong) PersonalHomePageViewModel* myViewModel;

@end

@implementation PersonalHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewModel.myView = self.view;
    
    @weakify(self);
    
    
    [self customView];
    [self lySetupLeftItem];
    [self customNotify];
    
    [[[self.myViewModel requestGetUserInfo] flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self.myViewModel requestGetMoodList];
    }] subscribeCompleted:^{
        @strongify(self);
        [self.myTableView reloadData];
    }];
    
    [[RACObserve(self.myViewModel, myIsFriend) filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(NSNumber* isFriend) {
        @strongify(self);
        LYLog(@"is frined %@", isFriend);
        if (!isFriend.boolValue) {
            self.navigationItem.rightBarButtonItem = nil;
            self.myFriendView.hidden = YES;
        }
        else {
            self.myFriendView.hidden = NO;
            self.navigationItem.rightBarButtonItem = self.myTempBarButtonItem;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    LYLog(@"dac %@" ,self);
}
#pragma mark - view init

- (void)initWithUserphone:(NSString *)userphone Uid:(NSNumber *)uid{
    self.myViewModel = [PersonalHomePageViewModel new];
    self.myViewModel.myUserphone = userphone;
    self.myViewModel.myUid = uid;
    self.isSelf = [userphone isEqualToString:[[UserModel instance] getMyUserphone]];
}

- (void)customView {
    [self.myBottomView lySetupBorderwithColor:0xf0f0f0 Width:1 Radius:0];
    
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 100;
    
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, 20)];
    [self.myTableView.tableHeaderView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.bounds.size.width, self.myBottomView.bounds.size.height + 10)];
    self.myTempBarButtonItem = self.navigationItem.rightBarButtonItem;
    if (self.isSelf) {
        self.myBottomView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - ibaction

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onAddFriend:(id)sender {
    if (self.myViewModel.myUid) {
        @weakify(self);
        [[[FriendModel instance] requestAddFriendWith:self.myViewModel.myUid] subscribeCompleted:^{
            @strongify(self);
            self.myViewModel.myIsFriend = @(1);
        }];
    }
}

- (IBAction)onContact:(id)sender {
    if (self.myViewModel.myUid && [CDChatManager manager].selfId) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_REQUEST_TO_CHAT object:nil userInfo:@{NOTIFY_UI_REQUEST_TO_CHAT:self.myViewModel.myUid}];
//
//        [[CDChatManager manager] fetchConvWithOtherId:[NSString stringWithFormat:@"%@", self.myViewModel.myUid] callback : ^(AVIMConversation *conversation, NSError *error) {
//            if (error) {
//                LYLog(@"%@", error);
//            }
//            else {
//                ChatDetailController *chatRoomVC = [[ChatDetailController alloc] initWithConv:conversation];
//                [self.navigationController pushViewController:chatRoomVC animated:YES];
//            }
//        }];
//        
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onTransfer:(id)sender {
    LYLog(@"transfer");
}

- (IBAction)onDeleteFriend:(id)sender {
    if (self.myViewModel.myUid) {
        @weakify(self);
        [[[FriendModel instance] requestDeleteFriendWithUid:self.myViewModel.myUid] subscribeCompleted:^{
            @strongify(self);
            self.myViewModel.myIsFriend = @(0);
            [self onRightButtonClick:nil];
        }];
    }
}

- (IBAction)onRightButtonClick:(id)sender {
    self.myPopView.hidden = !self.myPopView.hidden;
    [self.view bringSubviewToFront:self.myPopView]; //为了方便在IB中编辑，把pop放在最下层。
}


#pragma mark - ui

- (void)onDeletePhotoWith:(NSNumber *)photoId {
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        LYLog(@"cancel");
    }];
    [controller addAction:cancel];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [[self.myViewModel requestDeletePhoteWithPhotoId:photoId] subscribeNext:^(id x) {
            @strongify(self);
            [self.myViewModel requestGetUserInfo];
        }];
    }];
    [controller addAction:delete];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)onAdd {
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        LYLog(@"cancel");
    }];
    [controller addAction:cancel];
    
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self takePhoto];
    }];
    [controller addAction:takePhoto];
    
    UIAlertAction* localPhoto = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self LocalPhoto];
    }];
    [controller addAction:localPhoto];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}


-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        LYLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        @weakify(self);
        if (self.isAvatar) {
            [[self.myViewModel requestUploadAvatarWithImage:image] subscribeCompleted:^{
                @strongify(self);
                [self.myViewModel requestGetUserInfo];
            }];
        }
        else {
            [[self.myViewModel requestAddPhotoWithImage:image] subscribeCompleted:^{
                @strongify(self);
                [self.myViewModel requestGetUserInfo];
            }];
        }
    }
    //    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    LYLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - delegate


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long ret = 0;
    
    switch (section) {
        case ly_photo:
            ret = (self.myViewModel.myPhotosArr.count) / 4 + 1;
            break;
            
        case ly_information:
            ret = 4;
            break;
            
        case ly_message:
            ret = self.myViewModel.myMoodsArr.count + 1;
            break;
            
        default:
            break;
    }
    
    return ret;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case ly_photo:
        {
            PersonalHomepagePhotoCell* ret = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
            cell = ret;
            NSMutableArray* indexArr = [NSMutableArray array];
            NSMutableArray* imagesUrlArr = [NSMutableArray array];
            int i;
            for (i = 0; (indexPath.row * 4 + i) < self.myViewModel.myPhotosArr.count && i < 4; ++i) {
                long index = indexPath.row * 4 + i;
                [indexArr addObject:@(index)];
                [imagesUrlArr addObject:[self.myViewModel getImageUrlbyIndex:index]];
            }
            if (i < 4 && self.isSelf) {
                [indexArr addObject:@(-1)];
                NSString* path = [[NSBundle mainBundle] pathForResource:@"distribution_add_button" ofType:@"png"];
                [imagesUrlArr addObject:path];
            }
            [ret customViewWithIndexArr:indexArr UrlArr:imagesUrlArr];
            
            break;
        }
        case ly_information:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"information" forIndexPath:indexPath];
            UILabel* leftLabel = (UILabel *)[cell viewWithTag:10];
            UILabel* rightLabel = (UILabel *)[cell viewWithTag:20];
            UIImageView* avatarImageView = (UIImageView *)[cell viewWithTag:30];
            avatarImageView.hidden = YES;
            rightLabel.hidden = NO;
            switch (indexPath.row) {
                case ly_avatar:
                {
                    avatarImageView.hidden = NO;
                    rightLabel.hidden = YES;
                    leftLabel.text = @"头像";
                    if (self.myViewModel.myAvatarUrl) {
                        [avatarImageView setImageWithURL:[NSURL URLWithString:self.myViewModel.myAvatarUrl]];
                    }
                    else {
                        [avatarImageView setImage:[UIImage imageNamed:@"finance_avatar"]];
                    }
                    break;
                }
                case ly_nickname:
                    leftLabel.text = @"昵称";
                    rightLabel.text = self.myViewModel.myUserInfo.nickName;
                    break;
                case ly_gender:
                    leftLabel.text = @"性别";
                    rightLabel.text = [self.myViewModel.myUserInfo.gender isEqualToString:@"m"] ? @"男" : @"女";
                    break;
                case ly_userphone:
                    leftLabel.text = @"手机";
                    rightLabel.text = self.myViewModel.myUserphone;
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        case ly_message:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"message_head" forIndexPath:indexPath];
            }
            else {
                AroundMoodTableViewCell* ret = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell = ret;
                
                MoodInfo* info = [self.myViewModel getMoodInfoByIndex:indexPath.row - 1];
                if (info) {
                    ret.myMoodContent.text = info.moodContent;
                    ret.myImagesArr = info.attachs;
                    if (info.headUrl) {
                        [ret.myAvatarImageview setImageWithURL:[NSURL URLWithString:[LY_MSG_BASE_URL stringByAppendingString:info.headUrl]]];
                    }
                    ret.myCommentCountLabel.text = [NSString stringWithFormat:@"%@", info.comment_size];
                    ret.myForwardCountLabel.text = [NSString stringWithFormat:@"%@", info.forward_size];
                    ret.mySendDateLabel.text = info.sendDate;
                    ret.myUsernameLabel.text = info.username;
                }
            }
            break;
            
    }
    
    
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.myViewModel || !self.isSelf) {
        return nil;
    }
    if (indexPath.section == ly_information && indexPath.row == ly_avatar) {
        self.isAvatar = YES;
        [self onAdd];
    }
    
    return nil;
}


#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    if (!self.isSelf) {
        return ;
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_PERSONAL_HOMEPAGE_ADD_PHOTO object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        NSNumber* index = [note.userInfo objectForKey:NOTIFY_UI_PERSONAL_HOMEPAGE_ADD_PHOTO];
        if (index.integerValue < 0) {
            self.isAvatar = NO;
            [self onAdd];
        }
        else {
            [self onDeletePhotoWith:[self.myViewModel getImageIdbyIndex:index.integerValue]];
        }
    }];
}

@end
