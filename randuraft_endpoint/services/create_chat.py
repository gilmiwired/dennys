import argparse
import os

import google.generativeai as genai
import openai
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
genai.configure(api_key=os.getenv("GOOGLE_API_KEY") or "")


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


def get_json_response(messages: str) -> dict:
    for m in genai.list_models():
        if "generateContent" in m.supported_generation_methods:
            print(m.name)
    model = genai.GenerativeModel("gemini-1.5-pro-latest")

    response = model.generate_content(messages)
    return response.text


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
        completion = get_json_response(prompt)
        print(f"Generated completion: {completion}")
    except Exception as e:
        print(f"Error: {e}")
