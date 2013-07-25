//
//  ItemDetailViewController.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/3/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemDetailViewController : UIViewController {
    NSInteger itemId;
    NSString* itemName;
    NSString* itemCategoryName;
    NSString* itemRecyclability;
    NSString* itemNote;
    NSString* itemImageName;
    NSString* itemCategoryId;

    IBOutlet UILabel *itemNameText;
    
    IBOutlet UITextField *itemCategoryText;
    IBOutlet UITextField *itemRecyclabilityText;
    IBOutlet UITextField *itemNoteText;

    IBOutlet UIImageView *itemPictureView;
    IBOutlet UIImageView *itemCategoryThumbView;

}

@property (nonatomic) NSInteger itemId;

@property (nonatomic, retain) IBOutlet NSString* itemName;
@property (nonatomic, retain) IBOutlet NSString* itemNote;
@property (nonatomic, retain) IBOutlet NSString* itemImageName;
@property (nonatomic, retain) IBOutlet NSString* itemCategoryName;
@property (nonatomic, retain) IBOutlet NSString* itemRecyclability;
@property (nonatomic, retain) IBOutlet NSString* itemCategoryId;

@property (nonatomic, retain) IBOutlet UILabel *itemNameText;

@property (nonatomic, retain) IBOutlet UITextField *itemCategoryText;
@property (nonatomic, retain) IBOutlet UITextField *itemNoteText;
@property (nonatomic, retain) IBOutlet UITextField *itemRecyclabilityText;

@property (nonatomic, retain) IBOutlet UIImageView *itemPictureView;
@property (nonatomic, retain) IBOutlet UIImageView *itemCategoryThumbView;


@end
