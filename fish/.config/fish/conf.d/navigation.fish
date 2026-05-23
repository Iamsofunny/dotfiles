# Variables
set -g NAV_TOOL "z" # -g makes it global

# The 'cl' function (Logic: Run nav tool, and if successful, ls)
function cl
    $NAV_TOOL $argv
    and ls
end

# Navigation Aliases
alias cd="cl"
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
