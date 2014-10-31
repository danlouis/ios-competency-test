//
//  ViewController.m
//  competencyTest
//
//  Created by Dolpin on 10/31/14.
//  Copyright (c) 2014 com.ios.test. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)loadData
{
    [SVProgressHUD show];
    NSURL *URL = [NSURL URLWithString:@"http://private-anon-cb557d049-friendmock.apiary-mock.com/friends"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          // Handle error...
                                          return;
                                      }
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSLog(@"Response HTTP Status code: %ld\n", (long)[(NSHTTPURLResponse *)response statusCode]);
                                          NSLog(@"Response HTTP Headers:\n%@\n", [(NSHTTPURLResponse *)response allHeaderFields]);
                                      }
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      userData = [NSJSONSerialization
                                                            JSONObjectWithData:data
                                                            options:kNilOptions
                                                            error:&error];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [SVProgressHUD dismiss];
                                          [self.tableView reloadData];

                                      });
                                      
                                      NSLog(@"Response Body:\n%@\n", body);
                                  }];
    [task resume];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark - TableView DataSource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (userData==nil)
        return 0;
    else
        return userData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (cell==nil)
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
    
    UIImageView* profileImg = (UIImageView*)[cell viewWithTag:1];
    UILabel* userName = (UILabel*)[cell viewWithTag:2];
    UILabel* userStatus = (UILabel*)[cell viewWithTag:3];
    UIView* availability = (UIView*)[cell viewWithTag:4];
    availability.layer.cornerRadius=10;
    availability.layer.masksToBounds=YES;

    [profileImg setImageWithURL:[NSURL URLWithString:[userData objectAtIndex:indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [userName setText:[NSString stringWithFormat:@"%@%@",[userData objectAtIndex:indexPath.row][@"first_name"],[userData objectAtIndex:indexPath.row][@"last_name"]]];
    [userStatus setText:[userData objectAtIndex:indexPath.row][@"status"]];
    
    if ([[userData objectAtIndex:indexPath.row][@"available"] boolValue]==YES)
        [availability setBackgroundColor:[UIColor greenColor]];
    else
        [availability setBackgroundColor:[UIColor darkGrayColor]];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [AppDelegate sharedAppDelegate].selectedID =[userData objectAtIndex:indexPath.row][@"id"];
    [self performSegueWithIdentifier:@"toDetailView" sender:nil];
}
@end
