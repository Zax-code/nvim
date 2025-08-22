vcd(){
  if [ $# -eq 0 ]; then
    nvim "$(pwd)" --cmd "cd $(pwd)"
  else
    exec_arg="$1"
    if [ -d "$exec_arg" ]; then
      nvim "$exec_arg" --cmd "cd $exec_arg"
    elif [ -f "$exec_arg" ]; then
      nvim "$exec_arg" --cmd "cd $(dirname "$exec_arg")"
    else
      # Get the directory name from the file path
      # If the directory does not exist, create it
      # Get the filename from the file path and open it in nvim
      dir_name=$(dirname "$exec_arg")
      if [ ! -d "$dir_name" ]; then
        mkdir -p "$dir_name"
        nvim "$exec_arg" --cmd "cd $dir_name"
      else
        nvim "$exec_arg" --cmd "cd $dir_name"
      fi
    fi
  fi
}

