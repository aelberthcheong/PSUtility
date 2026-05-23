function Get-LineEnding {
    [CmdletBinding()]
    param ( 
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [switch]$Recurse
    )

    foreach ($p in Resolve-Path $Path -ErrorAction SilentlyContinue) {
        if (Test-Path $p -PathType "Container") {
            if ($Recurse) {
                Get-ChildItem -Path $p -File -Recurse:$Recurse | ForEach-Object {
                    Get-LineEnding -Path $_.FullName
                }
            }
            continue;
        }

        $content = [IO.File]::ReadAllText($p)
        $EOLType = if     ($content.Contains("`r`n")) { "CRLF" }
                   elseif ($content.Contains("`r"))   { "CR" }
                   elseif ($content.Contains("`n"))   { "LF" }
                   else                               { "None" }

        [PSCustomObject]@{
            Name = [IO.Path]::GetFileName($p)
            Type = $EOLType
            Path = $p.Path
        }
    }
}

function Get-FileLength {
    [CmdletBinding()]
    param ( 
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [switch]$Recurse,

        [Parameter(Mandatory=$false)]
        [ValidateSet("KB", "MB", "GB")]
        [string]$Unit
    )

    $divisor = switch ($Unit) {
        "KB" { 1KB }
        "MB" { 1MB }
        "GB" { 1GB }
    }

    foreach ($p in Resolve-Path $Path -ErrorAction SilentlyContinue) {
        if (Test-Path $p -PathType "Container") {
            if ($Recurse) {
                Get-ChildItem -Path $p -File -Recurse:$Recurse | ForEach-Object {
                    Get-FileLength -Path $_.FullName
                }
            }
            continue;
        }

        $file   = Get-Item $p
        $length = $divisor ? $file.length / $divisor : $file.length

        [PSCustomObject]@{
            Name   = [IO.Path]::GetFileName($p)
            Length = $Length
            Unit   = $Unit ? $Unit : "Bytes"
            Path   = $p.Path
        }
    }
}

function Invoke-Environment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [string] $cmd
    )

    cmd /c "`"$cmd`" > nul 2>&1 && set" | . { process {
        if ($_ -match "^([^=]+)=(.*)") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }}
}

function Set-MSVCEnvironment {
    [CmdletBinding()]
    param ()

    $Env:VSCMD_ARG_HOST_ARCH = "x64"
    $Env:VSCMD_ARG_TGT_ARCH  = "x64"
    $Env:VSCMD_ARG_APP_PLAT  = "Desktop"

    # Fun fact: jika kita remove trailing slash-nya, entah kenapa bakal error, cool... Windows amirite?
    $Env:VSINSTALLDIR = "C:\Program Files\Microsoft Visual Studio\18\Community\"

    Invoke-Environment (Join-Path $Env:VSINSTALLDIR "\Common7\Tools\vsdevcmd\ext\vcvars.bat")
    Invoke-Environment (Join-Path $Env:VSINSTALLDIR "\Common7\Tools\vsdevcmd\core\winsdk.bat")

    $Env:INCLUDE = @(
        $Env:__VSCMD_VCVARS_INCLUDE,
        $Env:__VSCMD_WINSDK_INCLUDE,
        $Env:__VSCMD_NETFX_INCLUDE
    ) -join ";"
}

function Resolve-NtStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int]$NtStatus
    )

    if (-not ([Management.Automation.PSTypeName]'NtDll.NtStatus').Type) {
        Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
namespace NtDll
{
    public class NtStatus
    {
        [DllImport("ntdll.dll")]
        public static extern uint RtlNtStatusToDosError(uint status);
    }
}
'@
    }

    # Cast [uint32] di .NET melakukan pengecekan nilai, bukan reinterpretasi bit sehingga
    # casting int negatif langsung ke uint32 raise exception. Maka, kita bit-AND dengan 0xFFFFFFFF:
    #   1. PowerShell mempromosikan kedua operand ke [long] (64-bit), melakukan sign-extension
    #      pada int (mengisi 32 bit atas dengan 1 karena MSB bernilai 1)
    #   2. 0xFFFFFFFF me-mask 32 bit atas tersebut, menyisakan hanya 32 bit bawah yang asli
    #   3. Hasilnya sekarang berupa [long] positif yang dapat di-cast ke [uint32] sesuai ekspetasi
    $uNtStatus = [uint32]($NtStatus -band 0xFFFFFFFFL)
    $errorCode = [NtDll.NtStatus]::RtlNtStatusToDosError($uNtStatus)

    # Convert win32 error code menjadi human readable message.
    # Kita perlu cast [int] karena constructor `Win32Exception` expect int sbgai param
    $message = ([ComponentModel.Win32Exception][int]$errorCode).Message

    [PSCustomObject]@{
        Status         = "0x$("{0:X8}" -f $NtStatus)"
        Win32ErrorCode = $errorCode
        Description    = $message
    }
}

New-Alias -Name gle -Value Get-LineEnding
New-Alias -Name gfl -Value Get-FileLength

Export-ModuleMember -Function * -Alias *