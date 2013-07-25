//
//  CategoryCell.h
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/4/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryCell : UITableViewCell {
    UILabel *primaryLabel;
    UIImageView *myImageView;
}

@property(nonatomic,retain)UILabel *primaryLabel;
@property(nonatomic,retain)UIImageView *myImageView;

@end
