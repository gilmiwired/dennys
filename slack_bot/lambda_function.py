import json
import requests
import openai
import os

def transform_message(original_message):
    # openai_api_key　= chatGPTのAPI
    openai_api_key = ''
    openai.api_key = openai_api_key


    prompt_for_summarization = f"{original_message}これを日本語で要約して "

    # GPT-3.5-turboの応答取得
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[
            {"role": "user", "content": prompt_for_summarization}
        ]
    )

    return response.choices[0].message['content']

 # こっから下はslackとawsの通信関連
def lambda_handler(event, context):
    body = json.loads(event['body'])
    challenge_value = body.get('challenge')

    if challenge_value: 
        return {
            'statusCode': 200,
            'body': json.dumps({'challenge': challenge_value})
        }

    original_message = body['event']['text']
    transformed_message = transform_message(original_message)

    ＃webhook用のurl
    webhook_url = ""

    response = requests.post(
        webhook_url,
        headers={'Content-Type': 'application/json'},
        data=json.dumps({'text': transformed_message})
    )

    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Message transformed and sent'})
    }
