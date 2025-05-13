//
//  ViewController.m
//  ToDoList
//
//  Created by Khaled Mustafa on 21/04/2025.
//

#import "ViewController.h"
#import "DetailsViewController.h"
#import "Task.h"
#import "TaskManager.h"
#import "Constants.h"
#import "ToDoTableViewCell.h"

@interface ViewController ()
- (IBAction)onAddNewTaskClick:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *addNewTaskPhoto;

@property (weak, nonatomic) IBOutlet UISearchBar *taskSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *taskTable;

@property NSMutableArray <Task *> * todoTaskList;

@property BOOL isSearch;

@property NSMutableArray<Task *> *highPriorityTasks;

@property NSMutableArray<Task *> *mediumPriorityTasks;

@property NSMutableArray<Task *> *lowPriorityTasks;

@property NSMutableArray <Task *> * filteredHighPriorityTasks;
@property NSMutableArray <Task *> * filteredMediumPriorityTasks;
@property NSMutableArray <Task *> * filteredLowPriorityTasks;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUIScreen];
    
    _todoTaskList = [NSMutableArray new];
    
    _highPriorityTasks = [NSMutableArray new];
    
    _mediumPriorityTasks = [NSMutableArray new];
    
    _lowPriorityTasks = [NSMutableArray new];
    
    _taskSearchBar.delegate = self;
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _todoTaskList = [TaskManager loadToDoTasks];
    
    for (Task *task in _todoTaskList) {
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

    [_taskTable reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_highPriorityTasks removeAllObjects];
    [_lowPriorityTasks removeAllObjects];
    [_mediumPriorityTasks removeAllObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isSearch){
        switch (section) {
            case 0:
                return  _filteredHighPriorityTasks.count;
                break;
            case 1:
                return  _filteredMediumPriorityTasks.count;
                break;
            case 2:
                return  _filteredLowPriorityTasks.count;
                break;
            default:
                break;
        }
    }
    
    switch (section) {
        case 0:
            return _highPriorityTasks.count > 0? _highPriorityTasks.count: 0;
        case 1:
            return _mediumPriorityTasks.count > 0? _mediumPriorityTasks.count: 0;
        case 2:
            return _lowPriorityTasks.count >0? _lowPriorityTasks.count: 0;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoTableViewCell *todoCell = [_taskTable dequeueReusableCellWithIdentifier:@"TodoTableCell" forIndexPath:indexPath];
    
    todoCell.layer.cornerRadius = 25;

    
    Task *task;
    
    if(_isSearch){
        switch (indexPath.section) {
            case 0: task = _filteredHighPriorityTasks[indexPath.row]; break;
            case 1: task = _filteredMediumPriorityTasks[indexPath.row]; break;
            case 2: task = _filteredLowPriorityTasks[indexPath.row]; break;
        }
    }else{
        switch (indexPath.section) {
            case 0: task = _highPriorityTasks[indexPath.row]; break;
            case 1: task = _mediumPriorityTasks[indexPath.row]; break;
            case 2: task = _lowPriorityTasks[indexPath.row]; break;
        }
    }
    
    todoCell.taskPriority.text = [self priorityTextForSection:indexPath.section];
    
    todoCell.priorityImage.image = [self priorityImageForSection:indexPath.section];
    
    todoCell.taskName.text = task.taskName;
    
    todoCell.taskStatus.text = @"TO DO";
    
    todoCell.taskDeadline.text = [self convertDateToString:task.taskDeadline];

    return todoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController * dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    [dvc setNavKey:FROM_TODO_TO_EDIT_TASK];
    
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
    
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _isSearch = searchText.length > 0;
    
    _filteredHighPriorityTasks = [NSMutableArray new];
    
    _filteredMediumPriorityTasks = [NSMutableArray new];
    
    _filteredLowPriorityTasks = [NSMutableArray new];
    
    NSArray *searchPool = _isSearch ? _todoTaskList : @[];
    
    for (Task *task in searchPool) {
        if ([[task.taskName lowercaseString] containsString:[searchText lowercaseString]]) {
            switch (task.taskPrority) {
                case PriorityHigh:
                    [_filteredHighPriorityTasks addObject:task];
                    break;
                case PriorityMedium:
                    [_filteredMediumPriorityTasks addObject:task];
                    break;
                case PriorityLow:
                    [_filteredLowPriorityTasks addObject:task];
                    break;
            }
        }
    }
    
    [_taskTable reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isSearch = YES;
    _taskSearchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _isSearch = NO;
    _taskSearchBar.text = @"";
    [_taskSearchBar resignFirstResponder];
    _taskSearchBar.showsCancelButton = NO;
    [_taskTable reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * name = [NSString new];
    switch (section) {
        case 0:
            name = @"High Priority";
            break;
        case 1:
            name =  @"Medium Priority";
            break;
        case 2:
            name =  @"Low Priority";
        default:
            break;
    }
    return name;
}

- (IBAction)onAddNewTaskClick:(UITapGestureRecognizer *)sender {
    NSLog(@"Add new Task tabbed Done!");
    DetailsViewController * dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    [dvc setNavKey:FROM_TODO_TO_ADD_NEW_TASK];
    
    [self.navigationController pushViewController:dvc animated:YES];
    
}

-(void) setupUIScreen{
    _taskTable.layer.cornerRadius = 25;
   _addNewTaskPhoto.userInteractionEnabled = YES;
    _taskSearchBar.backgroundColor = [UIColor whiteColor];
    _taskSearchBar.layer.backgroundColor = nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *taskToDelete = nil;

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

        if (taskToDelete) {
            NSLog(@"deleted from user defaults");
            [TaskManager deleteTask:taskToDelete];
            [_todoTaskList removeObject:taskToDelete];
        }

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (NSString *)priorityTextForSection:(NSInteger)section {
    return @[@"High Priority", @"Medium Priority", @"Low Priority"][section];
}

- (UIImage *)priorityImageForSection:(NSInteger)section {
    NSArray *images = @[@"high-priority", @"medium-priority", @"low-priority"];
    return [UIImage imageNamed:images[section]];
}

-(NSString *) convertDateToString: (NSDate *) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"EEE HH:mm"];

    NSString *formattedDate = [formatter stringFromDate:date];
    
    return formattedDate;
}

@end
