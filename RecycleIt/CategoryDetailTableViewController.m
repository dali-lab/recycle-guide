//
//  CategoryDetailTableViewController.m
//  RecycleIt
//
//  Created by Xiaoyi Chen on 9/26/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import "CategoryDetailTableViewController.h"
#import "ItemDetailViewController.h"

#import "RecycleItAppDelegate.h"
#import <sqlite3.h>


@implementation CategoryDetailTableViewController

@synthesize categoryDetailArray, categoryItemIdArray, categoryId;


- (void)initializeTableData
{    
    self.categoryDetailArray = [[NSMutableArray alloc]init];
    self.categoryItemIdArray = [[NSMutableArray alloc]init];
    
    sqlite3 *db = [RecycleItAppDelegate getNewDBConnection];
    sqlite3_stmt *statement = nil;
    const char *sql = [[NSString stringWithFormat:@"select * from item where categoryid = %d", categoryId] UTF8String];
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
        NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
    else{
        while(sqlite3_step(statement) == SQLITE_ROW){
            [categoryDetailArray addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 1)]];
            [categoryItemIdArray addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 0)]];
        }
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.categoryDetailArray release];
    [self.categoryItemIdArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //[self initializeTableData];
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" 
                                                    message:[NSString stringWithFormat:@"%d", categoryId]
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    self.title = NSLocalizedString(@"Category", @"");
    */
     
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [categoryDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [categoryDetailArray objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    NSInteger row = [indexPath row];

    
    ItemDetailViewController* itemDetailViewController = [[ItemDetailViewController alloc]     initWithNibName:@"ItemDetailViewController"  bundle:nil];
    
    itemDetailViewController.itemId = [(NSString *)[categoryItemIdArray objectAtIndex:row] intValue];
    
    RecycleItAppDelegate *delegate = (RecycleItAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.categoryNavController pushViewController:itemDetailViewController animated:YES];
    [itemDetailViewController release];
}

@end
