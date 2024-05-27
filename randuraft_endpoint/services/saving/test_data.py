from api.models.task import Task

TEST_TASK_TREE = [
    Task(
        id=1,
        task="ゲームコンセプトの定義",
        children=[
            Task(id=11, task="ゲームのジャンルを決定する"),
            Task(id=12, task="ターゲット audience を明確にする"),
            Task(id=13, task="ゲームのストーリーや設定を考える"),
            Task(id=14, task="コアとなるゲームプレイを決定する")
        ]
    ),
    Task(
        id=2,
        task="ゲームデザイン",
        children=[
            Task(id=21, task="ゲームメカニクスの設計"),
            Task(id=22, task="レベルデザイン"),
            Task(id=23, task="キャラクターデザイン"),
            Task(id=24, task="UI/UXデザイン")
        ]
    ),
    Task(
        id=3,
        task="技術選定",
        children=[
            Task(id=31, task="ゲームエンジンを選択する(Unity, Unreal Engineなど)"),
            Task(id=32, task="プログラミング言語を選択する"),
            Task(id=33, task="必要なアセット(画像、音楽など)を決定する")
        ]
    ),
    Task(
        id=4,
        task="開発",
        children=[
            Task(id=41, task="プロトタイプを作成する"),
            Task(id=42, task="ゲームの機能を実装する"),
            Task(id=43, task="テストプレイとデバッグ")
        ]
    ),
    Task(
        id=5,
        task="リリース",
        children=[
            Task(id=51, task="ゲームを公開するプラットフォームを選択する"),
            Task(id=52, task="マーケティングとプロモーション"),
            Task(id=53, task="ユーザーサポート")
        ]
    )
]
