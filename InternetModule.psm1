function Save-InternetModule{
    [CmdletBinding()]
    [OutputType([void])]
    Param
    (
        [Parameter(Mandatory)]
        [string]
        [ValidateNotNullOrEmpty()]
        $Name
    )

    try{
        Save-Module -Name $Name -Path $PSScriptRoot -Force -ErrorVariable SaveResult -ErrorAction SilentlyContinue

        if ($SaveResult){
            'No existe el módulo {0}' -f $Name | Write-Host -ForegroundColor 'Red'
        }

        if (!$SaveResult){
            $Target = Join-Path -Path $PSScriptRoot -ChildPath $Name
            Get-ChildItem -Path $Target -Recurse -Filter '*.*' | Unblock-File
            'Modulo {0} descargado en {1}' -f $Name, $Target | Write-Host -ForegroundColor 'Green'
            "Utilice Restore-InternetModule -Path '$Target' para restaurar " | Write-Host -ForegroundColor 'Green'
        }
    }
    catch{
        throw
    }
}

function Restore-InternetModule{
    [CmdletBinding()]
    [OutputType([void])]
    Param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path -Path $PSItem -PathType 'Container'})]
        [string]
        $Path
    )

    try{
	    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
		    throw (New-Object -TypeName System.Security.SecurityException -ArgumentList 'Ejecute este script con un usuario del grupo Administradores.')
	    }

        $ModulePath = Join-Path -Path $env:ProgramFiles -Child '\WindowsPowerShell\Modules'
        $Target = Join-Path -Path $ModulePath -ChildPath (Split-Path -Path $Path -Leaf)
        Copy-Item -Path $Path -Destination $ModulePath -Container -Force -Recurse
        "Módulo restaurado a $Target" | Write-Host -ForegroundColor 'Green'
    }
    catch{
        throw
    }
}
