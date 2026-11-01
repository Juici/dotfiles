# -*- mode: zsh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# vim: ft=zsh tw=120 sw=4 sts=4 et foldmarker=[[[,]]]

[[ -v commands[carapace] ]] || return

typeset -gA _carapace_supported
local cmd
for cmd in "${(f)$(carapace --list --names 2>/dev/null)}"; do
    _carapace_supported[${cmd}]=1
done

_carapace_completer() {
    local -a match mbegin mend

    local cmd=${words[1]:t} compline="${words[1,$CURRENT]}"
    local IFS='\n'

    # Attempt to fix the compline by appending a missing single/double quote.
    local q fixed_compline
    for q in "''" \' \"; do
        if (
            unset functions[__t];
            functions[__t]="${compline}${q}"
            [[ -v functions[__t] ]]
        ) 2>/dev/null
        then
            fixed_compline="${compline}${q}"
            break
        fi
    done

    local input="$(CARAPACE_COMPLINE="${compline}" CARAPACE_ZSH_HASH_DIRS="$(hash -d)" carapace "${cmd}" zsh "${(@Q)${(z)fixed_compline:-${compline}}}")"

    local style message noprefix data
    IFS=$'\001' read -rd '' style message noprefix data <<<"$input"

    local block tag displays_lines values_lines
    local -a displays=() values=()

    while IFS=$'\002' read -rd $'\002' block; do
        IFS=$'\003' read -rd '' tag displays_lines values_lines <<<"$block"

        displays+=( "${(f)displays_lines}" )
        values+=( "${(@)${(f)values_lines}/(#b)(*)' '##/${match[1]}}" )
    done <<<"$data"

    local -a slashes slashes_displays dots dots_displays eqs eqs_displays
    local value i=1

    while (( i <= ${#values} )); do
        # If we added quotes, then try stripping them from the end to
        # test for autoremovable suffix.
        value="${values[$i]%${q}}"

        case "$value" in
            *'/')
                slashes+=( "${value[1,-2]}" )
                slashes_displays+=( "${displays[$i]}" )
                ;;
            *'.')
                dots+=( "${value[1,-2]}" )
                dots_displays+=( "${displays[$i]}" )
                ;;
            *'=')
                eqs+=( "${value[1,-2]}" )
                eqs_displays+=( "${displays[$i]}" )
                ;;
            *)
                (( i++ ))
                continue
                ;;
        esac

        # Remove the entry as we are handling it separately.
        values[$i]=()
        displays[$i]=()
    done

    #zstyle ":completion:${curcontext}:*" list-colors "${style}"
    #zstyle ":completion:${curcontext}:*" group-name ''

    #[[ -z "${message}" ]] || _message -r "${message}"
    [[ "${noprefix}" = "true" ]] && compstate[insert]=menu

    _describe 'command' \
        displays values -qS '' -Q -- \
        slashes_displays slashes -qS '/' -Q -- \
        dots_displays dots -qS '.' -Q -- \
        eqs_displays eqs -qS '=' -Q
}

_carapace_or_default() {
    local cmd="${words[1]:t}" completer='_default'
    if [[ -v _carapace_supported[${cmd}] ]]; then
        completer='_carapace_completer'
    fi
    "${completer}" "$@"
}
zicompdef _carapace_or_default '-default-'
