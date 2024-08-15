using azure_task_management_system.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace azure_task_management_system.Services
{
    public class TaskService : ITaskService
    {
        private readonly List<TaskItem> _tasks = new List<TaskItem>();

        public TaskService()
        {
            // Pre-populated tasks for demonstration
            _tasks.Add(new TaskItem { Id = 1, Name = "Design Database", Description = "Design the project database schema.", Priority = "High", IsComplete = false });
            _tasks.Add(new TaskItem { Id = 2, Name = "Implement API", Description = "Develop the RESTful API.", Priority = "Medium", IsComplete = false });
        }

        public Task<IEnumerable<TaskItem>> GetTasksAsync()
        {
            return Task.FromResult((IEnumerable<TaskItem>)_tasks);
        }

        public Task CreateTaskAsync(TaskItem task)
        {
            task.Id = _tasks.Count + 1;
            _tasks.Add(task);
            return Task.CompletedTask;
        }
    }
}
