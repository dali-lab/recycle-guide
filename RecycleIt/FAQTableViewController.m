//
//  FAQTableViewController.m
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/17/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import "FAQTableViewController.h"
#import "FAQDetailViewController.h"
#import "FAQCell.h"
#import "RecycleItAppDelegate.h"

#import <sqlite3.h>

@implementation FAQTableViewController

@synthesize questionArray, answerArray;

@synthesize objectsForSections, answersForSections, arrayOfSections;


- (void)initializeTableData
{
    sqlite3 *db = [RecycleItAppDelegate getNewDBConnection];
    sqlite3_stmt *statement = nil;
    const char *sql = "select distinct section from faq";
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
        NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
    else{
        while(sqlite3_step(statement) == SQLITE_ROW){
            [arrayOfSections addObject:[NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 0)]];
        }
    }
    
    for(int i = 0; i < [arrayOfSections count]; i++){
        sqlite3_stmt *statement = nil;
        NSString* section = [arrayOfSections objectAtIndex:i];

        const char *sql = [[NSString stringWithFormat:@"select * from faq where section = '%@'", section] UTF8String];
        
        if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
            NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
        else{
            NSMutableArray *arrayOfQuestions = [[NSMutableArray alloc]init];
            NSMutableArray *arrayOfAnswers = [[NSMutableArray alloc]init];

            while(sqlite3_step(statement) == SQLITE_ROW){
                [arrayOfQuestions addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)]];
                [arrayOfAnswers addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 2)]];
            }
            if([arrayOfQuestions count] >0)
            {
                [objectsForSections setObject:arrayOfQuestions forKey:[NSString stringWithFormat:@"%@", section]];
            }
            if([arrayOfAnswers count] >0)
            {
                [answersForSections setObject:arrayOfAnswers forKey:[NSString stringWithFormat:@"%@", section]];
            }
            [arrayOfQuestions release];
            [arrayOfAnswers release];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = NSLocalizedString(@"FAQ", @"");
    
    self.arrayOfSections = [[NSMutableArray alloc]init];
    self.objectsForSections = [[NSMutableDictionary alloc]init];
    self.answersForSections = [[NSMutableDictionary alloc]init];
    
    [self initializeTableData];
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    for(char c = 'A';c<='Z';c++)
        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    return toBeReturned;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
    for(NSString *section in arrayOfSections)
    {
        NSString *firstCharacter = [section substringWithRange:NSMakeRange(0,1)];
        if( [[firstCharacter lowercaseString] compare: [title lowercaseString]] >=0 )
            return count;
        count ++;
    }
    return [arrayOfSections count] - 1;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([arrayOfSections count]==0)
        return @"";
    return [arrayOfSections objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayOfSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[objectsForSections objectForKey:[arrayOfSections objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FAQCell";
    
    FAQCell *cell = (FAQCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FAQCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell
    cell.primaryLabel.text = [[objectsForSections objectForKey:[arrayOfSections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    FAQDetailViewController* faqDetailViewController = [[FAQDetailViewController alloc] initWithNibName:@"FAQDetailViewController"  bundle:nil];
   
    faqDetailViewController.title = @"FAQ";
    
    [self.navigationController pushViewController:faqDetailViewController animated:YES];
    
    NSString* question = [[objectsForSections objectForKey:[arrayOfSections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    NSString* answer = [[answersForSections objectForKey:[arrayOfSections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    faqDetailViewController.faqtext.font = [UIFont fontWithName:@"Arial" size:18];;
    faqDetailViewController.faqtext.text = [NSString stringWithFormat:@"Q. %@\n\nA. %@", question, answer];
    faqDetailViewController.faqtext.dataDetectorTypes = UIDataDetectorTypeAll;
    faqDetailViewController.faqtext.editable = NO;
    
    [faqDetailViewController release];
}

@end
