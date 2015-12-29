//
//  EventAnnotation.h
//  HistoryMap
//
//  Created by Jitong Yu on 12/27/15.
//  Copyright (c) 2015 Jitong Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EventAnnotation : NSObject <MKAnnotation>

- (id)initWithImage: (UIImage *)image Title:(NSString *)title subtitle:(NSString *)subtitle summary:(NSString *)summary coordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic) CLLocationCoordinate2D coordinate;


@end
