//
//  AGAlbumTableViewController.m
//  1000Words
//
//  Created by Albee Gartenberg on 12/20/13.
//  Copyright (c) 2013 Albee Gartenberg. All rights reserved.
//

#import "AGAlbumTableViewController.h"
#import "Album.h"
#import "AGCoreDataHelper.h"
#import "AGPhotoCollectionViewController.h"

@interface AGAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation AGAlbumTableViewController

-(NSMutableArray *)albums
{
    if (!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    //Super = do all the functionality defined in our Super Class then do our implementation of the method
    [super viewWillAppear:animated];
    
    //NSFetchRequest object = used as a search criteria for NSManagedObjects in our persistant store or database
    // -- "give me all the album objects back" ....make sure to organize them "sort them by the date" and by Ascending...
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    
    NSError *error = nil;
    
    NSArray *fetchedAlbums = [[AGCoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    //set the value of the album's property = to the mutable copy (makes an NSArray to a mutable one)
    self.albums = [fetchedAlbums mutableCopy];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIAlertView *newAlbumAlert = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name!" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [newAlbumAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [newAlbumAlert show];
}

#pragma mark - Helper Methods

-(Album *)albumWithName:(NSString *)name;
{
    
    NSManagedObjectContext *context = [AGCoreDataHelper managedObjectContext];
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = name;
    album.date = [NSDate date];
    
    NSError *error = nil;
    if (![context save:&error]){
        //we have and error!
        NSLog(@"%@", error);
    }
    return album;
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.albums addObject:[self albumWithName:alertText]];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Album *selectedAlbum = self.albums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Album Chosen"]){
        
        if ([segue.destinationViewController isKindOfClass:[AGPhotoCollectionViewController class]]){
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            
            AGPhotoCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.album = self.albums [path.row];
        }
        
    }
    
}
@end
