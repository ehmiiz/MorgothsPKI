function Get-MorgothVMConfig {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Name of the virtual machine to retrieve configuration for"
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$VMName
    )

    process {
        foreach ($vm in $VMName) {
            try {
                $configPath = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\WindowsPowerShell\Lab\VirtualMachines\$vm\Config\vm-configuration.xml"
                
                if (-not (Test-Path -Path $configPath -PathType Leaf)) {
                    $PSCmdlet.WriteError([System.Management.Automation.ErrorRecord]::new(
                            [System.IO.FileNotFoundException]::new("Configuration file not found for VM: $vm"),
                            'VMConfigNotFound',
                            [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                            $configPath
                        ))
                    continue
                }

                Import-Clixml -Path $configPath -ErrorAction Stop
            }
            catch {
                $PSCmdlet.WriteError([System.Management.Automation.ErrorRecord]::new(
                        $_.Exception,
                        'VMConfigImportError',
                        [System.Management.Automation.ErrorCategory]::OperationStopped,
                        $configPath
                    ))
            }
        }
    }
}