import json
import os

import openai
import requests


def transform_message(original_message):
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        raise ValueError("OPENAI_API_KEY is not set")

    openai.api_key = openai_api_key

    prompt_for_summarization = f"{original_message} これを日本語で要約して"

    try:
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": prompt_for_summarization}],
        )
        return response.choices[0].message["content"]
    except openai.error.OpenAIError as e:
        print(f"OpenAI API error: {e}")
        return "Error in generating summary"


def lambda_handler(event, context):
    body = json.loads(event["body"])
    challenge_value = body.get("challenge")

    if challenge_value:
        return {"statusCode": 200, "body": json.dumps({"challenge": challenge_value})}

    original_message = body["event"]["text"]
    transformed_message = transform_message(original_message)

    webhook_url = os.getenv("WEBHOOK_URL")
    if not webhook_url:
        raise ValueError("WEBHOOK_URL is not set")

    try:
        response = requests.post(
            webhook_url,
            headers={"Content-Type": "application/json"},
            data=json.dumps({"text": transformed_message}),
        )
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print(f"Error sending message to webhook: {e}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Error in sending message to webhook"}),
        }

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Message transformed and sent"}),
    }
