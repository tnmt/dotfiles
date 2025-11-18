# Alacritty Configuration

This is the Alacritty terminal emulator configuration.

## Features

- **Color Scheme**: Tokyo Night Storm (default)
- **Font**: MesloLGS Nerd Font with dynamic sizing based on OS
- **Transparency**: 95% opacity with background blur
- **Performance**: Hardware acceleration enabled by default
- **Scrollback**: 100,000 lines of history

## Configuration Structure

```
~/.config/alacritty/
├── alacritty.toml      # Main configuration (generated from template)
├── themes/             # Additional color schemes
│   ├── tokyonight.toml
│   ├── catppuccin-mocha.toml
│   └── gruvbox-dark.toml
└── README.md
```

## Installation

1. Install Alacritty:
   ```bash
   # macOS
   brew install --cask alacritty
   
   # Linux (Ubuntu/Debian)
   sudo apt install alacritty
   
   # Linux (Arch)
   sudo pacman -S alacritty
   ```

2. Install fonts:
   ```bash
   bash ~/.local/share/chezmoi/run_once_install-fonts.sh
   ```

3. Apply configuration:
   ```bash
   chezmoi apply
   ```

## Key Bindings

- `Ctrl+Shift+N` - Spawn new Alacritty instance
- `Ctrl+Shift+C` - Copy to clipboard
- `Ctrl+Shift+V` - Paste from clipboard
- `Ctrl+Plus` - Increase font size
- `Ctrl+Minus` - Decrease font size
- `Ctrl+0` - Reset font size
- `Ctrl+Shift+U` - Open URL hints

## Color Schemes

The configuration includes several popular color schemes:

### Tokyo Night (default)
A clean, dark theme with good contrast and vibrant colors.

### Catppuccin Mocha
A soothing pastel theme with warm colors.

### Gruvbox Dark
A retro groove color scheme with earthy tones.

To switch color schemes, you can either:
1. Import a theme file in your alacritty.toml:
   ```toml
   import = ["~/.config/alacritty/themes/catppuccin-mocha.toml"]
   ```

2. Or replace the colors section in alacritty.toml with the contents from a theme file.

## Font Configuration

The configuration uses MesloLGS Nerd Font by default, which includes:
- Powerline symbols (for shell prompts)
- Nerd Font icons (for file managers and status lines)
- Ligature support

Font size is automatically adjusted based on the operating system:
- macOS: 16pt
- Linux: 12pt

## Customization

### Opacity
Adjust window transparency:
```toml
[window]
opacity = 0.95  # 0.0 (transparent) to 1.0 (opaque)
```

### Padding
Adjust internal padding:
```toml
[window.padding]
x = 5
y = 5
```

### Scrollback
Change history buffer size:
```toml
[scrolling]
history = 100000  # Number of lines
```

## Troubleshooting

### Font not displaying correctly
1. Ensure fonts are installed: `fc-list | grep -i meslo`
2. Restart Alacritty after font installation
3. Check font name matches exactly in configuration

### Performance issues
1. Ensure GPU drivers are up to date
2. Try disabling transparency: `opacity = 1.0`
3. Check `alacritty -vv` for warnings

### Colors look different
1. Check your terminal's color profile settings
2. Ensure `TERM=xterm-256color` is set
3. Some themes may require true color support

## Tips

1. **URL Opening**: Hold Ctrl+Shift+U to highlight URLs, then click to open
2. **Selection**: Triple-click to select entire line
3. **Search**: Use `Ctrl+Shift+F` for search mode (if configured)
4. **Vi Mode**: Enable with `Ctrl+Shift+Space` for vim-like navigation

## Migration from Other Terminals

### From iTerm2
- Import your color scheme to one of the theme files
- Adjust font size as needed
- Most keybindings will need to be reconfigured

### From Kitty
- Similar configuration structure (TOML)
- Most settings have direct equivalents
- Graphics protocol not supported

### From Terminal.app/GNOME Terminal
- Significantly more customization options available
- Better performance with large scrollback
- Hardware acceleration provides smoother scrolling
