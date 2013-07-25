//
//  FAQTableViewController.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/17/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FAQTableViewController : UITableViewController {
    NSMutableArray *questionArray;
    NSMutableArray *answerArray;
    
    NSMutableDictionary *objectsForSections;
    NSMutableDictionary *answersForSections;
    NSMutableArray *arrayOfSections;
}

@property (nonatomic, retain) NSMutableArray *questionArray;
@property (nonatomic, retain) NSMutableArray *answerArray;

@property (nonatomic, retain) NSMutableDictionary *answersForSections;
@property (nonatomic, retain) NSMutableDictionary *objectsForSections;
@property (nonatomic, retain) NSMutableArray *arrayOfSections;

@end
