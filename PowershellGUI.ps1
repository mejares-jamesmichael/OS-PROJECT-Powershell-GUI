# Allows to run script without restrictions. 
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Import scripts to main GUI
. "C:\Users\L E N O V O\Desktop\OS-PROJECT-Powershell-GUI\scripts\diskcleanup.ps1"
. "C:\Users\L E N O V O\Desktop\OS-PROJECT-Powershell-GUI\scripts\diskusage.ps1"

# Adds System.Windows.Forms library allowing to use GUI objects.
Add-Type -AssemblyName System.Windows.Forms #Type

# ------------------- GUI Forms & Objects --------------------------------
$FormObject = [System.Windows.Forms.Form] # Forms #MenuWindow
$LabelObject = [System.Windows.Forms.Label] # Text #MenuText
$ButtonObject = [System.Windows.Forms.Button] # Buttons #MenuButton
# -------------------------------------------------------------------------

# Create the first panel with a background color
$Panel = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#000082" #hex color
$Panel.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel.Dock = [System.Windows.Forms.DockStyle]::Top
$Panel.Height = 50

#Panel Text in the Homepage
$PanelText=New-Object $LabelObject # Sets the label
$PanelText.Text='♜ [OS Project] ➣ 오아시스 .exe                                                      ⍰   ❏   ✖' # Text
$PanelText.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFCF5") #Font color
$PanelText.AutoSize= $true
$PanelText.Font='Impact, 13'
$PanelText.Location=New-Object System.Drawing.Point(5,15) # x, y

$HeaderText=New-Object $LabelObject # Sets the label
$HeaderText.Text='➭ C:\Windows\system32\powershellGUI.ps1' # Text
$HeaderText.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$HeaderText.AutoSize= $true
$HeaderText.Font='Consolas,11, style=Underline'
$HeaderText.Location=New-Object System.Drawing.Point(10,55) # x, y

#Panel Page for Quick Guide Button
$Panel2 = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#FFFFFF" #hex color
$Panel2.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel2.Size = New-Object System.Drawing.Size(255, 290)
$Panel2.Location = New-Object System.Drawing.Point(30, 90)
$Panel2.Visible = $false

#Panel Text in Quick Guide Button
$PanelText2=New-Object $LabelObject # Sets the label
$PanelText2.Text=' Quick Guide Window _ ❏ ✖ ' # Text
$PanelText2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFCF5") #Font color
$backgroundHexColor = "#000082" #hex color
$PanelText2.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText2.AutoSize= $true
$PanelText2.Font='Consolas, 12, style=Bold'
$PanelText2.Location=New-Object System.Drawing.Point(0,0) # x, y

#PANEL TEXT FOR QUICK GUIDE WINDOW
$PanelText3=New-Object $LabelObject # Sets the label
$PanelText3.Text='Click this to set an automated time to run DiskCleanup               ➜' # Text
$PanelText3.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText3.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText3.AutoSize= $false
$PanelText3.Font='Consolas, 10'
$PanelText3.Size = New-Object System.Drawing.Size(220, 50) # Adjust size for multi-line text
$PanelText3.Location=New-Object System.Drawing.Point(10,85) # x, y

#PANEL TEXT FOR QUICK GUIDE WINDOW
$PanelText4=New-Object $LabelObject # Sets the label
$PanelText4.Text='Click to have a           ➜    comprehensive view of Disk Usage' # Text
$PanelText4.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText4.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText4.AutoSize= $false
$PanelText4.Font='Consolas, 10'
$PanelText4.Size = New-Object System.Drawing.Size(220, 50) # Adjust size for multi-line text
$PanelText4.Location=New-Object System.Drawing.Point(10,155) # x, y

#Panel Page for Learn More about Devs
$Panel3 = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#B3B4BA" #hex color grey
$Panel3.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel3.Size = New-Object System.Drawing.Size(440, 290)
$Panel3.Location = New-Object System.Drawing.Point(30, 90)
$Panel3.Visible = $false

#Panel Page for Learn More about Devs
$Panel4 = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#FFFFFF" #hex color white
$Panel4.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel4.Size = New-Object System.Drawing.Size(400, 200)
$Panel4.Location = New-Object System.Drawing.Point(20, 70)
$Panel4.Visible = $true

