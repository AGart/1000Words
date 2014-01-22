//
//  AGAlbumTableViewController.h
//  1000Words
//
//  Created by Albee Gartenberg on 12/20/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGAlbumTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *albums;

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
