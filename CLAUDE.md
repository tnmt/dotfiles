# CLAUDE.md

## リポジトリ概要

chezmoi で管理する dotfiles リポジトリ。詳細は README.md を参照。

## パッケージ管理

パッケージの追加・変更は `dot_config/packages/package-mapping.toml` を編集する。

### フィールド

| フィールド | 説明 | デフォルト |
|-----------|------|-----------|
| `brew` | Homebrew パッケージ名 | (省略で brew 出力なし) |
| `apt` | apt パッケージ名 | (省略で apt なし) |
| `apt_cmd` | apt 側のコマンド名が異なる場合 | (省略で apt と同じ) |
| `mode` | `base` / `development` / `desktop` | 必須 |
| `darwin_only` | `true` で macOS のみ brew インストール | `false` |

OS の振り分けは自動:
- macOS: `brew` が定義されているパッケージを brew でインストール
- Linux: `apt` があれば apt を優先、`apt` がなければ brew を利用
- Linux + `darwin_only=true`: brew でもインストールしない

### パッケージ追加の手順

1. `dot_config/packages/package-mapping.toml` にエントリを追加
2. `chezmoi apply` で Brewfile / apt リストが自動再生成される
3. 生成結果を確認（例: `~/.config/packages/brewfile`）
4. 必要に応じて `brew bundle --file=~/.config/packages/brewfile` / apt で適用

### 運用メモ

- `brew` は明示定義を推奨（現行テンプレートは `brew` キーがある項目のみ Brewfile に出力）
- 現在の方針は基本的に最新追従（バージョン固定は未導入）
- Homebrew / mise 本体の導入は `package-mapping.toml` 管理外で、セットアップスクリプト側で実行

### よくあるパターン

```toml
# macOS は brew、Linux は apt (最も一般的)
[パッケージ名]
brew = "brew名"
apt = "apt名"
mode = "development"

# brew のみ・全 OS (apt にパッケージが無い場合)
[パッケージ名]
brew = "brew名"
mode = "development"

# brew のみ・macOS 限定 (Docker, コンテナツール等)
[パッケージ名]
brew = "brew名"
mode = "development"
darwin_only = true

# apt のみ (Linux ビルドツール等)
[パッケージ名]
apt = "apt名"
mode = "development"
```

### 自動生成されるファイル

- `dot_config/packages/brewfile.tmpl` → `~/.config/packages/brewfile`
- `run_once_01-install-packages.sh.tmpl` 内の apt install リスト

## セットアップモード

| desktop | development | 用途 |
|---------|-------------|------|
| true | true | フルデスクトップ開発環境 |
| true | false | 軽量デスクトップ |
| false | true | 開発サーバー (headless) |
| false | false | 最小サーバー |

## スクリプト実行順序

数値プレフィックスで制御:
- `run_once_01-install-packages.sh.tmpl` - パッケージインストール
- `run_onchange_02-brew-bundle.sh.tmpl` - Brewfile 変更時に brew bundle 実行
- `run_once_04-setup-tmux.sh.tmpl` - tmux セットアップ
- `run_once_05-setup-nvim.sh.tmpl` - Neovim セットアップ
- `run_once_06-install-claude-cli.sh.tmpl` - Claude CLI インストール
