#!/usr/bin/env bash
# Antigravity CLI statusline: TokyoNight Glass HUD (quota-free)
# Dependencies: bash >= 4, jq, git (optional)

set -uo pipefail

payload=$(cat)
[[ -n ${payload//[[:space:]]/} ]] || exit 0

# Disable color when output is not a terminal-like consumer or NO_COLOR is set.
if [[ -n ${NO_COLOR:-} ]]; then
  RST=''; BOLD=''; NOBOLD=''; CARD=''; DARK=''; BASE=''; WHITE=''; MUTED=''; TRACK=''; CYAN=''; SKY=''; MINT=''; GREEN=''; AMBER=''; ORANGE=''; RED=''; VIOLET=''; GOLD=''; BG_MINT=''; BG_CYAN=''; BG_AMBER=''; BG_VIOLET=''; BG_RED=''; BG_SLATE=''
else
  ESC=$'\033'
  RST="${ESC}[0m"; BOLD="${ESC}[1m"; NOBOLD="${ESC}[22m"
CARD="${ESC}[48;5;236m"; DARK="${ESC}[38;5;232m"
BASE="${ESC}[38;5;252m"; WHITE="${ESC}[38;5;255m"; MUTED="${ESC}[38;5;244m"; TRACK="${ESC}[38;5;240m"
CYAN="${ESC}[38;5;45m"; SKY="${ESC}[38;5;117m"; MINT="${ESC}[38;5;49m"; GREEN="${ESC}[38;5;78m"
AMBER="${ESC}[38;5;214m"; ORANGE="${ESC}[38;5;208m"; RED="${ESC}[38;5;203m"; VIOLET="${ESC}[38;5;141m"; GOLD="${ESC}[38;5;221m"
BG_MINT="${ESC}[48;5;49m"; BG_CYAN="${ESC}[48;5;45m"; BG_AMBER="${ESC}[48;5;214m"; BG_VIOLET="${ESC}[48;5;141m"; BG_RED="${ESC}[48;5;203m"; BG_SLATE="${ESC}[48;5;243m"
fi

card() { printf '%s%s▌%s %s %s' "$CARD" "$1" "$BASE" "$2" "$RST"; }
pill() { printf '%s%s%s  %s  %s' "$1" "$DARK" "$BOLD" "$2" "$RST"; }
join_card() { [[ -n $2 ]] && printf -v "$1" '%s %s' "${!1}" "$2"; }
repeat_char() { local out='' i; for ((i=0;i<$2;i++)); do out+=$1; done; printf '%s' "$out"; }

fmt_duration() {
  local s=${1:-0}; [[ $s =~ ^-?[0-9]+$ ]] || { printf '?'; return; }
  ((s<=0)) && { printf 'now'; return; }
  local d=$((s/86400)) h=$((s%86400/3600)) m=$((s%3600/60))
  ((d)) && { printf '%dd' "$d"; ((h)) && printf '%dh' "$h"; return; }
  ((h)) && { printf '%dh' "$h"; ((m)) && printf '%dm' "$m"; return; }
  ((m)) && printf '%dm' "$m" || printf '%ds' "$s"
}

fmt_path() {
  local p=${1:-} max=${2:-28} base parent
  [[ -n $p ]] || return
  [[ -n ${HOME:-} && $p == "$HOME"* ]] && p="~${p#$HOME}"
  ((${#p}<=max)) && { printf '%s' "$p"; return; }
  base=${p##*/}; parent=${p%/*}; parent=${parent##*/}; p="…/$parent/$base"
  ((${#p}>max)) && p="…/$base"
  ((${#p}>max)) && p="…${base: -$((max-1))}"
  printf '%s' "$p"
}

track() {
  local spec=${1:-0:0} width=${2:-8} color=$3
  local filled=${spec%%:*} half=${spec##*:}
  [[ $filled =~ ^[0-9]+$ ]] || filled=0; [[ $half =~ ^[01]$ ]] || half=0
  ((filled>width)) && filled=$width; ((filled+half>width)) && half=0
  local empty=$((width-filled-half))
  printf '%s%s' "$color" "$(repeat_char '━' "$filled")"
  ((half)) && printf '╸'
  printf '%s%s%s' "$TRACK" "$(repeat_char '─' "$empty")" "$BASE"
}

if ! command -v jq >/dev/null 2>&1; then
  printf '%s %s\n' "$(pill "$BG_RED" '✗ AGY')" "$(card "$RED" 'jq is required')"; exit 0
fi

# TSV avoids the fragile positional array used by the previous version.
mapfile -t base_fields < <(jq -r '
  def clean: tostring|gsub("[\\r\\n\\t]+";" ");
  def tok: if type!="number" or .<=0 then "0" elif .>=1000000 then "\(((./100000)|round)/10)M" elif .>=10000 then "\((./1000)|round)k" elif .>=1000 then "\(((./100)|round)/10)k" else "\(.|round)" end;
  def cells($w): (if type!="number" then 0 else ([0,.,100]|sort|.[1]) end) as $p | (($p*$w/100)|floor) as $f | "\($f):\(if ($p*$w/100-$f)>=0.35 and $f<$w then 1 else 0 end)";
  [(.model.display_name//.model.id//"No Model"|clean|sub("\\s*\\((low|medium|high|max)\\)\\s*$";"";"i")),(.model.effort//""|clean),((.agent.display_name // .agent.name // .agent.id // .selected_agent.display_name // .selected_agent.name // .selected_agent.id // .agent_name // .agent_id // "") | clean),(.workspace.current_dir//.cwd//""|clean),(.workspace.project_dir//""|clean),(.agent_state//"idle"|clean),(.cycle_mode//""|clean),(.vim.mode//""|clean),(.sandbox.enabled//false|tostring),(.plan_tier//""|clean),(.context_window.used_percentage//0|if type=="number" then round else 0 end),(.context_window.used_percentage//0|cells(10)),(.context_window.used_percentage//0|cells(6)),((((.context_window.used_percentage//0)/100)*(.context_window.context_window_size//0))|tok),(.context_window.context_window_size//0|tok),(.context_window.current_usage.cache_read_input_tokens//0|tok),(.exceeds_200k_tokens//false|tostring),(.cost.total_usd//0|if type=="number" and .>0 then (. * 100 | round / 100 | tostring) else "" end),(.cost.estimated//false|tostring),(.task_count//0|tostring),(.artifact_count//0|tostring),(.terminal_width//120|tostring)]|.[]
' <<<"$payload" 2>/dev/null)
((${#base_fields[@]} == 22)) || exit 0
model=${base_fields[0]}; effort=${base_fields[1]}; agent=${base_fields[2]}; cwd=${base_fields[3]}; project=${base_fields[4]}; state=${base_fields[5]}; cycle=${base_fields[6]}; vim=${base_fields[7]}; sandbox=${base_fields[8]}; plan=${base_fields[9]}; pct=${base_fields[10]}; cells10=${base_fields[11]}; cells6=${base_fields[12]}; used_tok=${base_fields[13]}; ctx_size=${base_fields[14]}; cache_tok=${base_fields[15]}; over200=${base_fields[16]}; cost=${base_fields[17]}; estimated=${base_fields[18]}; tasks=${base_fields[19]}; artifacts=${base_fields[20]}; width=${base_fields[21]}
[[ $width =~ ^[0-9]+$ ]] || width=120
narrow=0; ((width<88)) && narrow=1

mode=${cycle^^}; [[ -n $mode && $mode != DEFAULT ]] || mode=READY
case $state in
  working) hdr=$(pill "$BG_CYAN" "󰚩 $mode");; tool_use) hdr=$(pill "$BG_AMBER" '󰒓 TOOL');;
  reviewing) hdr=$(pill "$BG_VIOLET" '󰈈 REVIEW');; error) hdr=$(pill "$BG_RED" '󰅚 ERROR');;
  authenticating|initializing) hdr=$(pill "$BG_SLATE" '󰔟 INIT');;
  *) [[ ${cycle,,} == plan ]] && hdr=$(pill "$BG_VIOLET" '󰏫 PLAN') || hdr=$(pill "$BG_MINT" "󰄬 $mode");;
esac

body="${VIOLET}󰧑 ${BOLD}${WHITE}${model}${NOBOLD}"
[[ -n $effort ]] && body+="${MUTED} · ${CYAN}${effort,,}"
((!narrow)) && [[ -n $plan ]] && body+="${MUTED} · ${GOLD}${plan}"
[[ -n $vim ]] && body+="${MUTED} · ${SKY}${vim:0:3}"
[[ $sandbox == true ]] && body+="${MUTED} · ${AMBER}sandbox"
line1="$hdr $(card "$CYAN" "$body")"
[[ -n $agent ]] && join_card line1 "$(card "$VIOLET" "${VIOLET}󰀄 ${BOLD}${WHITE}${agent}${NOBOLD}")"

loc=$cwd; [[ -n $loc ]] || loc=$project
[[ -n $loc ]] && join_card line1 "$(card "$SKY" "${SKY}󰉋 $(fmt_path "$loc" "$((narrow?16:28))")")"

# Cached non-blocking git status: agy StatusLineRunner kills commands after 5s,
# whereas git status on WSL /mnt/* (9P DrvFs) can take 8-10s+.
git_root=$loc
git_card=''
repo_root=''
if [[ -n $git_root && -d $git_root ]]; then
  d=${git_root%/}
  while [[ -n $d ]]; do
    if [[ -e "$d/.git" ]]; then repo_root=$d; break; fi
    [[ $d == */* ]] || break
    d=${d%/*}
  done
fi

if [[ -n $repo_root ]]; then
  cache_dir="/tmp/agy-statusline-git-${UID:-0}"
  mkdir -p -m 700 "$cache_dir" 2>/dev/null || true
  ckey=$(sha1sum <<<"$repo_root")
  ckey=${ckey%% *}
  cfile="$cache_dir/$ckey.porcelain"
  lfile="$cache_dir/$ckey.lock"
  [[ $repo_root == /mnt/* ]] && git_ttl=15 || git_ttl=3

  gout=''
  need_refresh=0
  if [[ -r $cfile ]]; then
    gout=$(<"$cfile")
    mtime=$(stat -c %Y "$cfile" 2>/dev/null || printf '0')
    (( EPOCHSECONDS - mtime >= git_ttl )) && need_refresh=1
  elif [[ $repo_root != /mnt/* ]] && command -v git >/dev/null 2>&1 && gout=$(timeout 0.5s git -C "$repo_root" --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null); then
    printf '%s\n' "$gout" >"$cfile.$$" 2>/dev/null && mv -f "$cfile.$$" "$cfile" 2>/dev/null || rm -f "$cfile.$$" 2>/dev/null
  else
    gout=''
    need_refresh=1
  fi

  if (( need_refresh )) && command -v git >/dev/null 2>&1; then
    (
      flock -n 9 || exit 0
      tmp="$cfile.tmp.$$"
      if out=$(timeout 25s git -C "$repo_root" --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null); then
        printf '%s\n' "$out" >"$tmp" && mv -f "$tmp" "$cfile"
      fi
      rm -f "$tmp"
    ) 9>"$lfile" </dev/null >/dev/null 2>&1 &
  fi

  branch=''; oid=''; cold_head=0
  if [[ -n $gout ]]; then
    while IFS= read -r l; do
      case $l in
        '# branch.head '*) branch=${l#\# branch.head };;
        '# branch.oid '*) oid=${l#\# branch.oid };;
      esac
      [[ -n $branch && -n $oid ]] && break
    done <<<"$gout"
    [[ $branch == '(detached)' ]] && branch="@${oid:0:7}"
  else
    cold_head=1
    git_dir="$repo_root/.git"
    if [[ -f $git_dir && -r $git_dir ]]; then
      IFS= read -r gd_line <"$git_dir" || gd_line=''
      if [[ $gd_line == 'gitdir: '* ]]; then
        gd_path=${gd_line#gitdir: }
        [[ $gd_path == /* ]] && git_dir=$gd_path || git_dir="$repo_root/$gd_path"
      fi
    fi
    if [[ -r "$git_dir/HEAD" ]]; then
      IFS= read -r head_ref <"$git_dir/HEAD" || head_ref=''
      if [[ $head_ref == 'ref: refs/heads/'* ]]; then branch=${head_ref#ref: refs/heads/}
      elif [[ $head_ref == 'ref: '* ]]; then branch=${head_ref#ref: }
      elif [[ -n $head_ref ]]; then branch="@${head_ref:0:7}"
      fi
    fi
  fi

  if [[ -n $branch ]]; then
    ((narrow && ${#branch}>13)) && branch="${branch:0:12}…"
    staged=0; dirty=0; untracked=0; conflicts=0; stash=0; ahead=0; behind=0
    if [[ -n $gout ]]; then
      while IFS= read -r l; do
        case $l in
          '# branch.ab '*) ab=${l#\# branch.ab }; ahead=${ab%% *}; ahead=${ahead#+}; behind=${ab##* }; behind=${behind#-};;
          '# stash '*) stash=${l#\# stash };;
          'u '*) ((conflicts+=1));;
          '1 '*|'2 '*) xy=${l:2:2}; [[ ${xy:0:1} != . ]] && ((staged+=1)); [[ ${xy:1:1} != . ]] && ((dirty+=1));;
          '? '*) ((untracked+=1));;
        esac
      done <<<"$gout"
    fi
    if (( cold_head )); then
      gb="${SKY}󰊢 $branch ${MUTED}…"; ga=$SKY
    elif ((staged+dirty+untracked+conflicts==0)); then
      gb="${MINT}󰊢 $branch 󰄬"; ga=$MINT
    else
      gb="${WHITE}󰊢 $branch"; ga=$AMBER
      ((conflicts)) && { gb+=" ${RED}!$conflicts"; ga=$RED; }; ((staged)) && gb+=" ${GREEN}●$staged"; ((dirty)) && gb+=" ${AMBER}*$dirty"; ((untracked)) && gb+=" ${MUTED}?$untracked"
    fi
    ((ahead)) && gb+=" ${CYAN}↑$ahead"; ((behind)) && gb+=" ${RED}↓$behind"; ((!narrow && stash)) && gb+=" ${VIOLET}⚑$stash"
    git_card=$(card "$ga" "$gb")
  fi
fi
join_card line1 "$git_card"

if ((pct>=90)); then ctx=$RED; elif ((pct>=75)); then ctx=$ORANGE; elif ((pct>=50)); then ctx=$AMBER; else ctx=$MINT; fi
cells=$cells10; tw=10; ((narrow)) && { cells=$cells6; tw=6; }
cb="${CYAN}󰍛 ${MUTED}context $(track "$cells" "$tw" "$ctx") ${BOLD}${ctx}${pct}%${NOBOLD}"
((!narrow)) && [[ $ctx_size != 0 ]] && cb+="${MUTED} · ${BASE}${used_tok}${MUTED}/${ctx_size}"
((!narrow)) && [[ $cache_tok != 0 ]] && cb+=" ${CYAN}↻${cache_tok}"
[[ $over200 == true ]] && cb+=" ${ORANGE}!200k"
line2=$(card "$ctx" "$cb")

# Quota display intentionally disabled.
[[ -n $cost ]] && { cp='$'; [[ $estimated == true ]] && cp='~$'; join_card line2 "$(card "$GREEN" "${GREEN}󰄉 ${cp}${cost}")"; }
[[ $tasks =~ ^[0-9]+$ ]] || tasks=0; [[ $artifacts =~ ^[0-9]+$ ]] || artifacts=0
if ((tasks || (!narrow && artifacts))); then
  ab=''; ((tasks)) && ab="${CYAN}󰝖 $tasks"; ((!narrow && artifacts)) && { [[ -n $ab ]] && ab+="${MUTED} · "; ab+="${VIOLET}󰏗 $artifacts"; }
  join_card line2 "$(card "$VIOLET" "$ab")"
fi

printf '%s\n%s\n' "$line1" "$line2"
