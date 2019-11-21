#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -Eueo pipefail

# Include the log helpers and banner
source ./log_utils.sh


# Main Program
print_main_banner

if [ $# -eq 0 ]; then
    usage
else
    for i in "$@"
    do
        case $i in
            -s|--sync)
                doSync
                doGitConfig
                shift
                ;;
            -l|--link)
                doSymLink
                shift
                ;;
            -i|--install)
                doInstall
                shift
                ;;
            -f|--fonts)
                installFonts
                shift
                ;;
            -c|--config)
                doConfig
                shift
                ;;
            -a|--all)
                installAll
                shift
                ;;
            *)
                usage
                shift
                ;;
        esac
    done
fi
