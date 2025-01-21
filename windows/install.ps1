# -------------------------------------------------------------
# functions

function sudo {
    Start-Process -Verb RunAs -FilePath "powershell" -ArgumentList (@("-Command") + $args)
}

# -------------------------------------------------------------
# path update and user bin directory

# $userbin = "$env:userprofile\bin"
# New-Item -Path $userbin -ItemType "directory"
# [Environment]::SetEnvironmentVariable("PATH", [Environment]::GetEnvironmentVariable("PATH", "User") + [IO.Path]::PathSeparator + $userbin, "User")

# -------------------------------------------------------------
# workspace softwares

# Install-Module -Name Microsoft.WinGet.Client

# winget install --id Microsoft.PowerToys -e -i
# winget install --id=dbeaver.dbeaver -e -i
winget install --id=Microsoft.VisualStudioCode -e -i
winget install --id=Git.Git -e -i
winget install --id=Microsoft.OpenSSH.Beta -e -i
# winget install --id MSYS2.MSYS2 -e -i

# winget install --id=IDRIX.VeraCrypt -e -i
winget install --id=Yubico.YubikeyManager -e -i

winget install --id=Discord.Discord -e -i
# winget install --id=ElectronicArts.EADesktop -e -i
# winget install --id=EpicGames.EpicGamesLauncher -e -i
# winget install --id=Ubisoft.Connect -e -i
# winget install --id=Valve.Steam -e -i
# winget install --id=WeMod.WeMod -e -i

winget install --id=7zip.7zip -e -i
# winget install --id=AgileBits.1Password -e -i
winget install --id=Brave.Brave -e -i
# winget install --id=Microsoft.Edge -e -i
winget install --id=Microsoft.DotNet.DesktopRuntime.8 -e -i --architecture x86
winget install --id=Microsoft.DotNet.Runtime.8 -e -i --architecture x86
# winget install --id=Microsoft.PowerShell -e -i
# winget install --id=Microsoft.WindowsTerminal -e -i
winget install --id=Spotify.Spotify -e -i
winget install --id=TheDocumentFoundation.LibreOffice -e -i
# winget install --id=VideoLAN.VLC -e -i

# -------------------------------------------------------------
# yubikey minidriver

[xml]$downloads = $(Invoke-WebRequest -Uri "https://downloads.yubico.com/")
$minidriver = $($downloads.ListBucketResult.Contents.Key -match "YubiKey-Minidriver-.*-x64.msi" -notmatch ".*.msi_.sha256") # FIXME returning multiple version ...

Invoke-WebRequest -Uri "https://downloads.yubico.com/$minidriver" -OutFile "$env:temp\YubiKey-Minidriver-x64.msi"
msiexec /I "$env:temp\YubiKey-Minidriver-x64.msi"

# -------------------------------------------------------------
# yubikey

Invoke-WebRequest -Uri "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-latest-win64.msi" -OutFile "$env:temp\yubico-piv-tool-latest-win64.msi"
msiexec /I "$env:temp\yubico-piv-tool-latest-win64.msi"

sudo "[Environment]::SetEnvironmentVariable('PATH', [Environment]::GetEnvironmentVariable('PATH', 'Machine') + [IO.Path]::PathSeparator + '$env:programfiles\Yubico\Yubico PIV Tool\bin\', 'Machine')"
sudo "[Environment]::SetEnvironmentVariable('PATH', [Environment]::GetEnvironmentVariable('PATH', 'Machine') + [IO.Path]::PathSeparator + '$env:programfiles\Yubico\YubiKey Manager\', 'Machine')"

# -------------------------------------------------------------
# git with ssh signing windows

# sudo "Set-Service ssh-agent -StartupType Automatic; Start-Service ssh-agent; Get-Service ssh-agent"

# git config --global core.sshCommand "'$env:programfiles\OpenSSH\ssh.exe'"
# git config --global gpg.ssh.program "$env:programfiles\OpenSSH\ssh-keygen.exe"

# -------------------------------------------------------------
# zsh

# mkdir "$env:temp\zsh"
# Invoke-WebRequest -Uri "https://mirror.msys2.org/msys/x86_64/zsh-5.9-2-x86_64.pkg.tar.zst" -OutFile "$env:temp\zsh-5.9-2-x86_64.pkg.tar.zst"
# tar -xf "$env:temp\zsh-5.9-2-x86_64.pkg.tar.zst" -C "$env:temp\zsh"
# mv "$env:temp\zsh" "$env:programfiles\Git"

# & "$env:programfiles\Git\bin\bash.exe" -c "echo '[ -t 1 ] && exec zsh' > ~/.bashrc"

# -------------------------------------------------------------
# wsl

# sudo "DISM /Online /Enable-Feature /All /Norestart /FeatureName:Microsoft-Windows-Subsystem-Linux; DISM /Online /Enable-Feature /All /Norestart /FeatureName:VirtualMachinePlatform"

# -------------------------------------------------------------
# drawing

# winget install --id=dotPDNLLC.paintdotnet -e -i
# winget install --id=GIMP.GIMP -e -i
# winget install --id=Inkscape.Inkscape -e -i
