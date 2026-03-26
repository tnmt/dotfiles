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
| `pacman` | pacman パッケージ名 (Arch Linux) | (省略で pacman なし) |
| `portage` | Gentoo portage atom (`category/package`) | (省略で portage なし) |
| `portage_keywords` | Gentoo accept_keywords (例: `~amd64`) | (省略で stable のみ) |
| `tap` | Homebrew tap (例: `k1LoW/tap`) | (省略で tap なし) |
| `mode` | `base` / `development` / `desktop` | 必須 |
| `darwin_only` | `true` で macOS のみ brew インストール | `false` |

OS の振り分けは自動:
- macOS: `brew` が定義されているパッケージを brew でインストール
- Linux (Arch): `pacman` があれば pacman/paru でインストール（Linuxbrew 不使用）
- Linux (Gentoo): `portage` があれば emerge でインストール（Linuxbrew 不使用）
- Linux (Ubuntu 等): `apt` があれば apt を優先、`apt` がなければ brew を利用
- Linux + `darwin_only=true`: brew でもインストールしない

### パッケージ追加の手順

1. `dot_config/packages/package-mapping.toml` にエントリを追加
2. `chezmoi apply` で Brewfile / apt リストが自動再生成される
3. 生成結果を確認（例: `~/.config/packages/brewfile`）
4. 必要に応じて `brew bundle --file=~/.config/packages/brewfile` / apt で適用

### 運用メモ

- `brew` は明示定義を推奨（現行テンプレートは `brew` キーがある項目のみ Brewfile に出力）
- 現在の方針は基本的に最新追従（バージョン固定は未導入）
- Homebrew / mise / paru 本体の導入は `package-mapping.toml` 管理外で、セットアップスクリプト側で実行
- 通常パッケージの導入元は `package-mapping.toml` を正とし、`run_once_*` 側で重複インストールを増やさない

### 責務ルール

- `package-mapping.toml` は通常パッケージの唯一の宣言元
- `run_once_01-install-packages.sh.tmpl` は bootstrap と apt/pacman/portage sync に限定
- `run_onchange_03-brew-bundle.sh.tmpl` は Brewfile 変更時の brew sync を担当
- `run_once_05-*` 以降は post-install のみとし、通常パッケージ導入を足さない
- 例外は Homebrew, paru, mise, 1Password apt repo のような bootstrap 処理
- `run_once_02-install-starship.sh` と `run_once_07-install-claude-cli.sh.tmpl` は upstream installer を使う外部ツール例外
- `run_once_04-install-fonts.sh.tmpl` は Ubuntu 系などで manifest だけでは足りない upstream font asset の manual fallback

### よくあるパターン

```toml
# macOS は brew、Linux は apt/pacman/portage (最も一般的)
[パッケージ名]
brew = "brew名"
apt = "apt名"
pacman = "pacman名"
portage = "category/package名"
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

# pacman のみ・Arch 限定
[パッケージ名]
pacman = "pacman名"
mode = "development"

# portage のみ・Gentoo 限定
[パッケージ名]
portage = "category/package名"
mode = "development"
```

### 自動生成されるファイル

- `dot_config/packages/brewfile.tmpl` → `~/.config/packages/brewfile`
- `run_once_01-install-packages.sh.tmpl` 内の apt / pacman / portage install リスト

## セットアップモード

| desktop | development | 用途 |
|---------|-------------|------|
| true | true | フルデスクトップ開発環境 |
| true | false | 軽量デスクトップ |
| false | true | 開発サーバー (headless) |
| false | false | 最小サーバー |

## スクリプト実行順序

数値プレフィックスで制御:
- `run_once_00-setup-1password-apt.sh.tmpl` - 1Password apt リポジトリセットアップ (Ubuntu のみ、Arch ではスキップ)
- `run_once_01-install-packages.sh.tmpl` - パッケージインストール (Arch: paru 自動導入 → pacman/paru、Gentoo: emerge、Ubuntu: apt + Linuxbrew)
- `run_once_02-install-starship.sh` - Starship インストール
- `run_onchange_03-brew-bundle.sh.tmpl` - Brewfile 変更時に brew bundle 実行
- `run_once_04-install-fonts.sh.tmpl` - フォントインストール
- `run_once_05-setup-tmux.sh.tmpl` - tmux post-install セットアップ (TPM 導入など)
- `run_once_06-setup-nvim.sh.tmpl` - Neovim post-install セットアップ (provider / formatter など)
- `run_once_07-install-claude-cli.sh.tmpl` - Claude CLI インストール
- `run_once_08-update-completions.sh` - 補完ファイル更新
- `run_onchange_99-install-bat-theme.sh` - bat テーマインストール
