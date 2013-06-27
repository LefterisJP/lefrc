setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.lefrc/prezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done