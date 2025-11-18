# Zsh Configuration

Zsh設定をNix/Home-managerから移行したものです。

## プロンプト設定

このzsh設定では、2つのプロンプトから選択できます：

### Powerlevel10k (現在のデフォルト)

高機能なZsh専用プロンプトで、以下の特徴があります：
- 高速なインスタントプロンプト
- Git情報の詳細表示
- コマンド実行時間の表示
- Python仮想環境、Node.jsバージョンなどの表示
- 豊富なカスタマイズオプション

**設定ファイル**: `~/.p10k.zsh`

**カスタマイズ**:
```bash
p10k configure
```

### Starship (代替オプション)

シンプルで高速、多言語対応のプロンプトです：
- Rust製で非常に高速
- 様々なシェルで使用可能（zsh, bash, fish等）
- TOML形式の設定ファイル
- シンプルでモダンな見た目

**設定ファイル**: `~/.config/starship/starship.toml`

## プロンプトの切り替え方法

### Powerlevel10k → Starship

1. `.zshrc`を編集:
   ```bash
   nvim ~/.zshrc
   ```

2. Powerlevel10kの設定をコメントアウト:
   ```bash
   # Option 1: Powerlevel10k (現在有効)
   # POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
   # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
   ```

3. Starshipの設定を有効化:
   ```bash
   # Option 2: Starship
   if command -v starship &> /dev/null; then
       eval "$(starship init zsh)"
   fi
   ```

4. zinitの設定でpowerlevel10kをコメントアウト:
   ```bash
   # zinit ice depth=1
   # zinit light romkatv/powerlevel10k
   ```

5. Starshipをインストール:
   ```bash
   brew install starship
   # または
   curl -sS https://starship.rs/install.sh | sh
   ```

6. シェルを再起動:
   ```bash
   exec zsh
   ```

### Starship → Powerlevel10k

上記の逆の手順を実行してください。

## インストールされているプラグイン

### Zinit経由
- **zsh-completions**: 強化された補完機能
- **zsh-autosuggestions**: コマンド履歴に基づいた自動補完候補
- **zsh-syntax-highlighting**: コマンドのシンタックスハイライト
- **zsh-256color**: 256色対応
- **powerlevel10k**: プロンプトテーマ（デフォルト）
- **zsh-z**: ディレクトリジャンプ（`j`コマンド）
- **history-search-multi-word**: 高度な履歴検索
- **anyframe**: pecoを使った各種セレクター
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

### Anyframe（pecoを使ったセレクター）
- `Ctrl+x b` - ディレクトリ移動履歴を表示
- `Ctrl+x r` - コマンド実行履歴を表示
- `Ctrl+x Ctrl+b` - Gitブランチ切り替え
- `Ctrl+]` - GHQリポジトリへジャンプ

### tmux
- `Ctrl+f` - tmux-sessionizer（プロジェクト切り替え）

## バージョンマネージャー

以下のバージョンマネージャーが自動検出されます（インストールされている場合）：
- **pyenv** - Python
- **plenv** - Perl
- **rbenv** - Ruby
- **nodebrew** - Node.js
- **goenv** - Go
- **mise** - 複数言語対応（推奨）

**推奨**: 新規インストールでは`mise`の使用を推奨します。

## 履歴設定

- 履歴ファイル: `~/.zsh_history`
- 履歴サイズ: 10,000,000行
- 機能:
  - 複数セッション間で履歴共有
  - タイムスタンプ記録
  - 重複コマンドの除外
  - 先頭スペースのコマンドは記録しない

## トラブルシューティング

### プロンプトが表示されない

1. Powerlevel10kが正しくインストールされているか確認:
   ```bash
   ls ~/.local/share/zinit/plugins/romkatv---powerlevel10k/
   ```

2. p10k設定ファイルが存在するか確認:
   ```bash
   ls ~/.p10k.zsh
   ```

3. zinitを再インストール:
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

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Starship](https://starship.rs/)
- [Zinit](https://github.com/zdharma-continuum/zinit)
- [zsh-users](https://github.com/zsh-users)