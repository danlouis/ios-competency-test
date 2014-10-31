//
//  ViewController.h
//  competencyTest
//
//  Created by Dolpin on 10/31/14.
//  Copyright (c) 2014 com.ios.test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* userData;
}
@property (strong,nonatomic) IBOutlet UITableView* tableView;
@end
