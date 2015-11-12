//
//  RYButtonBack.m
//  HabrahabrRSS
//
//  Created by Yurii Radchenko on 11.11.15.
//  Copyright © 2015 Yury Radchenko. All rights reserved.
//

#import "RYButtonBack.h"

@implementation RYButtonBack

- (instancetype) initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (self) {
        
        UIImage *backButtonImage = [UIImage imageNamed:@"backButton"];
        [self setImage:backButtonImage forState:UIControlStateNormal];
        self.frame = CGRectMake(0.0, 0.0,
                                backButtonImage.size.width,
                                backButtonImage.size.height);
        
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    return self;
}

@end
