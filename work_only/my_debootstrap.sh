# my getin_chroot.sh script which bind mounts the necessary files ONLY ONCE

declare -a mnt_arr=(\
/proc \
/dev/pts)

declare -a bind_mnt_arr=(\
/etc/resolv.conf \
/etc/hostname \
/etc/hosts \
/home/$USER/.hgext \
/home/$USER/.hgrc \
/home/$USER/bin \
/home/$USER/.ssh \
/home/$USER/.zlogin \
/home/$USER/.zlogout \
/home/$USER/.zprezto \
/home/$USER/.zpreztorc \
/home/$USER/.zprofile \
/home/$USER/.zsh_aliases \
/home/$USER/.zshenv \
/home/$USER/.zshrc \
/home/$USER/.zsh_functions
)

function do_remount {
        _CHROOT_PATH=$1
        _SYS_PATH=$2
        _OPTIONS=$3
        sudo umount $_CHROOT_PATH$_SYS_PATH 2> /dev/null
        sudo mount $_OPTIONS $_SYS_PATH $_CHROOT_PATH$_SYS_PATH
}

# uncomment when you need to change the chroot directory
#CHROOT_PATH=$1 
CHROOT_PATH=/chroot/wheezy

for i in ${mnt_arr[@]}
do
        do_remount $CHROOT_PATH$i
done

for i in ${bind_mnt_arr[@]}
do
        do_remount $CHROOT_PATH $i \ --bind
done



sudo chroot $CHROOT_PATH /bin/bash
