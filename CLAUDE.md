# CLAUDE.md

## リポジトリ概要

chezmoi で管理する dotfiles リポジトリ。詳細は README.md を参照。

## パッケージ管理

パッケージの追加・変更は `dot_config/packages/package-mapping.toml` を編集する。

### フィールド

| フィールド | 説明 | デフォルト |
|-----------|------|-----------|
| `brew` | Homebrew パッケージ名 | キー名 |
| `apt` | apt パッケージ名 | (省略で apt なし) |
| `apt_cmd` | apt 側のコマンド名が異なる場合 | (省略で apt と同じ) |
| `mode` | `base` / `development` / `desktop` | 必須 |
| `brew_os` | brew 対象 OS: `all` / `darwin` / `linux` | `all` |
| `skip_cleanup` | `true` で cleanup-brew-apt から除外 | `false` |

### パッケージ追加の手順

1. `dot_config/packages/package-mapping.toml` にエントリを追加
2. `chezmoi apply` で Brewfile / apt リストが自動再生成される
3. `brew bundle` または apt install で実際にインストール

### よくあるパターン

```toml
# macOS は brew、Linux は apt (最も一般的)
[パッケージ名]
brew = "brew名"
apt = "apt名"
mode = "development"
brew_os = "darwin"

# brew のみ (apt にパッケージが無い場合)
[パッケージ名]
brew = "brew名"
mode = "development"

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
