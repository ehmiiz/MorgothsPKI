function New-MorgothHyperV {
    <#
    .SYNOPSIS
        Creates a new Hyper-V virtual machine named Morgoth with required folder structure.

    .DESCRIPTION
        Ensures Hyper-V is enabled, creates necessary folder structure in user space,
        and sets up a Generation 2 Hyper-V VM with predefined specifications.

    .EXAMPLE
        New-MorgothHyperV -SwitchName "Lab"

        Creates the folder structure and a new Morgoth VM using the Lab virtual switch.

    .NOTES
        Requires administrative privileges and Hyper-V feature to be available.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium")]
    param(
        # Name of the existing virtual switch to connect the VM to
        [ValidateNotNullOrEmpty()]
        [string]$SwitchName = "Lab",

        # Memory size in GB for the VM
        [Parameter()]
        [ValidateRange(1, 64)]
        [int]$MemoryGB = 2,

        # Size of the virtual hard disk in GB
        [Parameter()]
        [ValidateRange(20, 1000)]
        [int]$VHDSizeGB = 30
    )

    try {
        # Verify administrative privileges
        $currentPrincipal = [Security.Principal.WindowsPrincipal]::new(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )
        
        if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            throw "This function requires administrative privileges"
        }
        
        Write-Output "Welcome to the realm of Morgoth."

        # Define base folder structure
        $labRoot = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\WindowsPowerShell\Lab"
        $vmRoot = Join-Path -Path $labRoot -ChildPath "VirtualMachines"
        $morgothPath = Join-Path -Path $vmRoot -ChildPath "Morgoth"
        $vhdPath = Join-Path -Path $morgothPath -ChildPath "Virtual Hard Disks"
        $configPath = Join-Path -Path $morgothPath -ChildPath "Config"

        Write-Verbose "Creating folder structure..."
        # Create folder structure
        $foldersToCreate = @($labRoot, $vmRoot, $morgothPath, $vhdPath, $configPath)
        foreach ($folder in $foldersToCreate) {
            if (-not (Test-Path -Path $folder)) {
                if ($PSCmdlet.ShouldProcess($folder, "Create directory")) {
                    New-Item -Path $folder -ItemType Directory -Force | Out-Null
                    Write-Verbose "Created directory: $folder"
                }
            }
        }

        # Verify Hyper-V feature
        $feature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -ErrorAction Stop
        if ($feature.State -ne 'Enabled') {
            if ($PSCmdlet.ShouldProcess("Windows", "Enable Hyper-V feature")) {
                Write-Verbose "Enabling Hyper-V feature..."
                Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart -ErrorAction Stop
                Write-Warning "Hyper-V has been enabled, master. A system reboot is required before we spawn Morgoth."
                return
            }
        }

        # Prepare VM parameters
        $vhdxPath = Join-Path -Path $vhdPath -ChildPath "Morgoth.vhdx"
        $vmParams = @{
            Name               = "Morgoth"
            Generation        = 2
            MemoryStartupBytes = $MemoryGB * 1GB
            Path              = $morgothPath
            NewVHDPath        = $vhdxPath
            NewVHDSizeBytes   = $VHDSizeGB * 1GB
            SwitchName        = $SwitchName
        }

        # Create the VM
        if ($PSCmdlet.ShouldProcess("Morgoth", "Create new Hyper-V virtual machine")) {
            $vm = New-VM @vmParams -ErrorAction Stop
            Write-Verbose "Successfully created VM 'Morgoth'"

            # Add DVD drive
            Add-VMDvdDrive -VMName $vm.Name -ErrorAction Stop
            Write-Verbose "Successfully added DVD drive to VM 'Morgoth'"

            # Export VM configuration for reference
            $vmConfig = Get-VM -Name $vm.Name | Select-Object *
            $configFile = Join-Path -Path $configPath -ChildPath "vm-configuration.xml"
            $vmConfig | Export-Clixml -Path $configFile
            Write-Verbose "Exported VM configuration to: $configFile"
        }
    }
    catch {
        Write-Error -ErrorRecord $_ -ErrorAction Stop
    }
}