#PanelText for LearnMoreAboutDevs
$PanelText5=New-Object $LabelObject # Sets the label
$PanelText5.Text=' DevNote Window ver1.01                 _ ❏ ✖ ' # Text
$PanelText5.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFCF5") #Font color
$backgroundHexColor = "#000082" #hex color blue
$PanelText5.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText5.AutoSize= $true
$PanelText5.Font='Consolas, 12, style=Bold'
$PanelText5.Location=New-Object System.Drawing.Point(0,0) # x, y

#PanelText for LearnMoreAboutDevs
$PanelText6=New-Object $LabelObject # Sets the label
$PanelText6.Text='➭ C:\Windows\system32\powershellGUI.ps1\ReadDevNote.txt' # Text
$PanelText6.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#B3B4BA" #hex color
$PanelText6.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText6.AutoSize= $true
$PanelText6.Font='Consolas, 9,style=Underline'
$PanelText6.Location=New-Object System.Drawing.Point(10,35) # x, y

#PanelText for LearnMoreAboutDevs
$PanelText7=New-Object $LabelObject # Sets the label
$PanelText7.Text='DEV(s)_ n Contributors➭' # Text
$PanelText7.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText7.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText7.AutoSize= $false
$PanelText7.Font='Consolas, 20, style=Bold'
$PanelText7.Size = New-Object System.Drawing.Size(250, 80) # Adjust size for multi-line text
$PanelText7.Location=New-Object System.Drawing.Point(10,10) # x, y

#PanelText (Members of the group that contributed) LEARN MORE ABOUT DEVS WINDOW
$PanelText8=New-Object $LabelObject # Sets the label
$PanelText8.Text='James Michael Mejares  Justine Delima       Patricia Relente          Bea Ynion                  John Arroyo' # Text
$PanelText8.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText8.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText8.AutoSize= $false
$PanelText8.Font='Cascadia Code, 10'
$PanelText8.Size = New-Object System.Drawing.Size(230, 80) # Adjust size for multi-line text
$PanelText8.Location=New-Object System.Drawing.Point(50,90) # x, y

#PanelText laptop for Learn More about #devs LAPTOP ICON
$PanelText9=New-Object $LabelObject # Sets the label
$PanelText9.Text=':' # Laptop logo, colon displayed in wingdings fornt
$PanelText9.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#008282") #Font color
$backgroundHexColor = "#FFFFFF" #hex color
$PanelText9.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText9.AutoSize= $false
$PanelText9.Font='Wingdings, 70'
$PanelText9.Size = New-Object System.Drawing.Size(250, 90) # Adjust size for multi-line text
$PanelText9.Location=New-Object System.Drawing.Point(273,30) # x, y

#Panel Page for DEVLOG Window
$Panel5 = New-Object System.Windows.Forms.Panel
$backgroundHexColor = "#C3C3C3" #hex color grey
$Panel5.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$Panel5.Size = New-Object System.Drawing.Size(250, 180)
$Panel5.Location = New-Object System.Drawing.Point(10, 10)
$Panel5.Visible = $false

#PanelText for DEVlOG Window #HEADER THING
$PanelText10=New-Object $LabelObject # Sets the label
$PanelText10.Text=' DevLog Window ver1.0    _ ❏ ✖ ' # Text
$PanelText10.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFCF5") #Font color
$backgroundHexColor = "#000082" #hex color blue
$PanelText10.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText10.AutoSize= $true
$PanelText10.Font='Consolas, 10, style=Bold'
$PanelText10.Location=New-Object System.Drawing.Point(0,0) # x, y

#PanelText inside DEVLOG window
$PanelText11=New-Object $LabelObject # Sets the label
$PanelText11.Text='Final project for course Operating System

    Task: GUI Project 
        Automated Disk Cleanup 
        Disk Usage Analyzer        

