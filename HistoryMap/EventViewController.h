//
//  EventViewController.h
//  HistoryMap
//
//  Created by Jitong Yu on 12/27/15.
//  Copyright (c) 2015 Jitong Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController


- (void)setContentWithText:(NSString *)text andImage:(UIImage *)image;
- (void)setBackground:(UIImage *)backgroundImage;
- (void)setText:(NSString *)text;

@end
