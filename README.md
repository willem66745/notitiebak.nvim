# Notitiebak

Simplistic note taking plugin for Neovim. Inspired on *zettelkasten* but
adapted to my own means. So instead of German I tried to translate it loosely
into Dutch: *notitiebak*.

## Installation

With Lazy, use the following snippet:

```lua
return {
  'willem66745/notitiebak.nvim',
  opts = {},
}
```

## Usage

To toggle a note use in command mode: `:NotitieToggle`. By default per day a
new note file is created. The note file is stored in the directory
`~/notes/`. The note file is named after the date in the format `YYYY-MM-DD.md`.

## Configuration

The default settings are:

```lua
{
  notes_directory = '~/notes',
  default_note = 'todays_date',
}
```

The `default_note` can be string, which will result that every note will end
up in the same file.

Dynamic behavior can archived by providing a function that returns a string.
Also when providing a special value as text can yield dynamic behavior:

* Today's date: `todays_date`
* Current branch name: `branch_name`
