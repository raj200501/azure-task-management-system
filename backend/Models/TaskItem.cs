namespace azure_task_management_system.Models
{
    public class TaskItem
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Priority { get; set; }
        public bool IsComplete { get; set; }
    }
}
