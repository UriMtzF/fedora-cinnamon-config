#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script must be executed with sudo privileges"
    echo "Execute it again with sudo"
    exit "1"
fi

configure_dnf() {
    config_file="./dnf.conf"
    
    if [ -e "$config_file" ]; then
        sudo cp "$config_file" /etc/dnf/dnf.conf
        echo "DNF configuration applied succesfully"
    else
        echo "A DNF configurations was not provided cannot apply changes"
    fi
}

uninstall_unnecesary() {
    while true; do
        read -p "Should I remove firewalld? (y/n): " remove_firewall
    
        case $remove_firewall in
            [Yy]* )
                sudo dnf remove xawtv-motv dnfdragora hexchat pidgin firewalld -y -q
                break;;
            [Nn]* )
                sudo dnf remove xawtv-motv dnfdragora hexchat pidgin -y -q
                break;;
            * )
            echo "Please choose either y or n"
        esac
    done
    echo "Succesfully deleted apps"
}

update() {
    sudo dnf update -y  -q
    sudo dnf install flatpak -y -q
    echo "Succesfully updated"
}

setup_rpmfusion() {
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y -q 
    sudo dnf config-manager --enable fedora-cisco-openh264 -y -q
    sudo dnf groupupdate core -y -q
    echo "Succesfully added RPM Fusion"
}

setup_multimedia() {
    sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y -q
    echo "Succesfully substituted ffmpeg"
    sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y -q
    sudo dnf groupupdate sound-and-video -y -q
    echo "Succesfully instaled multimedia group"
    while true; do
        read -p "Are you using intel, amd or NVIDIA video card?. Type (i/a/n): " videocard
        case $videocard in
            [Ii]* )
                sudo dnf install intel-media-driver -y -q
                echo "Intel media drivers installed succesfully"
                break;;
            [Aa]* )
                sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y -q
                sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y -q
                sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686 -y -q
                sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686 -y -q
                echo "AMD media drivers installed succesfully"
                break;;
            [Nn]* )
                sudo dnf install nvidia-vaapi-driver -y -q
                echo "NVIDIA wrapper installed succesfully"
                break;;
            * )
                echo "Choose either (i/a/n)"
        esac
    done
}

