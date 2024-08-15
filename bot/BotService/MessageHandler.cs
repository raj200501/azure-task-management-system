using Microsoft.Bot.Builder;
using Microsoft.Bot.Schema;
using System.Threading;
using System.Threading.Tasks;

public class MessageHandler : ActivityHandler
{
    protected override async Task OnMessageActivityAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
    {
        var userMessage = turnContext.Activity.Text;

        // Call LUIS to analyze intent (LUISHandler.cs)
        var intent = await LUISHandler.GetIntentAsync(userMessage);

        // Respond based on intent
        if (intent == "GetTaskList")
        {
            await turnContext.SendActivityAsync(MessageFactory.Text("Here are your tasks..."), cancellationToken);
        }
        else
        {
            await turnContext.SendActivityAsync(MessageFactory.Text("I'm not sure how to help with that."), cancellationToken);
        }
    }
}
