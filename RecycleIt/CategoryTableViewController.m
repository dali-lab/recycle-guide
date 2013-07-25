//
//  CategoryTableViewController.m
//  RecycleIt
//
//  Created by Xiaoyi Chen on 9/26/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "CategoryDetailTableViewController.h"
#import "RecycleItAppDelegate.h"

#import "CategoryCell.h"


#import <sqlite3.h>

@implementation CategoryTableViewController

@synthesize categoryArray, categoryIdArray;
@synthesize categoryDetailTableViewController;

- (void)initializeTableData
{
    sqlite3 *db = [RecycleItAppDelegate getNewDBConnection];
    sqlite3_stmt *statement = nil;
    const char *sql = "select * from category";
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
        NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
    else{
        while(sqlite3_step(statement) == SQLITE_ROW){
            [categoryArray addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 1)]];
            [categoryIdArray addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 0)]];
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
    [categoryArray release];
    [categoryIdArray release];
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

    self.title = NSLocalizedString(@"Categories", @"");
    
    //NSMutableArray *array = [[NSArray alloc] initWithObjects: @"category1", @"category2", nil];
    //self.categoryArray = array;
    //[array release];
    
    self.categoryArray = [[NSMutableArray alloc]init];
    self.categoryIdArray = [[NSMutableArray alloc]init];
    [self initializeTableData];
    
    
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
    return [self.categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    
    CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    //cell.text = [categoryArray objectAtIndex:row];
    cell.primaryLabel.text = [categoryArray objectAtIndex:row];
    cell.myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"categories_%d.jpg", row+1]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    
    categoryDetailTableViewController = [[CategoryDetailTableViewController alloc] initWithNibName:@"CategoryDetailTableViewController"  bundle:nil];
    
    categoryDetailTableViewController.categoryId = [(NSString *)[categoryIdArray objectAtIndex:row] intValue];
    [categoryDetailTableViewController initializeTableData];
    
    categoryDetailTableViewController.title = [NSString stringWithFormat:@"%@", [categoryArray objectAtIndex:row]];
    RecycleItAppDelegate *delegate = (RecycleItAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.categoryNavController pushViewController:categoryDetailTableViewController animated:YES];
    [categoryDetailTableViewController release];
}

@end
