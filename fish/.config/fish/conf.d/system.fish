# Package Management
alias update="sudo dnf upgrade --refresh"
alias psearch="dnf search"
alias pinstall="sudo dnf install"

# Systemd / Bisync Services
alias bisync-log="journalctl -u holemine-bisync.service -f"
alias bisync-status="systemctl list-timers holemine-bisync.timer"
alias bisync-now="sudo systemctl start holemine-bisync.service; and echo '🔗 Manual sync started.'"
alias bisync-pause="sudo systemctl stop holemine-bisync.timer; and echo '⏸  Timer PAUSED.'"
alias bisync-resume="sudo systemctl start holemine-bisync.timer; and echo '▶  Timer RESUMED.'"
alias bisync-resync="/home/matze/Scripts/holemine-init-bisync.sh; and echo 'RESYNC Success.'"
alias bisync-disable="sudo systemctl disable holemine-bisync.timer"
alias bisync-enable="sudo systemctl enable holemine-bisync.timer"
