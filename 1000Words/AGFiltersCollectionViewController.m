//
//  AGFiltersCollectionViewController.m
//  1000Words
//
//  Created by Albee Gartenberg on 12/27/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import "AGFiltersCollectionViewController.h"
#import "AGPhotoCollectionViewCell.h"
#import "Photo.h"

@interface AGFiltersCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;

@end

@implementation AGFiltersCollectionViewController

-(NSMutableArray *)filters
{
    if (!_filters) _filters = [[NSMutableArray alloc] init];
    return _filters;
}

-(CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
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
    
    self.filters = [[[self class] photoFilters] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

+(NSArray *)photoFilters
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil, nil];
    NSLog(@"Sepia Filter Good");
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussuanBlur" keysAndValues:nil, nil];
    NSLog(@"Blur Filter Good");
    
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues: @"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    NSLog(@"colorClamp Filter Good");
    
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil, nil];
    NSLog(@"instant Filter Good");
    
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil, nil];
    NSLog(@"Noir Filter Good");
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil, nil];
    NSLog(@"vignette Filter Good");
    
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5,nil, nil];
    NSLog(@"colorcontrols Filter Good");
    
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:nil, nil];
    NSLog(@"transfer Filter Good");
    
    CIFilter *unsharpen = [CIFilter filterWithName:@"UIUnsharpMask" keysAndValues:nil, nil];
    NSLog(@"unsharpen Filter Good");
    
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil, nil];
    NSLog(@"monochrome Filter Good");
        
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharpen, monochrome];
    
    return allFilters;
}

-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    CIImage *filteredImage = [filter outputImage];

    CGRect extent = [filteredImage extent];
    
    CGImageRef  cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    
    return finalImage;
}


#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    
    AGPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
    
}

#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AGPhotoCollectionViewCell *selectedCell = (AGPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.photo.image = selectedCell.imageView.image;
    
    NSError *error = nil;
    
    if (![[self.photo managedObjectContext] save:&error]){
        //Handle Error
        NSLog(@"%@", error);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}











@end
