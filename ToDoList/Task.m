//
//  Task.m
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import "Task.h"
#import "Constants.h"
@implementation Task

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self != nil){
        _taskId = [aDecoder decodeObjectForKey:TASK_ID];
        
        _taskName = [aDecoder decodeObjectForKey:TASK_NAME];
        
        _taskStatus = [aDecoder decodeIntegerForKey:TASK_STATUS]; // enum decode
        
        _taskPrority = [aDecoder decodeIntegerForKey:TASK_PRIORITY]; // enum decode
        
        _taskDeadline = [aDecoder decodeObjectForKey:TASK_DEADLINE];
        
        _taskDescription = [aDecoder decodeObjectForKey:TASK_DESCRIPTION];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    
    [coder encodeObject:_taskId forKey:TASK_ID];
    
    [coder encodeObject:_taskName forKey:TASK_NAME];
    
    [coder encodeInteger:_taskStatus forKey:TASK_STATUS];
    
    [coder encodeInteger:_taskPrority forKey:TASK_PRIORITY];
    
    [coder encodeObject:_taskDeadline forKey:TASK_DEADLINE];
    
    [coder encodeObject:_taskDescription forKey:TASK_DESCRIPTION];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Task Info:\n"
            "Task ID: %@\n"
            "Name: %@\n"
            "Description: %@\n"
            "Priority: %ld\n"
            "Status: %ld\n"
            "Deadline: %@",
            self.taskId.UUIDString,
            self.taskName,
            self.taskDescription,
            (long)self.taskPrority,
            (long)self.taskStatus,
            self.taskDeadline];
}

@end
