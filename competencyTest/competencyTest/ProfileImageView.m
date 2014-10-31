//
//  ProfileImageView.m
//  Sfindr
//
//  Created by Dolpin on 2/11/14.
//  Copyright (c) 2014 Dolpin. All rights reserved.
//

#import "ProfileImageView.h"

@implementation ProfileImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
   
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)setNeedsDisplay {
    
    self.layer.cornerRadius = self.frame.size.width/2;
    if (self.layer.cornerRadius==0)
        self.layer.cornerRadius=25;
    self.layer.masksToBounds = YES;
    [self.layer setBorderColor:[[UIColor colorWithRed:77/255.0 green:49/255.0 blue:115/255.0 alpha:1.0] CGColor]];
    [self.layer setBorderWidth: 2.0];
}

@end
