//
//  Task.h
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, Priority){
    PriorityHigh,
    PriorityMedium,
    PriorityLow
};

typedef NS_ENUM(NSInteger, Status){
    StatusToDo,
    StatusProgress,
    StatusDone
};

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding>

@property NSUUID * taskId; // unique task id

@property NSString * taskName;

@property NSString * taskDescription;

@property Priority taskPrority;

@property Status taskStatus;

@property NSDate * taskDeadline;

@end

NS_ASSUME_NONNULL_END
