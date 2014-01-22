//
//  AGPhotoCollectionViewController.m
//  1000Words
//
//  Created by Albee Gartenberg on 12/23/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import "AGPhotoCollectionViewController.h"
#import "AGPhotoCollectionViewCell.h"
#import "Photo.h"
#import "AGPictureDataTransformer.h"
#import "AGCoreDataHelper.h"
#import "AGPhotoDetailViewController.h"

@interface AGPhotoCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;  //Of UIImages

@end

@implementation AGPhotoCollectionViewController

-(NSMutableArray *)photos  //LAZY INSTANTIATION
{
    if (!_photos){
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSSet *unorderedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    [self.collectionView reloadData];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[AGPhotoDetailViewController class]])
        {
            AGPhotoDetailViewController *targetViewController = segue.destinationViewController;
            
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
            
            Photo *selectedPhoto = self.photos[indexPath.row];
            targetViewController.photo = selectedPhoto;
        }
    }
}

/* When we press the camera button, we create a UIImagePickerController and present the available
 option on the screen. If the camera is available because we are using our phone we show that. If not 
 then we show the Photos Album. */
- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - Helper Methods

-(Photo *)photoFromImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[AGCoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumbook = self.album;
    
    NSError *error = nil;
    if (![[photo managedObjectContext] save:&error]){
        //Error in Saving
        NSLog(@"%@", error);
    }
    return photo;
}



#pragma mark - UICollectionViewDataSource

//Display the photos stored in the photo's array
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Photo Cell";
    
    AGPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = photo.image;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

#pragma mark - UIImagePickerControllerDelegate

// If the User chooses media this delegate will fire. Using the parameters we can determine which media object they selected.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];

    [self.photos addObject:[self photoFromImage:image]];
    
    [self.collectionView reloadData];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// If the user presses cancel - dismisses the ImagePickerController
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end



