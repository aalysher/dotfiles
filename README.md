use apps:
1. firefox
2. neovim
3. alacritty(or kitty with yazi require `ttf-dejavu` font)
4. pass (password manager)
5. obsidian (notes)
6. gpg (encode tool)
7. git (must have)
8. postman (optional)
9. telegram (optional)
10. go (main language)
11. Goland (optional)
12. obs studio (screen recorder)
13. htop(bottom - alternative on rust)
14. tmux (must have)
15. docker, docker-compose (must have)
16. light-locker(with Lightdm - alternative i3lock)
17. stow (amazing saver dotfiles)
18. clipmenud (buffer manager)
19. scrot (screenshot)
20. feh (background image)
21. fzf (awesome finder)
22. lazygit (git for neovim)
23. kubectl (k8s)
24. vlc (video player)
25. blueberry (bluetooth)
26. bat(alternative cat written on rust)
27. playerctl (music)
28. dunst (notification)


```
sudo pacman -S --needed firefox go neovim kitty pass gpg git obsidian telegram-desktop lazygit clipmenu bottom obs-studio bottom tmux docker docker-compose light-locker lightdm stow scrot feh fzf kubectl vlc blueberry bat playerctl dunst ttf-dejavu
```

install yay
```
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

