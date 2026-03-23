# dotfiles

tnmtの開発環境を `chezmoi` で管理するための設定群です。XDG ベースのレイアウトに統一しており、macOS (Homebrew)、Ubuntu (apt + Linuxbrew)、Arch Linux (pacman/paru) に対応しています。1Password との連携も想定しています。

## 主な内容

- **シェル**: Zsh + Powerlevel10k、tmux ヘルパー (`tm`)。
- **エディタ**: Neovim（lazy.nvim、mason、none-ls で LSP/formatter を管理）。
- **パッケージ管理**: `package-mapping.toml` で brew/apt/pacman のパッケージ名を一元管理。brewfile、apt install リスト、pacman install リストを自動生成。
- **責務分離**: package manager bootstrap は `run_once_01-*`、post-install は各 `run_once_*` に分離。
- **ランタイム管理**: mise による Node, Python, Ruby, Go, Rust のバージョン管理。
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
- **development**: 開発ツール (Homebrew/paru, mise, Neovim セットアップ, Claude CLI)

## セットアップ

1. **chezmoi をインストール**
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
   ```

2. **リポジトリを適用**
   ```bash
   export PATH=$PATH:$HOME/.local/bin

   # SSH
   OP_ACCOUNT=my.1password.com chezmoi init git@github.com:tnmt/dotfiles.git

   # または HTTPS
   OP_ACCOUNT=my.1password.com chezmoi init tnmt
   ```
   初回実行時にプロンプトで以下を入力します:
   - Email address
   - Full name
   - Is this a desktop machine? (`desktop`)
   - Development environment? (`development`)

   `development=true` の場合、初回 `apply` 時に 1Password の値を参照するため、事前に `op` が利用可能であることと、`my.1password.com` にサインイン済みであることが前提です。

3. **後続のセットアップ (development=true の場合)**

   `chezmoi apply` により以下が自動実行されます:
   - **macOS / Ubuntu**: Homebrew インストール & `brew bundle`
   - **Arch Linux**: paru 自動インストール & pacman/paru でパッケージインストール（Linuxbrew 不使用）
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
pacman = "git-delta"
mode = "base"

[neovim]
brew = "neovim"
pacman = "neovim"
mode = "development"

[awscli]
brew = "awscli"
mode = "development"
darwin_only = true
```

- **brew** / **apt** / **pacman**: 各パッケージマネージャでのパッケージ名
- **cask**: Homebrew Cask のパッケージ名
- **apt_cmd**: apt 側のコマンド名がパッケージ名と異なる場合
- **mode**: `base` (常時), `development`, `desktop`
- **darwin_only**: `true` で macOS のみ brew インストール（デフォルト: `false`）

このファイルから以下が自動生成されます:
- `brewfile` (brew bundle 用)
- `run_once_01-install-packages.sh` 内の apt / pacman install リスト

### OSごとの解決ルール

- **macOS**: `brew` / `cask` が定義されているパッケージを Homebrew でインストール
- **Linux (Arch)**: `pacman` があれば pacman/paru でインストール（Linuxbrew 不使用）
- **Linux (Ubuntu 等)**: `apt` があれば apt を優先、`apt` がなければ brew を利用
- **Linux + darwin_only=true**: brew でもインストールしない

### パッケージ追加手順

1. `dot_config/packages/package-mapping.toml` にエントリを追加
2. `chezmoi apply` を実行してテンプレートを再生成
3. 生成結果を確認（例: `~/.config/packages/brewfile`）
4. 必要に応じて `brew bundle --file=~/.config/packages/brewfile` / apt で適用

### 運用メモ

- `brew` は「キー名を暗黙利用」ではなく、**明示定義を推奨**（現行テンプレートでは `brew` キーがある項目のみ Brewfile に出力）
- 現在の方針は基本的に「最新追従」（バージョン固定は未導入）
- Homebrew / mise / paru 本体の導入は `package-mapping.toml` 管理外で、セットアップスクリプト側で実行
- `tmux`, `neovim`, `ripgrep`, `fd`, `xclip` などの通常パッケージは `package-mapping.toml` を正とし、個別 setup script では再インストールしない
- Homebrew のみで入るツール（例: `atuin`, `1password-cli`）は、Linux で Homebrew 前提になりすぎないよう `development` に寄せる
- Arch Linux では paru が自動インストールされ、AUR パッケージ（`1password-cli`, `go-yq`, `ghq` 等）もインストール可能

### 責務ルール

- `package-mapping.toml`: 通常パッケージの宣言元
- `run_once_01-install-packages.sh.tmpl`: package manager bootstrap と apt/pacman 同期
- `run_onchange_03-brew-bundle.sh.tmpl`: Brewfile 変更時の Homebrew 同期
- `run_once_05-setup-tmux.sh.tmpl` 以降: post-install のみ。`apt install` / `brew install` / `pacman -S` を増やさない
- 例外は Homebrew, paru, mise, 1Password apt repo のような bootstrap 対象のみ
- `run_once_02-install-starship.sh` と `run_once_07-install-claude-cli.sh.tmpl`: upstream の公式 installer を使う外部ツール例外
- `run_once_04-install-fonts.sh.tmpl`: Ubuntu 系などで manifest だけでは足りない upstream font asset の manual fallback

## 1Password 連携

テンプレートから `{{ onepasswordRead "op://..." }}` を利用することで、リポジトリに秘密情報を含めずに 1Password から値を取得できます。`op signin` 済みであることが前提です。

この dotfiles で参照する情報は `my.1password.com` 側の Vault に入っています。`chezmoi` 実行時は `OP_ACCOUNT=my.1password.com` を明示してください。

```bash
OP_ACCOUNT=my.1password.com chezmoi init --apply tnmt
OP_ACCOUNT=my.1password.com chezmoi update --apply
```

## ライセンス

特にライセンスは設定していません。必要に応じてプロジェクトポリシーに従ってください。
