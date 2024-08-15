using Microsoft.AspNetCore.Mvc;
using azure_task_management_system.Models;
using azure_task_management_system.Services;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace azure_task_management_system.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TaskController : ControllerBase
    {
        private readonly ITaskService _taskService;

        public TaskController(ITaskService taskService)
        {
            _taskService = taskService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TaskItem>>> GetTasks()
        {
            var tasks = await _taskService.GetTasksAsync();
            return Ok(tasks);
        }

        [HttpPost]
        public async Task<ActionResult> CreateTask([FromBody] TaskItem task)
        {
            await _taskService.CreateTaskAsync(task);
            return Ok();
        }
    }
}
