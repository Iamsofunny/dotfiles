function fish_right_prompt
  if contains -- --final-rendering $argv
    set_color 5a6a8a
    echo -n (prompt_pwd)
    set_color normal
  end
end
