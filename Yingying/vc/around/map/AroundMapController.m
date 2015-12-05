//
//  AroundMapController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/4.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundMapController.h"


@interface AroundMapController ()
@property (nonatomic , strong) IBOutlet BMKMapView* myMapView;
@property (nonatomic , strong) BMKLocationService* myLocationService;
@end

@implementation AroundMapController {
    NSArray<BMKPointAnnotation *>* myPoints;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myMapView.delegate = self;
    
    [self addPointAnnotation];
//    [self addAnimatedAnnotation];
    self.myLocationService = [[BMKLocationService alloc] init];
    self.myLocationService.delegate = self;
    
    [self.myLocationService startUserLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.myMapView.delegate = self;
    self.myLocationService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.myMapView.delegate = nil;
    self.myLocationService.delegate = nil;
}
#pragma mark - ibaction

#pragma mark - ui

- (void)addPointAnnotation
{
    NSMutableArray* arr = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
        BMKPointAnnotation* pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39 + i * 0.2;
        coor.longitude = 116 + i * 0.2;
        pointAnnotation.coordinate = coor;
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
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
//    self.myMapView.showsUserLocation = YES;
//    [self.myMapView updateLocationData:userLocation];
    [self.myMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}


#pragma mark - delegate - map

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSLog(@"map load end");
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSLog(@"normal");
    //普通annotation
    if ([myPoints containsObject:annotation]) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
            
            annotationView.image = [UIImage imageNamed:@"first"];
            [annotationView setFrame:CGRectMake(0, 0, 30, 30)];
            
            UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"second"]];
            [img setFrame:CGRectMake(0, 0, 30, 30)];
            annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:img];
            
            UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"CustomMapView" owner:nil options:nil] lastObject];
            
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
            [annotationView.paopaoView addGestureRecognizer:tap];
//            annotationView.paopaoView = [[BMKActionPaopaoView alloc] init];
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


// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    NSLog(@"paopaoclick");
}

- (void)select:(id)sender {
    NSLog(@"sender click");
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    [mapView deselectAnnotation:view.annotation animated:YES];
    NSLog(@"click ");
}
#pragma mark - notify


@end
