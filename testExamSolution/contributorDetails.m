//
//  contributorDetails.m
//  testExamSolution
//
//  Created by ViktorsMacbook on 20.12.17.
//  Copyright © 2017 ViktorsMacbook. All rights reserved.
//

#import "contributorDetails.h"

@interface contributorDetails ()

@end

@implementation contributorDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup contributor data.
    self.contributorLogin.text = [NSString stringWithFormat:@"%@", [self.contributorInfo objectForKey:@"login"]];
    self.contributorAvatar.image = self.avatarImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
