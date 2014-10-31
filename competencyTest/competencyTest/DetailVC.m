//
//  DetailVC.m
//  competencyTest
//
//  Created by kjs on 10/31/14.
//  Copyright (c) 2014 com.ios.test. All rights reserved.
//

#import "DetailVC.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@interface DetailVC ()

@end

@implementation DetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadData
{
    [SVProgressHUD show];
    NSURL *URL = [NSURL URLWithString:@"http://private-anon-cb557d049-friendmock.apiary-mock.com/friends/id"];
    
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
#pragma mark
#pragma mark - TableView DataSource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (userData==nil)
        return 0;
    return 9;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==7)
        return [userData[@"photos"] count];
    if (section==8)
        return [userData[@"statuses"] count];
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    if (indexPath.section==0)// user cell
        
    {
       cell = [self.tableView dequeueReusableCellWithIdentifier:@"profileCell"];
        if (cell==nil)
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profileCell"];
        UIImageView* profileImg = (UIImageView*)[cell viewWithTag:1];
        UILabel* userName = (UILabel*)[cell viewWithTag:2];
        UIView* availability = (UIView*)[cell viewWithTag:4];
        availability.layer.cornerRadius=10;
        availability.layer.masksToBounds=YES;
        [profileImg setImageWithURL:[NSURL URLWithString:userData[@"img"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [userName setText:[NSString stringWithFormat:@"%@%@",userData[@"first_name"],userData [@"last_name"]]];
        if ([userData[@"available"] boolValue]==YES)
            [availability setBackgroundColor:[UIColor greenColor]];
        else
            [availability setBackgroundColor:[UIColor darkGrayColor]];
    }else
    if  (indexPath.section>0 && indexPath.section!=6  && indexPath.section!=8  )

    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"dataCell"];
        if (cell==nil)
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dataCell"];
        UILabel* dataLbl = (UILabel*)[cell viewWithTag:2];
        switch (indexPath.section) {
            case 1:
                [dataLbl setText:userData[@"phone"]];
                break;
            case 2:
                [dataLbl setText:userData[@"address_1"]];
                break;
            case 3:
                [dataLbl setText:userData[@"city"]];
                break;
            case 4:
                [dataLbl setText:userData[@"state"]];
                break;
            case 5:
                [dataLbl setText:userData[@"zipcode"]];
                break;
            case 7:
                [dataLbl setText:[userData[@"photos"] objectAtIndex:indexPath.row]];

                break;
           
           
            default:
                break;
        }
        
    }
    else if  (indexPath.section==6 ||  indexPath.section==8 )
    {
       cell = [self.tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
        if (cell==nil)
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descriptionCell"];
        UILabel* dataLbl = (UILabel*)[cell viewWithTag:2];
        if (indexPath.section==6)
        [dataLbl setText:userData[@"bio"]];
        else
            [dataLbl setText:[userData[@"statuses"] objectAtIndex:indexPath.row]];


    }
   
        return  cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"Phone";
            break;
        case 2:
            return @"Address";
            break;
        case 3:
            return @"City";
            break;
        case 4:
            return @"State";
            break;
        case 5:
            return @"Zipcode";

            break;
        case 6:
            return @"Bio";

            break;
        case 7:
            return @"Photos";
            break;
        case 8:
            return @"Statuses";
            break;
   
        default:
            break;
    }
    return @"";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return 100;
    if (indexPath.section==6 || indexPath.section==8)
        return 100;
    return 50;
}
@end
