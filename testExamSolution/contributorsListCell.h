//
//  contributorsListCell.h
//  testExamSolution
//
//  Created by ViktorsMacbook on 21.12.17.
//  Copyright © 2017 ViktorsMacbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contributorsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarIcon;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end
