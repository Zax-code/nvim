# My neovim config
## Getting started:
Simply execute this
```bash
git clone https://github.com/Zax-code/nvim.git ~/.config
```

### Be careful
This config was set up in WSL, if you're not using it / are not on windows, REMOVE the last config in lua/zax/set.lua:
```lua
-- For WSL only remove if not using it
vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ['+'] = "clip.exe",
    ['*'] = "clip.exe",
  },
  paste = {
    ['+'] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
    ['*'] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
  },
  cache_enabled = 0,
}
```
