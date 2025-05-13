//
//  TaskManager.m
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import "TaskManager.h"
#import "Task.h"
#import "Constants.h"

@implementation TaskManager

+ (nonnull NSMutableArray<Task *> *)loadDoneTasks {
    
    NSMutableArray<NSData *> * doneTaskListObject = [[NSUserDefaults standardUserDefaults] objectForKey:DONE_TASKS_LIST];
        
        NSMutableArray<Task *> * normalDoneTaskList = [[NSMutableArray alloc] init];
        
        for (int i=0; i<doneTaskListObject.count; ++i) {
            
            [normalDoneTaskList addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[doneTaskListObject objectAtIndex:i]]];
                
            NSLog(@"normalDoneTaskList incressed by one to become %ld %@",normalDoneTaskList.count ,normalDoneTaskList[i]);
        }
        
        return normalDoneTaskList;
}

+ (nonnull NSMutableArray<Task *> *)loadInProgressTasks {
    NSMutableArray<NSData *> * progressTaskListObject = [[NSUserDefaults standardUserDefaults] objectForKey:PROGRESS_TASKS_LIST];
                
        NSMutableArray<Task *> * normalProgressTaskList = [[NSMutableArray alloc] init];
        
        for (int i=0; i<progressTaskListObject.count; ++i) {
            
            [normalProgressTaskList addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[progressTaskListObject objectAtIndex:i]]];

            NSLog(@"normalProgressList incressed by one to become %ld %@",normalProgressTaskList.count ,normalProgressTaskList[i]);
        }
        
        return normalProgressTaskList;
}

+ (nonnull NSMutableArray<Task *> *)loadToDoTasks {
    NSMutableArray<NSData *> * todoTaskListObject = [[NSUserDefaults standardUserDefaults] objectForKey:TO_DO_TASKS_LIST];
    
        NSMutableArray<Task *> * normalTodoTaskList = [[NSMutableArray alloc] init];
        
        for (int i=0; i<todoTaskListObject.count; ++i) {
            
            [normalTodoTaskList addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[todoTaskListObject objectAtIndex:i]]];
                
            NSLog(@"normalTodoTaskList incressed by one to become %ld %@",normalTodoTaskList.count ,normalTodoTaskList[i]);
        }
                
        return normalTodoTaskList;
}

+ (BOOL)addNewTask:(nonnull Task *)newTask {
    
    NSMutableArray<NSData *> * todoTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:TO_DO_TASKS_LIST];
            
        NSData * newTaskObject  = [NSKeyedArchiver archivedDataWithRootObject:newTask];
        
        NSMutableArray<NSData *> * newList = [[NSMutableArray alloc] initWithArray:todoTaskObjectList];

        NSLog(@"before adding new task list count is %ld", newList.count);

        [newList addObject:newTaskObject];

        [[NSUserDefaults standardUserDefaults] setObject:newList forKey:TO_DO_TASKS_LIST];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"after adding new task list count is %ld", newList.count);
        
        return YES;
}

