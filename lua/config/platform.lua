-- Platform-specific settings

-- Windows specific settings
if vim.fn.has 'win32' == 1 then
  vim.o.shell = 'pwsh'
  vim.o.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  -- vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
  vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
elseif vim.fn.has 'unix' == 1 then
  vim.g.python3_host_prog = '/usr/bin/python3.12'
end

-- vim: ts=2 sts=2 sw=2 et
