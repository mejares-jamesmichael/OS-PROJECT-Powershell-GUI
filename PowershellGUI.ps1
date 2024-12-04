Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Main Menu
Add-Type -AssemblyName System.Windows.Forms #Type

$FormObject = [System.Windows.Forms.Form] # Forms #MenuWindow
$LabelObject = [System.Windows.Forms.Label] # Text #MenuText
$ButtonObject = [System.Windows.Forms.Button] # Buttons #MenuButton
$ComboBox = [System.Windows.Forms.ComboBox] # ComboBox

# Create the first panel with a background color
$Panel = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#073AA3" #hex color
$Panel.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel.Dock = [System.Windows.Forms.DockStyle]::Top
$Panel.Height = 50

#Panel Text in the Homepage
$PanelText=New-Object $LabelObject # Sets the label
$PanelText.Text='♜ [O/S Project✔] ➣ 穏やかな.exe                                                 ⍰ ❏ ✖' # Text
$PanelText.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFCF5") #Font color
$PanelText.AutoSize= $true
$PanelText.Font='Impact, 13, style=Bold'
$PanelText.Location=New-Object System.Drawing.Point(5,15) # x, y

#Panel Page for Quick Guide Button
$Panel2 = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#FFFFFF" #hex color
$Panel2.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel2.Size = New-Object System.Drawing.Size(255, 300)
$Panel2.Location = New-Object System.Drawing.Point(30, 90)
$Panel2.Visible = $true

#Panel Text in Quick Guide Button
$PanelText2=New-Object $LabelObject # Sets the label
$PanelText2.Text='Quick Guide Window  _ ❏ ✖ ' # Text
$PanelText2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFCF5") #Font color
$backgroundHexColor = "#073AA3" #hex color
$PanelText2.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText2.AutoSize= $true
$PanelText2.Font='Consolas, 12, style=Bold'
$PanelText2.Location=New-Object System.Drawing.Point(0,0) # x, y

$PanelText3=New-Object $LabelObject # Sets the label
$PanelText3.Text='Set time for AutoDiskCleanup ➜' # Text
$PanelText3.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText3.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText3.AutoSize= $true
$PanelText3.Font='Consolas, 10'
$PanelText3.Location=New-Object System.Drawing.Point(10,120) # x, y

$PanelText4=New-Object $LabelObject # Sets the label
$PanelText4.Text='Check Disk Analyzer ➜➜➜➜➜' # Text
$PanelText4.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText4.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText4.AutoSize= $true
$PanelText4.Font='Consolas, 10'
$PanelText4.Location=New-Object System.Drawing.Point(10,160) # x, y

#Panel Page for Learn More about Devs
$Panel3 = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#FFFFFF" #hex color
$Panel3.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel3.Size = New-Object System.Drawing.Size(440, 300)
$Panel3.Location = New-Object System.Drawing.Point(30, 90)
$Panel3.Visible = $false

$HeaderText=New-Object $LabelObject # Sets the label
$HeaderText.Text='Need Help?' # Text
$HeaderText.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$HeaderText.AutoSize= $true
$HeaderText.Font='Consolas,11 , style=Underline'
$HeaderText.Location=New-Object System.Drawing.Point(10,55) # x, y

#HomnePage Window
$MenuWindow=New-Object $FormObject 
$MenuWindow.ClientSize='500,450' # (X,Y)
$MenuWindow.Text='Homepage' # Label above the window
$backgroundHexColor = "#C0C0C0" #hex color
$MenuWindow.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuWindow.StartPosition = 'CenterScreen'

# Set the form to be non-resizable
$MenuWindow.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$MenuWindow.MaximizeBox = $false  # Disable the maximize button

$MenuText=New-Object $LabelObject # Sets the label
$MenuText.Text='Hello User!' # Text
$MenuText.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$MenuText.AutoSize= $true
$MenuText.Font='Consolas,15' #Font, Size, style=style
$MenuText.Location=New-Object System.Drawing.Point(55,170) # x, y

$MenuText2=New-Object $LabelObject # Sets the label
$MenuText2.Text='Welcome...' # Text
$MenuText2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#374375") #Font color
$MenuText2.AutoSize= $true
$MenuText2.Font='Grandview, 32, style=Bold' #Font, Size, style=style
$MenuText2.Location=New-Object System.Drawing.Point(50,190) # x, y

$MenuText3=New-Object $LabelObject # Sets the label
$MenuText3.Text='What do you want to perform?' # Text
$MenuText3.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#374375") #Font color
$MenuText3.AutoSize= $true
$MenuText3.Font='Grandview,13' #Font, Size, style=style
$MenuText3.Location=New-Object System.Drawing.Point(55,245) # x, y

#AutoDiskCleanup Button
$MenuButton=New-Object $ButtonObject # AutoDiskCleanup Button
$MenuButton.Text='Disk Cleanup'
$MenuButton.AutoSize= $true
$MenuButton.Font='Lucida Console, 11, style=Regular'
$MenuButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#CACBCD" #hex color
$MenuButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton.Size=New-Object System.Drawing.Size(140,30)
$MenuButton.Location=New-Object System.Drawing.Point(300,200)

