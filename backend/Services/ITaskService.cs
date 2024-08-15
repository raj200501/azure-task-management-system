using azure_task_management_system.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace azure_task_management_system.Services
{
    public interface ITaskService
    {
        Task<IEnumerable<TaskItem>> GetTasksAsync();
        Task CreateTaskAsync(TaskItem task);
    }
}
