set -g fish_prompt_pwd_full_dirs 999
set -g fish_transient_prompt 1

# Palette (matches waybar/colors.css & fuzzel/fuzzel.ini)
set -g _prompt_accent 4a9eff
set -g _prompt_urgent ff5555

function fish_prompt
  set -l last_status $status
  set -l is_final 0
  if contains -- --final-rendering $argv
    set is_final 1
  end

  echo

  if test $is_final -eq 0
    set_color $_prompt_accent
    echo (prompt_pwd)
  end

  if fish_is_root_user
    set_color $_prompt_urgent
    echo -n "# "
  else if test $is_final -eq 0 -a $last_status -ne 0
    set_color $_prompt_urgent
    echo -n "❯ "
  else
    set_color $_prompt_accent
    echo -n "❯ "
  end

  set_color normal
end
