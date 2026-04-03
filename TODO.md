# TODO

## Note
- `ftplugin/`: These files run before most other things. If a global plugin or the
  LSP also tries to set indentation, they might overwrite whatever you put in
  here.
- `after/ftplugin/`: As the name suggests, these run after everything else.
  This makes it the "final word." If you want to ensure your Go files use a
  tabstop of 4 and stay as tabs, putting it in after/ ensures no other plugin
  (like a generic indent-detector) can change it back to spaces later.
