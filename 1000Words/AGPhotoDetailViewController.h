//
//  AGPhotoDetailViewController.h
//  1000Words
//
//  Created by Albee Gartenberg on 12/27/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface AGPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;

@end
