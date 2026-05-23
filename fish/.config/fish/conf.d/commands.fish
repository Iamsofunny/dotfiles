# Core replacements
alias cat="bat"
alias ccat="command cat"
alias ls="lsd -F"
alias cp="cp -i"
alias e="micro"

# Networking & Help
alias wol-nas="wol --verbose 90:09:d0:19:11:23"
alias hlp="cat ~/.help | more"

alias db-start="docker compose -f /home/matze/Documents/Uni/Datenbanken\ Übung/db/compose.yml up -d"
alias db-stop="docker compose -f /home/matze/Documents/Uni/Datenbanken\ Übung/db/compose.yml down"
