
__tmp_pass_dir=$(cd $(dirname -- ${(%):-%N}) && pwd)
__tmp_pass_name=$(basename -- $__tmp_pass_dir | sed 's/^\.*//')

#create a custom pass alias to override the PASSWORD_STORE_DIR env variable
alias $__tmp_pass_name="PASSWORD_STORE_DIR=$__tmp_pass_dir pass"

# Small hack to allow use alternate path for PASSWORD_STORE_DIR in zsh completion
if type _pass > /dev/null 2>&1; then
  compdef _pass teampass
  zstyle ':completion::complete:teampass::' prefix "${__tmp_pass_dir}/"
  teampass() {
    PASSWORD_STORE_DIR="${__tmp_pass_dir}/" pass $@
  }
fi

unset __tmp_pass_dir __tmp_pass_name