+ (void)deleteTask:(nonnull Task *)deletedTask {
    NSArray<NSData *> *todoTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:TO_DO_TASKS_LIST];
    NSMutableArray<NSData *> *newList = [NSMutableArray arrayWithArray:todoTaskObjectList];

    for (int i = 0; i < newList.count; i++) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:newList[i]];
        
        if ([task.taskId isEqual:deletedTask.taskId]) {
            [newList removeObjectAtIndex:i];
            break;
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:TO_DO_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) deleteFromProgress: (Task *) deletedTask{
    NSArray<NSData *> *progressTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:PROGRESS_TASKS_LIST];
    
    NSMutableArray<NSData *> *newList = [NSMutableArray arrayWithArray:progressTaskObjectList];

    for (int i = 0; i < newList.count; i++) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:newList[i]];
        
        if ([task.taskId isEqual:deletedTask.taskId]) {
            [newList removeObjectAtIndex:i];
            break;
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:PROGRESS_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) deleteFromDone: (Task *) deletedTask{
    NSArray<NSData *> *doneTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:DONE_TASKS_LIST];
    
    NSMutableArray<NSData *> *newList = [NSMutableArray arrayWithArray:doneTaskObjectList];

    for (int i = 0; i < newList.count; i++) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:newList[i]];
        
        if ([task.taskId isEqual:deletedTask.taskId]) {
            [newList removeObjectAtIndex:i];
            break;
        }
    }

    [[NSUserDefaults standardUserDefaults] setObject:newList forKey:DONE_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)editTask:(nonnull Task *)edittedTask {
    NSArray<NSData *> *todoTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:TO_DO_TASKS_LIST];
    
    NSMutableArray<NSData *> *updatedList = [NSMutableArray arrayWithArray:todoTaskObjectList];
    
    for (int i = 0; i < updatedList.count; ++i) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:updatedList[i]];
        
        if ([task.taskId isEqual:edittedTask.taskId]) {
            NSData *newTaskData = [NSKeyedArchiver archivedDataWithRootObject:edittedTask];
            
            [updatedList replaceObjectAtIndex:i withObject:newTaskData];
            
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:updatedList forKey:TO_DO_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) editTaskFromProgress: (Task *) edittedTask{
    NSArray<NSData *> *todoTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:PROGRESS_TASKS_LIST];
    
    NSMutableArray<NSData *> *updatedList = [NSMutableArray arrayWithArray:todoTaskObjectList];
    
    for (int i = 0; i < updatedList.count; ++i) {
        Task *task = [NSKeyedUnarchiver unarchiveObjectWithData:updatedList[i]];
        
        if ([task.taskId isEqual:edittedTask.taskId]) {
            NSData *newTaskData = [NSKeyedArchiver archivedDataWithRootObject:edittedTask];
            
            [updatedList replaceObjectAtIndex:i withObject:newTaskData];
            
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:updatedList forKey:PROGRESS_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)fromToDoAddToProgress:(nonnull Task *)task {
    
    NSArray<NSData *> *todoTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:TO_DO_TASKS_LIST];

    NSMutableArray<NSData *> *todoList = [NSMutableArray arrayWithArray:todoTaskObjectList];
    
    for (int i = 0; i < todoList.count; ++i) {
        
        Task *localTask = [NSKeyedUnarchiver unarchiveObjectWithData:todoList[i]];
        
        if ([localTask.taskId isEqual:task.taskId]) {
            [todoList removeObjectAtIndex:i];
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:todoList forKey:TO_DO_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray<NSData *> *progressTaskListObject = [[NSUserDefaults standardUserDefaults] objectForKey:PROGRESS_TASKS_LIST];
    
    NSMutableArray<NSData *> *progressTaskList = [NSMutableArray arrayWithArray:progressTaskListObject];
    
    NSData * newTaskObject  = [NSKeyedArchiver archivedDataWithRootObject:task];

    [progressTaskList addObject:newTaskObject];
    
    [[NSUserDefaults standardUserDefaults] setObject:progressTaskList forKey:PROGRESS_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)fromProgressToDone:(nonnull Task *)task {
    NSArray<NSData *> *progressTaskObjectList = [[NSUserDefaults standardUserDefaults] objectForKey:PROGRESS_TASKS_LIST];

    NSMutableArray<NSData *> *progressList = [NSMutableArray arrayWithArray:progressTaskObjectList];
    NSLog(@"before deleting from progressList %ld", progressList.count);
    for (int i = 0; i < progressList.count; ++i) {
        
        Task *localTask = [NSKeyedUnarchiver unarchiveObjectWithData:progressList[i]];
        
        if ([localTask.taskId isEqual:task.taskId]) {
            [progressList removeObjectAtIndex:i];
            break;
        }
    }
    
    NSLog(@"after deleting from progressList %ld", progressList.count);

    [[NSUserDefaults standardUserDefaults] setObject:progressList forKey:PROGRESS_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray<NSData *> *doneTaskListObject = [[NSUserDefaults standardUserDefaults] objectForKey:DONE_TASKS_LIST];
    
    NSMutableArray<NSData *> *doneTaskList = [NSMutableArray arrayWithArray:doneTaskListObject];
    
    NSData * newTaskObject  = [NSKeyedArchiver archivedDataWithRootObject:task];

    [doneTaskList addObject:newTaskObject];
    NSLog(@"DoneListNow %ld", doneTaskList.count);

    [[NSUserDefaults standardUserDefaults] setObject:doneTaskList forKey:DONE_TASKS_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
