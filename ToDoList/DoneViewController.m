//
//  DoneViewController.m
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import "DoneViewController.h"
#import "Task.h"
#import "TaskManager.h"
#import "Constants.h"
#import "ToDoTableViewCell.h"
#import "DetailsViewController.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *doneSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *doneTable;

@property (weak, nonatomic) IBOutlet UIImageView *sortOutlet;

- (IBAction)onSortButtonClick:(UITapGestureRecognizer *)sender;

@property NSMutableArray<Task *> *doneTaskList;

@property NSMutableArray<Task *> *highPriorityTasks;

@property NSMutableArray<Task *> *mediumPriorityTasks;

@property NSMutableArray<Task *> *lowPriorityTasks;

@property BOOL isFiltered;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScreenUI];
    _doneTaskList = [NSMutableArray new];
     _highPriorityTasks = [NSMutableArray new];
     _mediumPriorityTasks = [NSMutableArray new];
     _lowPriorityTasks = [NSMutableArray new];
     _isFiltered = NO;
     
     _doneTable.delegate = self;
     _doneTable.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _doneTaskList = [TaskManager loadDoneTasks];
    
    if (!_isFiltered) {
        [self fillArrays];
    }
    
    [_doneTable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isFiltered ? 1 : 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFiltered) {
        return _doneTaskList.count;
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
    ToDoTableViewCell *cell = [_doneTable dequeueReusableCellWithIdentifier:@"DoneTableCell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 25;

    Task *task;
    if (_isFiltered) {
        task = _doneTaskList[indexPath.row];
    } else {
        switch (indexPath.section) {
            case 0:
                task = _highPriorityTasks[indexPath.row];
                break;
            case 1:
                task = _mediumPriorityTasks[indexPath.row];
                break;
            case 2:
                task = _lowPriorityTasks[indexPath.row];
                break;
        }
    }
    
    cell.taskName.text = task.taskName;
    cell.taskDeadline.text = [self convertDateToString:task.taskDeadline];
    cell.taskStatus.text = @"Done";
    
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
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_isFiltered) {
        return @"All Done Tasks";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    [dvc setNavKey:FROM_DONE_TO_EDIT_TASK];
    
    
    if(_isFiltered){
        [dvc setTask:_doneTaskList[indexPath.row]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}
- (IBAction)onSortButtonClick:(UITapGestureRecognizer *)sender {
    _isFiltered = !_isFiltered;
    NSLog(@"sort clicked");
    [_doneTable reloadData];
}

- (void)setupScreenUI {
    _doneTable.layer.cornerRadius = 25;
    _sortOutlet.userInteractionEnabled = YES;
    _doneSearchBar.backgroundColor = [UIColor whiteColor];
    _doneSearchBar.layer.backgroundColor = nil;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Task *taskToDelete = nil;

    if(_isFiltered){
        taskToDelete = _doneTaskList[indexPath.row];
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
        [TaskManager deleteFromDone:taskToDelete];
        [_doneTaskList removeObject:taskToDelete];
        [self fillArrays];
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    for (Task *task in _doneTaskList) {
        
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
