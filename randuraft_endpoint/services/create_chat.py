import argparse
import json
import os

import google.generativeai as genai  # type: ignore
import openai
import requests
from dotenv import load_dotenv
from tenacity import retry, stop_after_attempt, wait_random_exponential

load_dotenv()

required_keys = [
    "OPENAI_API_KEY",
    "GOOGLE_API_KEY",
]
not_set = []
for key in required_keys:
    if not os.getenv(key):
        not_set.append(key)
if len(not_set) > 0:
    fmt = ", ".join(not_set)
    raise Exception(f"Environment variables not set: {fmt}")


openai.api_key = os.getenv("OPENAI_API_KEY") or ""
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY") or ""
genai.configure(api_key=GOOGLE_API_KEY)


@retry(wait=wait_random_exponential(min=1, max=20), stop=stop_after_attempt(3))
def get_chat_completion(
    messages: str, role="user", model="gpt-3.5-turbo"
) -> str:
    try:
        response = openai.ChatCompletion.create(
            model=model,
            messages=[{"role": role, "content": messages}],
        )
        choices = response.get("choices", [{}])
        completion = choices[0].get("message", {}).get("content", "").strip()

        print(f"Model used: {response.get('model', 'No model info')}")
        print(f"Token usage details: {response.get('usage', {})}")

        return completion
    except Exception as e:
        print(f"Failed to get chat completion: {e}")
        raise


def get_chat_completion_Gemini(messages: str) -> dict:
    for m in genai.list_models():
        if "generateContent" in m.supported_generation_methods:
            print(m.name)
    model = genai.GenerativeModel("gemini-1.5-pro-latest")

    response = model.generate_content(messages)
    return response.text


def get_json_response(messages: str) -> str:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key={GOOGLE_API_KEY}"
    headers = {"Content-Type": "application/json"}

    prompt_part = (
        "You are a task planner. The 'tree' represents the hierarchical structure of tasks where each key is a task ID and its corresponding value is a list of subtask IDs. "
        "The 'tasks' provides detailed descriptions for each task ID. "
        "Based on the user's goal, generate a task tree with both 'tree' and 'tasks'. "
        "If possible, generate at least 10 tasks, making sure that the tasks are MECE and that the level below the tree provides specific actions to guide the user toward the goal. "
        "Ensure that the information is provided in a single line without any line breaks. Response in Japanese. Exclude all other explanations."
    )
    json_schema = (
        "{ 'type': 'array', 'items': { 'type': 'object', 'properties': { 'id': { 'type': 'integer' }, "
        "'task': { 'type': 'string' }, 'children': { 'type': 'array', 'items': { 'type': 'object', "
        "'properties': { 'id': { 'type': 'integer' }, 'task': { 'type': 'string' } }, 'required': ['id', 'task'] } } }, "
        "'required': ['id', 'task', 'children'] } }"
    )
    parts_text = (
        prompt_part
        + f"This time {messages} is user's goal."
        + " You have to use this JSON schema: '"
        + json_schema
        + "'"
    )

    data = {
        "contents": [{"parts": [{"text": parts_text}]}],
        "generationConfig": {"response_mime_type": "application/json"},
    }

    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 200:
        response_data = response.json()
        os.makedirs("saving", exist_ok=True)
        filename = "saving/tasks.json"
        with open(filename, "w", encoding="utf-8") as file:
            json.dump(response_data, file, indent=2, ensure_ascii=False)
        print(f"Data saved to {filename}")

        try:
            text_content = response_data["candidates"][0]["content"]["parts"][
                0
            ]["text"]

            tasks = json.loads(text_content)

            formatted_filename = "saving/tasks.json"
            with open(formatted_filename, "w", encoding="utf-8") as file:
                json.dump(tasks, file, indent=2, ensure_ascii=False)
            print(f"Formatted data saved to {formatted_filename}")

        except (KeyError, IndexError, json.JSONDecodeError) as e:
            print(f"Error processing JSON data: {e}")

        return json.dumps(response_data, indent=2, ensure_ascii=False)
    else:
        error_message = (
            f"Failed to retrieve data: {response.status_code}, {response.text}"
        )
        print(error_message)
        return error_message


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Get chat completion from OpenAI."
    )
    parser.add_argument(
        "--input",
        help="Input message to send to the chat model.",
        type=str,
        required=True,
    )
    args = parser.parse_args()

    try:
        # completion = get_chat_completion(args.input)

        prompt = 'List 5 popular cookie recipes using this JSON schema: {"type": "object", "properties": { "recipe_name": { "type": "string" }}}'
        completion = get_json_response(args.input)
        print(f"Generated completion: {completion}")
    except Exception as e:
        print(f"Error: {e}")
