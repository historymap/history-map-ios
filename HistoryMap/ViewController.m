//
//  ViewController.m
//  HistoryMap
//
//  Created by Jitong Yu on 12/26/15.
//  Copyright (c) 2015 Jitong Yu. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>

#import "EventAnnotation.h"
#import "EventViewController.h"

#import "AFNetworking.h"


@interface ViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    UIImage *paperImage;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSArray *eventsArray;

@property (nonatomic, strong) NSArray *annotationsArray;

@end

@implementation ViewController



//static const CLLocationCoordinate2D HangzhouLocation = {30.3, 120.2};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self; //manage annotation delegate
    
    [self showStartLocation];
    
    [self startStandardUpdates];
    
    [self downloadAndSetupData];
    
    [self zoomToCurrentLocation];
    
    paperImage = [UIImage imageNamed:@"paper.jpg"];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma show current location

static const CLLocationCoordinate2D HangzhouLocation = {30.3, 120.2};
- (void)showStartLocation
{
    //start region
    MKCoordinateRegion newRegion;
    newRegion.center = HangzhouLocation;
    newRegion.span.latitudeDelta = 10.0;
    newRegion.span.longitudeDelta = 10.0;
    self.mapView.region = newRegion;
}

- (void)zoomToCurrentLocation
{
    [self startStandardUpdates];
}

- (void)startStandardUpdates
{
    NSLog(@"start standard updates");
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 10; // meters
    
    //if (iOSVersion>=8) {
    [locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    //}
    
    if ([CLLocationManager locationServicesEnabled])
    {
        //NSLog(@"location service enabled");
        [locationManager startUpdatingLocation];
    }
    else
        NSLog(@"location services not enabled");
    
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"location manager did update locations");
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    currentLocation = location;
    [self showMapWithLocation:currentLocation];
    [locationManager stopUpdatingLocation];
    self.navigationItem.title = @"杭州";
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}


- (void)showMapWithLocation:(CLLocation *)location
{
    MKCoordinateRegion newRegion;
    newRegion.center = location.coordinate;
    newRegion.span.latitudeDelta = 0.1;
    newRegion.span.longitudeDelta = 0.1;
    [self.mapView setRegion:newRegion animated:YES];
    [self.mapView setShowsUserLocation:YES];
}



#pragma download data

/*
- (void)downloadAndSetupData
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://10.0.0.12:3000/api/Buildings"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSString *downloadedFile = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@", downloadedFile);
        [self setupEventsArrayWithData:downloadedFile];
        [self setupAnnotationsArrayWithEventsArray];
        [self showAnnotations];
    }];
    [downloadTask resume];
}
*/

/*
- (void)downloadAndSetupData
{

    //初始化数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //NSDictionary *parameter = @{@"user": @"root"};
    
    
    //设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //设置接收格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //这里是需要注意的一点，如果你的程序在解析的时候出现了错误，并打印了error的错误数据，多半是在设置接收格式的时候，少些了这一句代码。
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //请求数据
    [manager GET:@"http://10.0.0.12:3000/api/Buildings" parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
 
        if (responseObject) {
            self.firstData = responseObject;
            self.dataArray = responseObject[@"data"];
        }
 
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"Error == %@",error);
    }];
    
    
}
*/

- (void)downloadAndSetupData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:@"http://0.0.0.0:3000/api/Buildings" parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
        
        [self setupEventsArray:responseObject];
        [self setupAnnotationsArrayWithEventsArray];
        [self showAnnotations];

    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)setupEventsArray:(NSArray *)dataArray
{
    self.eventsArray = dataArray;
    NSLog(@"events number = %lu", (unsigned long)self.eventsArray.count);

}


/*
- (void)setupEventsArrayWithData:(NSString *)dataString
{
    NSString *jsonDataString = dataString;
    NSError *error;
    NSData *data = [jsonDataString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSArray *jsonArray = (NSArray*)jsonObject;
        
 
        for (id building in jsonArray) {
            if ([building isKindOfClass:[NSDictionary class]]) {
                NSLog(@"%@", building[@"name"]);
            }
        }
 
        self.eventsArray = jsonArray;
        NSLog(@"events number = %lu", (unsigned long)self.eventsArray.count);
    }
}
*/


- (void)setupAnnotationsArrayWithEventsArray
{
    NSMutableArray *tempAnnotationsArray = [[NSMutableArray alloc] init];
    
    for (id building in self.eventsArray) {
        NSString* name = building[@"name"];
        NSArray* events = building[@"events"];
        NSDictionary *event = [events firstObject];
        NSString* title = event[@"title"];
        NSString* time = event[@"time"];
        NSString* summary = event[@"summary"];
        
        NSDictionary* locationDic = building[@"location"];
        NSString* lat = locationDic[@"lat"];
        NSString* lng = locationDic[@"lng"];
        float lattitude = [lat floatValue];
        float longitude = [lng floatValue];
        CLLocationCoordinate2D location = {lattitude, longitude};
        
        NSString *subtitle = [NSString stringWithFormat:@"%@, %@", time, name];
        
        NSLog(@"%@", name);
        
        EventAnnotation *annotation = [[EventAnnotation alloc] initWithImage:nil Title:title subtitle:subtitle summary:summary coordinate:location];
        
        [tempAnnotationsArray addObject:annotation];
    }
    NSLog(@"annotation array count: %lu", (unsigned long)tempAnnotationsArray.count);
    
    
    self.annotationsArray = [NSArray arrayWithArray:tempAnnotationsArray];
    NSLog(@"annotation array count: %lu", (unsigned long)self.annotationsArray.count);
}





//show annotations

- (void)showAnnotations
{
    NSLog(@"show annotations");
    [self.mapView addAnnotations:self.annotationsArray];
}



- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"view for annotation");
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // 处理我们自定义的Annotation
    if ([annotation isKindOfClass:[EventAnnotation class]]) {
        static NSString* eventAnnotationIdentifier = @"EventAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:eventAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:eventAnnotationIdentifier];
        }
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        return pinView;
    }
    return nil;
}











// user tapped the call out accessory 'i' button
- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    EventAnnotation *annotation = (EventAnnotation *)view.annotation;
    EventViewController *evc = [[EventViewController alloc] init];
    //NSLog(@"%@", annotation.summary);
    [evc setBackground:paperImage];
    [evc setText:annotation.summary];
    
    //[evc setContentWithText:annotation.summary andImage:paperImage];
    [self.navigationController pushViewController:evc animated:YES];
    evc.navigationItem.title = annotation.title;
}







@end
