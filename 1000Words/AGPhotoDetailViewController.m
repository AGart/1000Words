//
//  AGPhotoDetailViewController.m
//  1000Words
//
//  Created by Albee Gartenberg on 12/27/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import "AGPhotoDetailViewController.h"
#import "Photo.h"
#import "AGFiltersCollectionViewController.h"

@interface AGPhotoDetailViewController ()

@end

@implementation AGPhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.imageView.image = self.photo.image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toFilterSegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[AGFiltersCollectionViewController class]])
            {
                AGFiltersCollectionViewController *targetViewController = segue.destinationViewController;
                targetViewController.photo = self.photo;
            }
    }
}



- (IBAction)addFilterButtonPressed:(UIButton *)sender
{
    
    
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    
    [[self.photo managedObjectContext] deleteObject: self.photo];
    
    NSError *error = nil;
    [[self.photo managedObjectContext] save:&error];
    if (error)
        {
            NSLog(@"ERROR");
        }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //Why don't you need to ReloadData????
    
}












@end
