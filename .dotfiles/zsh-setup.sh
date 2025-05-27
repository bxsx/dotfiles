#!/bin/bash

set -euo pipefail


_install_fonts() {
	FONT_STYLES=(
		"MesloLGS NF Regular.ttf"
		"MesloLGS NF Bold.ttf"
		"MesloLGS NF Italic.ttf"
		"MesloLGS NF Bold Italic.ttf"
	)
	local font_dir

 	case "$OSTYPE" in
  		darwin*)
			font_dir="$HOME/Library/Fonts"
   			;;
	  	linux-gnu*)
			font_dir="$HOME/.local/share/fonts"
   			;;
	  	*)
			echo "Error: Unsupported OS: $OSTYPE"
   			return 1
	  		;;
	esac

	echo "Installing MesloLGS Nerd Fonts to $font_dir"
 	mkdir -p "$font_dir"

	for font in "${FONT_STYLES[@]}"; do
 		local url="https://github.com/romkatv/powerlevel10k-media/raw/master/$(echo "$font" | sed 's/ /%20/g')"
	 	echo "Downloading: $font"
		curl -fsSL "$url" -o "$font_dir/$font"
	done

	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		fc-cache -f -v > /dev/null
	fi

 	echo "Installation complete."
}


KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-nvm"
git clone https://github.com/svenXY/timewarrior "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/timewarrior"
git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-you-should-use"

echo
while true; do
	read -rp "Install custom fonts for p10k? (Yes|No) " yn
	case $yn in
		[Yy]* ) _install_fonts; break;;
		[Nn]* ) echo "OK. Don't forget to install custom fonts from: https://github.com/romkatv/powerlevel10k#manual-font-installation"; break;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo "Done."