Project started: October: 18, 2024
Project due date: January 17, 2025' # Text
$PanelText11.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000") #Font color
$backgroundHexColor = "#C3C3C3" #hex color
$PanelText11.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$PanelText11.AutoSize= $false
$PanelText11.Font='Lucida Consolas, 9'
$PanelText11.Size = New-Object System.Drawing.Size(500, 300) # Adjust size for multi-line text #x for horizontal y for vertical
$PanelText11.Location=New-Object System.Drawing.Point(12,40) # x, y #x for horizontal y for vertical

#Button for DEVLOG
$MenuButton5=New-Object $ButtonObject # RateUs! Button
$MenuButton5.Text='DevLog! ✍'
$MenuButton5.AutoSize= $true
$MenuButton5.Font='Lucida Console, 11, style=Regular'
$MenuButton5.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#C3C3C3" #hex color
$MenuButton5.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton5.Size=New-Object System.Drawing.Size(10,10)
$MenuButton5.Location=New-Object System.Drawing.Point(280,150)




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
$backgroundHexColor = "#C3C3C3" #hex color
$MenuButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton.Size=New-Object System.Drawing.Size(140,30)
$MenuButton.Location=New-Object System.Drawing.Point(300,200)

#DiskUsageAnalyzer Button
$MenuButton2=New-Object $ButtonObject # DiskUsageAnalyzer Button
$MenuButton2.Text='Disk Analyzer'
$MenuButton2.AutoSize= $true
$MenuButton2.Font='Lucida Console, 11, style=Regular'
$MenuButton2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#C3C3C3" #hex color
$MenuButton2.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton2.Size=New-Object System.Drawing.Size(140,30)
$MenuButton2.Location=New-Object System.Drawing.Point(300,240)

#QuickGuide Button
$MenuButton3=New-Object $ButtonObject # QuickGuide Button
$MenuButton3.Text='Quick Guide'
$MenuButton3.AutoSize= $true
$MenuButton3.Font='Lucida Console, 11, style=Regular'
$MenuButton3.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#C3C3C3" #hex color
$MenuButton3.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton3.Size=New-Object System.Drawing.Size(140,30)
$MenuButton3.Location=New-Object System.Drawing.Point(300,280)

#CheckTheDevs Button
$MenuButton4=New-Object $ButtonObject # CheckTheDevs Button
$MenuButton4.Text='Learn more about the Devs!'
$MenuButton4.AutoSize= $true
$MenuButton4.Font='Lucida Console, 11, style=Regular'
$MenuButton4.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$backgroundHexColor = "#C3C3C3" #hex color
$MenuButton4.BackColor = [System.Drawing.ColorTranslator]::FromHtml($backgroundHexColor) #translating hex color
$MenuButton4.Size=New-Object System.Drawing.Size(140,30)
$MenuButton4.Location=New-Object System.Drawing.Point(120,400)


#BUTTON FUNCTIONALITIES
$MenuButton.Add_Click({ # Triggers when AutoDiskCleanup button is clicked
    Get-DiskCleanup
})

$MenuButton2.Add_Click({ # Triggers when DiskUsageAnalyzer button is clicked
    Get-DiskUsageAnalyzer
})

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

$MenuButton5.Add_Click({ #Triggers when Learn More about devs is clicked
    if ($Panel5.Visible) {
        $Panel5.SendToBack()  # Move the panel behind the form background
        $Panel5.Visible = $false
    } else {
        $Panel5.Visible = $true
        $Panel5.BringToFront()  # Bring the panel to the front
    }
})


#MenuWindow attachments(text, buttons, dropdownlist) references for the entire system
$MenuWindow.Controls.AddRange(@( $Panel, $Panel2, $Panel3, $HeaderText, $MenuText, $MenuText2, $MenuText3, $MenuButton, $MenuButton2, $MenuButton3, $MenuButton4))
$Panel.Controls.Add($PanelText)
$Panel2.Controls.AddRange(@($PanelText2, $PanelText3, $PanelText4))
$Panel3.Controls.AddRange(@($Panel4, $PanelText5, $PanelText6))
$Panel4.Controls.AddRange(@($PanelText7,$PanelText8, $PanelText9, $MenuButton5,$Panel5))
$Panel5.Controls.AddRange(@($PanelText10,$PanelText11))




# Display form 1 (Main Menu)
$MenuWindow.ShowDialog()