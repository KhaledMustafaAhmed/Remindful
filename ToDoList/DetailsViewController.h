//
//  DetailsViewController.h
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController 

@property int navKey;

@property Task * task;

@end

NS_ASSUME_NONNULL_END
