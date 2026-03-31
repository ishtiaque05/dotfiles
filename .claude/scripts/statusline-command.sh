#!/usr/bin/env bash
# claude-statusline — developer-focused status bar for Claude Code
# Displays model, git, context usage, session cost, and rate limit info.
# Adapts layout to terminal width: compact (<60), standard (<90), full (90+).

set -o pipefail

# ── Parse stdin JSON (must happen before any subshell consumes it) ──────────

input=$(cat)

eval "$(echo "$input" | jq -r '
  "cdir=" + (.workspace.current_dir // .cwd // "." | @sh) + "\n" +
  "model=" + (.model.display_name // "unknown" | @sh) + "\n" +
  "cc_ver=" + (.version // "" | @sh) + "\n" +
  "dur_ms=" + (.cost.total_duration_ms // 0 | tostring) + "\n" +
  "ctx_size=" + (.context_window.context_window_size // 200000 | tostring) + "\n" +
  "ctx_pct=" + (.context_window.used_percentage // 0 | tostring) + "\n" +
  "tok_in=" + (.context_window.total_input_tokens // 0 | tostring) + "\n" +
  "tok_out=" + (.context_window.total_output_tokens // 0 | tostring)
' 2>/dev/null)"

ctx_pct=${ctx_pct:-0}
tok_in=${tok_in:-0}
tok_out=${tok_out:-0}

# ── Colors ──────────────────────────────────────────────────────────────────

RST='\033[0m'

# Foreground palette — warm/muted tones
C_MODEL='\033[38;2;250;204;21m'      # Gold — model name
C_DIR='\033[38;2;148;163;184m'       # Slate — directory
C_BRANCH='\033[38;2;45;212;191m'     # Teal — branch
C_SYNC='\033[38;2;251;146;60m'       # Orange — ahead/behind
C_SEP='\033[38;2;71;85;105m'         # Dark slate — separators
C_LABEL='\033[38;2;100;116;139m'     # Muted — labels
C_VAL='\033[38;2;203;213;225m'       # Light — values
C_COST='\033[38;2;192;132;252m'      # Lavender — cost
C_OK='\033[38;2;74;222;128m'         # Green — healthy
C_WARN='\033[38;2;251;191;36m'       # Amber — caution
C_CRIT='\033[38;2;251;113;133m'      # Rose — danger
C_BAR_EMPTY='\033[38;2;55;65;81m'    # Dim — empty bar segments

# Color by percentage threshold
pct_color() {
  local v=${1%%.*}; [ -z "$v" ] && v=0
  if   [ "$v" -ge 80 ]; then echo "$C_CRIT"
  elif [ "$v" -ge 55 ]; then echo "$C_WARN"
  else echo "$C_OK"
  fi
}

# Gradient for bar bucket at position $1 of $2
bar_color() {
  local pos=$1 max=$2 pct=$((pos * 100 / max)) r g b
  if [ "$pct" -le 40 ]; then
    r=$((74  + (250 - 74)  * pct / 40))
    g=$((222 + (204 - 222) * pct / 40))
    b=$((128 + (21  - 128) * pct / 40))
  elif [ "$pct" -le 75 ]; then
    local t=$((pct - 40))
    r=$((250 + (251 - 250) * t / 35))
    g=$((204 + (146 - 204) * t / 35))
    b=$((21  + (60  - 21)  * t / 35))
  else
    local t=$((pct - 75))
    r=$((251 + (239 - 251) * t / 25))
    g=$((146 + (68  - 146) * t / 25))
    b=$((60  + (68  - 60)  * t / 25))
  fi
  printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b"
}

# ── Terminal width ──────────────────────────────────────────────────────────
# Claude Code hooks don't inherit terminal dimensions, so try multiple methods.

_w_cache="/tmp/claude-termw-${KITTY_WINDOW_ID:-default}"

detect_width() {
  local w=""
  # Kitty IPC (most accurate when using Kitty terminal with splits/tabs)
  if [ -n "${KITTY_WINDOW_ID:-}" ] && command -v kitten >/dev/null 2>&1; then
    w=$(kitten @ ls 2>/dev/null | jq -r --argjson wid "$KITTY_WINDOW_ID" \
      '.[].tabs[].windows[] | select(.id == $wid) | .columns' 2>/dev/null)
  fi
  # Direct TTY query
  [ -z "$w" ] || [ "$w" = "0" ] || [ "$w" = "null" ] && \
    w=$(stty size </dev/tty 2>/dev/null | awk '{print $2}')
  # tput
  [ -z "$w" ] || [ "$w" = "0" ] && w=$(tput cols 2>/dev/null)
  # Cache successful result
  if [ -n "$w" ] && [ "$w" -gt 0 ] 2>/dev/null; then
    echo "$w" > "$_w_cache" 2>/dev/null; echo "$w"; return
  fi
  # Read previous cache
  [ -f "$_w_cache" ] && { cat "$_w_cache" 2>/dev/null; return; }
  echo "${COLUMNS:-80}"
}

tw=$(detect_width)

# Layout mode
if   [ "$tw" -lt 60 ]; then layout="compact"
elif [ "$tw" -lt 90 ]; then layout="standard"
else layout="full"
fi

# ── Parallel data fetch ─────────────────────────────────────────────────────
# Launch expensive operations concurrently, collect via temp files.

_tmp="/tmp/claude-sl-$$"
mkdir -p "$_tmp"

# Cross-platform file mtime (seconds since epoch)
_mtime() { stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null || echo 0; }

# 1. Git info (index-only — no working tree scan)
{
  if git -C "$cdir" rev-parse --git-dir >/dev/null 2>&1; then
    _br=$(git -C "$cdir" --no-optional-locks branch --show-current 2>/dev/null)
    [ -z "$_br" ] && _br="detached"
    _sync=$(git -C "$cdir" rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    _ah=$(echo "$_sync" | awk '{print $1}'); _ah=${_ah:-0}
    _bh=$(echo "$_sync" | awk '{print $2}'); _bh=${_bh:-0}
    _stash=$(git -C "$cdir" stash list 2>/dev/null | wc -l | tr -d ' ')
    _epoch=$(git -C "$cdir" log -1 --format='%ct' 2>/dev/null)
    cat > "$_tmp/git" <<EOF
g_repo=true
g_branch='$_br'
g_ahead=${_ah:-0}
g_behind=${_bh:-0}
g_stash=${_stash:-0}
g_epoch=${_epoch:-0}
EOF
  else
    echo "g_repo=false" > "$_tmp/git"
  fi
} &

# 2. Usage rate limits (Anthropic OAuth API)
{
  _ucache="$HOME/.claude/.usage-cache.json"
  _uage=999999
  [ -f "$_ucache" ] && _uage=$(($(date +%s) - $(_mtime "$_ucache")))

  if [ "$_uage" -gt 60 ]; then
    _tok=""
    if [ "$(uname -s)" = "Darwin" ]; then
      _cred=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    else
      _cred=$(cat "$HOME/.claude/.credentials.json" 2>/dev/null)
    fi
    _tok=$(echo "$_cred" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('claudeAiOauth',{}).get('accessToken',''))" 2>/dev/null)

    if [ -n "$_tok" ]; then
      _uj=$(curl -s --max-time 3 \
        -H "Authorization: Bearer $_tok" \
        -H "Content-Type: application/json" \
        -H "anthropic-beta: oauth-2025-04-20" \
        "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
      if [ -n "$_uj" ] && echo "$_uj" | jq -e '.five_hour' >/dev/null 2>&1; then
        echo "$_uj" | jq '.' > "$_ucache" 2>/dev/null
      fi
    fi
  fi

  if [ -f "$_ucache" ]; then
    jq -r '
      "u5=" + (.five_hour.utilization // 0 | tostring) + "\n" +
      "u7=" + (.seven_day.utilization // 0 | tostring) + "\n" +
      "u5_reset=" + (.five_hour.resets_at // "" | @sh) + "\n" +
      "u7_reset=" + (.seven_day.resets_at // "" | @sh)
    ' "$_ucache" > "$_tmp/usage" 2>/dev/null
  else
    printf "u5=0\nu7=0\n" > "$_tmp/usage"
  fi
} &

wait

# Source results
[ -f "$_tmp/git" ]   && source "$_tmp/git"
[ -f "$_tmp/usage" ] && source "$_tmp/usage"
rm -rf "$_tmp" 2>/dev/null

# ── Derived values ──────────────────────────────────────────────────────────

dir_name=$(basename "$cdir" 2>/dev/null || echo ".")

# Session cost from token counts
cost_str=""
if [ "$tok_in" -gt 0 ] || [ "$tok_out" -gt 0 ]; then
  case "$model" in
    *"Opus 4"*|*"opus-4"*)   _ci="15.00"; _co="75.00" ;;
    *"Sonnet 4"*)             _ci="3.00";  _co="15.00" ;;
    *"Haiku 4"*|*"haiku-4"*) _ci="0.80";  _co="4.00"  ;;
    *)                        _ci="3.00";  _co="15.00" ;;
  esac
  cost_str=$(python3 -c "
c = ($tok_in * $_ci + $tok_out * $_co) / 1_000_000
print(f'\${c:.4f}' if c < 0.01 else f'\${c:.3f}' if c < 1 else f'\${c:.2f}')
" 2>/dev/null)
fi

# Session duration
_ds=$((dur_ms / 1000))
if   [ "$_ds" -ge 3600 ]; then dur_str="$((_ds/3600))h$((_ds%3600/60))m"
elif [ "$_ds" -ge 60 ];   then dur_str="$((_ds/60))m$((_ds%60))s"
else dur_str="${_ds}s"
fi

# Git age display
age_str=""
if [ "${g_repo:-false}" = "true" ] && [ "${g_epoch:-0}" -gt 0 ]; then
  _as=$(( $(date +%s) - g_epoch ))
  _am=$((_as / 60)); _ah=$((_as / 3600)); _ad=$((_as / 86400))
  if   [ "$_am" -lt 1 ];  then age_str="now"
  elif [ "$_ah" -lt 1 ];  then age_str="${_am}m"
  elif [ "$_ad" -lt 1 ];  then age_str="${_ah}h"
  else age_str="${_ad}d"
  fi
fi

# Git sync arrows
sync_str=""
[ "${g_ahead:-0}" -gt 0 ]  && sync_str="↑${g_ahead}"
[ "${g_behind:-0}" -gt 0 ] && sync_str="${sync_str}↓${g_behind}"

# Usage reset countdown
reset_5h=""; reset_7d=""
if [ -n "${u5_reset:-}" ] || [ -n "${u7_reset:-}" ]; then
  eval "$(python3 -c "
from datetime import datetime, timezone
def until(ts):
    if not ts: return '—'
    try:
        from datetime import datetime
        if '+' in ts[10:]:
            dt = datetime.fromisoformat(ts)
        elif ts.endswith('Z'):
            dt = datetime.fromisoformat(ts.replace('Z', '+00:00'))
        else:
            dt = datetime.fromisoformat(ts + '+00:00')
        d = int((dt - datetime.now(timezone.utc)).total_seconds())
        if d <= 0: return 'now'
        h, m = d // 3600, (d % 3600) // 60
        if h >= 24:
            days, rh = h // 24, h % 24
            return f'{days}d{rh}h' if rh else f'{days}d'
        return f'{h}h{m}m' if h else f'{m}m'
    except: return '—'
print(f\"reset_5h='{until(${u5_reset:-''})}'\" )
print(f\"reset_7d='{until(${u7_reset:-''})}'\" )
" 2>/dev/null)"
fi

# ── Context bar renderer ────────────────────────────────────────────────────

render_bar() {
  local width=$1 pct=$2 out=""
  local filled=$((pct * width / 100))
  [ "$filled" -lt 0 ] && filled=0
  for i in $(seq 1 "$width"); do
    if [ "$i" -le "$filled" ]; then
      out="${out}$(bar_color "$i" "$width")━${RST}"
    else
      out="${out}${C_BAR_EMPTY}━${RST}"
    fi
  done
  echo "$out"
}

# ── Output ──────────────────────────────────────────────────────────────────

raw_pct=${ctx_pct%%.*}; [ -z "$raw_pct" ] && raw_pct=0
pc=$(pct_color "$raw_pct")

# Determine bar width based on layout
case "$layout" in
  compact)  bw=20 ;;
  standard) bw=30 ;;
  full)     bw=40 ;;
esac

bar=$(render_bar "$bw" "$raw_pct")

# ── Line 1: Model │ Dir │ Git ───────────────────────────────────────────────

printf "${C_MODEL}${model}${RST}"
printf " ${C_SEP}│${RST} ${C_DIR}${dir_name}${RST}"

if [ "${g_repo:-false}" = "true" ]; then
  printf " ${C_BRANCH}${g_branch}${RST}"
  [ -n "$sync_str" ] && printf " ${C_SYNC}${sync_str}${RST}"
  if [ "$layout" != "compact" ]; then
    [ -n "$age_str" ] && printf " ${C_LABEL}${age_str}${RST}"
    [ "${g_stash:-0}" -gt 0 ] && printf " ${C_LABEL}stash:${C_VAL}${g_stash}${RST}"
  fi
fi

printf "\n"

# ── Line 2: Context bar ────────────────────────────────────────────────────

printf "${bar} ${pc}${raw_pct}%%${RST}"

if [ "$layout" != "compact" ]; then
  printf " ${C_SEP}│${RST} ${C_LABEL}${dur_str}${RST}"
  [ -n "$cost_str" ] && printf " ${C_SEP}│${RST} ${C_COST}${cost_str}${RST}"
fi

printf "\n"

# ── Line 3: Usage limits (only if data exists) ─────────────────────────────

u5_int=${u5%%.*}; u5_int=${u5_int:-0}
u7_int=${u7%%.*}; u7_int=${u7_int:-0}

if [ "$u5_int" -gt 0 ] || [ "$u7_int" -gt 0 ] || [ -f "$HOME/.claude/.usage-cache.json" ]; then
  u5c=$(pct_color "$u5_int")
  u7c=$(pct_color "$u7_int")

  case "$layout" in
    compact)
      printf "${C_LABEL}5h:${RST}${u5c}${u5_int}%%${RST} ${C_LABEL}wk:${RST}${u7c}${u7_int}%%${RST}"
      [ -n "$cost_str" ] && printf " ${C_COST}${cost_str}${RST}"
      ;;
    standard)
      printf "${C_LABEL}5h:${RST} ${u5c}${u5_int}%%${RST} ${C_LABEL}↻${reset_5h}${RST}"
      printf " ${C_SEP}│${RST} ${C_LABEL}wk:${RST} ${u7c}${u7_int}%%${RST} ${C_LABEL}↻${reset_7d}${RST}"
      ;;
    full)
      printf "${C_LABEL}5h:${RST} ${u5c}${u5_int}%%${RST} ${C_LABEL}↻${reset_5h}${RST}"
      printf " ${C_SEP}│${RST} ${C_LABEL}wk:${RST} ${u7c}${u7_int}%%${RST} ${C_LABEL}↻${reset_7d}${RST}"
      [ -n "${cc_ver}" ] && printf " ${C_SEP}│${RST} ${C_LABEL}cc:${C_VAL}${cc_ver}${RST}"
      ;;
  esac
  printf "\n"
fi
