# remove the previous symlinks if existing
rm -f "${ZDOTDIR:-$HOME}"/.zlogin
rm -f "${ZDOTDIR:-$HOME}"/.zlogout
rm -f "${ZDOTDIR:-$HOME}"/.zpreztorc
rm -f "${ZDOTDIR:-$HOME}"/.zprofile
rm -f "${ZDOTDIR:-$HOME}"/.zshenv
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done