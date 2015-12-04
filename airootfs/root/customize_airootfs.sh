#!/usr/bin/fish

# set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/fish root
cp -aT /etc/skel/ /root/
chmod 700 /root

su - root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

fish_update_completions
pacman -R python --noconfirm

wget -O /root/.spacemacs 'https://raw.githubusercontent.com/Gonzih/dotfiles/master/.spacemacs'

rm /root/.emacs.d -rf
git clone --depth 1 -b develop https://github.com/syl20bnr/spacemacs /root/.emacs.d

git clone --depth 1 https://github.com/Gonzih/.xmonad /root/.xmonad

echo 'xfce4-session &' >> /root/.xinitrc
echo 'exec xmonad --replace' >> /root/.xinitrc
