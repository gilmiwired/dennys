# dennys

***

## slack_bot
chatGPT APIのテストで作ったやつ
参考までにslackとAWS間のやり取りで使ってる技術はwebhookっていうやつ

## データベース関連

### DB構造

データベースについては**Firebase**ってやつ使う予定でいじってます。

treeとtaskは生成、それを元にサーバー側で各contentを作成<br> 
→　プロンプト削減のため<br>
主に表示するのはtreeと各タイトルのみ<br>
content作成はtitle,children,statusを作る<br>
UI上で各タスクに触れた時にdescription==nullだったら説明作成&DBのdescription更新とかにすればプロンプト減らせる...かな


#### DB例

``` 
user_ID/ 
├── tree
├── task
└── content/
   ├── ID1
   ├── ID2
   └── ...
```
<br>



#### tree例

```
tree = [
    [1, [2, 3, 4, 5, 6]],
    [2, [7, 8, 9]],
    [3, [10, 11, 12]],
    [4, [13, 14]],
    [5, [15, 16]],
    [6, [17, 18]]
]
```
<br>

#### tasks例
```
tasks = {
    1: "ゲームを作る",
    2: "デザイン",
    3: "プログラム",
    4: "グラフィックス",
    5: "サウンド",
    6: "テスト",
    7: "コンセプト",
    8: "キャラ・ストーリー",
    9: "ルール・メカニクス",
    10: "エンジン選択",
    11: "キャラ動き",
    12: "ロジック・AI",
    13: "キャラ・背景アート",
    14: "アニメーション",
    15: "BGM",
    16: "効果音",
    17: "バグチェック",
    18: "ユーザーテスト"
}
```


#### ID1~N例

```
ID1 = {
    "title": "ゲームを作る",
    "children": [2, 3, 4, 5, 6],
    "status": "do",
    "description": "説明"
}

ID2 = {
    "title": "デザイン",
    "children": [7, 8, 9],
    "status": "done",
    "description": "説明"
}
```


## 環境について

とりあえず初期はwebアプリ想定<br>
俺ちゃんの環境はこれ<br><br>
Flutter 3.3.4 • channel stable • https://github.com/flutter/flutter.git<br>
Framework • revision eb6d86ee27 (10 months ago) • 2022-10-04 22:31:45 -0700<br>
Engine • revision c08d7d5efc<br>
Tools • Dart 2.18.2 • DevTools 2.15.0