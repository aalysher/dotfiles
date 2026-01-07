### required:
1. pass (password manager)
2. gpg (encode tool)
3. git (must have)
4. stow (amazing saver dotfiles)


### optional:
1. firefox
2. neovim
3. ghostty
4. obsidian (notes)
5. postman (optional)
6. go (main language)
7. Goland/Zed (optional)
8. obs studio (screen recorder)
9. btop
10. tmux (must have)
11. docker, docker-compose (must have)
12. light-locker(with Lightdm - alternative i3lock)
13. clipmenud (buffer manager)
14. scrot (screenshot)
15. feh (background image)
16. fzf (awesome finder)
17. lazygit (git for neovim)
18. kubectl (k8s)
19. vlc (video player)
20. blueberry (bluetooth)
21. bat(alternative cat written on rust)
22. playerctl (music)
23. dunst (notification)
24. yazi/nautilus (TUI and GUI file managers)


```
sudo pacman -S --needed firefox go neovim ghostty yazi pass gpg git obsidian telegram-desktop lazygit clipmenu obs-studio btop tmux docker docker-compose light-locker lightdm stow scrot feh fzf kubectl vlc blueberry bat playerctl dunst ttf-dejavu
```

install yay
```
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

