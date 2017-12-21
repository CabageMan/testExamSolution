//
//  githubContributorsList.h
//  testExamSolution
//
//  Created by ViktorsMacbook on 20.12.17.
//  Copyright © 2017 ViktorsMacbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contributorDetails.h"
#import "contributorsListCell.h"

@interface githubContributorsList : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *contributors;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

@end
