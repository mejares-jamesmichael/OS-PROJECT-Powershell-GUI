function Get-DiskUsageAnalyzer {
  function OnApplicationLoad { 

      # Check if the System.Windows.Forms.DataVisualization assembly is loaded
      if([Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization") -eq $null) 
      { 
          [void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
          [void][System.Windows.Forms.MessageBox]::Show("Microsoft Chart Controls for Microsoft .NET 3.5 Framework is required","Microsoft Chart Controls Required") 
          [System.Diagnostics.Process]::Start("http://www.microsoft.com/downloads/en/details.aspx?familyid=130F7986-BF49-4FE5-9CA8-910AE6EA442C&displaylang=en"); 
          return $false 
      } 

      return $true 
  }

  function OnApplicationExit { 
      $script:ExitCode = 0 
  }

  function Call-Disk_Space_Chart_pff { 

  [void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")     
  [void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
  [void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")  
  [void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") 
  [void][reflection.assembly]::Load("mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
  [void][reflection.assembly]::Load("System.Windows.Forms.DataVisualization, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35") 
      #endregion Import Assemblies 

  # Enable visual styles for the application
  [System.Windows.Forms.Application]::EnableVisualStyles() 
  $formDiskSpacePieChart = New-Object System.Windows.Forms.Form
  $formDiskSpacePieChart.StartPosition = "CenterScreen" 
      
  # Create a button for saving (commented out)
  #$buttonSave = New-Object System.Windows.Forms.Button 
  $dataGrid1 = New-Object System.Windows.Forms.DataGrid  
  $chart1 = New-Object System.Windows.Forms.DataVisualization.Charting.Chart 
      
  # Create a SaveFileDialog for saving files (commented out)
  #$savefiledialog1 = New-Object System.Windows.Forms.SaveFileDialog 
  $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
  #endregion Generated Form Objects 
      
  # Create a Refresh button
  $btnRefresh = New-Object System.Windows.Forms.Button 
  $btngetdata = New-Object System.Windows.Forms.Button 
  $rtbPerfData = New-Object System.Windows.Forms.RichTextBox 
      
  # Create a Label for displaying service pack information
  $lblServicePack = New-Object System.Windows.Forms.Label 
  $lblDBName = New-Object System.Windows.Forms.Label 
  $lblOS = New-Object System.Windows.Forms.Label 
  $statusBar1 = New-Object System.Windows.Forms.StatusBar 
  $btnClose = New-Object System.Windows.Forms.Button 
      
  # Create a ComboBox for selecting servers (commented out)
  #$comboServers = New-Object System.Windows.Forms.ComboBox 
  $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState 
  $txtComputerName = New-Object System.Windows.Forms.TextBox 
  $dataGrid1 = New-Object System.Windows.Forms.DataGrid  

  function Load-Chart { 
      # Define parameters for the Load-Chart function
      Param(
          [Parameter(Position=1, Mandatory=$true)] 
          [System.Windows.Forms.DataVisualization.Charting.Chart]$ChartControl,
          [Parameter(Position=2, Mandatory=$true)] 
          $XPoints,
          [Parameter(Position=3, Mandatory=$true)] 
          $YPoints,
          [Parameter(Position=4, Mandatory=$false)] 
          [string]$XTitle,
          [Parameter(Position=5, Mandatory=$false)] 
          [string]$YTitle,
          [Parameter(Position=6, Mandatory=$false)] 
          [string]$Title,
          [Parameter(Position=7, Mandatory=$false)] 
          [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]$ChartType,
          [Parameter(Position=8, Mandatory=$false)] 
          $SeriesIndex = 0,
          [Parameter(Position=9, Mandatory=$false)] 
          $TitleIndex = 0,
          [switch]$Append)

          # Initialize the ChartAreaIndex to 0
          $ChartAreaIndex = 0 

          # Check if the Append switch is set
          if($Append) 
          { 
              $name = "ChartArea " + ($ChartControl.ChartAreas.Count + 1).ToString(); 
              $ChartArea = $ChartControl.ChartAreas.Add($name) 
              $ChartAreaIndex = $ChartControl.ChartAreas.Count - 1 
              $name = "Series " + ($ChartControl.Series.Count + 1).ToString(); 
              $Series = $ChartControl.Series.Add($name)  
              $SeriesIndex = $ChartControl.Series.Count - 1 
              $Series.ChartArea = $ChartArea.Name

              # Check if the Title parameter is provided
              if($Title) 
              { 
                  $name = "Title " + ($ChartControl.Titles.Count + 1).ToString(); 
                  $TitleObj = $ChartControl.Titles.Add($name) 
                  $TitleIndex = $ChartControl.Titles.Count - 1  
                  $TitleObj.DockedToChartArea = $ChartArea.Name 
                  $TitleObj.IsDockedInsideChartArea = $false 
              } 
          }
          else 
          { 
              # If no title is provided, check if there are no chart areas
              if($ChartControl.ChartAreas.Count -eq 0) 
              { 
                  $name = "ChartArea " + ($ChartControl.ChartAreas.Count + 1).ToString(); 
                  [void]$ChartControl.ChartAreas.Add($name) 
                  $ChartAreaIndex = $ChartControl.ChartAreas.Count - 1 
              }  

              # Check if there are no series in the ChartControl
              if($ChartControl.Series.Count -eq 0) 
              { 
                  $name = "Series " + ($ChartControl.Series.Count + 1).ToString(); 
                  $Series = $ChartControl.Series.Add($name)  
                  $SeriesIndex = $ChartControl.Series.Count - 1 
                  $Series.ChartArea = $ChartControl.ChartAreas[0].Name 
              }
          }

          # Retrieve the series object from the ChartControl using the SeriesIndex
          $Series = $ChartControl.Series[$SeriesIndex] 
          $ChartArea = $ChartControl.ChartAreas[$Series.ChartArea] 
          $Series.Points.Clear()
          
          # Check if the Title parameter is provided
          if($Title) 
          { 
              # Check if there are no titles currently in the ChartControl
              if($ChartControl.Titles.Count -eq 0) 
              { 
                  $name = "Title " + ($ChartControl.Titles.Count + 1).ToString(); 
                  [void]$ChartControl.Titles.Add($name) 
                  $TitleIndex = $ChartControl.Titles.Count - 1 
                  $ChartControl.Titles[$TitleIndex].DockedToChartArea = $ChartArea.Name 
                  $ChartControl.Titles[$TitleIndex].IsDockedInsideChartArea = $false 
              } 

              # Set the text of the title to the provided Title parameter
              $ChartControl.Titles[$TitleIndex].Text = $Title 
          }

          # Check if the ChartType parameter is provided
          if($ChartType) 
          { 
              $Series.ChartType = $ChartType 
          } 

          # Check if the XTitle parameter is provided
          if($XTitle) 
          { 
              $ChartArea.AxisX.Title = $XTitle 
          } 

          # Check if the YTitle parameter is provided
          if($YTitle) 
          { 
              $ChartArea.AxisY.Title = $YTitle 
          } 

          # Check if XPoints is not an array or not enumerable
          if($XPoints -isnot [Array] -or $XPoints -isnot [System.Collections.IEnumerable]) 
          { 
              $array = New-Object System.Collections.ArrayList 
              $array.Add($XPoints) 
              $XPoints = $array 
          } 

          # Check if YPoints is not an array or not enumerable
          if($YPoints -isnot [Array] -or $YPoints -isnot [System.Collections.IEnumerable]) 
          { 
              $array = New-Object System.Collections.ArrayList 
              $array.Add($YPoints) 
              $YPoints = $array 
          } 

          # Bind the X and Y points to the series for plotting
          $Series.Points.DataBindXY($XPoints, $YPoints) 
      }

      function Clear-Chart 
      { 
          # Define parameters for the Clear-Chart function
          Param (   
              [Parameter(Position=1, Mandatory=$true)] 
              [System.Windows.Forms.DataVisualization.Charting.Chart]$ChartControl,
              [Parameter(Position=2, Mandatory=$false)] 
              [Switch]$LeaveSingleChart 
          ) 

          # Initialize a count variable to determine how many items to leave
          $count = 0  
      
          # If the LeaveSingleChart switch is set, set count to 1
          if($LeaveSingleChart) 
          { 
              $count = 1 
          } 

          # Remove series from the chart until the count of series is equal to $count
          while($ChartControl.Series.Count -gt $count) 
          { 
              $ChartControl.Series.RemoveAt($ChartControl.Series.Count - 1) 
          } 

          # Remove chart areas from the chart until the count of chart areas is equal to $count
          while($ChartControl.ChartAreas.Count -gt $count) 
          { 
              $ChartControl.ChartAreas.RemoveAt($ChartControl.ChartAreas.Count - 1) 
          } 

          # Remove titles from the chart until the count of titles is equal to $count
          while($ChartControl.Titles.Count -gt $count) 
          { 
              $ChartControl.Titles.RemoveAt($ChartControl.Titles.Count - 1) 
          } 

          # If there are any series left in the chart
          if($ChartControl.Series.Count -gt 0) 
          { 
              $ChartControl.Series[0].Points.Clear() 
          } 
      }

      function Load-PieChart 
      { 
          # Define parameters for the Load-PieChart function
          param( 
              [string[]]$servers = "$ENV:COMPUTERNAME" 
          ) 

          # Loop through each server in the servers array
          foreach ($server in $servers) { 
              $Disks = @(Get-WMIObject -Namespace "root\cimv2" -class Win32_LogicalDisk -Impersonation 3 -ComputerName $server -filter "DriveType=3") 

              # Remove all current charts from the chart control
              Clear-Chart $chart1 

              # Loop through each disk retrieved from WMI
              foreach($disk in $Disks) 
              {  
                  $UsedSpace = (($disk.size - $disk.freespace) / 1gb) 
                  $FreeSpace = ($disk.freespace / 1gb) 
                  Load-Chart $chart1 -XPoints ("Used ({0:N1} GB)" -f $UsedSpace), ("Free Space ({0:N1} GB)" -f $FreeSpace) -YPoints $UsedSpace, $FreeSpace -ChartType "Bar" -Title ("Volume: {0} ({1:N1} GB)" -f $disk.deviceID, ($disk.size / 1gb)) -Append  
              } 

              # Set custom style for the chart series
              foreach ($Series in $chart1.Series) 
              { 
                  $Series.CustomProperties = "PieDrawingStyle=Concave" 
              } 
          } 
      }

      function Get-DiskDetails 
      { 
          # Define parameters for the Get-DiskDetails function
          param( 
              [string[]]$ComputerName = "LocalHost" 
          ) 

          # Initialize an empty array to hold the results
          $Object = @() 
      
          # Create a new ArrayList to store the results
          $array = New-Object System.Collections.ArrayList       

          # Loop through each computer in the ComputerName array
          foreach ($Computer in $ComputerName) { 
              # Test if the computer is online by sending a ping
              if(Test-Connection -ComputerName $Computer -Count 1 -ea 0) { 
                  Write-Verbose "$Computer online" 
              
                  $D = Get-WmiObject win32_logicalDisk -ComputerName $Computer | 
                      select-object DeviceID, VolumeName, FreeSpace, Size, DriveType | 
                      ? { $_.DriveType -eq 3 }

                  # Loop through each disk retrieved
                  foreach($disk in $D) 
                  { 
                      $TotalSize = $Disk.Size / 1Gb -as [int] 
                      $InUseSize = ($Disk.Size / 1Gb -as [int]) - ($Disk.Freespace / 1Gb -as [int]) 
                      $FreeSpaceGB = $Disk.Freespace / 1Gb -as [int] 
                      $FreeSpacePer = ((($Disk.Freespace / 1Gb -as [float]) / ($Disk.Size / 1Gb -as [float])) * 100) -as [int] 

                      # Create a new PSObject with the disk details and add it to the Object array
                      $Object += New-Object PSObject -Property @{ 
                          Name = $Computer.ToUpper(); 
                          DeviceID = $Disk.DeviceID; 
                          VolumeName = $Disk.VolumeName; 
                          SizeGB = $TotalSize; 
                          InUseGB = $InUseSize; 
                          FreeSpaceGB = $FreeSpaceGB; 
                          PercentageGB = $FreeSpacePer 
                      }  
                  } 
              } 
          } 

          # Define column formatting for the output table
          $column1 = @{expression="Name"; width=30; label="Name"; alignment="left"} 
          $column2 = @{expression="DeviceID"; width=15; label="DeviceID"; alignment="left"} 
          $column3 = @{expression="VolumeName"; width=15; label="VolumeName"; alignment="left"} 
          $column4 = @{expression="SizeGB"; width=15; label="SizeGB"; alignment="left"} 
          $column5 = @{expression="InUseGB"; width=15; label="InUseGB"; alignment="left"} 
          $column6 = @{expression="FreeSpaceGB"; width=15; label="FreeSpaceGB"; alignment="left"} 
          $column7 = @{expression="PercentageGB"; width=15; label="PercentageGB"; alignment="left"} 

          # Format the output as a table using the defined columns
          # $Object|format-table $column1, $column2, $column3 ,$column4, $column5, $column6,$column7 

          # Uncomment the line above to display the formatted table in the console
          $object | format-table $column1, $column2, $column3 ,$column4 ,$column5 ,$column6, $column7 
          $array.AddRange($Object)  
          $dataGrid1.DataSource = $array  
      }

      # Define a script block to get disk space details
      $GetData = { 
          $statusBar1.text = "Getting Disk Space Details Data..please wait" 
      
          # Check if the specified computer is reachable by pinging it
          if(Test-Connection -ComputerName $txtComputerName.text -Count 1 -ea 0) {  
              $data = Get-DiskDetails -ComputerName $txtComputerName.text | Out-String 
              Load-PieChart -servers $txtComputerName.text  
          } 
          else 
          { 
              [Windows.Forms.MessageBox]::Show("Unable to connect to the server!!") 
          } 
      
          # Uncomment the line below to display the retrieved data in a RichTextBox (currently commented out)
          # $rtbPerfData.text = $data.Trim() 
          $errorActionPreference = "Continue" 
          $statusBar1.Text = "Ready" 
      } 

      # Define a script block to close the form
      $Close = { 
          $formDiskSpacePieChart.close() 
      }

      # Define a script block to correct the initial state of the form
      $Form_StateCorrection_Load = 
      { 
          $formDiskSpacePieChart.WindowState = $InitialFormWindowState 
      }

      # ----------formDiskSpacePieChart------------

      $formDiskSpacePieChart.Controls.Add($buttonSave) 
      $formDiskSpacePieChart.Controls.Add($chart1) 
      $formDiskSpacePieChart.ClientSize = New-Object System.Drawing.Size(575, 575) 
      $formDiskSpacePieChart.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $formDiskSpacePieChart.MinimumSize = New-Object System.Drawing.Size(300, 300) 
      $formDiskSpacePieChart.Name = "formDiskSpacePieChart" 
      $formDiskSpacePieChart.Text = "Disk Space Pie Chart" 
      $formDiskSpacePieChart.Controls.Add($btnRefresh) 
      $formDiskSpacePieChart.Controls.Add($lblServicePack) 
      $formDiskSpacePieChart.Controls.Add($lblOS) 
      $formDiskSpacePieChart.Controls.Add($lblDBName) 
      $formDiskSpacePieChart.Controls.Add($statusBar1)
      $formDiskSpacePieChart.Controls.Add($txtComputerName) 
      $formDiskSpacePieChart.ClientSize = New-Object System.Drawing.Size(600, 600) 
      $formDiskSpacePieChart.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $formDiskSpacePieChart.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::SizableToolWindow  
      $formDiskSpacePieChart.Name = "form1" 
      $formDiskSpacePieChart.Text = "Disk Usage Analyzer" 
      $formDiskSpacePieChart.add_Load($PopulateList) 
      $formDiskSpacePieChart.add_Load($FormEvent_Load) 
      
      
      # ---------Create a new Size object to define the dimensions of the data grid----------
      $System_Drawing_Size = New-Object System.Drawing.Size  
      $System_Drawing_Size.Width = 575 
      $System_Drawing_Size.Height = 125 

      $dataGrid1.Size = $System_Drawing_Size  
      $dataGrid1.DataBindings.DefaultDataSourceUpdateMode = 0  
      $dataGrid1.HeaderForeColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0)  
      $dataGrid1.Name = "dataGrid1"  
      $dataGrid1.DataMember = ""  
      $dataGrid1.TabIndex = 0  
      $System_Drawing_Point = New-Object System.Drawing.Point  
      $System_Drawing_Point.X = 13  
      $System_Drawing_Point.Y = 62 
      $dataGrid1.Location = $System_Drawing_Point 

      # Add the data grid control to the form's controls
      $formDiskSpacePieChart.Controls.Add($dataGrid1)  
      $dataGrid1.CaptionText = 'Disk Details'     

      # btnRefresh 
      $btnRefresh.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $btnRefresh.Enabled = $TRUE 
      $btnRefresh.Location = New-Object System.Drawing.Point(230, 35) 
      $btnRefresh.Name = "btnRefresh" 
      $btnRefresh.Size = New-Object System.Drawing.Size(95, 20) 
      $btnRefresh.TabIndex = 7 
      $btnRefresh.Text = "GetDiskSpace" 
      $btnRefresh.UseVisualStyleBackColor = $True 
      $btnRefresh.add_Click($GetData) 

      # lblDBName 
      $lblDBName.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $lblDBName.Font = New-Object System.Drawing.Font("Lucidaole", 8.25, 1, 3, 1) 
      $lblDBName.Location = New-Object System.Drawing.Point(13, 10) 
      $lblDBName.Name = "lblDBName" 
      $lblDBName.Size = New-Object System.Drawing.Size(178, 23) 
      $lblDBName.TabIndex = 0 
      $lblDBName.Text = "Enter Server Name" 
      $lblDBName.Visible = $TRUE 

      # txtComputerName 
      $txtComputerName.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $txtComputerName.Location = New-Object System.Drawing.Point(13, 35) 
      $txtComputerName.Name = "txtComputerName" 
      $txtComputerName.TabIndex = 1 
      $txtComputerName.Size = New-Object System.Drawing.Size(200, 70) 
      $txtComputerName.Visible = $TRUE 

      # lblServicePack 
      $lblServicePack.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $lblServicePack.Font = New-Object System.Drawing.Font("Lucidaole", 8.25, 1, 3, 1) 
      $lblServicePack.Location = New-Object System.Drawing.Point(13, 100) 
      $lblServicePack.Name = "lblServicePack" 
      $lblServicePack.Size = New-Object System.Drawing.Size(278, 23) 
      $lblServicePack.TabIndex = 0 
      $lblServicePack.Text = "ServicePack" 
      $lblServicePack.Visible = $False 

      # lblOS 
      $lblOS.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $lblOS.Font = New-Object System.Drawing.Font("Lucidaole", 8.25, 1, 3, 1) 
      $lblOS.Location = New-Object System.Drawing.Point(12, 77) 
      $lblOS.Name = "lblOS" 
      $lblOS.Size = New-Object System.Drawing.Size(278, 23) 
      $lblOS.TabIndex = 2 
      $lblOS.Text = "Service Information" 
      $lblOS.Visible = $False 

      # statusBar1 
      $statusBar1.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $statusBar1.Location = New-Object System.Drawing.Point(0, 365) 
      $statusBar1.Name = "statusBar1" 
      $statusBar1.Size = New-Object System.Drawing.Size(390, 22) 
      $statusBar1.TabIndex = 5 
      $statusBar1.Text = "statusBar1"  

      # chart1 
      $chart1.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right  
      $chart1.BackGradientStyle = [System.Windows.Forms.DataVisualization.Charting.GradientStyle]::TopBottom  
      $System_Windows_Forms_DataVisualization_Charting_ChartArea_1 = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
      $System_Windows_Forms_DataVisualization_Charting_ChartArea_1.Area3DStyle.Enable3D = $True 
      $System_Windows_Forms_DataVisualization_Charting_ChartArea_1.AxisX.Title = "Disk" 
      $System_Windows_Forms_DataVisualization_Charting_ChartArea_1.AxisY.Title = "Disk Space (MB)" 
      $System_Windows_Forms_DataVisualization_Charting_ChartArea_1.Name = "ChartArea1" 

      # Add the chart area to the chart
      [void]$chart1.ChartAreas.Add($System_Windows_Forms_DataVisualization_Charting_ChartArea_1) 
      $chart1.DataBindings.DefaultDataSourceUpdateMode = [System.Windows.Forms.DataSourceUpdateMode]::OnValidation  
      $chart1.Location = New-Object System.Drawing.Point(13, 200) 
      $chart1.Name = "chart1" 
      $System_Windows_Forms_DataVisualization_Charting_Series_2 = New-Object System.Windows.Forms.DataVisualization.Charting.Series 
      $System_Windows_Forms_DataVisualization_Charting_Series_2.ChartArea = "ChartArea1" 
      $System_Windows_Forms_DataVisualization_Charting_Series_2.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Pie  
      $System_Windows_Forms_DataVisualization_Charting_Series_2.CustomProperties = "DrawingStyle=Cylinder, PieDrawingStyle=Concave" 
      $System_Windows_Forms_DataVisualization_Charting_Series_2.IsVisibleInLegend = $False 
      $System_Windows_Forms_DataVisualization_Charting_Series_2.Legend = "Legend1" 
      $System_Windows_Forms_DataVisualization_Charting_Series_2.Name = "Disk Space" 

      # Add the series to the chart
      [void]$chart1.Series.Add($System_Windows_Forms_DataVisualization_Charting_Series_2) 
      $chart1.Size = New-Object System.Drawing.Size(575, 350) 
      $chart1.TabIndex = 0 
      $chart1.Text = "chart1" 
      $System_Windows_Forms_DataVisualization_Charting_Title_3 = New-Object System.Windows.Forms.DataVisualization.Charting.Title 
      $System_Windows_Forms_DataVisualization_Charting_Title_3.Alignment = [System.Drawing.ContentAlignment]::TopCenter  
      $System_Windows_Forms_DataVisualization_Charting_Title_3.DockedToChartArea = "ChartArea1" 
      $System_Windows_Forms_DataVisualization_Charting_Title_3.IsDockedInsideChartArea = $False 
      $System_Windows_Forms_DataVisualization_Charting_Title_3.Name = "Title1" 

      # Set the text displayed on the title to "Disk Space" 
      [void]$chart1.Titles.Add($System_Windows_Forms_DataVisualization_Charting_Title_3) 
      $InitialFormWindowState = $formDiskSpacePieChart.WindowState 
      $formDiskSpacePieChart.add_Load($Form_StateCorrection_Load) 
      return $formDiskSpacePieChart.ShowDialog() 

  } #End of Function

  # Call OnApplicationLoad to initialize 
  if(OnApplicationLoad -eq $true) 
  { 
      Call-Disk_Space_Chart_pff | Out-Null 
      OnApplicationExit 
  }
}