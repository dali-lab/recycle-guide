//
//  ItemDetailViewController.m
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/3/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "RecycleItAppDelegate.h"

#import <sqlite3.h>


@implementation ItemDetailViewController

@synthesize itemId, itemName, itemNote, itemImageName, itemCategoryName, itemRecyclability, itemNameText, itemPictureView, itemCategoryText, itemRecyclabilityText, itemNoteText, itemCategoryId, itemCategoryThumbView;

- (void)initializeItemData
{            
    sqlite3 *db = [RecycleItAppDelegate getNewDBConnection];
    sqlite3_stmt *statement = nil;
    const char *sql = [[NSString stringWithFormat:@"select * from item where id = %d", itemId] UTF8String];    
    
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!=SQLITE_OK)
        NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
    else{
        while(sqlite3_step(statement) == SQLITE_ROW){
            itemName = [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 1)];
            
            itemCategoryId = [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 2)];
            
            itemNote = [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 3)];
            itemImageName = [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement, 4)];
        }
    }
    
    sqlite3_stmt *statement2 = nil;
    if (itemCategoryId != nil){
        if ([itemCategoryId isEqualToString:@"12"]) {
            itemRecyclability = @"NOT RECYCLABLE";
        }
        else {
            itemRecyclability = @"RECYCLABLE";
        }
        
        const char *sql2 = [[NSString stringWithFormat:@"select * from category where id = %@", itemCategoryId] UTF8String];
        if(sqlite3_prepare_v2(db, sql2, -1, &statement2, NULL)!=SQLITE_OK)
            NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
        else{
            while(sqlite3_step(statement2) == SQLITE_ROW){
                itemCategoryName = [NSString stringWithFormat:@"%s", (char*)sqlite3_column_text(statement2, 1)];;
            }
        }
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    [self initializeItemData];
    
    self.title =itemName;
    itemNameText.text = itemName;
    
    itemCategoryText.enabled = NO;
    itemRecyclabilityText.enabled = NO;
    itemNoteText.enabled = NO;
    
    if ([itemRecyclability isEqual:@"RECYCLABLE"]) {
        itemRecyclabilityText.textColor = [UIColor greenColor];
    }
    else{
        itemRecyclabilityText.textColor = [UIColor redColor];
    }
    
    itemCategoryText.text = itemCategoryName;
    itemRecyclabilityText.text = itemRecyclability;
    
    
    if ([itemNote isEqualToString:@""]) {
        itemNoteText.hidden = YES;
    }
    else{        
        itemNoteText.text = itemNote;
    }
    
    UIImage *categoryImage = [UIImage imageNamed:[NSString stringWithFormat:@"categories_%@.jpg", itemCategoryId]];
    itemCategoryThumbView.image = categoryImage;
    [categoryImage release];
    
    UIImage *image = [UIImage imageNamed:itemImageName];
    itemPictureView.image = image;
    [image release];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
