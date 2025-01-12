#! /bin/bash

#THIS IS ONLY MEANT TO BE RAN ON KALI LINUX AT THE MOMENT. USE AT OWN RISK

# Set terminal colors so it's pretty

TERM=xterm-256color # Fix colors for msys2 terminal
color_R=$(tput setaf 9)
color_G=$(tput setaf 10)
color_B=$(tput setaf 12)
color_Y=$(tput setaf 208)
color_N=$(tput sgr0)
print() {
    printf "${color_B}${1}${color_N}"
}

if [ "$EUID" -ne 0 ]
  then print "${color_R}[!] Please run as root!!${color_N}"
  exit
fi

# Set custom packages in this var

Packages="terminator zsh zsh-autosuggestions kali-wallpapers* kali-community-wallpapers kali-tools-web kali-theme* kali-tools-wireless kali-tools-vulnerability kali-tools-exploitation kali-tools-passwords kali-tools-social-engineering kali-tools-reverse-engineering kali-tools-sniffing-spoofing kali-tools-information-gathering kali-tools-identify git build-essential "
# Set tools directory

Tools_dir=$HOME/dotfiles-and-more

pause() {
    print "[.] Press any key to continue... (or press Ctrl+C to cancel)"
    read -s
}

check_tools_dir(){
    # Check for Tools dir if it doesn't exist git clone it
    # This is so i can either git clone the repo or curl the sh script

    if [ ! -d "$Tools_dir" ]; then
        print "[!] Tools are not downloaded."
        print "[.] Downloading..."
        git clone https://github.com/MCFDev/dotfiles-and-more $HOME
        # Make symbolic link for tools so it's easier to modify them in the future if needed
        ln -s $Tools_dir/tools/ovpntool /bin
    fi

}

setup_zsh(){
    print "[.] Making sure user shell is set to ZSH"
    chsh -s /bin/zsh
    print "[.] Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print "[.] Installing the .zshrc."
    cp $Tools_dir/.zshrc $HOME
}

User="$(ls -b /home|tr -d '\n')" # Assumes there's only one user for now.
DistroName="$(awk '/PRETTY_NAME=/' /etc/*-release | sed 's/PRETTY_NAME=//' | tr -d '"')"
Hostname="$(hostname|tr -d '\n')"
Kernel="$(uname -sr|tr -d '\n')"

print "Hello, ${color_G}$User@$Hostname.\n${color_Y}Distro: $DistroName\nKernel: $Kernel${color_N}\n" # This is just so the output looks good, there's no real reason for this.
print ${color_R}"\n[!!!] THIS  SCRIPT IS ONLY MEANT TO BE RAN ON KALI LINUX AT THE MOMENT. USE AT YOUR OWN RISK.${color_N}\n"
pause # Give the user a chance to stop execution.
print "\n[-] Time for an update."
apt update && apt upgrade -y && apt dist-upgrade -y
print "\n[-] Installing Packages\n"
apt install -y $Packages
print "\n[!]Reboot might be needed\n"
setup_zsh
check_tools_dir

print "${color_Y}[!]Done. Reboot to make sure everything is working properly.${color_N}"

