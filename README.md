# fedora-cinnamon-config
A script to customize a fresh installation of fedora cinnamon spin
## How-to
**Requirements**
- git (optional)
**Be careful**
- The way that I used to install Vivaldi assumes that you're using a x86_64 processor.
- There's no way to just uninstall some apps from the initial selection.
- The script is no optimized to use the minimal time, network or resources.

---

### With git
If you want you can clone this repo in any folder by using
```sh
git clone https://github.com/UriMtzF/fedora-cinnamon-config.git
```
Move to the containing folder
```sh
cd fedora-cinnamon-config
```
Make the script executable 
```sh
chmod +x initial-config.sh
```
Execute it
```sh
./initial-config.sh
```
### Without git
- Download the latest version from the release section or from [here](https://github.com/UriMtzF/fedora-cinnamon-config/archive/refs/tags/v0.1.0.zip)
- Unzip the file and make the scrip executable from the file manager or execute
```sh
chmod +x initial-config.sh
```
- Open it from terminal
```sh
./initial-config.sh
```

---

# FAQ (kinda...)
## Why some packages or no others?
While a lot of users could use some packages, I only use some of the included ones, however is easy to add yours by adding them on the array `available_native_apps`, the apps added to this array must be available in the offical or RPM Fusion repo otherwise it won't find them.
For flatpak apps just change the array `available_flatpaks` using the name of the package on flathub.
## Why only Vivaldi and Brave?
Again, those are the browsers that I commonly use
### Why first download the vivialdi rpm?
While trying to add the native repo I encountered some problems so it's easier to use wget to download some rpm and then update it.
## Can I change the DNF configuration?
Sure! Just change the configuration in the file provided by this repo, then what you write will be applied. However the file just have sane defaults.
## Why the extras?
Someone could just want one set of options so there's freedom, the selection of extras are from personal taste.
## Some options could change in the future?
Maybe, I distrohop a lot in my free time so it was time to set a script every time that I come back to Fedora so having some extras could be useful.

---

# Changelog
**v0.1.0**
- Initial release of the script, by default applies a sane dnf configuration, adding `defaultyes`, `keepcache` and 10 `max_parallel_downloads`
- By default install RPM Fusion repo free and nonfree, change the ffmpeg available from free to nonfree and setup multimedia codecs reccomended by RPM Fusion.
- By default uninstall some extra software; DnfDragora, Hexchat, Pidgin and XawTelevision Viewer, optionally can uninstall firewalld.
- By default installs and setup flatpak and flathub.
- Shows some selections of native and flatpak apps that can be installed.
- Prompts the user to install either Brave or Vivaldi browser.
- Prompts the user to install some extra software or adding useful COPR repos
  - Adds `medzik/jetbrains` to have available JetBrains software
  - Adds `hyperreal/better_fonts` and install `fontconfig-font-replacements` and `fontconfig-enhanced-defaults`to have better fonts in some sites instead of DejaVuSans
  - Adds `claaj/typst` and install `typst` a new markup-base typesetting system, FOSS alternative to LaTeX
- **Trying** add a fix to the discord rich presence from installation in flatpak.
