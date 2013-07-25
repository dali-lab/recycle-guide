//
//  CategoryTableViewController.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 9/26/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryDetailTableViewController;

@interface CategoryTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView* categoryTableView;
    NSMutableArray *categoryArray;
    NSMutableArray *categoryIdArray;
    CategoryDetailTableViewController *categoryDetailTableViewController;
}

@property (nonatomic, retain) NSMutableArray *categoryArray;
@property (nonatomic, retain) NSMutableArray *categoryIdArray;

@property (nonatomic, retain) CategoryDetailTableViewController *categoryDetailTableViewController;

- (void)initializeTableData;


@end
