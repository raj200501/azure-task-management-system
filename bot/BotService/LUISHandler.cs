using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;

public static class LUISHandler
{
    private static readonly string LUISAppId = "your-luis-app-id";
    private static readonly string LUISAPIKey = "your-luis-api-key";
    private static readonly string LUISAPIHostName = "your-luis-api-hostname";

    public static async Task<string> GetIntentAsync(string message)
    {
        string queryString = $"{LUISAPIHostName}/luis/prediction/v3.0/apps/{LUISAppId}/slots/production/predict?subscription-key={LUISAPIKey}&query={message}";

        using (var client = new HttpClient())
        {
            var response = await client.GetStringAsync(queryString);
            var jsonResponse = JObject.Parse(response);
            var intent = jsonResponse["prediction"]["topIntent"].ToString();
            return intent;
        }
    }
}
