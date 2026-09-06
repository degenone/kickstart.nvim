local M = {}
M.paths = {}

local function github(repo, version)
  return {
    src = 'https://github.com/' .. repo,
    version = version,
  }
end

-- Native vim.pack manifest. Packages are registered at startup and loaded when
-- their configuration or lazy trigger requires them.
M.specs = {
  github('windwp/nvim-autopairs'),
  github('catppuccin/nvim'),
  github('Mofiqul/vscode.nvim'),
  github('hrsh7th/nvim-cmp'),
  github('L3MON4D3/LuaSnip'),
  github('rafamadriz/friendly-snippets'),
  github('saadparwaiz1/cmp_luasnip'),
  github('hrsh7th/cmp-nvim-lsp'),
  github('hrsh7th/cmp-path'),
  github('stevearc/conform.nvim'),
  github('mfussenegger/nvim-dap'),
  github('rcarriga/nvim-dap-ui'),
  github('nvim-neotest/nvim-nio'),
  github('jay-babu/mason-nvim-dap.nvim'),
  github('leoluz/nvim-dap-go'),
  github('dlyongemallo/diffview.nvim'),
  github('Mofiqul/dracula.nvim'),
  github('lewis6991/gitsigns.nvim'),
  github('ellisonleao/gruvbox.nvim'),
  github('NMAC427/guess-indent.nvim'),
  github('lukas-reineke/indent-blankline.nvim'),
  github('folke/lazydev.nvim'),
  github('mfussenegger/nvim-lint'),
  github('neovim/nvim-lspconfig'),
  github('williamboman/mason.nvim'),
  github('williamboman/mason-lspconfig.nvim'),
  github('WhoIsSethDaniel/mason-tool-installer.nvim'),
  github('j-hui/fidget.nvim'),
  github('seblyng/roslyn.nvim'),
  github('echasnovski/mini.nvim'),
  github('nvim-neo-tree/neo-tree.nvim'),
  github('nvim-lua/plenary.nvim'),
  github('nvim-tree/nvim-web-devicons'),
  github('MunifTanjim/nui.nvim'),
  github('rest-nvim/rest.nvim'),
  github('MeanderingProgrammer/render-markdown.nvim'),
  github('nvim-telescope/telescope.nvim', 'v0.2.1'),
  github('nvim-telescope/telescope-fzf-native.nvim'),
  github('nvim-telescope/telescope-ui-select.nvim'),
  github('folke/todo-comments.nvim'),
  github('folke/tokyonight.nvim'),
  github('nvim-treesitter/nvim-treesitter', 'main'),
  github('mbbill/undotree'),
  github('tpope/vim-sleuth'),
}

function M.install()
  -- Register packages first. Individual specs are loaded below according to
  -- their event, filetype, command, and key triggers.
  vim.pack.add(M.specs, {
    confirm = false,
    -- A no-op loader registers installed packages without `:packadd!`, whose
    -- runtimepath entries would otherwise be sourced later during startup.
    load = function(data) M.paths[data.spec.name] = data.path end,
  })
end

local function plugin_path(name)
  if M.paths[name] then return M.paths[name] end
  local plugin = vim.pack.get({ name })[1]
  return plugin and plugin.path or nil
end

local function run(command, opts)
  local result = vim.system(command, vim.tbl_extend('force', { text = true }, opts or {})):wait()
  if result.code == 0 then return true end

  local output = vim.trim((result.stderr or '') .. '\n' .. (result.stdout or ''))
  vim.notify(('Command failed: %s\n%s'):format(table.concat(command, ' '), output), vim.log.levels.ERROR)
  return false
end

function M.build_fzf()
  local path = plugin_path 'telescope-fzf-native.nvim'
  if not path then
    vim.notify('telescope-fzf-native.nvim is not installed.', vim.log.levels.WARN)
    return false
  end

  local library = vim.fs.joinpath(path, 'build', vim.fn.has('win32') == 1 and 'libfzf.dll' or 'libfzf.so')
  if vim.uv.fs_stat(library) then return true end

  if vim.fn.executable 'cmake' ~= 1 then
    vim.notify('CMake is required to build telescope-fzf-native.nvim. Install it, then run :PackBuild fzf.', vim.log.levels.WARN)
    return false
  end

  local commands = {
    { 'cmake', '-S', '.', '-B', 'build', '-DCMAKE_BUILD_TYPE=Release' },
    { 'cmake', '--build', 'build', '--config', 'Release' },
    { 'cmake', '--install', 'build', '--prefix', 'build' },
  }
  for _, command in ipairs(commands) do
    if not run(command, { cwd = path }) then return false end
  end
  return true
end

function M.build(name)
  if not name or name == '' or name == 'fzf' then return M.build_fzf() end
  vim.notify(('Unknown package build target: %s'):format(name), vim.log.levels.ERROR)
  return false
end