setup_flathub() {
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

available_native_apps=("java-17-openjdk-devel" "syncthing" "steam" "chromium" "lutris" "kdenlive" "obs-studio" "git" "onedrive")
show_native_apps() {
    echo "Install some of this essential packages (native, using dnf):"
    for ((i=0; i<${#available_native_apps[@]}; i++)); do
        echo "$((i+1)). ${available_native_apps[$i]}"
    done
}

install_apps() {
    for package_number in "${package_numbers[@]}"; do
        package="${available_native_apps[$((package_number-1))]}"
        sudo dnf install -y "$package" -q
        echo "$package installed succesfully"
    done
}

available_flatpaks=("org.inkscape.Inkscape" "md.obsidian.Obsidian" "com.discordapp.Discord" "org.qbittorrent.qBittorrent" "org.onlyoffice.desktopeditors" "com.usebottles.bottles" "com.github.tchx84.Flatseal" "org.prismlauncher.PrismLauncher" "org.openrgb.OpenRGB" "net.davidotek.pupgui2" "org.videolan.VLC" "org.geogebra.GeoGebra")
show_flatpaks() {
    echo "Install some of this essential packages (using flatpak):"
    for ((i=0; i<${#available_flatpaks[@]}; i++)); do
        echo "$((i+1)). ${available_flatpaks[$i]}"
    done
}

install_flatpaks() {
    for flatpak_number in "${flatpak_numbers[@]}"; do
        flatpak="${available_flatpaks[$((flatpak_number-1))]}"
        flatpak install flathub "$flatpak" -y
        echo "$flatpak installed succesfully"
    done
}

install_browser() {
    while true; do
        read -p "Would you like to install Vivaldi (v), Brave (b) or none (n) of them? (b/v/n): " browser
        case $browser in
            [Bb]* )
                sudo dnf install dnf-plugins-core -y -q
                sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo -y
                sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc -y -q
                sudo dnf install brave-browser -y -q
                echo "Brave installed succesfully"
                break;;
            [Vv]* )
                sudo dnf install wget -q -y
                wget https://downloads.vivaldi.com/stable/vivaldi-stable-6.5.3206.53-1.x86_64.rpm
                sudo dnf install ./vivaldi-stable-6.5.3206.53-1.x86_64.rpm -y -q
                sudo dnf update -y -q
                echo "Vivaldi installed succesfully"
                break;;
            [Nn]* )
                break;;
            * )
                echo "Choose either (b/v/n)"
        esac
    done    
}

install_extras() {
    echo "This extra packages include some QOL software, fonts and repos from COPR"
    echo "- better_fonts: Fonts to not show DejaVu Sans on every website"
    echo "- typst: A new markup-base typesetting system, FOSS alternative to LaTeX"
    echo "- medzik/jetbrains: A COPR repo to easily install JetBrains products"
    while true; do
        read -p "Would you like to install this extras? (y/n): " extras
        case $extras in
            [Yy]* )
                sudo dnf copr enable hyperreal/better_fonts -y -q
                sudo dnf copr enable claaj/typst  -y -q
                sudo dnf copr enable medzik/jetbrains -y -q
                sudo dnf install fontconfig-font-replacements fontconfig-enhanced-defaults typst -y -q
                break;;
            [Nn]* )
                break;;
            * ) 
                echo "Choose either (y/n)"
        esac
    done
}

apply_discordfix() {
    while true; do
        read -p "If you have installed Discord from flatpak the rich presence will not work, would you like to apply the known patch? (y/n): " applypatch
        case $applypatch in
            [Yy]* )
                mkdir -p ~/.config/user-tmpfiles.d
                echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
                systemctl --user enable --now systemd-tmpfiles-setup.service
                break;;
            [Nn]* )
                break;;
            * ) 
                echo "Choose either (y/n)"
        esac
    done
    echo "Patch applied succesfully, for further info of the patch check https://github.com/flathub/com.discordapp.Discord/wiki/Rich-Precense-(discord-rpc)"
}

echo "This script will setup Fedora (specially cinnamon) to be usable from the beggining"
echo "Will do:"
echo "- Configure dnf to sane settings"
echo "- Uninstall: DnfDragora, Hexchat, Pidgin and XawTelevision Viewer"
echo "- Add and setup rpm fusion"
echo "- Update the system"
echo "- Setup multimedia from rpm fusion"
echo "- Add flathub"
echo "- Select some apps to install"
echo "- If on laptop setup battery saving configuration"
while true; do
    read -p "Are you sure you want to proceed? (y/n): " answer

    case $answer in
        [Yy]* )
            echo "Executing script..."
            echo "Copying configuration from dnf.conf in the same directory as the script"
            configure_dnf
            echo "Updating system, please be patient"
            update
            echo "Setting up RPM Fusion"
            setup_rpmfusion
            echo "Setting up reccomended multimedia packages from RPM Fusion"
            setup_multimedia
            echo "Uninstalling unnecesary apps"
            uninstall_unnecesary
            echo "Setting up flathub"
            setup_flathub
            echo "Now you can select some apps to be installed"
            show_native_apps
            read -p "Select the numbers of the apps you want to install separated by a space: " -a package_numbers
            install_apps
            show_flatpaks
            read -p "Select the numbers of the apps you want to install separated by a space: " -a flatpak_numbers
            install_flatpaks
            install_browser
            install_extras
            apply_discordfix
            break;;
        [Nn]* )
            echo "Exiting..."
            exit;;
        * )
            echo "Please choose either y or n"
    esac
done
