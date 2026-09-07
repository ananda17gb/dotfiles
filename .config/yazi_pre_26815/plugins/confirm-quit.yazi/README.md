# confirm-quit.yazi

[Yazi](https://github.com/sxyazi/yazi) plugin that will prevent [quit](https://yazi-rs.github.io/docs/configuration/keymap/#mgr.quit) terminating *Yazi* if there are multiple tabs open

_Based on an official [Yazi extension recommendation](https://yazi-rs.github.io/docs/tips#confirm-quit)._

## Screenshot

![Screenshot](/demo.gif)

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) v26.1.22+

## Installation

```bash
ya pkg add jessefarinacci/confirm-quit
```

## Setup

Add this to your `init.lua`:

```lua
require("confirm-quit"):setup()
```

Add this to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
desc = "Exit the process"
on = "q"
run = "plugin confirm-quit"
```
