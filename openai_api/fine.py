import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")

response = openai.File.create(
  file=open("sample_prompt.jsonl", "rb"),
  purpose='fine-tune'
)
file_id = response["id"]
openai.FineTuningJob.create(training_file=file_id, model="davinci-002")
