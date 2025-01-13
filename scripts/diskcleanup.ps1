function Get-DiskCleanup {
    # Allows to run script without restrictions. 
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    # Adds System.Windows.Forms library allowing to use GUI objects.
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
            open the program. The main function of the $textNotif is to
            notify the user if the process is a success.
        #>
        $textNotif = New-Object $LabelObject
        $textNotif.Font = "Arial, style=Bold"
        $textNotif.ForeColor = "Red"
        $textNotif.Size = New-Object System.Drawing.Size(220,50)

        # Delete Button, Button Text is "Clean".
        $delButton = New-Object $ButtonObject
        $delButton.Text = "Clean"
        $delButton.Location = New-Object System.Drawing.Point(210,290)

        <# -> $dataGridView 
            DataGridView to display scanned data.
            The main function of $dataGridView is it creates a table object
            that displays the junks size in MegaBytes(MB) and junk
            description. #>
        $dataGridView = New-Object $DataGridView
        $dataGridView.Location = New-Object System.Drawing.Point(90, 350)
        $dataGridView.Size = New-Object System.Drawing.Size(350, 200) # Adjusted size
        $dataGridView.ColumnCount = 3
        $dataGridView.Columns[0].Name = "Category"
        $dataGridView.Columns[1].Name = "Size"
        $dataGridView.Columns[2].Name = "Description"

        <# -> "function Get-DirectorySize {}"
            A function to get the total size of files in a directory. 
            It has a parameter that gets every path/folder of junks later on. #>
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

        <#  -> "$categories @()"
            Insert DataGridView with categories and their total sizes.
            $categories variable is an array that contains the paths/folder 
            locations of junks and their description. #>
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

        <# -> "foreach ($category in $categories)" loop
            It loops to get each path/folder locations in the $categories array.
            and add it to each column in table object in the GUI.
            Then it computes the size of each path using the function
            "Get-DirectorySize." #>
        foreach ($category in $categories) {
            $size = Get-DirectorySize -path $category.Path
            $dataGridView.Rows.Add($category.Description, "$size MB", $category.Description)
        }

        <# -> "$delButton.Add_Click({})"
            Triggered when button is clicked. It contains many if-else condition
            that checks if the check box was checked. If the check box is
            checked, it will remove the files of the selected junks inside its
            folders. #>
        $delButton.Add_Click({
            if ($deliveryOptBox.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Windows\SoftwareDistribution\DeliveryOptimization\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "Delivery Optimization still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Delivery Opt Box Cleaned Successfully."
                }
            }
        
            if ($direct_x.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Users\$username\AppData\Local\D3DSCache\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "DirectX Shader Cache still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "DirectX Shader Cache Files Cleaned Successfully."
                }
            }
        
            if ($downloadedFiles.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Windows\Downloaded Program Files\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "Downloaded Program Files still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Downloaded Program Files Cleaned Successfully."
                }
            }
        
            if ($recycleBin.Checked -eq $true) {
                try {
                    Clear-RecycleBin -Force -ErrorAction Stop
                } catch {
                    Write-Host "Recycle Bin still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Recycle Bin Cleaned Successfully."
                }
            }
        
            if ($setup_file.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Windows\Panther\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "Setup Log Files still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Setup Log Files Cleaned Successfully."
                }
            }
        
            if ($tempBox.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Users\$username\AppData\Local\Temp\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "Temporary Files still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Temporary Files Cleaned Successfully."
                }
            }
        
            if ($tempInBox.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Users\$username\AppData\Local\Microsoft\Windows\INetCache\IE\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "Temporary Internet Files still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Temporary Internet Files Cleaned Successfully."
                }
            }
        
            if ($thumbnail.Checked -eq $true) {
                try {
                    Remove-Item "$global:driveLetter\Users\$username\AppData\Local\Microsoft\Windows\Explorer\*" -Force -Recurse -ErrorAction Stop
                } catch {
                    Write-Host "Thumbnails still retain files that are important or being used by another process"
                    # Error suppressed
                } finally {
                    Write-Host "Thumbnail Cleaned Successfully."
                }
            }
        
            # Notify the user about the outcome
            if ($tempBox.Checked -eq $true -or $recycleBin.Checked -eq $true -or $downloadedFiles.Checked -eq $true -or $tempInBox.Checked -eq $true -or $thumbnail.Checked -eq $true -or $direct_x.Checked -eq $true -or $setup_file.Checked -eq $true -or $deliveryOptBox.Checked -eq $true) {
                $textNotif.Location = New-Object System.Drawing.Point(195,260)
                $textNotif.Text = "Cleaning Successful."
            } else {
                $textNotif.Location = New-Object System.Drawing.Point(195,260)
                $textNotif.Text = "No items selected."
                Write-Host "No Items Selected."
            }
        })
            
        <# -> "$adcWindow.Controls.AddRange"
            It add objects to the window. #>
        $adcWindow.Controls.AddRange(@($adcText, $tempBox, $recycleBin, $delButton,
                                        $textNotif, $downloadedFiles, $tempInBox,
                                        $thumbnail, $direct_x, $setup_file,
                                        $deliveryOptBox, $dataGridView))

        # Opens/Shows the window
        $adcWindow.ShowDialog()

        # Close the window
        $adcWindow.Dispose()
    }

    #-------------------- GUI Variables (Main Window) -------------------------
    # $mainWindow - it declares a new window object. 
    $mainWindow = New-Object $WindowObj
    $mainWindow.ClientSize = '500,350'
    $mainWindow.Text = 'Automated Disk Cleanup'
    $mainWindow.StartPosition = 'CenterScreen'
    $mainWindow.FormBorderStyle = 'FixedSingle'
    $mainWindow.MaximizeBox = $false
    $mainWindow.MinimizeBox = $false

    # $adcTitle - A text object entitled "Automated Disk Cleanup"
    $adcTitle = New-Object $LabelObject
    $adcTitle.Text = 'Automated Disk Cleanup'
    $adcTitle.Autosize = $true
    $adcTitle.Font = 'Lucida Console, 10, style=Regular'
    $adcTitle.Location = New-Object System.Drawing.Point(30,100)

    <# $ddlBox - A drop down list, when clicked, it shows a list of drivers
        example: C:, D:, E: drive
    #>
    $ddlBox = New-Object $ComboBox
    $ddlBox.Size = New-Object System.Drawing.Size(150,50)
    $ddlBox.Font = 'Arial, 10'
    $ddlBox.Location = New-Object System.Drawing.Point(40,90)
    $ddlBox.DropDownStyle = 'DropDownList'

    # $selectBtn - A button object entitled "Select Drive."
    $selectBtn = New-Object $ButtonObject
    $selectBtn.Text = 'Select Drive'
    $selectBtn.BackColor = 'salmon'
    $selectBtn.Location = New-Object System.Drawing.Point(80,120)

    # $FreeSpaceText - A text object entitled "Free Space:"
    $FreeSpaceText = New-Object $LabelObject
    $FreeSpaceText.Text = 'Free Space:'
    $FreeSpaceText.Location = New-Object System.Drawing.Point(270,70)

    <# $DisplayFreeSpace - 
        A blank text object that will display free space size in gigabytes(GB)
        if a driver is selected. 
    #>
    $DisplayFreeSpace = New-Object $LabelObject
    $DisplayFreeSpace.AutoSize = $true
    $DisplayFreeSpace.Location = New-Object System.Drawing.Point(370,70)

    # $TotalSpaceText - A text object entitled "Total Space:"
    $TotalSpaceText = New-Object $LabelObject
    $TotalSpaceText.Text = 'Total Space:'
    $TotalSpaceText.Location = New-Object System.Drawing.Point(270,140)

    <# $DisplayTotalSpace - 
        A blank text object that will display total space size in gigabytes(GB)
        if a driver is selected.
    #>
    $DisplayTotalSpace = New-Object $LabelObject
    $DisplayTotalSpace.AutoSize = $true
    $DisplayTotalSpace.Location = New-Object System.Drawing.Point(370,140)

    <# $RefreshBtn -
        A button object entitled "Refresh". Its main function is to update
        the data of the free space size displayed in GUI.
    #>
    $RefreshBtn = New-Object $ButtonObject
    $RefreshBtn.Text = 'Refresh'
    $RefreshBtn.Location = New-Object System.Drawing.Point(320,170)

    <# $timeComboBox - 
        A drop down list that contains time. The user can set time to
        run the cleaning program automatically.
    #>
    $timeComboBox = New-Object $ComboBox
    $timeComboBox.Size = New-Object System.Drawing.Size(150,50)
    $timeComboBox.Font = 'Arial, 10'
    $timeComboBox.Location = New-Object System.Drawing.Point(40,200)
    $timeComboBox.DropDownStyle = 'DropDownList'
    $timeComboBox.Items.AddRange(@("12:00AM", "01:00AM", "02:00AM", "03:00AM", "04:00AM", "05:00AM", "06:00AM", "07:00AM", "08:00AM", "09:00AM", "10:00AM", "11:00AM", "12:00PM", "1:00PM", "2:00PM", "3:00PM", "4:00PM", "5:00PM", "6:00PM", "7:00PM", "8:00PM", "9:00PM", "10:00PM", "11:00PM"))

    # $saveTimeBtn - Button object to save the selected time
    $saveTimeBtn = New-Object $ButtonObject
    $saveTimeBtn.Text = 'Save Time'
    $saveTimeBtn.Location = New-Object System.Drawing.Point(200,200)

    # $drives - Gets the list of drives using the Get-Volume.
    $drives = Get-Volume

    <# "foreach($drive in $drives) loop"
        Adds available driver in drop down list. #>
    foreach($drive in $drives) {
        if($null -ne $drive.DriveLetter) {
            $ddlBox.Items.Add($drive.DriveLetter)
        }
        if ($drive.DriveLetter -eq "C") {
            $ddlBox.Text = "C"
        }
    }

    <# -> $ddlBox.Add_SelectedIndexChanged({..}) -
        Its main function is to get the size of the free space size and
        total space size of the driver in MB, convert it to gigabytes(GB) and
        return sizes in gigabytes(GB). #>
    $ddlBox.Add_SelectedIndexChanged({
        # Gets the available space and total space of the selected driver
        $global:driveLetter = $ddlBox.SelectedItem + ":"
        
        # $DriverDetails - Gets the details of the selected driver letter.
        $DriverDetails = Get-Volume -DriveLetter $ddlBox.SelectedItem
        
        # $DriverFreeSpace - Converts the free size MB to GB.
        $DriverFreeSpace = [math]::Round(($DriverDetails.SizeRemaining / 1GB), 2)
        $DisplayFreeSpace.Text = "$DriverFreeSpace GB"

        # $DriverTotalSpace - Converts the total size MB to GB.
        $DriverTotalSpace = [math]::Round(($DriverDetails.Size / 1GB), 2)
        $DisplayTotalSpace.Text = "$DriverTotalSpace GB"

        <# "Write-Host $global:driveLetter" -
            It writes the current driver selected by the user in the terminal.
            Its main function is to check if the $global:driveLetter 
            return the correct driver. #>
        Write-Host $global:driveLetter
    })

    <# $saveTimeBtn.Add_Click({..}) -
        Adds functionality to the "save" button. Its main function is to save
        time set by the user to clean the desktop.
    #>
    $saveTimeBtn.Add_Click({
        $selectedTime = $timeComboBox.SelectedItem
        if ($selectedTime) {
            $taskName = "AutomatedDiskCleanup"
            $taskAction = New-ScheduledTaskAction -Execute "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-File "C:\Users\$username\Desktop\OS-PROJECT-Powershell-GUI\PowershellGUI.ps1""
            $taskTrigger = New-ScheduledTaskTrigger -Daily -At $selectedTime
            $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
            Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings -Force
            [System.Windows.Forms.MessageBox]::Show("Disk Cleanup scheduled at $selectedTime daily.", "Schedule Saved", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a time.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    <# $selectBtn.Add_Click({..}) -
        Adds functionality to the "Select Driver" button. Its main function
        is to display the GUI of checkboxes of every junk. #>
    $selectBtn.Add_Click({ CheckBoxWindow })

    <# $RefreshBtn.Add_Click({..}) -
        Adds functionality to the "Refresh" button. Its main function is to
        update the free space size and total size of drivers in GB. #>
    $RefreshBtn.Add_Click({ 
        # Gets the available space and total space of the selected driver
        $global:driveLetter = $ddlBox.SelectedItem + ":"

        # $DriverDetails - Gets the details of the selected driver letter.
        $DriverDetails = Get-Volume -DriveLetter $ddlBox.SelectedItem

        # $DriverFreeSpace - Converts the free size MB to GB.
        $DriverFreeSpace = [math]::Round(($DriverDetails.SizeRemaining / 1GB), 2)
        $DisplayFreeSpace.Text = "$DriverFreeSpace GB"

        # $DriverTotalSpace - Converts the total size MB to GB.
        $DriverTotalSpace = [math]::Round(($DriverDetails.Size / 1GB), 2)
        $DisplayTotalSpace.Text = "$DriverTotalSpace GB"

        # To check if the $global:driveLetter return the correct driver in terminal.
        Write-Host $global:driveLetter
    })

    # Add objects to Automated Disk Cleanup Window
    $mainWindow.Controls.AddRange(@($adcTitle, $ddlBox, $selectBtn, $FreeSpaceText, $DisplayFreeSpace, $TotalSpaceText, $DisplayTotalSpace, $RefreshBtn, $timeComboBox, $saveTimeBtn))

    # Display Automated Disk Cleanup Window
    $mainWindow.ShowDialog()
}