import os
import openai
import time

openai.api_key = os.getenv("OPENAI_API_KEY")
finetuned_model = os.getenv("FINE_TURNING_MODEL")

def AskChatbot(message):
    retries = 3
    delay = 10
    for _ in range(retries):
        try:
            completion = openai.Completion.create(
                 model       = finetuned_model,
                 prompt      = message,
                 max_tokens  = 1024,
                 n           = 10,
                 stop        = None,
                 temperature = 0,
            )
            print("\n\n\n")
            response = completion.choices[0]["text"]
            print("\n\n\n")
            return response.strip()
        except openai.error.ServiceUnavailableError:
            time.sleep(delay)
            continue
    return "Error: Unable to retrieve response from model."


message = "You are a task planner. The 'tree' represents the hierarchical structure of tasks where each key is a task ID and its corresponding value is a list of subtask IDs. The 'tasks' provides detailed descriptions for each task ID. Based on the user's goal, generate a task tree with both 'tree' and 'tasks'. If possible, generate at least 10 tasks, making sure that the tasks are MECE and that the level below the tree provides specific actions to guide the user toward the goal.The response should be structured as follows: {'tree': {'1': ['2', '3',...], '2': ['4', '5',...], '3': [],...}, 'tasks': {'1': 'Goal description', '2': 'Subtask 1 description',...}}. ***Ensure that the information is provided in a single line without any line breaks.*** Response in japanese. Exclude all other explanations. ***Now follow this and make with trees and tasks at アプリ制作"
res = AskChatbot(message)
print(res)
