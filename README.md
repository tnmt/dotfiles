# dotfiles

tnmtの開発環境を `chezmoi` で管理するための設定群です。XDG ベースのレイアウトに統一しており、Linuxbrew や 1Password との連携も想定しています。

## 主な内容

- **シェル**: Zsh + Powerlevel10k、tmux ヘルパー (`tm`)。
- **ユーティリティ**: `cleanup-brew-apt` - aptとbrewで重複インストールされたパッケージをbrewから削除。
- **エディタ**: Neovim（lazy.nvim、mason、none-ls で LSP/formatter を管理）。
- **パッケージ管理**: `dot_config/packages/brewfile` を `brew bundle` で適用。`run_onchange_brew-bundle.sh` で Brewfile 変更時に自動実行。
- **ランタイム設定**: `run_once_setup-nvim.sh` などのセットアップスクリプト、`dot_zshenv` による XDG 変数設定。
- **Claude CLI**: `run_once_install-claude-cli.sh` でnative版をインストール（旧npm版から移行）。

## セットアップ

1. **chezmoi をインストール**  
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
   ```

2. **リポジトリを適用**  
   ```bash
   ## git
   chezmoi init git@github.com:tnmt/dotfiles.git
   chezmoi apply

   ## https
   chezmoi init tnmt
   ```
   初回実行時は `.chezmoi.toml.tmpl` のプロンプトで名前・メールアドレスなどを入力します。

3. **Homebrew パッケージを導入**  
   `chezmoi apply` 後、自動または手動で以下を実行します。
   ```bash
   brew bundle --file=$HOME/.config/packages/brewfile
   ```

4. **Neovim 初期化**
   `run_once_setup-nvim.sh` により依存が導入されます。再実行を避けるために `~/.local/state/nvim/setup.done` を利用しています。
   追加で `nvim` を起動し、lazy.nvim がプラグインを同期するのを待ちます。

5. **Claude CLI インストール**
   `run_once_install-claude-cli.sh` により公式のnative版Claude CLIが自動インストールされます。

## 1Password 連携

テンプレートから `{{ onepasswordRead "op://..." }}` を利用することで、リポジトリに秘密情報を含めずに 1Password から値を取得できます。`op signin` 済みであることが前提です。

## ライセンス

特にライセンスは設定していません。必要に応じてプロジェクトポリシーに従ってください。
