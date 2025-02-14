function Copy-MorgothVM {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$SourceVMName,
        [Parameter(Mandatory)]
        [string]$NewVMName
    )

    try {
        # Get source configuration
        $sourceConfig = Get-MorgothConfiguration -VMName $SourceVMName
        
        if ($sourceConfig) {
            # Create new VM with same specs
            $vmParams = @{
                Name               = $NewVMName
                Generation        = $sourceConfig.Generation
                MemoryStartupBytes = $sourceConfig.MemoryStartupBytes
                Path              = $sourceConfig.Path -replace $SourceVMName, $NewVMName
                SwitchName        = $sourceConfig.NetworkAdapters[0].SwitchName
                NewVHDPath        = $sourceConfig.HardDrives[0].Path -replace $SourceVMName, $NewVMName
                NewVHDSizeBytes   = $sourceConfig.HardDrives[0].ControllerLocation
            }

            if ($PSCmdlet.ShouldProcess($NewVMName, "Create clone VM")) {
                New-VM @vmParams
                Write-Verbose "Successfully cloned VM configuration from $SourceVMName to $NewVMName"
            }
        }
    }
    catch {
        Write-Error -ErrorRecord $_
    }
}