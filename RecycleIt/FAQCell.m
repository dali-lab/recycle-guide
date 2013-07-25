//
//  FAQCell.m
//  RecycleIt
//
//  Created by Xiaoyi Chen on 10/18/11.
//  Copyright 2011 Digital Arts Dartmouth. All rights reserved.
//

#import "FAQCell.h"


@implementation FAQCell

@synthesize primaryLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = UITextAlignmentLeft;
        primaryLabel.numberOfLines = 0;
        primaryLabel.font = [UIFont fontWithName:@"Arial" size:16];

        [self.contentView addSubview:primaryLabel];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;

    frame= CGRectMake(boundsX+5 ,0, 250, 80);
    primaryLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
