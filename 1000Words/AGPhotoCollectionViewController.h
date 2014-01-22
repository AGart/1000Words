//
//  AGPhotoCollectionViewController.h
//  1000Words
//
//  Created by Albee Gartenberg on 12/23/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface AGPhotoCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
