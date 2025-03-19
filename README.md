# Web Technologies Base Repository

## How to run

1. Install all required dependencies for the project with `install_dependencies.ps1` script
```
powershell -ExecutionPolicy Bypass -File install_dependencies.ps1
```

If you are unable to run this script due to security policies, run this command as well, and run the script again:

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

```

2. Install all dependencies:

```
poetry install
```

3. Run the app:

```
poetry run uvicorn src.main:app --reload
```

4. To uninstall dependencies, please run  `uninstall_dependencies.ps1` script
```
powershell -ExecutionPolicy Bypass -File uninstall_dependencies.ps1
```

