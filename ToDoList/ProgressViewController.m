//
//  ProgressViewController.m
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import "ProgressViewController.h"
#import "Task.h"
#import "TaskManager.h"
#import "DetailsViewController.h"
#import "ToDoTableViewCell.h"
#import "Constants.h"
@interface ProgressViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *taskSearch;

@property (weak, nonatomic) IBOutlet UITableView *progressTable;

- (IBAction)onSortClick:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *onSortClickOutlet;

@property NSMutableArray<Task *> *highPriorityTasks;

@property NSMutableArray<Task *> *mediumPriorityTasks;

@property NSMutableArray<Task *> *lowPriorityTasks;

@property NSMutableArray<Task *> * progressTaskList;

@property BOOL isFiltered;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScreenUI];
    
    _progressTaskList = [NSMutableArray new];
    
    _highPriorityTasks = [NSMutableArray new];
    
    _mediumPriorityTasks = [NSMutableArray new];
    
    _lowPriorityTasks = [NSMutableArray new];
    
    _isFiltered = NO;
    
    _progressTable.delegate = self;
    
    _progressTable.dataSource  = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    _progressTaskList = [TaskManager loadInProgressTasks];
    
    NSLog(@"%ld", _progressTaskList.count);
    
    if (!_isFiltered) {
        
        [self fillArrays];
       }
    
    [_progressTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _isFiltered ? 1 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isFiltered) {
           return _progressTaskList.count;
       } else {
           switch (section) {
               case 0:
                   return _highPriorityTasks.count;
               case 1:
                   return _mediumPriorityTasks.count;
               case 2:
                   return _lowPriorityTasks.count;
               default:
                   return 0;
           }
       }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoTableViewCell *cell = [_progressTable dequeueReusableCellWithIdentifier:@"TodoTableCell" forIndexPath:indexPath];

    cell.layer.cornerRadius = 25;

    Task *task;
    
    if (_isFiltered) {
        
        task = _progressTaskList[indexPath.row];
        
    } else {
        
        switch (indexPath.section) {
            case 0:
              //  task = _highPriorityTasks[indexPath.row];
               task = [_highPriorityTasks objectAtIndex:indexPath.row];
                break;
            case 1:
                task = _mediumPriorityTasks[indexPath.row];
                break;
            case 2:
                task = _lowPriorityTasks[indexPath.row];
                break;
            default:
                break;
        }
    }
    
    NSLog(@"%@", task.taskName);
    
    cell.taskName.text = task.taskName;
    
    cell.taskDeadline.text = [self convertDateToString:task.taskDeadline];
    
    cell.taskStatus.text = @"In Progress";
    
    switch (task.taskPrority) {
        case PriorityHigh:
            cell.priorityImage.image = [UIImage imageNamed:@"high-priority"];
            cell.taskPriority.text = @"High Priority";
            break;
            
        case PriorityMedium:
            cell.priorityImage.image = [UIImage imageNamed:@"medium-priority"];
            cell.taskPriority.text = @"Medium Priority";
            break;
            
        case PriorityLow:
            cell.priorityImage.image = [UIImage imageNamed:@"low-priority"];
            cell.taskPriority.text = @"Low Priority";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isFiltered) {
        return @"All Progress Tasks";
    } else {
        switch (section) {
            case 0:
                return @"High Priority";
            case 1:
                return @"Medium Priority";
            case 2:
                return @"Low Priority";
            default:
                return @"";
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController * dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    [dvc setNavKey:FROM_PROGRESS_TO_EDIT_TASK];
    
    if(_isFiltered){
        [dvc setTask:_progressTaskList[indexPath.row]];
    }else{
        switch (indexPath.section) {
            case 0:
                [dvc setTask:_highPriorityTasks[indexPath.row]];
                break;
            case 1:
                [dvc setTask:_mediumPriorityTasks[indexPath.row]];
                break;
            case 2:
                [dvc setTask:_lowPriorityTasks[indexPath.row]];
                break;
        }
    }
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *taskToDelete = nil;

        if(_isFiltered){
            taskToDelete = _progressTaskList[indexPath.row];
        }else{
            switch (indexPath.section) {
                case 0:
                    taskToDelete = _highPriorityTasks[indexPath.row];
                    [_highPriorityTasks removeObjectAtIndex:indexPath.row];
                    break;
                case 1:
                    taskToDelete = _mediumPriorityTasks[indexPath.row];
                    [_mediumPriorityTasks removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    taskToDelete = _lowPriorityTasks[indexPath.row];
                    [_lowPriorityTasks removeObjectAtIndex:indexPath.row];
                    break;
            }
        }
        

        if (taskToDelete) {
            NSLog(@"deleted from user defaults");
            [TaskManager deleteFromProgress:taskToDelete];
            [_progressTaskList removeObject:taskToDelete];
            [self fillArrays];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) setupScreenUI{
    _progressTable.layer.cornerRadius = 25;
    _onSortClickOutlet.userInteractionEnabled = YES;
    _taskSearch.backgroundColor = [UIColor whiteColor];
    _taskSearch.layer.backgroundColor = nil;
}


- (IBAction)onSortClick:(UITapGestureRecognizer *)sender {
    _isFiltered = !_isFiltered;
    NSLog(@"press on sort");
    [_progressTable reloadData];
}

-(NSString *) convertDateToString: (NSDate *) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"EEE HH:mm"];

    NSString *formattedDate = [formatter stringFromDate:date];
    
    return formattedDate;
}

-(void) fillArrays{
    [_highPriorityTasks removeAllObjects];
 
    [_mediumPriorityTasks removeAllObjects];
 
    [_lowPriorityTasks removeAllObjects];
    
    for (Task *task in _progressTaskList) {
        
        switch (task.taskPrority) {
                
            case PriorityHigh:
                
                [_highPriorityTasks addObject:task];
                
                break;
                
            case PriorityMedium:
                
                [_mediumPriorityTasks addObject:task];
                
                break;
                
            case PriorityLow:
                
                [_lowPriorityTasks addObject:task];
                
                break;
        }
    }
}
@end
