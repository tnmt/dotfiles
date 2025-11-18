# Tmux Configuration

Tmux設定をNix/Home-managerから移行したものです。TPM (Tmux Plugin Manager)を使用してプラグインを管理します。

## 主な機能

- **プレフィックスキー**: `Ctrl-t` (デフォルトの`Ctrl-b`から変更)
- **Viモード**: コピーモードでVimライクな操作
- **24時間時計**: ステータスバーに24時間形式で表示
- **履歴**: 10,000行のスクロールバック履歴
- **True Color対応**: 24ビットカラーサポート
- **マウスサポート**: マウスでペイン選択やリサイズが可能
- **自動リナンバリング**: ウィンドウを閉じた際の番号自動整理

## インストール

1. **tmuxのインストール**:
   ```bash
   # macOS
   brew install tmux

   # Linux (Ubuntu/Debian)
   sudo apt install tmux

   # Linux (Arch)
   sudo pacman -S tmux
   ```

2. **セットアップスクリプトの実行**:
   ```bash
   bash ~/.local/share/chezmoi/run_once_setup-tmux.sh
   ```

3. **プラグインのインストール**:
   ```bash
   tmux
   # tmux内で Ctrl-t + I (大文字のI) を押す
   ```

## インストールされるプラグイン

- **tpm**: Tmux Plugin Manager
- **tmux-sensible**: 基本的な設定のベストプラクティス
- **tmux-yank**: クリップボード連携の強化
- **tmux-copycat**: 検索機能の強化
- **tmux-resurrect**: セッションの保存・復元
- **tmux-continuum**: 自動セッション保存
- **tmux-pain-control**: ペイン操作の改善
- **tokyo-night-tmux**: Tokyo Nightテーマ

## キーバインド

### 基本操作

| キー | 動作 |
|------|------|
| `Ctrl-t` | プレフィックスキー |
| `Ctrl-t + r` | 設定再読み込み |
| `Ctrl-t + ?` | キーバインド一覧表示 |

### ウィンドウ操作

| キー | 動作 |
|------|------|
| `Ctrl-t + c` | 新規ウィンドウ作成 |
| `Ctrl-t + n` | 次のウィンドウ |
| `Ctrl-t + p` | 前のウィンドウ |
| `Ctrl-t + 数字` | 指定番号のウィンドウへ移動 |
| `Ctrl-t + ,` | ウィンドウ名変更 |
| `Ctrl-t + &` | ウィンドウを閉じる |

### ペイン操作

| キー | 動作 |
|------|------|
| `Ctrl-t + \|` | 水平分割 |
| `Ctrl-t + -` | 垂直分割 |
| `Alt + ↑/↓/←/→` | ペイン移動（プレフィックス不要） |
| `Ctrl-t + Ctrl-h/j/k/l` | ペインリサイズ（連続入力可） |
| `Ctrl-t + x` | ペインを閉じる |
| `Ctrl-t + z` | ペインのズーム切り替え |
| `Ctrl-t + {` | ペインを前方に移動 |
| `Ctrl-t + }` | ペインを後方に移動 |

### ペイン同期

| キー | 動作 |
|------|------|
| `Ctrl-t + e` | 全ペインの同期ON（小文字） |
| `Ctrl-t + E` | 全ペインの同期OFF（大文字） |

複数サーバーに同じコマンドを実行する際に便利です。

### コピーモード

| キー | 動作 |
|------|------|
| `Ctrl-t + [` | コピーモード開始 |
| `v` | 選択開始（Viモード） |
| `y` | コピーしてクリップボードへ |
| `Ctrl-v` | 矩形選択 |
| `q` または `Esc` | コピーモード終了 |
| `Ctrl-t + ]` | 貼り付け |

### セッション管理（tmux-resurrect）

| キー | 動作 |
|------|------|
| `Ctrl-t + Ctrl-s` | セッション保存 |
| `Ctrl-t + Ctrl-r` | セッション復元 |

tmux-continuumにより、15分ごとに自動保存されます。

### プラグイン管理（TPM）

| キー | 動作 |
|------|------|
| `Ctrl-t + I` | プラグインインストール（大文字I） |
| `Ctrl-t + U` | プラグイン更新（大文字U） |
| `Ctrl-t + Alt-u` | プラグイン削除 |

## 設定のカスタマイズ

### カラースキームの変更

Tokyo Night以外のテーマを使いたい場合：

1. `.tmux.conf`から`tokyo-night-tmux`プラグインを削除
2. 別のテーマプラグインを追加:
   ```conf
   # Catppuccin
   set -g @plugin 'catppuccin/tmux'

   # Dracula
   set -g @plugin 'dracula/tmux'

   # Nord
   set -g @plugin 'arcticicestudio/nord-tmux'
   ```

### ステータスバーのカスタマイズ

Tokyo Nightテーマの設定変更：
```conf
set -g @tokyo-night-tmux_show_datetime 1
set -g @tokyo-night-tmux_show_path 1
set -g @tokyo-night-tmux_path_format relative
set -g @tokyo-night-tmux_show_git 1
```

## よくある使用例

### 新規セッション作成
```bash
tmux new -s myproject
```

### セッション一覧
```bash
tmux ls
```

### セッションへアタッチ
```bash
tmux attach -t myproject
```

### セッションから離脱（デタッチ）
```
Ctrl-t + d
```

### セッション削除
```bash
tmux kill-session -t myproject
```

### すべてのセッション削除
```bash
tmux kill-server
```

## トラブルシューティング

### カラーが正しく表示されない
`.zshrc`または`.bashrc`に以下を追加:
```bash
export TERM=screen-256color
```

### クリップボード連携が動かない

**macOS**: pbcopy/pbpasteは標準で利用可能

**Linux**: xclipまたはxselをインストール:
```bash
sudo apt install xclip  # Ubuntu/Debian
sudo pacman -S xclip    # Arch
```

### プラグインがインストールされない

1. TPMが正しくインストールされているか確認:
   ```bash
   ls ~/.tmux/plugins/tpm
   ```

2. tmuxを再起動
3. `Ctrl-t + I`でプラグインをインストール

### セッションが復元されない

tmux-resurrectの保存場所を確認:
```bash
ls ~/.tmux/resurrect/
```

## チートシート

簡単なリファレンス:
```
プレフィックス: Ctrl-t

ウィンドウ:
  c    新規作成
  n/p  次/前
  数字  移動

ペイン:
  |    水平分割
  -    垂直分割
  矢印  移動(Alt+矢印)
  x    閉じる
  z    ズーム

その他:
  [    コピーモード
  d    デタッチ
  ?    ヘルプ
```

## 参考リンク

- [Tmux公式ドキュメント](https://github.com/tmux/tmux/wiki)
- [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm)
- [Tokyo Night Tmux](https://github.com/janoamaral/tokyo-night-tmux)