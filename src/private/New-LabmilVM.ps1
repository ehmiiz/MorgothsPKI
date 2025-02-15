<#
.DESCRIPTION
Creates a hyper-v vm in C:\VM
.EXAMPLE
PS C:\> .\New-LabmilVM.ps1 -Name "DC01" -IsoPath "C:\Users\James\WinServ2022.iso"
Creates the first VM, copying the iso to C:\VM\ISO\ for the next one.
.EXAMPLE
PS C:\> .\New-LabmilVM.ps1 -Name "DC02"
Creates the a VM, using the iso in C:\VM\ISO\, with the provided name. The VM will be started.
.EXAMPLE
PS C:\> "DC2","DC3","DC4","PKI-ROOT","PKI-ISSUER" | Foreach-Object { .\New-LabmilVM.ps1 -Name $_ }
Uses a comma-seperated string to create 5 VMs with different names


.NOTES
Author: Emil Larsson - 2021-12-18
#>

function New-LabmilVM {
    [CmdletBinding()]
    param (
        # Name of the VM
        [Parameter(Mandatory = $true)]
        [string]$Name,
        # Provide iso-path on first-run
        [string]$IsoPath
    )

    if ($PSVersionTable.PSVersion.Major -lt 6) {
        Write-Verbose "Windows PowerShell detected, assuming windows client.."
    }
    else {
        # Verify Windows
        if (-not $IsWindows) {
            Write-Error "Hyper-V is a Windows feature only." -ErrorAction Stop
        }
    }


    # Verify Hyper-V
    $HyperV = Get-Service vmcompute
    if ($HyperV.Status -ne 'Running') {
        Write-Error "Hyper-V is not running - try: Enable-WindowsOptionalFeature -FeatureName 'Microsoft-Hyper-V' -Online " -ErrorAction Stop
    }

    # Verify Name
    if (-not $Name) {
        Write-Error "Name not provided, cannot create un-named VM." -ErrorAction Stop
    }

    # Verify Free Drive Space
    $DriveSpace = (Get-PSDrive -Name C | Select-Object -ExpandProperty Free) / 1GB
    if ($DriveSpace -lt 40) {
        Write-Error "40GB free disk storage is needed for implementation" -ErrorAction Stop
    }

    # Creates folders
    $null = New-Item ENV:\HYPERMIL_V -Value 'C:\VM' -ErrorAction SilentlyContinue
    $labmilFolders = "ISO", "DRIVE"
    $labmilFolders | ForEach-Object {
        if ( -not (Test-Path "$env:HYPERMIL_V\$_") ) {
            $null = New-Item "$env:HYPERMIL_V\$_" -ItemType Directory
        }
    }

    # Adds a readme file
    $labMilReadme = "$env:HYPERMIL_V\README.md"
    if ( -not ( Test-Path $labMilReadme ) ) {
        $readmeparams = @{
            ItemType    = 'File'
            Value       = "# PLACE ISO IN .\ISO`n- Will grab the first iso, so place only one in the ISO folder`n- will only create and start the VM, for ultimate lab-age"
            Name        = 'README.md'
            Path        = "$Env:HYPERMIL_V"
            ErrorAction = 'SilentlyContinue'
        }
        $null = New-Item @readmeparams
    }

    $Iso = (Get-Item $env:HYPERMIL_V\ISO\*.iso | Select-Object -First 1).FullName
    if (-Not $Iso) {
        if (-Not $IsoPath) {
            Write-Error "Provide ISO Path." -ErrorAction Stop
        }
        else {
            Write-Verbose "IsoPath provided. First-time setup."
            $IsoFile = Get-Item $IsoPath # used later on
        }
    }

    # Checks if name already exists
    $VMCheck = Get-VM $Name -ErrorAction SilentlyContinue
    if ($VMCheck.Name -eq $Name) {
        $NotSupportedException = New-Object -TypeName NotSupportedException -ArgumentList "The VM-Name provided already exists on the system."
        Write-Error -Exception $NotSupportedException -Category NotImplemented -ErrorAction Stop
    }

    # Find correct VMSwitch
    $DefaultSwitch = Get-VMSwitch 'Default Switch' -ErrorAction SilentlyContinue
    if ( -not $DefaultSwitch) {
        try {
            $DefaultSwitch = (Get-VMSwitch)[0]
        }
        catch {
            throw $error[0]
        }
    }


    # Create VM
    try {
        $labMilVMParams = @{
            Name               = $Name
            MemoryStartUpBytes = 1GB
            NewVHDPath         = "$env:HYPERMIL_V\DRIVE\$Name.vhdx"
            NewVHDSizeBytes    = 40GB
            SwitchName         = $DefaultSwitch.Name
        }
        New-VM @labMilVMParams | Out-Null
    }
    catch {
        Write-Error $error[0]
    }

    # Add Iso
    if ($Iso) {
        Add-VMDvdDrive -VMName $Name -Path $Iso
    }
    elseif ( (-Not $Iso) -and ( -not $IsoPath) ) {
        $NotSupportedException = New-Object -TypeName NotSupportedException -ArgumentList "No ISO exists and no IsoPath was provided. Provide a path to an iso for first-time use."
        Write-Error -Exception $NotSupportedException -Category NotImplemented -ErrorAction Stop
    }
    elseif ( (-Not $Iso) -and ( $IsoPath) ) {
        if ($IsoFile) {
            Copy-Item $IsoPath -Destination "$env:HYPERMIL_V\ISO\" -Verbose
            $Iso = (Get-Item $env:HYPERMIL_V\ISO\*.iso | Select-Object -First 1).FullName
            Add-VMDvdDrive -VMName $Name -Path $Iso
        }
        else {
            $NotSupportedException = New-Object -TypeName NotSupportedException -ArgumentList "Did not find an iso on path. Check that this iso exists. Path: $IsoPath"
            Write-Error -Exception $NotSupportedException -Category NotImplemented -ErrorAction Stop
        }
    
    }

    # Start VM
    Start-VM $Name

    $DataForEndResult = Get-VM -Name $Name | Select-Object State, DynamicMemoryEnabled, Generation, Status

    $EndReusult = [PSCustomObject]@{
        Name                 = $Name
        State                = $DataForEndResult.State
        Status               = $DataForEndResult.Status
        Iso                  = $Iso
        Drive                = $labMilVMParams.NewVHDPath
        Generation           = $DataForEndResult.Generation
        DynamicMemoryEnabled = $DataForEndResult.DynamicMemoryEnabled
        VirtualSwitch        = $labMilVMParams.SwitchName
        RAM                  = $labMilVMParams.MemoryStartUpBytes / 1GB
        DriveSpace           = $labMilVMParams.NewVHDSizeBytes / 1GB
    }

    $EndReusult
}