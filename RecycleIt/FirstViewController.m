//
//  FirstViewController.m
//  RecycleIt
//
//  Created by Xiaoyi Chen on 5/18/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import "FirstViewController.h"
#import "ItemDetailViewController.h"
#import "RecycleItAppDelegate.h"
#import <sqlite3.h>

@implementation FirstViewController

@synthesize dataSource, tipOfTheDayArray;

- (void)initializeTableData
{    
    sqlite3 *db = [RecycleItAppDelegate getNewDBConnection];
    sqlite3_stmt *statement = nil;
    const char *sql = [@"select * from item" UTF8String];
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
        NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
    else{
        dataSource = [[NSMutableArray alloc]init];
        while(sqlite3_step(statement) == SQLITE_ROW){
            [dataSource addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 1)]];
        }
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.title = @"Search";
    self.navigationController.navigationBar.hidden = YES;
    
    // Override point for customization after app launch 
    [self initializeTableData];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([tipOfTheDayArray count]==0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"tipoftheday" ofType:@"plist"];
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        self.tipOfTheDayArray = tmpArray;
        [tmpArray release];
    }
    
    tipOfTheDayText.text = [tipOfTheDayArray objectAtIndex:random()%[tipOfTheDayArray count]];
    self.navigationController.navigationBar.hidden = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

#pragma mark UISearchBarDelegate

- (void)reloadTableData:(NSString *)searchText{
    [tableData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""]||searchText==nil){
        [myTableView reloadData];
        return;
    }
    NSInteger counter = 0;
    for(NSString *name in dataSource)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        //case insensitive
        NSRange r = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
        //NSRange r = [name rangeOfString:searchText];
        
        if(r.location != NSNotFound)
            [tableData addObject:name];
        counter++;
        [pool release];
    }
    [myTableView reloadData];
}

- (void)itemNameSearched:(NSString *)itemName {
    sqlite3 *db = [RecycleItAppDelegate getNewDBConnection];
    sqlite3_stmt *statement = nil;
    const char *sql = [[NSString stringWithFormat:@"select * from item where name = '%@'", itemName] UTF8String];
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
        NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
    else{
        ItemDetailViewController* itemDetailViewController = [[ItemDetailViewController alloc]     initWithNibName:@"ItemDetailViewController"  bundle:nil];
        itemDetailViewController.title = itemName;
        
        while(sqlite3_step(statement) == SQLITE_ROW){
            itemDetailViewController.itemId = [[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 0)] intValue];
        }
        
        [self.navigationController pushViewController:itemDetailViewController animated:YES];
        [itemDetailViewController release];
        self.navigationController.navigationBar.hidden = NO;
        
        [myTableView removeFromSuperview];
    }
}

- (void)handleSearch:(UISearchBar *)searchBar {
//    NSLog(@"User searched for %@", searchBar.text);
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    
    if ([tableData count] > 0) {
        [self itemNameSearched:[tableData objectAtIndex:0]];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item not found." 
                                                        message:[NSString stringWithFormat:@"You searched for '%@'. But we don't have the information of that item yet. Please search again.", searchBar.text]
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [myTableView removeFromSuperview];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
//    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    [myTableView removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
    
    /*
    ItemDetailViewController* itemDetailViewController = [[ItemDetailViewController alloc]     initWithNibName:@"ItemDetailViewController"  bundle:nil];
    
    itemDetailViewController.title = [NSString stringWithFormat:@"%@", [categoryDetailArray objectAtIndex:row]];
    itemDetailViewController.itemId = [(NSString *)[categoryItemIdArray objectAtIndex:row] intValue];
    
    [self.navigationController]
     */
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //search bar preferences
    sBar.showsCancelButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, sBar.frame.size.height, sBar.frame.size.width, 400)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    //initialize the two arrays; dataSource will be initialized and populated by appDelegate
    searchedData = [[NSMutableArray alloc]init];
    tableData = [[NSMutableArray alloc]init];
    [self reloadTableData:sBar.text];
    //[tableData addObjectsFromArray:dataSource];//on launch it should display all the records
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    sBar.showsCancelButton = NO;
    //[self handleSearch:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadTableData:searchText];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@”contacts error in num of row”);
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row]; 
    return cell;
}

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
    [sBar resignFirstResponder];
    [self itemNameSearched:[tableData objectAtIndex:row]];
}

@end
