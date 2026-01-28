# dotfiles

tnmtの開発環境を `chezmoi` で管理するための設定群です。XDG ベースのレイアウトに統一しており、Linuxbrew や 1Password との連携も想定しています。

## 主な内容

- **シェル**: Zsh + Powerlevel10k、tmux ヘルパー (`tm`)。
- **ユーティリティ**: `cleanup-brew-apt` - aptとbrewで重複インストールされたパッケージをbrewから削除。
- **エディタ**: Neovim（lazy.nvim、mason、none-ls で LSP/formatter を管理）。
- **パッケージ管理**: `dot_config/packages/brewfile` を `brew bundle` で適用。Brewfile 変更時に自動実行。
- **ランタイム管理**: mise による Node, Python, Ruby, Go のバージョン管理。
- **Claude CLI**: 公式のnative版をインストール。

## セットアップモード

初回実行時に以下を選択します:

| desktop | development | 用途 |
|---------|-------------|------|
| true | true | フルデスクトップ開発環境 |
| true | false | 軽量デスクトップ (開発ツールなし) |
| false | true | 開発サーバー (headless + 開発ツール) |
| false | false | 最小サーバー |

- **desktop**: GUI関連 (フォント, デスクトップアプリ, xclip)
- **development**: 開発ツール (Homebrew, mise, Neovim セットアップ, Claude CLI)

## セットアップ

1. **chezmoi をインストール**
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
   ```

2. **リポジトリを適用**
   ```bash
   export PATH=$PATH:$HOME/.local/bin

   # SSH
   chezmoi init --apply git@github.com:tnmt/dotfiles.git

   # または HTTPS
   chezmoi init --apply tnmt
   ```
   初回実行時にプロンプトで以下を入力します:
   - Email address
   - Full name
   - Is this a desktop machine? (`desktop`)
   - Development environment? (`development`)

3. **後続のセットアップ (development=true の場合)**

   `chezmoi apply` により以下が自動実行されます:
   - Homebrew インストール & `brew bundle`
   - mise によるランタイムインストール
   - Neovim 依存パッケージのインストール
   - Claude CLI インストール

   Neovim 初回起動時に lazy.nvim がプラグインを同期します。

## 1Password 連携

テンプレートから `{{ onepasswordRead "op://..." }}` を利用することで、リポジトリに秘密情報を含めずに 1Password から値を取得できます。`op signin` 済みであることが前提です。

## ライセンス

特にライセンスは設定していません。必要に応じてプロジェクトポリシーに従ってください。
