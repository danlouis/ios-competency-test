//
//  DetailVC.h
//  competencyTest
//
//  Created by kjs on 10/31/14.
//  Copyright (c) 2014 com.ios.test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary* userData;
}
@property (strong,nonatomic) IBOutlet UITableView* tableView;

@end
