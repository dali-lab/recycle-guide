//
//  FAQDetailViewController.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/17/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FAQDetailViewController : UIViewController {
    IBOutlet UITextView* faqtext;
}

@property (nonatomic, retain) IBOutlet UITextView *faqtext;

@end
