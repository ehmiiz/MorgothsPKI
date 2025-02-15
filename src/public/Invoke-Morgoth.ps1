function Invoke-Morgoth {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    # Verify elevated access and Hyper-V
    try {
        # Check for admin privileges
        $currentPrincipal = [Security.Principal.WindowsPrincipal]::new(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )
        
        if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            throw [System.UnauthorizedAccessException]::new(
                "This script requires elevated privileges. Please run PowerShell as Administrator."
            )
        }

        # Fast check if Hyper-V is enabled using WMI
        $hyperv = Get-CimInstance -Class Win32_ComputerSystem -ErrorAction Stop
        if (-not ($hyperv.HypervisorPresent)) {
            throw [System.InvalidOperationException]::new(
                "Hyper-V is not enabled on this system. Please enable Hyper-V using 'Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All'"
            )
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                $_.Exception,
                'HyperVPrerequisitesNotMet',
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                $null
            )
        )
    }

    # Define the path to the Dark Realm's artifacts
    $script:IsoPath = Join-Path -Path 'C:\VM' -ChildPath 'ISO'

    # Prepare the Dark Realm's foundation
    if (-not (Test-Path -Path $IsoPath)) {
        if ($PSCmdlet.ShouldProcess($IsoPath, "Forge directory for the Dark Realm's artifacts")) {
            New-Item -Path $IsoPath -ItemType Directory -Force | Out-Null
        }
    }

    # Check if we already have an ISO
    $existingIso = Get-Item -Path (Join-Path -Path $IsoPath -ChildPath '*.iso') -ErrorAction SilentlyContinue | Select-Object -First 1

    # Always show the ASCII art
    Write-Output @"
███╗   ███╗ ██████╗ ██████╗  ██████╗  ██████╗ ████████╗██╗  ██╗██╗███████╗
████╗ ████║██╔═══██╗██╔══██╗██╔════╝ ██╔═══██╗╚══██╔══╝██║  ██║   ██╔════╝
██╔████╔██║██║   ██║██████╔╝██║  ███╗██║   ██║   ██║   ███████║   ███████╗
██║╚██╔╝██║██║   ██║██╔══██╗██║   ██║██║   ██║   ██║   ██╔══██║   ╚════██║
██║ ╚═╝ ██║╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝   ██║   ██║  ██║   ███████║
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ╚═╝  ╚═╝   ╚══════╝
                         ██████╗ ██╗  ██╗██╗
                         ██╔══██╗██║ ██╔╝██║
                         ██████╔╝█████╔╝ ██║
                         ██╔═══╝ ██╔═██╗ ██║
                         ██║     ██║  ██╗██║
                         ╚═╝     ╚═╝  ╚═╝╚═╝
"@

    # Only prompt for ISO if none exists
    if (-not $existingIso) {
        Write-Output @"
To forge the Dark Realm, Morgoth requires the Windows Server 2025 artifacts.

The Dark Lord demands:
1. Journey to the Microsoft Evaluation Center (https://www.microsoft.com/evalcenter)
2. Acquire the Windows Server 2025 ISO
3. Place your offering in: $IsoPath

This artifact shall serve as the foundation for Morgoth's PKI infrastructure.
"@

        # Await the servant's confirmation
        Invoke-Item $IsoPath
        Read-Host "Press Enter once you have placed the sacred ISO in the Dark Realm's vault"
    } else {
        Write-Output "The Dark Lord acknowledges your previous offering: $($existingIso.Name)"
    }

    # Create VMs using splatting for better readability
    $vmParams = @{
        IsoPath = $existingIso.FullName # Use the existing ISO or the newly placed one
    }

    # Create infrastructure in logical order with clear comments
    # 1. Domain Controller
    $vmParams['Name'] = 'AngbandDC'
    New-LabmilVM @vmParams

    # 2. Root CA (Offline)
    $vmParams['Name'] = 'MorgothRootCA' 
    New-LabmilVM @vmParams

    # 3. Intermediate CA
    $vmParams['Name'] = 'SauronIntermediateCA'
    New-LabmilVM @vmParams
    
    # 4. Subordinate CAs
    foreach ($name in 'ElfSubordinateCA','HumanSubordinateCA','DwarfSubordinateCA') {
        $vmParams['Name'] = $name
        New-LabmilVM @vmParams
    }
}