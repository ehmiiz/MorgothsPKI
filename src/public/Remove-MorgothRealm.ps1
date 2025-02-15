function Remove-MorgothRealm {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    param()

    try {
        # Verify the Dark Lord's authority
        $currentPrincipal = [Security.Principal.WindowsPrincipal]::new(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )
        
        if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            throw [System.UnauthorizedAccessException]::new(
                "Only those with the highest authority may unmake the Dark Realm. Run PowerShell as Administrator."
            )
        }

        Write-Output @"
██╗   ██╗███╗   ██╗███╗   ███╗ █████╗ ██╗  ██╗██╗███╗   ██╗ ██████╗ 
██║   ██║████╗  ██║████╗ ████║██╔══██╗██║ ██╔╝██║████╗  ██║██╔════╝ 
██║   ██║██╔██╗ ██║██╔████╔██║███████║█████╔╝ ██║██╔██╗ ██║██║  ███╗
██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═██╗ ██║██║╚██╗██║██║   ██║
╚██████╔╝██║ ╚████║██║ ╚═╝ ██║██║  ██║██║  ██╗██║██║ ╚████║╚██████╔╝
 ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
"@

        # List of realms to be unmade
        $vmNames = @(
            'AngbandDC',
            'MorgothRootCA',
            'SauronIntermediateCA',
            'ElfSubordinateCA',
            'HumanSubordinateCA',
            'DwarfSubordinateCA'
        )

        # First, stop all VMs if they exist
        foreach ($vmName in $vmNames) {
            $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
            
            if ($vm) {
                if ($PSCmdlet.ShouldProcess($vmName, "Halting the realm of")) {
                    Write-Verbose "The dark powers begin to unmake the realm of $vmName"
                    
                    if ($vm.State -eq 'Running') {
                        Stop-VM -Name $vmName -Force -ErrorAction Stop
                    }
                    
                    # Remove the VM and all its artifacts
                    Remove-VM -Name $vmName -Force -ErrorAction Stop
                    
                    # Get associated VHD paths before they're removed
                    $vhdPath = Join-Path -Path 'C:\VM' -ChildPath "$vmName.vhdx"
                    
                    if (Test-Path -Path $vhdPath) {
                        Remove-Item -Path $vhdPath -Force -ErrorAction Stop
                    }
                }
            }
        }

        # Remove all empty directories except ISO
        if ($PSCmdlet.ShouldProcess('C:\VM', "Cleansing the remnants of the Dark Realm")) {
            Get-ChildItem -Path 'C:\VM' -Directory | 
                Where-Object { $_.Name -ne 'ISO' } | 
                ForEach-Object {
                    if (-not (Get-ChildItem -Path $_.FullName -Recurse -File)) {
                        Remove-Item -Path $_.FullName -Force -Recurse
                    }
                }
        }

        Write-Output "The Dark Realm has been unmade, though the sacred ISO artifacts remain untouched."
    }
    catch {
        $PSCmdlet.ThrowTerminatingError(
            [System.Management.Automation.ErrorRecord]::new(
                $_.Exception,
                'DarkRealmUnmakingFailed',
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                $null
            )
        )
    }
} 