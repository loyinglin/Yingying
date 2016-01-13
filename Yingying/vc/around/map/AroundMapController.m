//
//  AroundMapController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMapController.h"
#import "UIViewController+YingyingModalViewController.h"
#import "AroundMapViewModel.h"
#import "LYAnnotationView.h"
#import "MapInfoModel.h"
#import "UserModel.h"
#import <objc/runtime.h>

@interface AroundMapController ()
@property (nonatomic , strong) IBOutlet BMKMapView* myMapView;
@property (nonatomic , strong) BMKLocationService* myLocationService;
@property (nonatomic , strong) BMKGeoCodeSearch* mySearchService;

@property (nonatomic , strong) AroundMapViewModel* myViewModel;
@end

@implementation AroundMapController {
    NSArray<BMKPointAnnotation *>* myPoints;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myViewModel = [AroundMapViewModel new];
    [self customMap];
    [self customNotify];
    
    @weakify(self);
    [RACObserve(self.myViewModel, myMapUserInfoArr) subscribeNext:^(id x) {
        @strongify(self);
        [self updateMapAnnotation];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view init

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.myMapView.delegate = self;
    self.myLocationService.delegate = self;
    self.mySearchService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.myMapView.delegate = nil;
    self.myLocationService.delegate = nil;
    self.mySearchService.delegate = nil;
}

- (void)customMap {
    self.myMapView.delegate = self;
    
    //    [self addAnimatedAnnotation];
    self.myLocationService = [[BMKLocationService alloc] init];
    self.myLocationService.delegate = self;
    
    self.mySearchService = [[BMKGeoCodeSearch alloc] init];
    self.mySearchService.delegate = self;
    
    [self.myLocationService startUserLocationService];
}
#pragma mark - ibaction

- (IBAction)onMine:(id)sender {
    UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"mine_view_controller"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onLeading:(id)sender {
    if ([MapInfoModel instance].myPosition.latitude) {
//        self.myMapView.showsUserLocation = !self.myMapView.showsUserLocation;
        [self.myMapView setCenterCoordinate:[MapInfoModel instance].myPosition animated:YES];
    }
    else {
        [self presentMessageTips:@"尚未定位"];
    }
}

#pragma mark - ui

- (void)updateMapAnnotation {
    [self.myMapView removeAnnotations:self.myMapView.annotations]; //把原来的remove
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < self.myViewModel.myMapUserInfoArr.count; ++i) {
        BMKPointAnnotation* pointAnnotation = [BMKPointAnnotation new];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [self.myViewModel getlatitudeByIndex:i].floatValue;
        coordinate.longitude = [self.myViewModel getLongitudeByIndex:i].floatValue;
        pointAnnotation.coordinate = coordinate;
        pointAnnotation.title = [self.myViewModel getMapUserInfoByIndex:i].nickname;
        [arr addObject:pointAnnotation];
    }
    myPoints = arr;
    [self.myMapView addAnnotations:myPoints];
    [self.myMapView showAnnotations:myPoints animated:YES];
}
#pragma mark - delegate - location

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    LYLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKLocationViewDisplayParam* param = [[BMKLocationViewDisplayParam alloc] init];
    param.locationViewImgName = @"map_myself_location";
    //    param.isAccuracyCircleShow = YES;
    //
    self.myMapView.showsUserLocation = YES;
    [self.myMapView updateLocationViewWithParam:param];
    [self.myMapView updateLocationData:userLocation];
    
    [self.myMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.myLocationService stopUserLocationService];
    BMKReverseGeoCodeOption* option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = userLocation.location.coordinate;
    
    
    [[MapInfoModel instance] updatecurrentLocationWith:userLocation.location.coordinate];
    [self.myViewModel requestRefreshLocation];
    [self.mySearchService reverseGeoCode:option];
}


#pragma mark - delegate - map

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    LYLog(@"map load end");
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if ([myPoints containsObject:annotation]) {
        NSString *AnnotationViewID = @"renameMark";
        LYAnnotationView *annotationView = (LYAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[LYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            long index = [myPoints indexOfObject:annotation];
            MapUserInfo* info = [self.myViewModel getMapUserInfoByIndex:index];
            if (info) {
                [annotationView customViewWithGenderIsMalf:[info.gender isEqualToString:@"m"] AvatarUrl:info.thumbUrl];
            }
            // 设置颜色
            //            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            //            annotationView.animatesDrop = YES;
            // 设置可拖拽
            //            annotationView.draggable = YES;
            
            //
            //            CGRect rect = view.frame;
            //            rect.origin.x = - (rect.size.width / 2);
            //            rect.origin.y = - (rect.size.height / 2);
            //            view.frame = rect;
            //            [annotationView addSubview:view];
            
            //            annotationView.image = [UIImage imageNamed:@"map_avatar"];
            //            annotationView.centerOffset = CGPointMake(-100, -75);
            
            //            UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_avatar"]];
            //            annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:img];
            
            //            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
            //            [annotationView addGestureRecognizer:tap];
        }
        return annotationView;
    }
    
    //    动画annotation
    //    NSString *AnnotationViewID = @"AnimatedAnnotation";
    //    MyAnimatedAnnotationView *annotationView = nil;
    //    if (annotationView == nil) {
    //        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    //    }
    //    NSMutableArray *images = [NSMutableArray array];
    //    for (int i = 1; i < 4; i++) {
    //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
    //        [images addObject:image];
    //    }
    //    annotationView.annotationImages = images;
    return nil;
    
}

-(UIImage *)getImageFromView:(UIView *)theView
{
    //    UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    LYLog(@"paopaoclick");
    if (![view.reuseIdentifier isEqualToString:@"renameMark"]) {
        [self lyModalPersonalHomePageWithUserphone:[[UserModel instance] getMyUserphone]];
    }
    else {
        long index = [myPoints indexOfObject:view.annotation];
        MapUserInfo* info = [self.myViewModel getMapUserInfoByIndex:index];
        if (info) {
            [self lyModalPersonalHomePageWithUserphone:info.userphone];
        }
    }
}

- (void)select:(id)sender {
    LYLog(@"sender click");
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    //    [mapView deselectAnnotation:view.annotation animated:YES];
    //    LYLog(@"click ");
    //    UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"personal_home_page_controller"];
    //    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - delegate - search

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        LYLog(@"address %@", [result address]);
        [[MapInfoModel instance] updateCurrentPositionWithAddress:result.address];
    }
    else {
        LYLog(@"error");
    }
}



#pragma mark - notify

- (void)customNotify {
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_UI_MAP_FILTER_UPDATE object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        NSNumber* filterNumber = [note.userInfo objectForKey:NOTIFY_UI_MAP_FILTER_UPDATE];
        if (filterNumber) {
            long type = filterNumber.integerValue;
            switch (type) {
                case notify_enum_map_filter_all:
                    self.myViewModel.myGender = nil;
                    self.myViewModel.myMood = nil;
                    break;
                case notify_enum_map_filter_female:
                    self.myViewModel.myGender = @"f";
                    self.myViewModel.myMood = nil;
                    break;
                    
                case notify_enum_map_filter_male:
                    self.myViewModel.myGender = @"m";
                    self.myViewModel.myMood = nil;
                    break;
                    
                case notify_enum_map_filter_mood:
                    self.myViewModel.myGender = nil;
                    self.myViewModel.myMood = @"mood";
                    break;
                    
                case notify_enum_map_filter_res:
                    self.myViewModel.myGender = nil;
                    self.myViewModel.myMood = @"res";
                    break;
                    
                default:
                    break;
            }
        }
        [self.myViewModel requestRefreshLocation];
    }];
}

@end
