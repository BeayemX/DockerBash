#/usr/bin/env bash

_container_list()
{
    # Avoid auto completing multiple values
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi
    COMPREPLY=($(compgen -W "$(db-ls-names)" -- "${COMP_WORDS[1]}"))
}

complete -F _container_list db
complete -F _container_list db-rm
