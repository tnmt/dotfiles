# dotfiles

tnmtの開発環境を `chezmoi` で管理するための設定群です。XDG ベースのレイアウトに統一しており、Linuxbrew や 1Password との連携も想定しています。

## 主な内容

- **シェル**: Zsh + Powerlevel10k、tmux ヘルパー (`tm`)。
- **エディタ**: Neovim（lazy.nvim、mason、none-ls で LSP/formatter を管理）。
- **パッケージ管理**: `package-mapping.toml` で apt/brew のパッケージ名を一元管理。brewfile と apt install リストを自動生成。
- **ランタイム管理**: mise による Node, Python, Ruby, Go のバージョン管理。
- **ユーティリティ**:
  - `cleanup-brew-apt` - apt と brew で重複インストールされたパッケージを brew から削除 (Python)
  - `tm` - tmux セッション管理ヘルパー
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

## パッケージ管理

`dot_config/packages/package-mapping.toml` でパッケージ名を一元管理しています:

```toml
[delta]
brew = "delta"
apt = "git-delta"
mode = "base"

[neovim]
brew = "neovim"
mode = "development"
skip_cleanup = true  # cleanup-brew-apt の対象外
```

- **brew** / **apt**: 各パッケージマネージャでのパッケージ名
- **mode**: `base` (常時), `development`, `desktop`
- **brew_os**: `all` (デフォルト), `darwin` (macOS のみ brew)
- **skip_cleanup**: `true` で cleanup-brew-apt から除外

このファイルから以下が自動生成されます:
- `brewfile` (brew bundle 用)
- `run_once_01-install-packages.sh` 内の apt install リスト

## 1Password 連携

テンプレートから `{{ onepasswordRead "op://..." }}` を利用することで、リポジトリに秘密情報を含めずに 1Password から値を取得できます。`op signin` 済みであることが前提です。

## ライセンス

特にライセンスは設定していません。必要に応じてプロジェクトポリシーに従ってください。
