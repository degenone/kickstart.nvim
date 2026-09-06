# REST and DAP workflows

This is a quick reference for the workflows configured in this Neovim setup.

## REST requests

`rest.nvim` uses `.http` files and supports environment variables through `.env` files.

Example project layout:

```text
my-project/
├── .env
└── requests.http
```

Example `.env`:

```dotenv
url=http://localhost:5000
token=replace-me
```

Example `requests.http`:

```http
GET {{url}}/api/v1/foo HTTP/1.1
Authorization: Bearer {{token}}
Accept: application/json
```

Keep real secrets out of Git and commit an `.env.example` instead.

```gitignore
.env
.env.*
!.env.example
```

Useful commands:

| Command | Purpose |
| --- | --- |
| `:Rest run` | Run the request under the cursor |
| `:Rest run {name}` | Run a named request |
| `:Rest last` | Run the previous request again |
| `:Rest open` | Open the last response pane |
| `:Rest env select` | Choose an environment file |
| `:Rest env set .env.dev` | Associate a specific environment file |
| `:Rest env show` | Show the selected environment file |
| `:Rest logs` | Open REST logs |
| `:Rest cookies` | Open the REST cookie store |

In a response window, use `H` and `L` to move between the response, headers,
and other result panes.

The current setup expects `curl`; `mimetypes` and `xml2lua` are optional LuaRocks
dependencies for external-body and XML support.

## C# / .NET debugging

Build the project in Debug mode before launching the debugger:

```sh
dotnet build -c Debug
```

Open a `.cs` file, place the cursor on a line, and set a breakpoint with:

```text
<leader>b
```

Start or continue the session with `<F5>` or `:DapContinue`. Select the built
`.dll` when prompted, usually under `bin/Debug/<target-framework>/`.

| Key / command | Purpose |
| --- | --- |
| `<F5>` / `:DapContinue` | Start or continue debugging |
| `<F1>` / `:DapStepInto` | Step into |
| `<F2>` / `:DapStepOver` | Step over |
| `<F3>` / `:DapStepOut` | Step out |
| `<leader>b` / `:DapToggleBreakpoint` | Toggle a breakpoint |
| `<leader>B` | Set a conditional breakpoint |
| `<F7>` | Toggle the DAP UI |
| `:DapTerminate` | End the current session |
| `:DapShowLog` | Open the DAP log |

For a console application, `:DapContinue` launches the selected DLL; the
process does not need to be started manually. A breakpoint may initially be
shown as pending until the debug adapter has initialized.

Useful diagnostics:

```vim
:checkhealth vim.lsp
:checkhealth vim.deprecated
:checkhealth rest-nvim
:lua print(vim.inspect(require('dap').session()))
:DapShowLog
```

If stepping reports `No stopped threads`, the session has not reached a stopped
breakpoint yet. Continue until the breakpoint is hit, then step.
