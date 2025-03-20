# Set installation paths on Windows
$BaseInstallPath = "D:\Tools"
$PythonPath = "$BaseInstallPath\Python"
$SQLitePath = "$BaseInstallPath\SQLite"
$PoetryPath = "$BaseInstallPath\Poetry"

# Function to check if a command exists
function Command-Exists {
    param ($command)
    return [bool](Get-Command $command -ErrorAction SilentlyContinue)
}

# Ensure the base install directory exists
if (!(Test-Path $BaseInstallPath)) {
    New-Item -ItemType Directory -Path $BaseInstallPath -Force | Out-Null
}

# Install Git if not installed
if (!(Command-Exists git)) {
    Write-Host "Git not found. Downloading and installing Git..."
    
    $GitInstallerUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-2.42.0-64-bit.exe"
    $GitInstallerPath = "$env:TEMP\git-installer.exe"

    Invoke-WebRequest -Uri $GitInstallerUrl -OutFile $GitInstallerPath

    Write-Host "Running Git installer..."
    Start-Process -FilePath $GitInstallerPath -ArgumentList "/VERYSILENT /NORESTART" -Wait

    if (Command-Exists git) {
        Write-Host "Git installed successfully."
    } else {
        Write-Host "Git installation failed. Please check manually: https://git-scm.com/download/win"
        exit 1
    }
} else {
    Write-Host "Git is already installed."
}

# Install Python if not installed
if (!(Command-Exists python)) {
    Write-Host "Python not found. Downloading and installing Python..."
    
    $PythonInstallerUrl = "https://www.python.org/ftp/python/3.12.1/python-3.12.1-amd64.exe"
    $PythonInstallerPath = "$env:TEMP\python-installer.exe"

    Invoke-WebRequest -Uri $PythonInstallerUrl -OutFile $PythonInstallerPath

    Write-Host "Running Python installer..."
    Start-Process -FilePath $PythonInstallerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

    if (Command-Exists python) {
        Write-Host "Python installed successfully."
    } else {
        Write-Host "Python installation failed. Please check manually: https://www.python.org/downloads/"
        exit 1
    }
} else {
    Write-Host "Python is already installed."
}

# Install SQLite if not installed
if (!(Command-Exists sqlite3)) {
    Write-Host "Installing SQLite..."
    
    $SQLiteUrl = "https://www.sqlite.org/2024/sqlite-tools-win-x64-3440200.zip"
    $SQLiteZipPath = "$env:TEMP\sqlite.zip"
    $SQLiteExtractPath = "$SQLitePath"

    Invoke-WebRequest -Uri $SQLiteUrl -OutFile $SQLiteZipPath
    Expand-Archive -Path $SQLiteZipPath -DestinationPath $SQLiteExtractPath -Force

    $SQLiteExe = "$SQLiteExtractPath\sqlite3.exe"
    if (Test-Path $SQLiteExe) {
        [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + $SQLiteExtractPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "SQLite installed successfully."
    } else {
        Write-Host "SQLite installation failed. Please check manually: https://www.sqlite.org/download.html"
        exit 1
    }
} else {
    Write-Host "SQLite is already installed."
}

# Install Poetry if not installed
if (!(Command-Exists poetry)) {
    Write-Host "Installing Poetry..."
    
    $PoetryInstallScriptUrl = "https://install.python-poetry.org"
    $PoetryInstallScriptPath = "$env:TEMP\install-poetry.py"

    Invoke-WebRequest -Uri $PoetryInstallScriptUrl -OutFile $PoetryInstallScriptPath

    Write-Host "Running Poetry installer..."
    python $PoetryInstallScriptPath

    $PoetryExe = "$env:USERPROFILE\.local\bin\poetry.exe"
    if (Test-Path $PoetryExe) {
        [System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";" + "$env:USERPROFILE\.local\bin", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Poetry installed successfully."
    } else {
        Write-Host "Poetry installation failed. Please check manually: https://python-poetry.org/docs/#installation"
        exit 1
    }
} else {
    Write-Host "Poetry is already installed."
}

# Install dependencies using Poetry
Write-Host "Installing Python dependencies from pyproject.toml..."
if (Test-Path "pyproject.toml") {
    Write-Host "Found pyproject.toml. Installing dependencies..."
    poetry install
    Write-Host "Dependencies installed successfully."
} else {
    Write-Host "Error: No pyproject.toml found in the current directory. Skipping dependency installation."
}

Write-Host "Installation complete. Restart your terminal to apply changes."
