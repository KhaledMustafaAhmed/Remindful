//
//  DetailsViewController.m
//  ToDoList
//
//  Created by Khaled Mustafa on 23/04/2025.
//

#import "DetailsViewController.h"
#import "Task.h"
#import "Constants.h"
#import "TaskManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationOutlet;


- (IBAction)onTaskPriorityClick:(UISegmentedControl *)sender;

- (IBAction)onTaskStatusClick:(UISegmentedControl *)sender;

- (IBAction)taskDeadline:(UIDatePicker *)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *dateOutlet;


@property (weak, nonatomic) IBOutlet UITextView *taskDescription;

- (IBAction)onNotificationClick:(UISegmentedControl *)sender;

- (IBAction)onAddNewTaskClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriorityOutlet;

@property (weak, nonatomic) IBOutlet UISegmentedControl *taskStatusOutlet;

@property (weak, nonatomic) IBOutlet UILabel *detailsHeader;

@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;

@property NSInteger priority;

@property NSInteger status;

@property NSDate * deadline;

@property NSInteger notification;

@property UIAlertController * successAlert;

@property NSString * taskName;

@property NSString * taskDes;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _deadline = [NSDate new];
    
    _taskName = [NSString new];
    
    _taskDes = [NSString new];
    
    NSDate *currentDate = [NSDate date];
    
    NSDate *validSelectedDate = [currentDate dateByAddingTimeInterval:60];
        
    _dateOutlet.minimumDate = validSelectedDate;
    
    switch (_navKey) {
            
        case FROM_TODO_TO_ADD_NEW_TASK:
            
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:1];
            
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:2];
            
            break;
            
        case FROM_TODO_TO_EDIT_TASK:
            [_taskStatusOutlet setEnabled:YES forSegmentAtIndex:1];
            
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:2];
            
            _detailsHeader.text = @"Edit Task";
            
            [_addButtonOutlet setTitle:@"Save changes" forState:UIControlStateNormal];
            
            _taskPriorityOutlet.selectedSegmentIndex = _task.taskPrority;
            _priority = _task.taskPrority;
            
            _taskDescription.text = _task.taskDescription;
            _taskDes = _task.taskDescription;
            
            _taskNameTextField.text = _task.taskName;
            _taskName = _task.taskName;
            
            _taskStatusOutlet.selectedSegmentIndex = _task.taskStatus;
            _status = _task.taskStatus;
            
            break;
        case FROM_PROGRESS_TO_EDIT_TASK:
            [_taskStatusOutlet setEnabled:YES forSegmentAtIndex:1];
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:0];
            
            [_taskStatusOutlet setEnabled:YES forSegmentAtIndex:2];
            
            _detailsHeader.text = @"Edit Task";
            
            [_addButtonOutlet setTitle:@"Save changes" forState:UIControlStateNormal];
            
            _taskPriorityOutlet.selectedSegmentIndex = _task.taskPrority;
            _priority = _task.taskPrority;
            
            _taskDescription.text = _task.taskDescription;
            _taskDes = _task.taskDescription;
            
            _taskNameTextField.text = _task.taskName;
            _taskName = _task.taskName;
            
            _taskStatusOutlet.selectedSegmentIndex = _task.taskStatus;
            _status = _task.taskStatus;
            break;
        case FROM_DONE_TO_EDIT_TASK:
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:1];
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:0];
            [_taskStatusOutlet setEnabled:NO forSegmentAtIndex:2];
//            [_notificationOutlet setEnabled:NO forSegmentAtIndex:0];
//            [_notificationOutlet setEnabled:NO forSegmentAtIndex:1];
            
            _notificationOutlet.enabled = NO;
            _addButtonOutlet.enabled = NO;
            [_addButtonOutlet setTitle:@"Done Task" forState:UIControlStateNormal];

            _detailsHeader.text = @"Done Task";
            
            _taskPriorityOutlet.selectedSegmentIndex = _task.taskPrority;
            _priority = _task.taskPrority;
            _taskPriorityOutlet.enabled = NO;
            
            _taskDescription.text = _task.taskDescription;
            _taskDes = _task.taskDescription;
            _taskDescription.editable = NO;
            
            _taskNameTextField.text = _task.taskName;
            _taskName = _task.taskName;
            _taskNameTextField.enabled = NO;
            
            _taskStatusOutlet.selectedSegmentIndex = _task.taskStatus;
            _status = _task.taskStatus;
            _taskStatusOutlet.enabled = NO;
            
            _dateOutlet.enabled = NO;
            
            break;
            
        default:
            break;
    }
}

- (IBAction)taskDeadline:(UIDatePicker *)sender {
    _deadline = [sender date];
}

- (IBAction)onTaskStatusClick:(UISegmentedControl *)sender {
    _status = [sender selectedSegmentIndex];
}

- (IBAction)onTaskPriorityClick:(UISegmentedControl *)sender {
    _priority = [sender selectedSegmentIndex];
}

- (IBAction)onAddNewTaskClick:(UIButton *)sender {
    
    if (_taskNameTextField.text.length == 0 || _taskDescription.text.length == 0) {
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"You Must Fill All Task Details!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
            [alert addAction:action];
        
            [self presentViewController:alert animated:YES completion:nil];
        
            return;
        }
    
        Task *task = [Task new];
    
        task.taskName = _taskNameTextField.text;
    
        task.taskDescription = _taskDescription.text;
    
        task.taskDeadline = _deadline;
    
        task.taskStatus = _status;
    
        task.taskPrority = _priority;

        if (_navKey == FROM_TODO_TO_EDIT_TASK) {
            
            task.taskId = _task.taskId;

            if (task.taskStatus == StatusProgress) {
                
                [TaskManager fromToDoAddToProgress:task];
                
            } else {
                [TaskManager editTask:task];
            }

            _successAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Task updated successfully!" preferredStyle:UIAlertControllerStyleAlert];
            
        }
        else if (_navKey == FROM_PROGRESS_TO_EDIT_TASK){
            task.taskId = _task.taskId;

            if (task.taskStatus == StatusDone) {
                                
                [TaskManager fromProgressToDone:task];
            } else {
                [TaskManager editTaskFromProgress:task];
            }

            _successAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Task updated successfully!" preferredStyle:UIAlertControllerStyleAlert];
        }
        else {
            
            task.taskId = [NSUUID UUID];
            
            [TaskManager addNewTask:task];

            _successAlert = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Task added successfully!" preferredStyle:UIAlertControllerStyleAlert];
        }

        UIAlertAction *successAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [_successAlert addAction:successAction];
        [self presentViewController:_successAlert animated:YES completion:nil];
}


- (IBAction)onNotificationClick:(UISegmentedControl *)sender {
    _notification = [sender selectedSegmentIndex];
}

//-(void) registerNotify{
//    UIIIMu
//}
@end
