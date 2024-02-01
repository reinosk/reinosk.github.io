if command -v pacman >/dev/null 2>&1 ; then
    
    Info "Arch Linux/SteamOS detected, installing dependencies..."
    Info "Please enter your password when asked"
    Info "------------------------------------"
    
    if [ "$osid" != "steamos" ] ; then
        
        if ! grep -q -E '^\[multilib\]' '/etc/pacman.conf'; then
            Info "Enabling multilib.."
            printf "\n# Multilib repo enabled by osu-winello\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | "$root_var" tee -a /etc/pacman.conf
        fi
        
        Info "Installing packages and wine-staging dependencies.."
        if command -v wine >/dev/null 2>&1 ; then
            Info "Wine (possibly) already found, removing it to replace with staging.."
            "$root_var" pacman -Rdd --noconfirm wine || Info "Looks like staging is already installed"
        fi
        
        "$root_var" pacman -Sy --noconfirm --needed git base-devel p7zip wget zenity wine-staging winetricks giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox || Error "Some libraries didn't install for some reason, check pacman or your connection"
        Info "Dependencies done, skipping.."
        
    else
        
        deck_fs_check=$("$root_var" [ -w /usr ] && echo "rw" || echo "ro")
        if [ "$deck_fs_check" = "ro" ]; then
            Error "The Steam Deck's file system is in read-only mode, preventing further action. To continue, you must disable read-only mode. More information can be found on GitHub: https://github.com/NelloKudo/osu-winello#steam-deck-support"
        else
            "$root_var" pacman --needed -Sy libxcomposite lib32-libxcomposite gnutls lib32-gnutls wine winetricks || Error "Check your connection"
            
        fi
    fi
fi