local function setup_commands()
  vim.api.nvim_create_user_command('PackBuild', function(args)
    M.build(args.args)
  end, {
    force = true,
    nargs = '?',
    complete = function() return { 'fzf' } end,
    desc = 'Build native vim.pack dependencies',
  })

  vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update()
  end, { desc = 'Update vim.pack packages', force = true })
end

local plugin_modules = {
  'plugins.autopairs',
  'plugins.catppuccin',
  'plugins.colorscheme',
  'plugins.completion',
  'plugins.conform',
  'plugins.debug',
  'plugins.diffview',
  'plugins.dracula',
  'plugins.gitsigns',
  'plugins.gruvbox',
  'plugins.guess-indent',
  'plugins.indent_line',
  'plugins.lazydev',
  'plugins.lint',
  'plugins.lsp',
  'plugins.mini',
  'plugins.neo-tree',
  'plugins.rest',
  'plugins.render-markdown',
  'plugins.telescope',
  'plugins.theme-loader',
  'plugins.todo-comments',
  'plugins.tokyonight',
  'plugins.treesitter',
  'plugins.undotree',
  'plugins.vim-sleuth',
  'custom.plugins.init',
}

local main_modules = {
  ['gitsigns.nvim'] = 'gitsigns',
  ['guess-indent.nvim'] = 'guess-indent',
  ['indent-blankline.nvim'] = 'ibl',
  ['lazydev.nvim'] = 'lazydev',
  ['nvim-neo-tree.nvim'] = 'neo-tree',
  ['conform.nvim'] = 'conform',
  ['todo-comments.nvim'] = 'todo-comments',
  ['fidget.nvim'] = 'fidget',
  ['mason.nvim'] = 'mason',
}

local function plugin_name(spec)
  local source = type(spec) == 'string' and spec or type(spec) == 'table' and spec[1] or nil
  return type(source) == 'string' and source:match '/([^/]+)$' or nil
end

local configured = {}
local configuring = {}
local loaded = {}
local pending_after = {}
local force_after_scripts = false

