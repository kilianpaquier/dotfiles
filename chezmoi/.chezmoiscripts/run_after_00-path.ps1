$bin = Join-Path $HOME '.local\bin'
$path = [Environment]::GetEnvironmentVariable('Path', 'User')

if (($path -split ';') -notcontains $bin) {
  [Environment]::SetEnvironmentVariable('Path', "$path;$bin".TrimStart(';'), 'User')
}