#DiskUsageAnalyzer Button
$MenuButton2=New-Object $ButtonObject # DiskUsageAnalyzer Button
$MenuButton2.Text='Disk Analyzer'
$MenuButton2.AutoSize= $true
$MenuButton2.Font='Lucida Console, 11, style=Regular'
$MenuButton2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#CACBCD" #hex color
$MenuButton2.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton2.Size=New-Object System.Drawing.Size(140,30)
$MenuButton2.Location=New-Object System.Drawing.Point(300,240)

#QuickGuide Button
$MenuButton3=New-Object $ButtonObject # QuickGuide Button
$MenuButton3.Text='Quick Guide'
$MenuButton3.AutoSize= $true
$MenuButton3.Font='Lucida Console, 11, style=Regular'
$MenuButton3.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#CACBCD" #hex color
$MenuButton3.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton3.Size=New-Object System.Drawing.Size(140,30)
$MenuButton3.Location=New-Object System.Drawing.Point(300,280)

#CheckTheDevs Button
$MenuButton4=New-Object $ButtonObject # CheckTheDevs Button
$MenuButton4.Text='Learn more about the Devs!'
$MenuButton4.AutoSize= $true
$MenuButton4.Font='Lucida Console, 11, style=Regular'
$MenuButton4.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#CACBCD" #hex color
$MenuButton4.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton4.Size=New-Object System.Drawing.Size(140,30)
$MenuButton4.Location=New-Object System.Drawing.Point(120,400)

$MenuButton.Add_Click({ # Triggers when ADC button is clicked
    $AutoDiskWindow.ShowDialog()
    $MenuWindow.Close()
})

#$MenuButton2.AddClick - For Disk Usage Analyzer

$MenuButton3.Add_Click({ #Triggers when Quick Guide Button is clicked
    if ($Panel2.Visible) {
        $Panel2.SendToBack()  # Move the panel behind the form background
        $Panel2.Visible = $false
    } else {
        $Panel2.Visible = $true
        $Panel2.BringToFront()  # Bring the panel to the front
    }
})

$MenuButton4.Add_Click({ #Triggers when Learn More about devs is clicked
    if ($Panel3.Visible) {
        $Panel3.SendToBack()  # Move the panel behind the form background
        $Panel3.Visible = $false
    } else {
        $Panel3.Visible = $true
        $Panel3.BringToFront()  # Bring the panel to the front
    }
})

#MenuWindow attachments(text, buttons, dropdownlist)
$MenuWindow.Controls.AddRange(@( $Panel, $Panel2, $Panel3, $HeaderText, $MenuText, $MenuText2, $MenuText3, $MenuButton, $MenuButton2, $MenuButton3, $MenuButton4))
$Panel.Controls.Add($PanelText)
$Panel2.Controls.AddRange(@($PanelText2, $PanelText3, $PanelText4))

# Form 2 - Automated Disk Cleanup
$AutoDiskWindow = New-Object $FormObject
$AutoDiskWindow.ClientSize = '400,170'
$AutoDiskWindow.Text = 'Automated Disk Cleanup'
$AutoDiskWindow.BackColor = 'white'
$AutoDiskWindow.StartPosition = 'CenterScreen'

$wText = New-Object $LabelObject # Text Form 2
$wText.Text = 'Set Time for Disk Cleanup:'
$wText.Autosize =  $true
$wText.Size = New-Object System.Drawing.Size(50,20)
$wText.Location = New-Object System.Drawing.Point(20,30)

$hourBox = New-Object $ComboBox # Hour drop down list
$hourBox.Text = 'hr'
$hourBox.Size = New-Object System.Drawing.Size(50,20)
$hourBox.Location = New-Object System.Drawing.Point(200,30)
$hourBox.Items.AddRange((0..23 | ForEach-Object {$_.ToString("D2") })) # 24 hour format (0-23)

$minuteBox = New-Object $ComboBox # Minute drop down list
$minuteBox.Text = 'min'
$minuteBox.Size = New-Object System.Drawing.Size(50,20)
$minuteBox.Location = New-Object System.Drawing.Point(260,30)
$minuteBox.Items.AddRange((0..59 | ForEach-Object {$_.ToString("D2") })) # 2 digit format (00-59)

# Submit Button
$submit_btn = New-Object $ButtonObject
$submit_btn.Text = 'Submit'
$submit_btn.Autosize =  $true
$submit_btn.Location = New-Object System.Drawing.Point(150,80)

# Button Click Event
$submit_btn.Add_Click({
    if ($hourBox.SelectedItem -and $minuteBox.SelectedItem) {
        # Retrieve the selected hour and minute
        $hour = $hourBox.SelectedItem
        $minute = $minuteBox.SelectedItem

        # Schedule the Disk Cleanup task
        Schedule-DiskCleanup -Hour $hour -Minute $minute
        [System.Windows.Forms.MessageBox]::Show("Disk Cleanup scheduled at $($hour):$($minute) daily.")
        $MenuWindow.Close()
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select both hour and minute.", "Error")
    }
})

# form2 attachments(text, buttons, dropdownlist)
$AutoDiskWindow.Controls.AddRange(@($wText, $hourBox, $minuteBox, $submit_btn))

# form3 - for Disk Usage Analyzer

# Display form 1 (Main Menu)
$MenuWindow.ShowDialog()