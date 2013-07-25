//
//  FirstViewController.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 5/18/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController <UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource> {
    IBOutlet UISearchBar *sBar;//search bar
    
    NSMutableArray *tipOfTheDayArray;
    IBOutlet UILabel* tipOfTheDayText;
    
    UITableView *myTableView;
    NSMutableArray *dataSource; //will be storing all the data
    NSMutableArray *tableData;//will be storing data that will be displayed in table
    NSMutableArray *searchedData;//will be storing data matching with the search string
}

@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,retain)NSMutableArray *tipOfTheDayArray;


@end
