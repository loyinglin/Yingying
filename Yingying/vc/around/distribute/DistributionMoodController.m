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
#import <MBProgressHUD.h>


@interface DistributionMoodController ()

@property (nonatomic , strong) IBOutlet UICollectionView* myImages;
@property (nonatomic , strong) IBOutlet UILabel*        myAddressLabel;

@property (nonatomic , strong) MBProgressHUD*  HUD;

@property (nonatomic , strong) DistributionMoodViewModel* myViewModel;

@end

@implementation DistributionMoodController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.myViewModel = [DistributionMoodViewModel new];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:UIColorFromRGB(0x778c93)} forState:UIControlStateNormal];
    
    [RACObserve(self.myViewModel, myImagesArr) subscribeNext:^(id x) {
        [self.myImages reloadData];
        [self performSelector:@selector(updateCollectionLayout) withObject:nil afterDelay:0.1]; //update yanchi
    }];
    
    
    RAC(self.myAddressLabel, text) = RACObserve([MapInfoModel instance], myAddress);
    
    [self customNotify];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    LYLog(@"dealloc message");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - view init

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)updateCollectionLayout {
    for (NSLayoutConstraint* constraint in self.myImages.constraints) {
        if ([constraint.identifier isEqualToString:@"height"]) {
            if (self.myImages.contentSize.height) {
                constraint.constant = self.myImages.contentSize.height;
            }
        }
    }
    [self.view setNeedsLayout];
}

#pragma mark - ibaction

- (IBAction)onDistribute:(id)sender {
//    [self.navigationController presentMessageTips:@"发布成功"];
//    [self.navigationController popViewControllerAnimated:YES];
    
    [self.myViewModel requestSendMoodWithContent:@"test loy"];
    
}

- (IBAction)onAdd:(id)sender {
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        LYLog(@"cancel");
    }];
    [controller addAction:cancel];
    
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    [controller addAction:takePhoto];
    
    UIAlertAction* localPhoto = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        LYLog(@"file path :%@", filePath);
        

        
        [self.myViewModel requestUploadImage:filePath View:self.view];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self.myViewModel updateAddImage:image];
//        self.myImageView.image = image;

        
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
    LYLog(@"click %ld", indexPath.row);
}

#pragma mark - notify

- (void)customNotify {
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_PROGRESS_UPLOAD object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        /***/
        if (!self.HUD) {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:self.HUD];
            
            // Set determinate mode
            self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
            
            self.HUD.labelText = @"上传中";
            [self.HUD show:YES];

        }
        /***/
        NSNumber* progress = [note.userInfo objectForKey:NOTIFY_PROGRESS_UPLOAD];
        if (progress.floatValue < 0 || progress.floatValue >= 1.0) {
            [self.HUD removeFromSuperview];
        }
        else {
            self.HUD.progress = progress.floatValue;
        }
    }];
}

@end
