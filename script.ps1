Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Disable JIT debugging
[System.Diagnostics.Debugger]::Launch() # Prevent debugging

# Error Handling to avoid JIT debugging popup
try {
    # Create UI
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "StealthSync Configurator"
    $form.Size = New-Object System.Drawing.Size(600, 400) # Adjust size for proper centering
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::Black
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog # Prevent resizing
    $form.MaximizeBox = $false # Disable maximize button
    $form.MinimizeBox = $false # Disable minimize button

    # Create a TableLayoutPanel for centering content
    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.RowCount = 10 # Number of rows (adjust as needed)
    $tableLayoutPanel.ColumnCount = 1 # Only one column to center everything
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.CellBorderStyle = [System.Windows.Forms.TableLayoutPanelCellBorderStyle]::None
    $tableLayoutPanel.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))  # Take up full height
    $form.Controls.Add($tableLayoutPanel)

    # Header Label
    $headerLabel = New-Object System.Windows.Forms.Label
    $headerLabel.Text = "StealthSync"
    $headerLabel.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold)
    $headerLabel.ForeColor = [System.Drawing.Color]::White
    $headerLabel.AutoSize = $true
    $headerLabel.TextAlign = 'MiddleCenter'  # Center header text
    $tableLayoutPanel.Controls.Add($headerLabel, 0, 0)  # Add it to row 0, column 0
    $tableLayoutPanel.SetCellPosition($headerLabel, (New-Object System.Windows.Forms.TableLayoutPanelCellPosition(0, 0)))

    # Source Folder Selection
    $sourceLabel = New-Object System.Windows.Forms.Label
    $sourceLabel.Text = "Source Folder:"
    $sourceLabel.Anchor = 'Top, Left, Right'  # Center label text
    $tableLayoutPanel.Controls.Add($sourceLabel, 0, 1)  # Add to next row

    $sourceTextBox = New-Object System.Windows.Forms.TextBox
    $sourceTextBox.Size = New-Object System.Drawing.Size(250, 20)
    $sourceTextBox.Anchor = 'Top, Left, Right'  # Allow centering within layout
    $tableLayoutPanel.Controls.Add($sourceTextBox, 0, 2)

    $sourceButton = New-Object System.Windows.Forms.Button
    $sourceButton.Text = "..."
    $sourceButton.BackColor = [System.Drawing.Color]::Gray
    $sourceButton.ForeColor = [System.Drawing.Color]::White
    $sourceButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $sourceButton.Size = New-Object System.Drawing.Size(30, 22)
    $sourceButton.Anchor = 'Top, Left, Right'  # Center the button
    $sourceButton.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($folderBrowser.ShowDialog() -eq "OK") {
            $sourceTextBox.Text = $folderBrowser.SelectedPath
        }
    })
    $tableLayoutPanel.Controls.Add($sourceButton, 0, 3)

    # Target Folder Selection
    $targetLabel = New-Object System.Windows.Forms.Label
    $targetLabel.Text = "Target Folder:"
    $targetLabel.Anchor = 'Top, Left, Right'  # Center label text
    $tableLayoutPanel.Controls.Add($targetLabel, 0, 4)

    $targetTextBox = New-Object System.Windows.Forms.TextBox
    $targetTextBox.Size = New-Object System.Drawing.Size(250, 20)
    $targetTextBox.Anchor = 'Top, Left, Right'  # Allow centering within layout
    $tableLayoutPanel.Controls.Add($targetTextBox, 0, 5)

    $targetButton = New-Object System.Windows.Forms.Button
    $targetButton.Text = "..."
    $targetButton.BackColor = [System.Drawing.Color]::Gray
    $targetButton.ForeColor = [System.Drawing.Color]::White
    $targetButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $targetButton.Size = New-Object System.Drawing.Size(30, 22)
    $targetButton.Anchor = 'Top, Left, Right'  # Center the button
    $targetButton.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($folderBrowser.ShowDialog() -eq "OK") {
            $targetTextBox.Text = $folderBrowser.SelectedPath
        }
    })
    $tableLayoutPanel.Controls.Add($targetButton, 0, 6)

    # Encrypt & Zip Options
    $encryptCheckBox = New-Object System.Windows.Forms.CheckBox
    $encryptCheckBox.Text = "Encrypt Files"
    $encryptCheckBox.ForeColor = [System.Drawing.Color]::White
    $encryptCheckBox.Anchor = 'Top, Left, Right'  # Center checkbox text
    $tableLayoutPanel.Controls.Add($encryptCheckBox, 0, 7)

    $zipCheckBox = New-Object System.Windows.Forms.CheckBox
    $zipCheckBox.Text = "Archive Files (ZIP)"
    $zipCheckBox.ForeColor = [System.Drawing.Color]::White
    $zipCheckBox.Anchor = 'Top, Left, Right'  # Center checkbox text
    $tableLayoutPanel.Controls.Add($zipCheckBox, 0, 8)

    # Schedule Selection
    $scheduleLabel = New-Object System.Windows.Forms.Label
    $scheduleLabel.Text = "Sync Interval:"
    $scheduleLabel.Anchor = 'Top, Left, Right'  # Center label text
    $tableLayoutPanel.Controls.Add($scheduleLabel, 0, 9)

    $scheduleComboBox = New-Object System.Windows.Forms.ComboBox
    $scheduleComboBox.Size = New-Object System.Drawing.Size(200, 20)
    $scheduleComboBox.Items.Add("Daily") | Out-Null
    $scheduleComboBox.Items.Add("Weekly") | Out-Null
    $scheduleComboBox.Items.Add("Monthly") | Out-Null
    $scheduleComboBox.SelectedIndex = 0
    $scheduleComboBox.Anchor = 'Top, Left, Right'  # Center combo box
    $tableLayoutPanel.Controls.Add($scheduleComboBox, 0, 10)

    # Start Button
    $startButton = New-Object System.Windows.Forms.Button
    $startButton.Text = "Start Sync"
    $startButton.Size = New-Object System.Drawing.Size(150, 30)
    $startButton.BackColor = [System.Drawing.Color]::Green
    $startButton.ForeColor = [System.Drawing.Color]::White
    $startButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $startButton.Anchor = 'Top, Left, Right'  # Center the button
    $startButton.Add_Click({
        $sourceFolder = $sourceTextBox.Text
        $targetFolder = $targetTextBox.Text
        $logFile = "$targetFolder\sync.log"
        $interval = $scheduleComboBox.SelectedItem
        
        if (!(Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Path $targetFolder | Out-Null
        }
        
        function Sync-Files {
            $files = Get-ChildItem -Path $sourceFolder -File
            foreach ($file in $files) {
                $destination = "$targetFolder\$($file.Name)"
                if (!(Test-Path $destination) -or ((Get-Item $file.FullName).LastWriteTime -gt (Get-Item $destination).LastWriteTime)) {
                    Copy-Item -Path $file.FullName -Destination $destination -Force | Out-Null
                    "[$(Get-Date)] Synced: $($file.Name)" | Out-File -Append -FilePath $logFile
                }
            }
        }
        
        function Schedule-Task {
            $taskName = "StealthSyncTask"
            $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $PSCommandPath"
            
            switch ($interval) {
                "Daily" { $trigger = New-ScheduledTaskTrigger -Daily -At 12:00AM }
                "Weekly" { $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 12:00AM }
                "Monthly" { $trigger = New-ScheduledTaskTrigger -Monthly -Days 1 -At 12:00AM }
            }
            
            Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -User "SYSTEM" -RunLevel Highest -Force | Out-Null
        }
        
        Sync-Files
        Schedule-Task
        [System.Windows.Forms.MessageBox]::Show("Sync Scheduled and Completed", "StealthSync")
    })
    $tableLayoutPanel.Controls.Add($startButton, 0, 11)

    # Show the form
    $form.ShowDialog()

} catch {
    # Catch any errors to prevent JIT debugging
    Write-Host "Error: $_"
    [System.Windows.Forms.MessageBox]::Show("An error occurred: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}
