# Web Technologies Base Repository

## Prerequisites 
Installation scripts here rely on usage of (WinGet)[https://github.com/microsoft/winget-cli], it should be installed by default on Windows 11, but on Windows 10 it should be installed through App Installer in Microsoft Store (instructions for that are (here)[https://github.com/microsoft/winget-cli?tab=readme-ov-file#microsoft-store-recommended])

## How to run

1. Install all required dependencies for the project with `install_dependencies.ps1` script, please run it in Powershell terminal
```
powershell -ExecutionPolicy Bypass -File install_dependencies.ps1
```

If you are unable to run this script due to security policies, run this command as well, and run the script again:

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

```

2. Start the app through a script:

```
./start_app.ps1

```

3. For package management this app uses (uv)[https://github.com/astral-sh/uv], to view what can be used run this command in Powershell terminal:

```
uv --help
```

4. To uninstall dependencies, please run  `uninstall_dependencies.ps1` script
```
powershell -ExecutionPolicy Bypass -File uninstall_dependencies.ps1
```

