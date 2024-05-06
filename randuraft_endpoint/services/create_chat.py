import argparse
import os

import openai
from dotenv import load_dotenv
from tenacity import retry, stop_after_attempt, wait_random_exponential

load_dotenv()

required_keys = [
    "OPENAI_API_KEY",
]
not_set = []
for key in required_keys:
    if not os.getenv(key):
        not_set.append(key)
if len(not_set) > 0:
    fmt = ", ".join(not_set)
    raise Exception(f"Environment variables not set: {fmt}")


openai.api_key = os.getenv("OPENAI_API_KEY") or ""


@retry(wait=wait_random_exponential(min=1, max=20), stop=stop_after_attempt(3))
def get_chat_completion(messages: str, role="user", model="gpt-3.5-turbo") -> str:
    try:
        response = openai.ChatCompletion.create(
            model=model,
            messages=[{"role": role, "content": messages}],
        )
        choices = response.get("choices", [{}])
        completion = choices[0].get("message", {}).get("content", "").strip()
        return completion
    except Exception as e:
        print(f"Failed to get chat completion: {e}")
        raise


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Get chat completion from OpenAI.")
    parser.add_argument(
        "--input",
        help="Input message to send to the chat model.",
        type=str,
        required=True,
    )
    args = parser.parse_args()

    try:
        completion = get_chat_completion(args.input)
        print(f"Generated completion: {completion}")
    except Exception as e:
        print(f"Error: {e}")
