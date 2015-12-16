//
//  AroundModalAddressController.m
//  Yingying
//
//  Created by 林伟池 on 15/12/16.
//  Copyright © 2015年 林伟池. All rights reserved.
//

#import "AroundModalAddressController.h"
#import "AroundAddressViewModel.h"

@interface AroundModalAddressController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic , strong) AroundAddressViewModel*      myViewModel;
@property (nonatomic , strong) IBOutlet UIPickerView*       myPicker;

@property (nonatomic , assign) long myIndexProvince;
@property (nonatomic , assign) long myIndexCity;
@property (nonatomic , assign) long myIndexArea;

@end

@implementation AroundModalAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myViewModel = [AroundAddressViewModel new];
    
    [self.myViewModel updateSelectedProvince:0];
    [self.myViewModel updateSelectedCity:0];
    self.myIndexArea = self.myIndexCity = self.myIndexProvince = 0;
    
//    self.myPicker
    
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

#pragma mark - ibaction

- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onSure:(id)sender {
    NSLog(@"adddress %@", [self.myViewModel getAddressByProvince:self.myIndexProvince City:self.myIndexCity Area:self.myIndexArea]);
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - ui

#pragma mark - delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    long ret = 0;
    switch (component) {
        case 0:
            ret = [self.myViewModel getProvinceCount];
            break;
        case 1:
            ret = [self.myViewModel getCitysCount];
            break;
            
        case 2:
            ret = [self.myViewModel getAreasCount];
            break;
            
            
        default:
            break;
    }
    return ret;
}




- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CityItem* item;
    
    switch (component) {
        case 0:
            item = [self.myViewModel getProvinceByIndex:row];
            break;
        case 1:
            item = [self.myViewModel getCityByIndex:row];
            break;
            
        case 2:
            item = [self.myViewModel getAreaByIndex:row];
            break;
            
            
        default:
            break;
    }
    
    NSString* str;
    if (item) {
        str = item.cityName;
    }
    else {
        str = @"无";
    }
    
    return str;
//    return [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [self.myViewModel updateSelectedProvince:row];
        [self.myViewModel updateSelectedCity:0];
        [self.myPicker reloadComponent:1];
        [self.myPicker reloadComponent:2];
        self.myIndexProvince = row;
    }
    else if(component == 1){
        [self.myViewModel updateSelectedCity:row];
        [self.myPicker reloadComponent:2];
        self.myIndexCity = row;
    }
    else {
        self.myIndexArea = row;
    }
    
}
#pragma mark - notify


@end
