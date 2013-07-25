//
//  CategoryDetailTableViewController.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 9/26/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryDetailTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *categoryDetailArray;
    NSMutableArray *categoryItemIdArray;
    NSInteger categoryId;
}

- (void)initializeTableData;

@property (nonatomic, retain) NSMutableArray *categoryDetailArray;
@property (nonatomic, retain) NSMutableArray *categoryItemIdArray;

@property (nonatomic) NSInteger categoryId;

@end