local function load_plugin(name)
  if not name or loaded[name] then return end
  vim.cmd.packadd { name, bang = false }
  loaded[name] = true

  -- :packadd only sources plugin/ files. Packages loaded after startup also
  -- need their after/plugin scripts sourced explicitly. Batch these until the
  -- complete dependency tree is on runtimepath.
  if force_after_scripts then pending_after[#pending_after + 1] = name end
end

local function source_pending_after()
  local names = pending_after
  pending_after = {}
  for _, name in ipairs(names) do
    local path = plugin_path(name)
    local after_files = path and vim.fn.glob(vim.fs.joinpath(path, 'after', 'plugin', '**', '*.{vim,lua}'), false, true) or {}
    for _, file in ipairs(after_files) do
      vim.cmd.source { file, magic = { file = false } }
    end
  end
end

local configure_spec

local function load_spec_tree(spec, seen)
  seen = seen or {}
  if type(spec) == 'string' then
    load_plugin(plugin_name(spec))
    return
  end
  if type(spec) ~= 'table' or spec.enabled == false then return end
  if type(spec[1]) == 'table' then
    for _, child in ipairs(spec) do
      load_spec_tree(child, seen)
    end
    return
  end

  local name = plugin_name(spec)
  if not name or seen[name] then return end
  seen[name] = true
  for _, dependency in ipairs(spec.dependencies or {}) do
    load_spec_tree(dependency, seen)
  end
  load_plugin(name)
end

local function configure_dependency(dependency)
  if type(dependency) == 'table' then
    configure_spec(dependency)
  else
    load_plugin(plugin_name(dependency))
  end
end

configure_spec = function(spec)
  if type(spec) == 'string' then
    configure_dependency(spec)
    return
  end
  if type(spec) ~= 'table' or spec.enabled == false then return end

  -- Some spec files return a list of plugin specs rather than one spec.
  if type(spec[1]) == 'table' then
    for _, child in ipairs(spec) do
      configure_spec(child)
    end
    return
  end

  local name = plugin_name(spec)
  if not name or configured[name] or configuring[name] then return end
  configuring[name] = true

  -- Source the complete package tree first. Some dependency setup callbacks
  -- call into their parent package (friendly-snippets -> LuaSnip), while other
  -- parents inspect dependencies as they are sourced (rest.nvim -> nvim-nio).
  load_spec_tree(spec)
  source_pending_after()

  for _, dependency in ipairs(spec.dependencies or {}) do
    configure_dependency(dependency)
  end

  local ok, err = xpcall(function()
    if type(spec.config) == 'function' then
      spec.config()
    elseif spec.config == true then
      local module = main_modules[name]
      if module then require(module).setup() end
    elseif spec.opts then
      local module = spec.main or main_modules[name]
      if module then require(module).setup(spec.opts) end
    end

    for _, key in ipairs(spec.keys or {}) do
      local lhs, rhs = key[1], key[2]
      if lhs and rhs then
        local opts = vim.tbl_extend('force', {}, key)
        opts[1] = nil
        opts[2] = nil
        local mode = opts.mode or 'n'
        opts.mode = nil
        vim.keymap.set(mode, lhs, rhs, opts)
      end
    end
  end, debug.traceback)

  configuring[name] = nil
  if not ok then error(err) end
  configured[name] = true
end

local function activate_spec(spec, source_after_scripts)
  local previous = force_after_scripts
  force_after_scripts = previous or source_after_scripts
  local ok, err = xpcall(function() configure_spec(spec) end, debug.traceback)
  force_after_scripts = previous
  if not ok then error(err) end
end

local function command_list(commands)
  if type(commands) == 'string' then return { commands } end
  return commands or {}
end

local function register_lazy_commands(spec)
  local commands = command_list(spec.cmd)
  for _, command in ipairs(commands) do
    vim.api.nvim_create_user_command(command, function(args)
      -- Plugin command definitions cannot replace our stubs, so remove every
      -- stub owned by this spec before sourcing the package.
      for _, sibling in ipairs(commands) do
        pcall(vim.api.nvim_del_user_command, sibling)
      end
      activate_spec(spec, true)

      local invocation = command .. (args.bang and '!' or '')
      if args.args ~= '' then invocation = invocation .. ' ' .. args.args end
      vim.cmd(invocation)
    end, {
      bang = true,
      nargs = '*',
      desc = ('Load %s and run :%s'):format(plugin_name(spec), command),
      force = true,
    })
  end
end

local function register_lazy_keys(spec)
  for _, key in ipairs(spec.keys or {}) do
    local lhs, rhs = key[1], key[2]
    if lhs and rhs then
      local opts = vim.tbl_extend('force', {}, key)
      opts[1] = nil
      opts[2] = nil
      local mode = opts.mode or 'n'
      opts.mode = nil
      vim.keymap.set(mode, lhs, function()
        activate_spec(spec, true)
        if type(rhs) == 'function' then
          rhs()
        else
          local keys = vim.api.nvim_replace_termcodes(rhs, true, false, true)
          vim.api.nvim_feedkeys(keys, 'm', false)
        end
      end, opts)
    end
  end
end

local function register_lazy_events(spec)
  if spec.event then
    vim.api.nvim_create_autocmd(spec.event, {
      once = true,
      callback = function(args)
        if args.event == 'VimEnter' then
          vim.schedule(function() activate_spec(spec, true) end)
        else
          activate_spec(spec, vim.v.vim_did_enter == 1)
        end
      end,
      desc = 'Load ' .. plugin_name(spec),
    })
  end
  if spec.ft then
    local filetypes = type(spec.ft) == 'table' and spec.ft or { spec.ft }

    -- Resolve the prospective filetype before the regular FileType event so
    -- packages that ship ftplugin/ files are already on runtimepath.
    vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
      callback = function(args)
        local filetype = vim.filetype.match { buf = args.buf, filename = args.file }
        if filetype and vim.tbl_contains(filetypes, filetype) then activate_spec(spec, vim.v.vim_did_enter == 1) end
      end,
      desc = 'Preload ' .. plugin_name(spec) .. ' for matching filetypes',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      once = true,
      callback = function() activate_spec(spec, vim.v.vim_did_enter == 1) end,
      desc = 'Load ' .. plugin_name(spec),
    })
  end
end

local function setup_spec(spec)
  if type(spec) ~= 'table' or spec.enabled == false then return end
  if type(spec[1]) == 'table' then
    for _, child in ipairs(spec) do
      setup_spec(child)
    end
    return
  end

  local is_lazy = spec.lazy ~= false and (spec.event ~= nil or spec.ft ~= nil or spec.cmd ~= nil)
  if not is_lazy then
    configure_spec(spec)
    return
  end

  register_lazy_commands(spec)
  register_lazy_keys(spec)
  register_lazy_events(spec)
end

function M.setup()
  M.install()
  setup_commands()
  M.build_fzf()

  local plugin_specs = {}
  local custom_specs = {}
  for _, module_name in ipairs(plugin_modules) do
    local ok, spec = pcall(require, module_name)
    if not ok then
      error(('Could not load plugin specification %s: %s'):format(module_name, spec))
    end
    if module_name == 'custom.plugins.init' then
      custom_specs = spec
    else
      plugin_specs[#plugin_specs + 1] = spec
    end
  end

  for _, spec in ipairs(plugin_specs) do
    setup_spec(spec)
  end

  for _, custom_spec in ipairs(custom_specs) do
    if custom_spec.dir and vim.uv.fs_stat(custom_spec.dir) and custom_spec.dir ~= vim.fn.stdpath 'config' .. '/lua/custom/modules/file-copy' then
      vim.opt.rtp:prepend(custom_spec.dir)
    end
    if type(custom_spec.config) == 'function' then custom_spec.config() end
  end
end

return M
