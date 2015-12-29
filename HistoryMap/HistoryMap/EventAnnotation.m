//
//  EventAnnotation.m
//  HistoryMap
//
//  Created by Jitong Yu on 12/27/15.
//  Copyright (c) 2015 Jitong Yu. All rights reserved.
//

#import "EventAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@implementation EventAnnotation


- (id)initWithImage: (UIImage *)image Title:(NSString *)title subtitle:(NSString *)subtitle summary:(NSString *)summary coordinate:(CLLocationCoordinate2D)coordinate;
{
    self = [super init];
    if (self != nil) {
        self.headImage = image;
        self.title = title;
        self.subtitle = subtitle;
        self.summary = summary;
        self.coordinate = coordinate;
    }
    return self;
}

/*
- (NSString *)stringForPlacemark:(CLPlacemark *)placemark {
    
    NSMutableString *string = [[NSMutableString alloc] init];
    if (placemark.locality) {
        [string appendString:placemark.locality];
    }
    
    if (placemark.administrativeArea) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendString:placemark.administrativeArea];
    }
    
    if (string.length == 0 && placemark.name)
        [string appendString:placemark.name];
    
    return string;
}

- (void)updateSubtitleIfNeeded {
    
    if (self.subtitle == nil) {
        // for the subtitle, we reverse geocode the lat/long for a proper location string name
        CLLocation *location = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks[0];
                self.subtitle = [NSString stringWithFormat:@"Near %@", [self stringForPlacemark:placemark]];
            }
        }];
    }
}

*/

@end