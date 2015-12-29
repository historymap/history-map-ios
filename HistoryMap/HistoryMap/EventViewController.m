//
//  EventViewController.m
//  HistoryMap
//
//  Created by Jitong Yu on 12/27/15.
//  Copyright (c) 2015 Jitong Yu. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController (){
    UITextView *tv;
    UIImageView *iv;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)setText:(NSString *)text
{
    
    
    tv = [[UITextView alloc] initWithFrame:self.view.frame];
    tv.font = [UIFont fontWithName:@"Arial"size:18.0];
    
    tv.editable = NO;
    tv.text = text;
    tv.textContainerInset = UIEdgeInsetsMake(100.0, 30.0, 30.0, 30.0);
    tv.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    tv.opaque = NO;
    [self.view addSubview:tv];
}



- (void)setBackground:(UIImage *)backgroundImage
{
    iv = [[UIImageView alloc] initWithFrame:self.view.frame];
    //iv.frame = self.view.frame;
    iv.image = backgroundImage;
    [self.view addSubview:iv];
}


- (void)setContentWithText:(NSString *)text andImage:(UIImage *)image
{

    tv = [[UITextView alloc] initWithFrame:self.view.frame];
    tv.font = [UIFont fontWithName:@"Arial"size:18.0];
    tv.editable = NO;
    tv.text = text;

    iv = [[UIImageView alloc] initWithImage:image];
    iv.frame = self.view.frame;
    
    
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectZero];
    [parentView addSubview:iv];
    [iv setFrame:self.view.frame];
    [parentView addSubview:tv];
    [tv setFrame:self.view.frame];
    [parentView sizeToFit];
    
    UIGraphicsBeginImageContext([parentView bounds].size);
    [[parentView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [iv removeFromSuperview];
    iv.image = outputImage;
    [self.view addSubview:iv];
}

@end
