#!/bin/zsh

# if ssh_tunnel_port is not set then we need to source .zshrc again to get it
if [[ -z "$ssh_tunnel_port" ]]; then
    . ~/.zshrc
fi
 ssh -v -D $ssh_tunnel_port -N lefteris@lefvps -o "ProxyCommand corkscrew emea-proxy.uk.oracle.com 80 84.22.97.122 1986"
