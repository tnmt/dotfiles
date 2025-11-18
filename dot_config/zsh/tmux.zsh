# Tmux configuration for zsh

# Aliases
alias tmux='tmux -2'  # Force 256 color support
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# Auto-start tmux on terminal launch (optional - uncomment to enable)
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s main
# fi

# Function to create a new tmux session with a name based on current directory
tnew() {
    local session_name="${1:-$(basename $(pwd))}"
    tmux new-session -s "$session_name"
}

# Function to attach or create session
tattach() {
    local session_name="${1:-$(basename $(pwd))}"
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -s "$session_name"
    fi
}
