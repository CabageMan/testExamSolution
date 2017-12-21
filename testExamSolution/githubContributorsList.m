//
//  githubContributorsList.m
//  testExamSolution
//
//  Created by ViktorsMacbook on 20.12.17.
//  Copyright © 2017 ViktorsMacbook. All rights reserved.
//

#import "githubContributorsList.h"

@interface githubContributorsList ()

@end

@implementation githubContributorsList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingActivity.hidden = false;
    
    // Initialize the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getData)
                  forControlEvents:UIControlEventValueChanged];
    
    // Initialization the contributors data array
    contributors = [[NSMutableArray alloc] init];
    
    // Fill the contributors dictionary
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contributors.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the table view cell identifier and initialize the cell
    NSString *cellIdentifier = [NSString stringWithFormat:@"contributorsListCell"];
    contributorsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                 forIndexPath:indexPath];
    
    // Get contributors data from the array
    NSDictionary *contributorInfo = [NSDictionary dictionaryWithDictionary:[contributors objectAtIndex:indexPath.row]];
    NSString *contributorId = [NSString stringWithFormat:@"%@", [contributorInfo objectForKey:@"id"]];
    NSString *contributorLogin = [NSString stringWithFormat:@"%@",
                                  [contributorInfo objectForKey:@"login"]];
    NSString *contributorAvatarLink = [NSString stringWithFormat:@"%@", [contributorInfo objectForKey:@"avatar_url"]];
    
    // Fill the labels with contributor data and set the placeholder image
    cell.avatarIcon.image = [UIImage imageNamed:@"placeHolderImage.jpg"];
    cell.loginLabel.text = contributorLogin;
    cell.idLabel.text = contributorId;
    
    // Configure the request and replace the avatar image if it exists
    NSURL *url = [NSURL URLWithString:contributorAvatarLink];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    contributorsListCell *updateCell = (id)[self.tableView
                                                            cellForRowAtIndexPath:indexPath];
                    if (updateCell) {
                        updateCell.avatarIcon.image = image;
                    }
                });
            }
        }
    }];
    
    [task resume];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Determination of segue
    if ([segue.identifier isEqualToString:@"showContributorDetail"]) {
        // Create and setup animation of the segue
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        // I understand that I spend a long time with animation and left it like this)
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:false];
        
        // get controller and tableviewcell, transfer data to contributionDetails controller
        contributorDetails *destViewController = segue.destinationViewController;
        NSIndexPath *cellIndexPath = self.tableView.indexPathForSelectedRow;
        contributorsListCell *cellOfTableView = (id)[self.tableView
                                                     cellForRowAtIndexPath:cellIndexPath];
        
        destViewController.contributorInfo = [contributors objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        destViewController.avatarImage = cellOfTableView.avatarIcon.image;
    }
    
}

- (void) getData {
    
    
    // Start the loading activity indicator
    if (!self.loadingActivity.hidden) {
        [self.loadingActivity startAnimating];
    }
    
    // End the refreshing
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
    
    // Make request for the contributors data
    NSString *dataUrl = [NSString stringWithFormat:@"https://api.github.com/repos/videolan/vlc/contributors"];
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession]
        dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:&error];
                                          
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                       // Separate data from json response
                       for (NSDictionary *person in json) {
                           NSMutableDictionary *personData = [[NSMutableDictionary alloc] init];
                           [personData setObject:[person objectForKey:@"login"]
                                                              forKey:@"login"];
                           [personData setObject:[person objectForKey:@"id"]
                                                              forKey:@"id"];
                           [personData setObject:[person objectForKey:@"avatar_url"]
                                                              forKey:@"avatar_url"];
                           [contributors addObject:personData];
                       };
                       // Stop the loading activity indicator, and refresh the table view
                   if (!self.loadingActivity.hidden) {
                       [self.loadingActivity stopAnimating];
                       self.loadingActivity.hidden = true;
                   }
                       // End the refreshing
                       [self.refreshControl endRefreshing];
                   
                       [self.tableView reloadData];
               });
            
        }
    
    ];
    [downloadTask resume];
    
}

@end
