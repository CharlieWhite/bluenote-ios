//
//  MasterViewController.m
//  bluenote-ios
//
//  Created by Charlie White on 9/7/13.
//  Copyright (c) 2013 Charlie White. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "AddNoteViewController.h"
#import "Note.h"
#import "AppDelegate.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)loadNotes
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"notes" parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  // Handled with articleDescriptor
                                                  _objects = mappingResult.array;
                                                  [self.refreshControl endRefreshing];
                                                  [self.tableView reloadData];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [self.refreshControl endRefreshing];
                                                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                  [alertView show];
                                              }];
    [self.refreshControl endRefreshing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(loadNotes) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDetailView) name:localReceived object:nil];
    
    [self loadNotes];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    if (delegate.showDetail) {
        delegate.showDetail = NO;
        Note *object = [_objects lastObject];
        DetailViewController *dvc = [[DetailViewController alloc] init];
        [self.navigationController pushViewController:dvc animated:YES];
    }

}

- (void) viewDidAppear:(BOOL)animated {
    [self loadNotes];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.showDetail) {
        delegate.showDetail = NO;
        Note *object = [_objects lastObject];
        DetailViewController *dvc = [[DetailViewController alloc] init];
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (void) loadDetailView {
    NSLog(@"load detail view");
    Note *object = [[Note alloc] init];
    object.message = @"Do the dishes! please.";
    DetailViewController *dvc = [[DetailViewController alloc] init];
    [dvc setDetailItem:object];
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [vc setDetailItem:object];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)insertNewObject:(id)sender
{
    AddNoteViewController *addVC = [[AddNoteViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Note *note = _objects[indexPath.row];
    cell.textLabel.text = [note message];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
