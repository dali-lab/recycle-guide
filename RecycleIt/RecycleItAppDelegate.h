//
//  RecycleItAppDelegate.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 5/18/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class CategoryNavController;

@interface RecycleItAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    IBOutlet CategoryNavController *categoryNavController;
}

+ (sqlite3 *) getNewDBConnection;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet CategoryNavController *categoryNavController;



@end
