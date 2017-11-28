# Utils
Scripts varios de utilitarios

# InternetModule.psm1

### Save-InternetModule
Descarga un módulo de Internet y lo copia en una carpeta local.

### Restore-InternetModule
Copia un módulo descargado de Internet al directorio de módulos de PowerShell.

### Uso

```powershell
Import-Module .\InternetModule.psm1
Save-InternetModule -Name 'MyModuleName'


Import-Module .\InternetModule.psm1
Restore-InternetModule -Path 'C:\Temp\MyModuleName'

```

