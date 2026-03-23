# Zsh Configuration

## プロンプト設定

このzsh設定では Starship を利用します。

### Starship

シンプルで高速、多言語対応のプロンプトです：
- Rust製で非常に高速
- 様々なシェルで使用可能（zsh, bash, fish等）
- TOML形式の設定ファイル
- シンプルでモダンな見た目

**設定ファイル**: `~/.config/starship/starship.toml`

Starship は `run_once_02-install-starship.sh` で導入され、`~/.config/zsh/.zshrc` から初期化されます。

## インストールされているプラグイン

### Zinit経由
- **zsh-completions**: 強化された補完機能
- **zsh-autosuggestions**: コマンド履歴に基づいた自動補完候補
- **zsh-syntax-highlighting**: コマンドのシンタックスハイライト
- **zsh-256color**: 256色対応
- **atuin**: 履歴検索と同期対応のシェル履歴マネージャ
- **zsh-z**: ディレクトリジャンプ（`j`コマンド）
- **history-search-multi-word**: 高度な履歴検索
- **kube-aliases**: Kubernetes用のエイリアス

## エイリアス

### 基本コマンド
- `vi`, `vim` → `nvim` (Neovim)
- `ls` → カラー表示付き
- `g` → `git`
- `be` → `bundle exec`
- `j` → `zshz` (ディレクトリジャンプ)

### tmux関連
- `ta` → `tmux attach -t`
- `tad` → `tmux attach -d -t`
- `ts` → `tmux new-session -s`
- `tl` → `tmux list-sessions`

詳細は `~/.config/zsh/tmux.zsh` を参照

## キーバインド

### fzfセレクター
- `Ctrl+x b` - ディレクトリ移動履歴を表示
- `Ctrl+x Ctrl+b` - Gitブランチ切り替え
- `Ctrl+]` - GHQリポジトリへジャンプ
- `Ctrl+r` - `atuin` でコマンド履歴を検索

## バージョンマネージャー

以下のバージョンマネージャーが自動検出されます（インストールされている場合）：
- **mise** - 複数言語対応

**推奨**: 新規セットアップでは `mise` を利用し、必要なランタイムを一括管理してください。


## 履歴設定

- 履歴ファイル: `~/.zsh_history`
- 履歴サイズ: 10,000,000行
- 機能:
  - 複数セッション間で履歴共有
  - タイムスタンプ記録
  - 重複コマンドの除外
  - 先頭スペースのコマンドは記録しない
  - `Ctrl+r` から `atuin` のインタラクティブ検索を利用

### atuin

- 設定ファイル: `~/.config/atuin/config.toml`
- 現在の設定ではローカル履歴検索のみを有効化
- 同期を使いたい場合は `atuin register` または `atuin login` を実行

## トラブルシューティング

### プロンプトが表示されない

1. Starship がインストールされているか確認:
   ```bash
   command -v starship
   ```

2. zinitを再インストール:
   ```bash
   rm -rf ~/.local/share/zinit
   exec zsh
   ```

### 補完が動作しない

```bash
rm -f ~/.zcompdump
autoload -U compinit && compinit
```

### アイコンが文字化けする

Nerd Fontがインストールされているか確認:
```bash
fc-list | grep -i "nerd\|meslo"
```

インストールされていない場合:
```bash
bash ~/.local/share/chezmoi/run_once_install-fonts.sh
```

## 追加のカスタマイズ

### 追加の設定ファイルを読み込む

`~/.config/zsh/`に`.zsh`ファイルを配置すると、必要に応じて読み込めます：

```bash
# ~/.zshrcの最後に追加
for config_file (~/.config/zsh/*.zsh(N)); do
  source "$config_file"
done
```

現在は`tmux.zsh`が自動的に読み込まれます。

## 参考リンク

- [Starship](https://starship.rs/)
- [Zinit](https://github.com/zdharma-continuum/zinit)
- [zsh-users](https://github.com/zsh-users)
