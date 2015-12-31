//
//  DistributionMoodController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//


#import "DistributionMoodController.h"
#import "DistributionMoodViewModel.h"
#import "NSObject+LYUITipsView.h"
#import "MapInfoModel.h"
#import "DataModel.h"
#import "LYColor.h"
#import "UIViewController+YingyingNavigationItem.h"
#import "LYBaseImageViewController.h"
#import <MBProgressHUD.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface DistributionMoodController ()

@property (nonatomic , strong) IBOutlet UICollectionView*   myImages;
@property (nonatomic , strong) IBOutlet UITextField*        myAddressTextField;
@property (nonatomic , strong) IBOutlet UITextView*         myMoodContentTextView;

@property (nonatomic , strong) DistributionMoodViewModel* myViewModel;

@end

@implementation DistributionMoodController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.myViewModel = [DistributionMoodViewModel new];
    
    @weakify(self);
    [RACObserve(self.myViewModel, myImagesArr) subscribeNext:^(id x) {
        @strongify(self);
        [self.myImages reloadData];
    }];
    
    RAC(self.myViewModel, myMoodConent) = self.myMoodContentTextView.rac_textSignal;
    RAC(self.myViewModel, myLocName) = self.myAddressTextField.rac_textSignal;
    self.myViewModel.myView = self.view;

//    [self.myImages addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL]; 被下面的取代了

    [self.myImages rac_valuesForKeyPath:@"contentSize" observer:self];
    [RACObserve(self.myImages, contentSize) subscribeNext:^(id x) {
        @strongify(self);
        [self updateCollectionLayout];
    }];
    
    [self lySetupRightItem];
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    LYLog(@"dealloc message");
//    [self.myImages removeObserver:self forKeyPath:@"contentSize"];
}


#pragma mark - view init

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    LYLog(@"OB %@ %@", keyPath, change);
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        [self updateCollectionLayout];
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)updateCollectionLayout {
    for (NSLayoutConstraint* constraint in self.myImages.constraints) {
        if ([constraint.identifier isEqualToString:@"height"]) {
            if (self.myImages.contentSize.height) {
                constraint.constant = self.myImages.contentSize.height;
            }
        }
    }
//    [self.view layoutIfNeeded];
}

#pragma mark - ibaction

- (IBAction)onDistribute:(id)sender {
    [self.myViewModel requestSendMood];
    
}

- (IBAction)onAddress:(id)sender {
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        LYLog(@"cancel");
    }];
    [controller addAction:cancel];
    
    UIAlertAction* location = [UIAlertAction actionWithTitle:[MapInfoModel instance].myAddress style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.myAddressTextField.text = action.title;
        self.myAddressTextField.enabled = NO;
    }];
    [controller addAction:location];
    
    UIAlertAction* edit = [UIAlertAction actionWithTitle:@"自由编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.myAddressTextField.enabled = YES;
    }];
    [controller addAction:edit];
    
    UIAlertAction* hide = [UIAlertAction actionWithTitle:@"不显示位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.myAddressTextField.text = @"";
    }];
    [controller addAction:hide];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)onAdd:(id)sender {
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
#pragma mark - ui

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
        
        [self.myViewModel updateAddImage:image];
    }
//    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    LYLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myViewModel.myImagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView* img = (UIImageView *)[cell viewWithTag:10];
    if (img) {
        [img setImage:[self.myViewModel.myImagesArr objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 == self.myViewModel.myImagesArr.count) {
        [self onAdd:nil];
    }
    else {
        LYBaseImageViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"image_view_controller"];
        controller.myImage = [self.myViewModel.myImagesArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
    LYLog(@"click %ld", indexPath.row);
}

#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_DELETE_PHOTO object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        UIImage* img = [note.userInfo objectForKey:NOTIFY_UI_DELETE_PHOTO];
        [self.myViewModel updateDeleteImage:img];
    }];
}

@end
