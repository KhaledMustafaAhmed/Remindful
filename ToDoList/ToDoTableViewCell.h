//
//  ToDoTableViewCell.h
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *priorityImage;

@property (weak, nonatomic) IBOutlet UILabel *taskName;

@property (weak, nonatomic) IBOutlet UILabel *taskPriority;

@property (weak, nonatomic) IBOutlet UILabel *taskDeadline;

@property (weak, nonatomic) IBOutlet UILabel *taskStatus;

@end

NS_ASSUME_NONNULL_END
