import argparse
import json
import os
from typing import Any, Dict

import google.generativeai as genai
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
def create_content_using_openai(
    messages: str, role="user", model="gpt-3.5-turbo"
) -> str:
    """
    入力に対してOpenAI APIからの返答を出力
    Args:
        `message` (str): 入力プロンプト
        `role` (str): ロール
        `model` (str): 使用するモデル
    Return:
        `str`: 生成されたテキスト
    """
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


def Gemini_API_model_list() -> None:
    """
    Gemini_APIで使えるモデルリスト表示
    """
    for m in genai.list_models():
        if "generateContent" in m.supported_generation_methods:
            print(m.name)
    return


@retry(wait=wait_random_exponential(min=1, max=20), stop=stop_after_attempt(3))
def create_content_using_gemini(
    messages: str, model="gemini-1.5-pro-latest"
) -> dict:
    """
    入力に対してGemini APIからの返答を出力
    Args:
        `message` (str): 入力プロンプト
        `model` (str): 使用するモデル
    Return:
        `str`: 生成されたテキスト
    """
    model = genai.GenerativeModel(model)
    response = model.generate_content(messages)
    return response.text


def save_json(data: Dict[str, Any], filename: str) -> None:
    """
    指定されたデータをJSON形式で保存
    Args:
        `data` (Dict[str, Any]): 保存するデータ
        `filename` (str): 保存するファイルの名前
    """
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)
    print(f"Data saved to {filename}")


@retry(wait=wait_random_exponential(min=1, max=20), stop=stop_after_attempt(3))
def create_task_tree(task: str) -> Dict[str, Any]:
    """
    入力を基にGemini-1.5-proのJson modeを使いタスクツリーを生成。その結果を辞書で返す。
    Args:
        `task` (str): ユーザーの目標とするタスク
    Returns:
        `Dict[str, Any]`: 生成されたタスクツリーの辞書。エラーが発生した場合はエラーメッセージが含まれる辞書。
    """
    model = "gemini-1.5-pro-latest"
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={GOOGLE_API_KEY}"  # noqa
    headers = {"Content-Type": "application/json"}

    prompt_part = (
        "You are a task planner. "
        "The 'tree' represents the hierarchical structure of tasks where each key is a task ID and its corresponding value is a list of subtask IDs."  # noqa
        "The 'tasks' provides detailed descriptions for each task ID. "
        "Based on the user's goal, generate a task tree with both 'tree' and 'tasks'. "  # noqa
        "If possible, generate at least 10 tasks, making sure that the tasks are MECE and that the level below the tree provides specific actions to guide the user toward the goal. "  # noqa
        "Ensure that the information is provided in a single line without any line breaks. Response in Japanese. Exclude all other explanations."  # noqa
    )

    parts_text = prompt_part + f"This time {task} is user's goal."

    data = {
        "contents": [{"parts": [{"text": parts_text}]}],
        "generationConfig": {"response_mime_type": "application/json"},
    }

    response = requests.post(url, headers=headers, json=data)
    if response.status_code == 200:
        response_data = response.json()
        # 必要に応じて
        # save_json(response_data, "saving/tasks.json")
        return response_data
    else:
        error_message = {
            "error": f"Failed to retrieve data: {response.status_code}, {response.text}"
        }
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
        completion = create_task_tree(args.input)

        print(f"Generated completion: {completion}")
    except Exception as e:
        print(f"Error: {e}")
