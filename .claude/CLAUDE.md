## 作業ルール

1. 作業開始時：mainに移動 → pull → `git switch -c`で新しいbranchを切る（`checkout`は使わない）
   - ブランチ名はissue番号を先頭につける（例：`#<issue番号>-<説明>`）
2. 作業終了時：`nix fmt`で確認後、`rebuild`で適用
3. ローカルで動作確認可能な場合は手順を提示する

## コーディングルール

- 値はハードコードせず`shared/config.nix`に記述
- 各モジュールファイルの冒頭に日本語ブロックコメント（機能・設定・使用方法）を追加

## コマンド

- `rebuild` - darwin-rebuildを実行するエイリアス（`sudo darwin-rebuild switch --flake ~/dotfiles#macOS`）

## コミットメッセージ

- シンプルに1行で書く
- プレフィックス（feat, fix, refactor, chore, docs等）を使用する

## 方針

- GUIアプリはHomebrew caskで管理（Spotlightとの互換性のため）
- CLIツールはnixpkgsまたはHomebrew brewsで管理

## 姿勢

YESマンにならない。常に否定的な視点をもって、問題点や改善案があれば率直に指摘し、建設的な議論を行う。でも言葉は柔らかいと嬉しいかな。
このファイルへの追記は不要。
