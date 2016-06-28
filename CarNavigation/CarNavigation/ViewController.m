//
//  ViewController.m
//  CarNavigation
//
//  Created by zhangbin on 16/6/28.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
/** 定位管理者*/
@property(nonatomic,strong)CLLocationManager *mgr;
/** 上一次的位置*/
@property(nonatomic,strong)CLLocation *PreviousLocation;
/** 汽车总路程*/
@property(nonatomic,assign)CLLocationDistance SumDistance;
/** 汽车总时间*/
@property(nonatomic,assign)NSTimeInterval SumTime;

@end

@implementation ViewController
// 1.懒加载创建定位管理者
-(CLLocationManager *)mgr{
    if (_mgr == nil) {
        self.mgr = [[CLLocationManager alloc]init];
    }
    return _mgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   // 2.设置代理
    self.mgr.delegate = self;
   // 3.判断系统版本
    if ([[UIDevice currentDevice].systemVersion doubleValue] >=9.0) {
        // 主动请求授权
        [self.mgr requestAlwaysAuthorization];
    }
   // 4.开始定位
    [self.mgr startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 获取当前位置
    CLLocation *CurrentLocation = [locations lastObject];// locations是代理方法的参数
    if (self.PreviousLocation !=nil) {
        // 计算当前位置CurrentLocation和之前位置PreviousLocation的距离(单位:米)
        CLLocationDistance Distance = [CurrentLocation distanceFromLocation:self.PreviousLocation];
        // 计算当前位置CurrentLocation的时间和之前位置PreviousLocation的时间之间的差值（单位:秒）
        //  CLLocation类的timestamp属性:获取位置信息的时间，信息中包含距离,时间等等
        NSTimeInterval Time = [CurrentLocation.timestamp timeIntervalSinceDate:self.PreviousLocation.timestamp];
        // 计算当期位置和之前位置的速度(米/秒)
        CGFloat Speed = Distance / Time;
        // 累加汽车开的总距离
        self.SumDistance +=Distance;
        // 累加汽车开的总时间
        self.SumTime += Time;
        // 计算汽车总的平均速度
        CGFloat AllAvageSpeed = self.SumDistance / self.SumTime;
        NSLog(@"两次距离的差值%lf 时间的差值%lf 两次的平均速度%lf 总距离%lf 总时间%lf 总的平均速度%lf",Distance,Time,Speed,self.SumDistance,self.SumTime,AllAvageSpeed);
    }
    // 执行到这里将这次的位置变为上一次的位置.因为newLocation的创建分配了存储空间，所以给previousLocation赋值，那么previousLocation也相当于创建了存储空间
    self.PreviousLocation = CurrentLocation;
}

@end
