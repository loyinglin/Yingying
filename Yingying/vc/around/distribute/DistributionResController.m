//
//  DistributionResController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "DistributionResController.h"
#import "DistributionResViewModel.h"
#import "LYBaseImageViewController.h"
#import "UIView+LYModify.h"
#import "UIViewController+YingYingImagePickerController.h"
#import "UIViewController+YingyingNavigationItem.h"
#import "LYColor.h"
#import "MapInfoModel.h"

@interface DistributionResController ()

@property (nonatomic , strong) IBOutlet UITextView*         myResDesc;


@property (nonatomic , strong) IBOutlet UICollectionView*   myImages;
@property (nonatomic , strong) IBOutlet UILabel*            myPlaceholderLabel;

@property (nonatomic , strong) IBOutlet UITextField*        myAddressTextField;
@property (nonatomic , strong) IBOutlet UITextField*        myPriceTextField;
@property (nonatomic , strong) IBOutlet UITextField*        myNameTextField;
@property (nonatomic , strong) IBOutlet UIView*             myTabBackView;

@property (nonatomic , strong) DistributionResViewModel*    myViewModel;
@end


@implementation DistributionResController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myViewModel = [DistributionResViewModel new];
    
    @weakify(self);
    [RACObserve(self.myViewModel, myImagesArr) subscribeNext:^(id x) {
        @strongify(self);
        [self.myImages reloadData];
    }];
    RAC(self.myViewModel, myMoodConent) = self.myResDesc.rac_textSignal;
    RAC(self.myViewModel, myLocName) = self.myAddressTextField.rac_textSignal;

    RAC(self.myViewModel, myPirce) = [self.myPriceTextField.rac_textSignal map:^id(NSString* text) {
        return @(text.floatValue);
    }];
    RAC(self.myViewModel, myName) = self.myNameTextField.rac_textSignal;
    self.myViewModel.myView = self.view;
    
    if ([MapInfoModel instance].myAddress.length > 0) {
        self.myViewModel.myLocName = self.myAddressTextField.text = [MapInfoModel instance].myAddress;
    }
    
    [self.myImages rac_valuesForKeyPath:@"contentSize" observer:self];
    [RACObserve(self.myImages, contentSize) subscribeNext:^(id x) {
        @strongify(self);
        [self updateCollectionLayout];
    }];

    [self customView];
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    LYLog(@"dealloc message");
}

#pragma mark - view init

- (void)customView {
    
    [self.myResDesc lySetupBorderwithColor:0xcdcdcd Width:1 Radius:5];
    [self lySetupRightItem];
}

- (void)updateCollectionLayout {
    for (NSLayoutConstraint* constraint in self.myImages.constraints) {
        if ([constraint.identifier isEqualToString:@"height"]) {
            if (self.myImages.contentSize.height) {
                constraint.constant = self.myImages.contentSize.height;
            }
        }
    }
}

#pragma mark - ibaction


- (IBAction)onDistribute:(id)sender {
    @weakify(self);
    [[self.myViewModel requestSendRes] subscribeNext:^(id x) {
        NSLog(@"vc %@", x);
    } error:^(NSError *error) {
        NSLog(@"eror");
    } completed:^{
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_REFRESH_AROUND_MOOD object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];

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
        self.myViewModel.myLocName = action.title;
        self.myAddressTextField.userInteractionEnabled = NO;
    }];
    [controller addAction:location];
    
    UIAlertAction* edit = [UIAlertAction actionWithTitle:@"自由编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.myTabBackView.userInteractionEnabled = NO;
        self.myAddressTextField.userInteractionEnabled = YES;
    }];
    [controller addAction:edit];
    
    UIAlertAction* hide = [UIAlertAction actionWithTitle:@"不显示位置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.myAddressTextField.text = @"";
    }];
    [controller addAction:hide];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - ui

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myViewModel.myImagesArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
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
        [self lyModalChoosePicker];
    }
    else {
        LYBaseImageViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"image_view_controller"];
        
        controller.myImage = [self.myViewModel.myImagesArr objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma delegate - placeholder

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.myPlaceholderLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.myPlaceholderLabel.hidden = NO;
    }
    return YES;
}


#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_DELETE_PHOTO object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        UIImage* img = [note.userInfo objectForKey:NOTIFY_UI_DELETE_PHOTO];
        [self.myViewModel updateDeleteImage:img];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_IMAGE_PICKER_DONE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        if (self.myPickImage) {
            [self.myViewModel updateAddImage:self.myPickImage];
        }
    }];
}


@end
