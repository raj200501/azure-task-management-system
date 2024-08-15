#r "Microsoft.Azure.WebJobs"
#r "Microsoft.Extensions.Logging"
#r "Newtonsoft.Json"

using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Net.Http;

public static async void Run(TimerInfo myTimer, ILogger log)
{
    log.LogInformation($"Task Reminder Function executed at: {DateTime.Now}");

    using (var client = new HttpClient())
    {
        var response = await client.GetAsync("https://your-api-endpoint/api/task");
        if (response.IsSuccessStatusCode)
        {
            var tasksJson = await response.Content.ReadAsStringAsync();
            var tasks = JsonConvert.DeserializeObject<Task[]>(tasksJson);

            foreach (var task in tasks)
            {
                if (!task.IsComplete && task.Priority == "High")
                {
                    log.LogInformation($"Reminder sent for task: {task.Name}");
                }
            }
        }
    }
}

public class Task
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string Priority { get; set; }
    public bool IsComplete { get; set; }
}
