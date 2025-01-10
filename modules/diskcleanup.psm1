function Get-DiskCleanup {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    Add-Type -AssemblyName System.Windows.Forms

    # ---------------- GUI Forms & Objects ------------------------
    $WindowObj = [System.Windows.Forms.Form] # Forms = Window
    $LabelObject = [System.Windows.Forms.Label] # Text
    $ButtonObject = [System.Windows.Forms.Button] # Button
    $ComboBox = [System.Windows.Forms.ComboBox] # DropDownList
    $CheckBoxObj = [System.Windows.Forms.CheckBox] # CheckBox []
    $DataGridView = [System.Windows.Forms.DataGridView] # DataGridView
    # --------------------------------------------------------------

    # --------------------- Variable/s -----------------------
    $username = $env:UserName # Gets the current username logged in
    # --------------------------------------------------------

    <# 
    -> function CheckBoxWindow {..}
        A GUI function that allows user to select specific junk to be
        deleted later on. It also contains checkboxes.
    #>
    function CheckBoxWindow {
        # Automated Disk Cleanup Main Window 
        $adcWindow = New-Object $WindowObj
        $adcWindow.Height = 700
        $adcWindow.Width = 550
        $adcWindow.Text = "Select Junk"
        $adcWindow.StartPosition = "CenterScreen"

        # A text object = "Check the items you wish to delete"        
        $adcText = New-Object $LabelObject
        $adcText.Text = "Check the items you wish to delete"
        $adcText.Size = New-Object System.Drawing.Size(320,30)
        $adcText.Font = "Arial, 10, style=Bold"
        $adcText.Location = New-Object System.Drawing.Point(130,80)

        # CheckBox for Delivery Optimization Files 
        $deliveryOptBox = New-Object $CheckBoxObj
        $deliveryOptBox.Location = New-Object System.Drawing.Point(55,110)
        $deliveryOptBox.Size = New-Object System.Drawing.Size(300,40)
        $deliveryOptBox.Font = "Arial, 9"
        $deliveryOptBox.Checked = $false
        $deliveryOptBox.Text = "Delivery Optimization Files"

        # CheckBox for DirectX Files
        $direct_x = New-Object $CheckBoxObj
        $direct_x.Location = New-Object System.Drawing.Point(55,140)
        $direct_x.Size = New-Object System.Drawing.Size(300,40)
        $direct_x.Font = "Arial, 9"
        $direct_x.Checked = $false
        $direct_x.Text = "DirectX Shader Cache"

        # CheckBox for Downloaded Program Files.
        $downloadedFiles = New-Object $CheckBoxObj
        $downloadedFiles.Location = New-Object System.Drawing.Point(55,170)
        $downloadedFiles.Size = New-Object System.Drawing.Size(210,40)
        $downloadedFiles.Font = "Arial, 9"
        $downloadedFiles.Checked = $false
        $downloadedFiles.Text = "Downloaded Program Files"

        # CheckBox for Recycle Bin.
        $recycleBin = New-Object $CheckBoxObj
        $recycleBin.Location = New-Object System.Drawing.Point(55,200)
        $recycleBin.Size = New-Object System.Drawing.Size(210,40)
        $recycleBin.Font = "Arial, 9"
        $recycleBin.Checked = $false
        $recycleBin.Text = "Recycle Bin"

        # CheckBox for Setup Log Files.
        $setup_file = New-Object $CheckBoxObj
        $setup_file.Location = New-Object System.Drawing.Point(300,110)
        $setup_file.Size = New-Object System.Drawing.Size(250,40)
        $setup_file.Font = "Arial, 9"
        $setup_file.Checked = $false
        $setup_file.Text = "Setup Log Files"

        # CheckBox for Temporary files folder.
        $tempBox = New-Object $CheckBoxObj
        $tempBox.Location = New-Object System.Drawing.Point(300,140)
        $tempBox.Size = New-Object System.Drawing.Size(250,40)
        $tempBox.Font = "Arial, 9"
        $tempBox.Checked = $false
        $tempBox.Text = "Temporary Files"

        # CheckBox for Temporary Internet Files.
        $tempInBox = New-Object $CheckBoxObj
        $tempInBox.Location = New-Object System.Drawing.Point(300,170)
        $tempInBox.Size = New-Object System.Drawing.Size(300,40)
        $tempInBox.Font = "Arial, 9"
        $tempInBox.Checked = $false
        $tempInBox.Text = "Temporary Internet Files"

        # CheckBox for Thumbnail.
        $thumbnail = New-Object $CheckBoxObj
        $thumbnail.Location = New-Object System.Drawing.Point(300,200)
        $thumbnail.Size = New-Object System.Drawing.Size(300,40)
        $thumbnail.Font = "Arial, 9"
        $thumbnail.Checked = $false
        $thumbnail.Text = "Thumbnails"

        <# 
        -> $textNotif 
            A Text Object that will be used later on if the delButton was
            clicked. It contains blank string if it is the first time to
            open the program.
        #>
        $textNotif = New-Object $LabelObject
        $textNotif.Font = "Arial, style=Bold"
        $textNotif.ForeColor = "Red"
        $textNotif.Size = New-Object System.Drawing.Size(220,50)

        # Delete Button, Button Text is "Clean".
        $delButton = New-Object $ButtonObject
        $delButton.Text = "Clean"
        $delButton.Location = New-Object System.Drawing.Point(210,290)

        # DataGridView to display scanned data
        $dataGridView = New-Object $DataGridView
        $dataGridView.Location = New-Object System.Drawing.Point(90, 350)
        $dataGridView.Size = New-Object System.Drawing.Size(350, 200) # Adjusted size
        $dataGridView.ColumnCount = 3
        $dataGridView.Columns[0].Name = "Category"
        $dataGridView.Columns[1].Name = "Size"
        $dataGridView.Columns[2].Name = "Description"

        # Function to get the total size of files in a directory
        function Get-DirectorySize {
            param (
                [string]$path
            )
            if (Test-Path $path) {
                $totalSize = (Get-ChildItem -Path $path -File -Recurse | Measure-Object -Property Length -Sum).Sum
                return [math]::Round($totalSize / 1MB, 2)
            }
            return 0
        }

        # Populate DataGridView with categories and their total sizes
        $categories = @(
            @{Path = "$global:driveLetter\Users\$username\AppData\Local\Temp\*"; Description = "Temporary Files"},
            @{Path = "$global:driveLetter\Users\$username\AppData\Local\Microsoft\Windows\Explorer\*"; Description = "Thumbnails"},
            @{Path = "$global:driveLetter\Users\$username\AppData\Local\D3DSCache\*"; Description = "DirectX Shader Cache"},
            @{Path = "$global:driveLetter\Windows\Downloaded Program Files\*"; Description = "Downloaded Program Files"},
            @{Path = "$global:driveLetter\Windows\Panther\*"; Description = "Setup Log Files"},
            @{Path = "$global:driveLetter\Users\$username\AppData\Local\Microsoft\Windows\INetCache\IE\*"; Description = "Temporary Internet Files"},
            @{Path = "$global:driveLetter\Windows\SoftwareDistribution\DeliveryOptimization\*"; Description = "Delivery Optimization Files"},
            @{Path = "$global:driveLetter\$Recycle.Bin\*"; Description = "Recycle Bin"}
        )

        foreach ($category in $categories) {
            $size = Get-DirectorySize -path $category.Path
            $dataGridView.Rows.Add($category.Description, "$size MB", $category.Description)
        }

        # Triggers when button is clicked.
        $delButton.Add_Click({
            if ($deliveryOptBox.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Windows\SoftwareDistribution\DeliveryOptimization\*" -Force -Recurse
                Write-Host "Delivery Opt Box Cleaned Successfully."
            }

            if ($direct_x.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Users\$username\AppData\Local\D3DSCache\*" -Force -Recurse
                Write-Host "DirectX Shader Cache Files Cleaned Successfully."
            }

            if ($downloadedFiles.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Windows\Downloaded Program Files\*" -Force -Recurse
                Write-Host "Downloaded Program Files Cleaned Successfully."
            }

            if ($recycleBin.Checked -eq $true) {
                Clear-RecycleBin -Force
                Write-Host "Recycle Bin Cleaned Successfully."
            }
            
            if ($setup_file.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Windows\Panther\*" -Force -Recurse
                Write-Host "Setup Log Files Cleaned Successfully."
            }

            if ($tempBox.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Users\$username\AppData\Local\Temp\*" -Force -Recurse
                Write-Host "Temporary Files Cleaned Successfully."
            }

            if ($tempInBox.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Users\$username\AppData\Local\Microsoft\Windows\INetCache\IE\*" -Force -Recurse
                Write-Host "Temporary Internet Files Cleaned Successfully."
            }

            if ($thumbnail.Checked -eq $true) {
                Remove-Item "$global:driveLetter\Users\$username\AppData\Local\Microsoft\Windows\Explorer\*" -Force -Recurse
                Write-Host "Thumbnail Cleaned Successfully."
            }

            if ($tempBox.Checked -eq $true -or $recycleBin.Checked -eq $true -or $downloadedFiles.Checked -eq $true -or $tempInBox.Checked -eq $true -or $thumbnail.Checked -eq $true -or $direct_x.Checked -eq $true -or $setup_file.Checked -eq $true -or $deliveryOptBox.Checked -eq $true) {
                $textNotif.Location = New-Object System.Drawing.Point(195,260)
                $textNotif.Text = "Cleaning Successful."
            } else {
                $textNotif.Location = New-Object System.Drawing.Point(195,260)
                $textNotif.Text = "No items selected."
                Write-Host "No Items Selected."
            }
        })

        # Add objects to the window.
        $adcWindow.Controls.AddRange(@($adcText, $tempBox, $recycleBin, $delButton,
                                        $textNotif, $downloadedFiles, $tempInBox,
                                        $thumbnail, $direct_x, $setup_file,
                                        $deliveryOptBox, $dataGridView))

        # Opens the window
        $adcWindow.ShowDialog()

        # Close the window
        $adcWindow.Dispose()
    }

    #---------------------- GUI Variables (Main Window)
    $mainWindow = New-Object $WindowObj
    $mainWindow.ClientSize = '500,330'
    $mainWindow.Text = 'Automated Disk Cleanup'
    $mainWindow.StartPosition = 'CenterScreen'
    $mainWindow.FormBorderStyle = 'FixedSingle'
    $mainWindow.MaximizeBox = $false
    $mainWindow.MinimizeBox = $false

    $adcTitle = New-Object $LabelObject
    $adcTitle.Text = 'Automated Disk Cleanup'
    $adcTitle.Autosize = $true
    $adcTitle.Font = 'Lucida Console, 10, style=Regular'
    $adcTitle.Location = New-Object System.Drawing.Point(30,100)

    $ddlBox = New-Object $ComboBox
    $ddlBox.Size = New-Object System.Drawing.Size(150,50)
    $ddlBox.Font = 'Arial, 10'
    $ddlBox.Location = New-Object System.Drawing.Point(40,130)
    $ddlBox.DropDownStyle = 'DropDownList'

    $selectBtn = New-Object $ButtonObject
    $selectBtn.Text = 'Select Drive'
    $selectBtn.BackColor = 'salmon'
    $selectBtn.Location = New-Object System.Drawing.Point(80,160)

    $FreeSpaceText = New-Object $LabelObject
    $FreeSpaceText.Text = 'Free Space:'
    $FreeSpaceText.Location = New-Object System.Drawing.Point(270,130)

    $DisplayFreeSpace = New-Object $LabelObject
    $DisplayFreeSpace.Location = New-Object System.Drawing.Point(370,130)

    $TotalSpaceText = New-Object $LabelObject
    $TotalSpaceText.Text = 'Total Space:'
    $TotalSpaceText.Location = New-Object System.Drawing.Point(270,180)

    $DisplayTotalSpace = New-Object $LabelObject
    $DisplayTotalSpace.Location = New-Object System.Drawing.Point(370,180)

    $RefreshBtn = New-Object $ButtonObject
    $RefreshBtn.Text = 'Refresh'
    $RefreshBtn.Location = New-Object System.Drawing.Point(360,203)

    # ComboBox for selecting time
    $timeComboBox = New-Object $ComboBox
    $timeComboBox.Size = New-Object System.Drawing.Size(150,50)
    $timeComboBox.Font = 'Arial, 10'
    $timeComboBox.Location = New-Object System.Drawing.Point(40,200)
    $timeComboBox.DropDownStyle = 'DropDownList'
    $timeComboBox.Items.AddRange(@("12:00AM", "01:00AM", "02:00AM", "03:00AM", "04:00AM", "05:00AM", "06:00AM", "07:00AM", "08:00AM", "09:00AM", "10:00AM", "11:00AM", "12:00PM", "1:00PM", "2:00PM", "3:00PM", "4:00PM", "5:00PM", "6:00PM", "7:00PM", "8:00PM", "9:00PM", "10:00PM", "11:00PM"))

    # Button to save the selected time
    $saveTimeBtn = New-Object $ButtonObject
    $saveTimeBtn.Text = 'Save Time'
    $saveTimeBtn.Location = New-Object System.Drawing.Point(200,200)

    # Populate dropdown with drives
    $drives = Get-Volume
    foreach($drive in $drives) {
        if($null -ne $drive.DriveLetter) {
            $ddlBox.Items.Add($drive.DriveLetter)
        }
        if ($drive.DriveLetter -eq "C") {
            $ddlBox.Text = "C"
        }
    }

    $ddlBox.Add_SelectedIndexChanged({
        # Gets the available space and total space of the selected driver
        $global:driveLetter = $ddlBox.SelectedItem + ":"
        Write-Host $global:driveLetter
        $DriverDetails = Get-Volume -DriveLetter $ddlBox.SelectedItem
        $DriverFreeSpace = [math]::Round(($DriverDetails.SizeRemaining / 1GB), 2)
        $DisplayFreeSpace.Text = "$DriverFreeSpace GB"
        $DriverTotalSpace = [math]::Round(($DriverDetails.Size / 1GB), 2)
        $DisplayTotalSpace.Text = "$DriverTotalSpace GB"

        # To check if the variables returns the correct path/folder.
        Write-Host $global:driveLetter
    })

    $saveTimeBtn.Add_Click({
        $selectedTime = $timeComboBox.SelectedItem
        if ($selectedTime) {
            $taskName = "AutomatedDiskCleanup"
            $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\Users\james\OS-PROJECT-Powershell-GUI\modules\diskcleanup.psm1"
            $taskTrigger = New-ScheduledTaskTrigger -Daily -At $selectedTime
            $taskPrincipal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
            $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
            Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Principal $taskPrincipal -Settings $taskSettings -Force
            [System.Windows.Forms.MessageBox]::Show("Disk Cleanup scheduled at $selectedTime daily.", "Schedule Saved", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a time.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    $selectBtn.Add_Click({ CheckBoxWindow })
    $RefreshBtn.Add_Click({ 
        # APPLIES THE SAME PROCESS:
        # Gets the available space and total space of the selected driver
        $global:driveLetter = $ddlBox.SelectedItem + ":"
        Write-Host $global:driveLetter
        $DriverDetails = Get-Volume -DriveLetter $ddlBox.SelectedItem
        $DriverFreeSpace = [math]::Round(($DriverDetails.SizeRemaining / 1GB), 2)
        $DisplayFreeSpace.Text = "$DriverFreeSpace GB"
        $DriverTotalSpace = [math]::Round(($DriverDetails.Size / 1GB), 2)
        $DisplayTotalSpace.Text = "$DriverTotalSpace GB"

        # To check if the variables returns the correct path/folder.
        Write-Host $global:driveLetter
    })

    # Add controls to main window
    $mainWindow.Controls.AddRange(@($adcTitle, $ddlBox, $selectBtn, $FreeSpaceText, $DisplayFreeSpace, $TotalSpaceText, $DisplayTotalSpace, $RefreshBtn, $timeComboBox, $saveTimeBtn))

    # Display Main Window
    $mainWindow.ShowDialog()
}