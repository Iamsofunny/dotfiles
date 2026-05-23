set -g pwd_color CCFF04
set -g fish_prompt_pwd_full_dirs 999

# Show directory
function show_pwd
  set_color normal
  echo -n "╭──"
  
  set -l pwd
  set pwd (prompt_pwd)
  set_color $pwd_color
  echo -s " $pwd"
end

# Show prompt w/ privilege cue
function show_prompt
  set_color normal
  echo -n "╰─"
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    set_color red
    echo -n " # "
  else
    set_color $pwd_color
    echo -n " \$ "
  end
end

## SHOW PROMPT
function fish_prompt
  echo
  show_pwd
  show_prompt
  set_color normal
end
