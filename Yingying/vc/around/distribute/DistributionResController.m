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
#import "UIViewController+YingyingNavigationItem.h"
#import "LYColor.h"
#import "MapInfoModel.h"

@interface DistributionResController ()

@property (nonatomic , strong) IBOutlet UITextView*         myResDesc;


@property (nonatomic , strong) IBOutlet UICollectionView*   myImages;
@property (nonatomic , strong) IBOutlet UILabel*            myPlaceholderLabel;

@property (nonatomic , strong) IBOutlet UITextField*        myAddressTextField;
@property (nonatomic , strong) IBOutlet UITextField*        myPriceTextField;
@property (nonatomic , strong) IBOutlet UITextField*        myNameTextField;;

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
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil)
//        {
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(image);
//        }
//        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
//        LYLog(@"file path :%@", filePath);
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self.myViewModel updateAddImage:image];
    }
    
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
        [self onAdd:nil];
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
}


@end
