"""
これも旧バージョン
import json
from tiktoken import TikToken, tokenizers

# データの読み込み
data_path = "sample_prompt.jsonl"
with open(data_path, "r", encoding="utf-8") as f:
    dataset = [json.loads(line) for line in f]

# tiktokenを使用してトークン数を計算
tokenizer = TikToken(tokenizer=tokenizers.ByteLevelBPETokenizer())
total_tokens = sum(
    tokenizer.count_tokens(ex["prompt"]) + tokenizer.count_tokens(ex["completion"])
    for ex in dataset
)

# 結果の表示
print(f"Total tokens (using tiktoken): {total_tokens}")
"""
