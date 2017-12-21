//
//  contributorDetails.h
//  testExamSolution
//
//  Created by ViktorsMacbook on 20.12.17.
//  Copyright © 2017 ViktorsMacbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contributorDetails : UIViewController

@property (nonatomic, strong) NSDictionary *contributorInfo;
@property (nonatomic, strong) UIImage *avatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *contributorAvatar;
@property (weak, nonatomic) IBOutlet UILabel *contributorLogin;

@end
