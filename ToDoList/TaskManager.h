//
//  TaskManager.h
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import <Foundation/Foundation.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface TaskManager : NSObject

+(NSMutableArray <Task *> *) loadToDoTasks;

+(NSMutableArray <Task *> *) loadInProgressTasks;

+(NSMutableArray <Task *> *) loadDoneTasks;

+(BOOL) addNewTask: (Task *) newTask;

+(void) editTask: (Task *) edittedTask;

+(void) deleteTask: (Task *) deletedTask;

+(void) fromToDoAddToProgress: (Task *) task;

+(void) fromProgressToDone: (Task *) task;

+(void) editTaskFromProgress: (Task *) edittedTask;
+(void) deleteFromDone: (Task *) deletedTask;

+(void) deleteFromProgress: (Task *) deletedTask;
@end

NS_ASSUME_NONNULL_END
