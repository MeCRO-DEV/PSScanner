##########################################################
# PSScanner
# ---------
# Author: David Wang, Apr 2021 -V1.0
# Dependency: PSParallel (By Staffan Gustafsson)
# https://github.com/powercode/PSParallel
#
##########################################################
# The MIT License (MIT)
#
# Copyright (c) 2021, David Wang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and 
# associated documentation files (the "Software"), to deal in the Software without restriction, 
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.#>
##########################################################
#Requires -Version 5.0
[xml]$Global:xaml = {
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:PSSCanner"
        WindowStartupLocation="CenterScreen"
        FocusManager.FocusedElement="{Binding ElementName=TB_IPAddress}"
        Title="PSScanner" Height="778" Width="1034" ResizeMode="CanMinimize" BorderThickness="2" BorderBrush="LightGray">
        <Window.Resources>
            <Style TargetType="Button" x:Key="btnLime">
                <Setter Property="Background" Value="Yellow"/>
                <Setter Property="Foreground" Value="#000"/>
                <Setter Property="FontSize" Value="15"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button">
                            <Border Background="{TemplateBinding Background}" CornerRadius="5" BorderThickness="1" Padding="5" BorderBrush="#000">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center">
                                </ContentPresenter>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
                <Style.Triggers>
                    <Trigger Property="IsMouseOver" Value="True">
                        <Setter Property="Background" Value="Lime"/>
                        <Setter Property="Foreground" Value="#fff"/>
                    </Trigger>
                </Style.Triggers>
            </Style>
            <Style TargetType="Button" x:Key="btnBrown">
                <Setter Property="Background" Value="LightGray"/>
                <Setter Property="Foreground" Value="#000"/>
                <Setter Property="FontSize" Value="15"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button">
                            <Border Background="{TemplateBinding Background}" CornerRadius="5" BorderThickness="1" Padding="5" BorderBrush="#000">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center">
                                </ContentPresenter>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
                <Style.Triggers>
                    <Trigger Property="IsMouseOver" Value="True">
                        <Setter Property="Background" Value="Brown"/>
                        <Setter Property="Foreground" Value="#fff"/>
                    </Trigger>
                </Style.Triggers>
            </Style>
            <Style TargetType="Button" x:Key="btnGreen">
                <Setter Property="Background" Value="LightGray"/>
                <Setter Property="Foreground" Value="#000"/>
                <Setter Property="FontSize" Value="15"/>
                <Setter Property="Padding" Value="5"/>
                <Setter Property="Margin" Value="5"/>
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button">
                            <Border Background="{TemplateBinding Background}" CornerRadius="5" BorderThickness="1" Padding="5" BorderBrush="#000">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center">
                                </ContentPresenter>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>
                </Setter>
                <Style.Triggers>
                    <Trigger Property="IsMouseOver" Value="True">
                        <Setter Property="Background" Value="Green"/>
                        <Setter Property="Foreground" Value="#fff"/>
                    </Trigger>
                </Style.Triggers>
            </Style>
        </Window.Resources>
        <Grid Background="DarkCyan" HorizontalAlignment="Left" Width="1024">
            <TextBox x:Name="TB_IPAddress" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="4,4,0,0" VerticalAlignment="Top" Width="200" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="15" Background="LightYellow" TextAlignment="Center" ToolTip="Any IP in the target subnet"/>
            <TextBlock IsHitTestVisible="False" Text="IP Address" FontFamily="Courier New" FontSize="16" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="12,10,0,0" Foreground="DarkGray">
                <TextBlock.Style>
                    <Style TargetType="{x:Type TextBlock}">
                        <Setter Property="Visibility" Value="Collapsed"/>
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding Text, ElementName=TB_IPAddress}" Value="">
                                <Setter Property="Visibility" Value="Visible"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </TextBlock.Style>
            </TextBlock>
            <TextBox x:Name="TB_NetMask" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="206,4,0,0" VerticalAlignment="Top" Width="200" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="15" Background="LightYellow" TextAlignment="Center" ToolTip="Minimum [255.255.0.0]"/>
            <TextBlock IsHitTestVisible="False" Text="Subnet Mask" FontFamily="Courier New" FontSize="16" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="214,10,0,0" Foreground="DarkGray">
                <TextBlock.Style>
                    <Style TargetType="{x:Type TextBlock}">
                        <Setter Property="Visibility" Value="Collapsed"/>
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding Text, ElementName=TB_NetMask}" Value="">
                                <Setter Property="Visibility" Value="Visible"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </TextBlock.Style>
            </TextBlock>
            <TextBox x:Name="TB_CIDR" Text="24" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="408,4,0,0" VerticalAlignment="Top" Width="50" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="2" Background="LightYellow" TextAlignment="Center" ToolTip="CIDR [16-31]"/>
            <TextBlock IsHitTestVisible="False" Text="CIDR" FontFamily="Courier New" FontSize="16" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="412,10,0,0" Foreground="DarkGray">
                <TextBlock.Style>
                    <Style TargetType="{x:Type TextBlock}">
                        <Setter Property="Visibility" Value="Collapsed"/>
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding Text, ElementName=TB_CIDR}" Value="">
                                <Setter Property="Visibility" Value="Visible"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </TextBlock.Style>
            </TextBlock>
            <TextBox x:Name="TB_Threshold" Text="32" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="460,4,0,0" VerticalAlignment="Top" Width="60" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="3" Background="LightYellow" TextAlignment="Center" ToolTip="Runspacepool capacity [1-128]"/>
            <TextBlock IsHitTestVisible="False" Text="Threshold" FontFamily="Courier New" FontSize="10" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="462,14,0,0" Foreground="DarkGray">
                <TextBlock.Style>
                    <Style TargetType="{x:Type TextBlock}">
                        <Setter Property="Visibility" Value="Collapsed"/>
                        <Style.Triggers>
                            <DataTrigger Binding="{Binding Text, ElementName=TB_Threshold}" Value="">
                                <Setter Property="Visibility" Value="Visible"/>
                            </DataTrigger>
                        </Style.Triggers>
                    </Style>
                </TextBlock.Style>
            </TextBlock>
            <RadioButton x:Name="RB_Mask" Content="Mask" FontFamily="Courier New" FontSize="20" HorizontalAlignment="Left" Height="24" Margin="522,10,0,0" VerticalAlignment="Top" Width="70" Foreground="Cyan" ToolTip="Use subnet mask"/>
            <RadioButton x:Name="RB_CIDR" Content="CIDR" FontFamily="Courier New" FontSize="20" HorizontalAlignment="Left" Height="24" Margin="594,10,0,0" VerticalAlignment="Top" Width="70" Foreground="Cyan" ToolTip="Use CIDR"/>
            <CheckBox x:Name="CB_More" Content="More" FontFamily="Courier New" FontSize="20" HorizontalAlignment="Left" Height="24" Margin="666,10,0,0"  VerticalAlignment="Top" Width="70" Foreground="Lime" ToolTip="Show logon user and serial number"/>
            <CheckBox x:Name="CB_ARP" Content="ARP" FontFamily="Courier New" FontSize="20" HorizontalAlignment="Left" Height="24" Margin="738,10,0,0"  VerticalAlignment="Top" Width="70" Foreground="DarkOrange" ToolTip="Use ARP request"/>
            <TextBox x:Name="TB_Delay" Text="2" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="798,4,0,0" VerticalAlignment="Top" Width="27" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="1" Background="LightYellow" TextAlignment="Center" ToolTip="ARP Ping Delay (0-9ms)"/>
            <CheckBox x:Name="CB_CC" Content="" FontFamily="Courier New" FontSize="40" HorizontalAlignment="Left" Height="60" Margin="830,10,0,0"  VerticalAlignment="Top" Width="60" Foreground="DarkOrange" ToolTip="Clear ARP cache before scanning"/>
            <Button x:Name="BTN_Scan" Content="Scan" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="851,4,0,0" VerticalAlignment="Top" Width="60" Foreground="Blue" Style="{StaticResource btnLime}"/>
            <Button x:Name="BTN_Exit" Content="Exit" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="913,4,0,0" VerticalAlignment="Top" Width="60" Foreground="Blue" Style="{StaticResource btnBrown}"/>
            <Button x:Name="BTN_About" Content="" FontFamily="Courier New" FontSize="15" HorizontalAlignment="Left" Height="30" Margin="975,4,0,0" VerticalAlignment="Top" Width="35" Foreground="Yellow" Style="{StaticResource btnGreen}"/>
            <RichTextBox x:Name="RTB_Output" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="668" Margin="4,36,0,0" VerticalAlignment="Top" Width="1006" Background="Black" Foreground="LightGreen" IsReadOnly="true" HorizontalScrollBarVisibility="Auto" VerticalScrollBarVisibility="Visible" MaxWidth="4096">
                <FlowDocument  PageWidth="4096">
                    <Paragraph>
                        <Run Text=""/>
                    </Paragraph>
                </FlowDocument>
            </RichTextBox>
            <StatusBar HorizontalAlignment="Left" Height="26" Margin="4,706,0,0" VerticalAlignment="Top" Width="820">
                <StatusBarItem>
                    <TextBlock x:Name="SB" FontFamily="Courier New" FontSize="16" FontWeight="Bold" Foreground="Blue"/>
                </StatusBarItem>
            </StatusBar>
            <ProgressBar x:Name="PB" IsIndeterminate="False" HorizontalAlignment="Left" Height="26" Margin="824,706,0,0" VerticalAlignment="Top" Width="186" Background="LightYellow" Foreground="Blue"/>
        </Grid>
    </Window>
}

Import-Module PSParallel

$emoji_about  = [char]::ConvertFromUtf32(0x02753) # ❓
$emoji_box_h  = [char]::ConvertFromUtf32(0x02501) # ━

# Loading WPF assemblies 
try{
    Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase,system.windows.forms,System.Drawing
} catch {
    Throw "Failed to load WPF assemblies, script terminated."
}

# Initialize synchronized Hashtable and main window
$syncHash = [hashtable]::Synchronized(@{})
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$syncHash.window = [Windows.Markup.XamlReader]::Load($reader)

# AutoFind all controls
$syncHash.Gui = @{}
#$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'x:Name')]]") | ForEach-Object {
    if(!($_ -match "ColorAnimation" -or $_ -match "ThicknessAnimation")) {
        $syncHash.Gui.Add($_.Name, $syncHash.Window.FindName($_.Name)) 2>&1 3>&1 4>&1 | Out-Null
    }
}

# Initialize GUI controls
$syncHash.Gui.RB_CIDR.IsChecked = $true
$syncHash.Gui.RB_Mask.IsChecked = $false
$syncHash.Gui.TB_NetMask.IsEnabled = $false
$syncHash.GUI.TB_Delay.IsEnabled = $false
$syncHash.Gui.BTN_About.Content = "$emoji_about"
$syncHash.Gui.CB_CC.IsEnabled    = $false
$syncHash.Gui.CB_CC.IsChecked    = $true
$syncHash.Gui.SB.Text = $env:USERDNSDOMAIN + '\' + $env:USERNAME + ' | ' + $env:COMPUTERNAME + ' | ' + $env:NUMBER_OF_PROCESSORS + ' CPU Core(s)'

# create the runspace pool and pass the $syncHash variable through
$SessionVariable = New-Object 'Management.Automation.Runspaces.SessionStateVariableEntry' -ArgumentList 'syncHash', $syncHash, 'Synchronized hash table'

$SessionState = [Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$SessionState.Variables.Add($SessionVariable)
$MaxThreads = [int]$env:NUMBER_OF_PROCESSORS
$RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $MaxThreads, $SessionState, $Host)
$RunspacePool.ApartmentState = [Threading.ApartmentState]::STA
$RunspacePool.Open()

# create a "Jobs" array to track the created runspaces
$syncHash.Jobs = [System.Collections.ArrayList]@()

# Concurrent Q for output
$syncHash.Q = New-Object System.Collections.Concurrent.ConcurrentQueue[psobject]

# Control variable to trigger updating UI
[bool]$syncHash.ScanCompleted = $false

# Live Node counter, mutex protected
[int]$syncHash.Count = 0 # Microsoft claimed that synchronized hash table is thread safe, but it's not. I have to use mutex to protect it.

# Global mutex for accessing shared resources in threads
$Global:createdNew = $False # Stores Boolean value if the current PowerShell Process gets a lock on the Mutex
# Create the Mutex Object usin the constructuor -> Mutex Constructor (Boolean, String, Boolean)
$syncHash.mutex = New-Object -TypeName System.Threading.Mutex($false, "Tom", [ref]$Global:createdNew)

# check if there is any thread still running
Function isThreadRunning {
    $Queue = 0

    foreach($Job in $syncHash.Jobs){
        $Queue += if ($Job.Handle.IsCompleted -eq $false) { 1 } else { 0 }
    }

    if ($Queue -gt 0){
        return $true
    }

    return $false
}

# check if a thread is still running when exiting the GUI amd clean up when closing
$syncHash.Window.add_closing({
    [bool]$running = isThreadRunning
    if($running){
        [Windows.MessageBox]::Show(' Worker thread(s) running, please wait...',' Oops!','Ok','Error')
        $_.Cancel = $true
        return
    }
    # Cleanup mutex
    if($syncHash.mutex){
        $syncHash.mutex.Close()
        $syncHash.mutex.Dispose()
    }
    # Stop the timers
    if($syncHash.timer_terminal){
        $syncHash.timer_terminal.Stop()
    }
    if($syncHash.timer){
        $syncHash.timer.Stop()
    }
    Unregister-Event -SourceIdentifier Process_Result -Force
})

# Clean up the runspaces when exiting the GUI
$syncHash.Window.add_closed({
    foreach($Job in $syncHash.Jobs)
    {
        if ($Job.Session.IsCompleted -eq $true)
        {
            $Job.Session.EndInvoke($Job.Handle)
        }
        $RunspacePool.Close()
    }
})

# Exit button clicked
$syncHash.GUI.BTN_Exit.Add_Click({
    $syncHash.Window.close()
})

# Switch between Net mask and CIDR
$syncHash.GUI.RB_Mask.Add_Click({
    $syncHash.GUI.TB_NetMask.IsEnabled = $true
    $syncHash.GUI.TB_CIDR.IsEnabled = $false
    $syncHash.GUI.TB_CIDR.Clear()
})

# Switch between Net mask and CIDR
$syncHash.GUI.RB_CIDR.Add_Click({
    $syncHash.GUI.TB_NetMask.IsEnabled = $false
    $syncHash.GUI.TB_NetMask.Clear()
    $syncHash.GUI.TB_CIDR.IsEnabled = $true
})

# ARP seleced
$syncHash.GUI.CB_ARP.Add_Click({
    if($syncHash.GUI.CB_ARP.isChecked){
        $syncHash.GUI.TB_Delay.IsEnabled = $true
        $syncHash.Gui.CB_CC.IsEnabled    = $true
    } else {
        $syncHash.GUI.TB_Delay.IsEnabled = $false
        $syncHash.Gui.CB_CC.IsEnabled    = $false
    }
})

# IP input validation
$syncHash.Gui.TB_IPAddress.Add_TextChanged({
    if ($this.Text -match '[^0-9.]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9.]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# Network Mask input validation
$syncHash.Gui.TB_NetMask.Add_TextChanged({
    if ($this.Text -match '[^0-9.]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9.]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# Threshold input validation
$syncHash.Gui.TB_Threshold.Add_TextChanged({
    if ($this.Text -match '[^0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# Delay input validation
$syncHash.Gui.TB_Delay.Add_TextChanged({
    if ($this.Text -match '[^0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# CIDR input validation
$syncHash.Gui.TB_CIDR.Add_TextChanged({
    if ($this.Text -match '[^0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# When focus is on the output window, press ESC key to clear the output window
$handler_keypress = {
    [string]$key = ($_.key).ToString()
    if($key -match "Escape"){
        $syncHash.Gui.rtb_Output.Document.Blocks.Clear()
    }
    if($key -match "F12"){
        if(!(Test-Path -Path "C:\PSScanner")) {
            New-Item -Path "C:\PSScanner" -type directory -Force -ErrorAction Ignore -WarningAction Ignore -InformationAction Ignore | Out-Null
        }
        $range   = New-Object System.Windows.Documents.TextRange($syncHash.Gui.RTB_Output.Document.ContentStart, $syncHash.Gui.RTB_Output.Document.ContentEnd)
        $dt = Get-Date -Format "MM-dd-yyyy-HH-mm-ss"
        $path = "c:\PSScanner\" + '[' + $dt + ']' + '-output.txt'
        $fStream = [System.IO.FileStream]::New($path, [System.IO.FileMode]::Create)
        $range.Save($fStream, [System.Windows.DataFormats]::Text)
        $fStream.Close()
        Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "Screen saved." -NewLine $true
    }
}
$syncHash.Gui.RTB_Output.add_KeyDown($handler_keypress)

# Show output in UI thread
function Show-Result {
    [CmdletBinding()]
    param(
        [string]$Font,
        [string]$Size,
        [string]$Color,
        [string]$Text,
        [bool]$NewLine
    )
    
    try{
        $RichTextRange = New-Object System.Windows.Documents.TextRange( $syncHash.Gui.RTB_Output.Document.ContentEnd, $syncHash.Gui.rtb_Output.Document.ContentEnd ) 
    } catch {
    }

    if($Text){
        $RichTextRange.Text = $Text
    } else {
        $RichTextRange.Text = "          "
    }
    
    if($Color){
        try{
            $RichTextRange.ApplyPropertyValue( ( [System.Windows.Documents.TextElement]::ForegroundProperty ), $Color ) 2>&1 | Out-Null
        } catch {
        }
    } else {
        $RichTextRange.ApplyPropertyValue( ( [System.Windows.Documents.TextElement]::ForegroundProperty ), "Red" )
    }
    
    if($Font){
        try{
            $RichTextRange.ApplyPropertyValue( ( [System.Windows.Documents.TextElement]::FontFamilyProperty ), $Font ) 2>&1 | Out-Null
        } catch {
        }
        
    } else {
        $RichTextRange.ApplyPropertyValue( ( [System.Windows.Documents.TextElement]::FontFamilyProperty ), "Courier New" )
    }
    
    if($Size){
        try{
            $RichTextRange.ApplyPropertyValue( ( [System.Windows.Documents.TextElement]::FontSizeProperty ),   $Size ) 2>&1 | Out-Null
        } catch {
        }
        
    }else{
        $RichTextRange.ApplyPropertyValue( ( [System.Windows.Documents.TextElement]::FontSizeProperty ),   "18" )
    }
    
    if(!($NewLine -eq $null)){
        if($NewLine) { $syncHash.Gui.RTB_Output.AppendText("`r")}
    } 
    
    $syncHash.Gui.RTB_Output.ScrollToEnd()
}

# UI updating block, called by a timer dispatch
$syncHash.OutputResult = {
    $objHash = @{
        font    = ""
        size    = ""
        color   = ""
        msg     = ""
        newline = $false
    }
    if(!($syncHash.Q.IsEmpty)){
        [bool]$ok = $syncHash.Q.TryDequeue([ref]$objHash)

        if($ok){ # There is something ready to display
            Show-Result -Font $objHash.font -Size $objHash.size -Color $objHash.color -Text $objHash.msg -NewLine $objHash.newline
            if($objHash.msg -match "completed"){ # When completed, save the result to a file located in c:\PSScanner
                if(!(Test-Path -Path "C:\PSScanner")) {
                    New-Item -Path "C:\PSScanner" -type directory -Force -ErrorAction Ignore -WarningAction Ignore -InformationAction Ignore | Out-Null
                }
                $range   = New-Object System.Windows.Documents.TextRange($syncHash.Gui.RTB_Output.Document.ContentStart, $syncHash.Gui.RTB_Output.Document.ContentEnd)
                $dt = Get-Date -Format "MM-dd-yyyy-HH-mm-ss"
                $path = "c:\PSScanner\" + '(' + $dt + ')' + '-output.txt'
                $fStream = [System.IO.FileStream]::New($path, [System.IO.FileMode]::Create)
                $range.Save($fStream, [System.Windows.DataFormats]::Text)
                $fStream.Close()
                New-Event -SourceIdentifier Process_Result -MessageData $path
            }
        }
    }
}

# Show result in worker threads. Initially designed for calling from thread, but later I found it is not thread safe.
# It can be called from outside of thread
$syncHash.outputFromThread_scriptblock = {
    param (
        [string]$f,
        [string]$s,
        [string]$c,
        [string]$m,
        [bool]$n
    )
    $objHash = @{
        font    = $f
        size    = $s
        color   = $c
        msg     = $m
        newline = $n
    }
    $syncHash.Q.Enqueue($objHash)
}

#Timer for updating the terminal
$syncHash.timer_terminal = new-object System.Windows.Threading.DispatcherTimer

# Setup timer and callback for updating GUI
$syncHash.Window.Add_SourceInitialized({            
    $syncHash.timer_terminal.Interval = [TimeSpan]"0:0:0.10"
    $syncHash.timer_terminal.Add_Tick( $syncHash.OutputResult )
    $syncHash.timer_terminal.Start()
})

# Update UI
$syncHash.updateUI = {
    if($syncHash.ScanCompleted){
        $syncHash.ScanCompleted = $false

        if($syncHash.Gui.RB_CIDR.isChecked){
            $syncHash.Gui.TB_CIDR.IsEnabled      = $true
            $syncHash.Gui.TB_NetMask.IsEnabled   = $false
        } else {
            $syncHash.Gui.TB_CIDR.IsEnabled      = $false
            $syncHash.Gui.TB_NetMask.IsEnabled   = $true
        }
        $syncHash.Gui.TB_IPAddress.IsEnabled = $true
        $syncHash.Gui.TB_Threshold.IsEnabled = $true
        $syncHash.Gui.RB_Mask.IsEnabled      = $true
        $syncHash.Gui.RB_CIDR.IsEnabled      = $true
        $syncHash.Gui.CB_More.IsEnabled      = $true
        $syncHash.Gui.CB_ARP.IsEnabled       = $true
        $syncHash.Gui.BTN_Scan.IsEnabled     = $true
        $syncHash.Gui.BTN_About.IsEnabled    = $true
        $syncHash.Gui.BTN_Exit.IsEnabled     = $true
        if($syncHash.Gui.CB_ARP.isChecked){
            $syncHash.Gui.TB_Delay.IsEnabled = $true
            $syncHash.Gui.CB_CC.IsEnabled    = $true
        } else {
            $syncHash.Gui.TB_Delay.IsEnabled = $false
            $syncHash.Gui.CB_CC.IsEnabled    = $false
        }

        if(!(isThreadRunning)){ $syncHash.Gui.PB.IsIndeterminate = $false } # stop progressbar animation
    }
}

#Timer for updating the GUI
$syncHash.timer = new-object System.Windows.Threading.DispatcherTimer

# Setup timer and callback for updating GUI
$syncHash.Window.Add_SourceInitialized({            
    $syncHash.timer.Interval = [TimeSpan]"0:0:5.00" # 5 seconds delay
    $syncHash.timer.Add_Tick( $syncHash.updateUI )
    $syncHash.timer.Start()
})

# Setup event handler to sort the output file
$syncHash.PostPocess = {
    [string]$path = $event.messagedata
    $o = [System.Collections.ArrayList]@() # Original
    $h = [System.Collections.ArrayList]@() # header
    $f = [System.Collections.ArrayList]@() # Footer
    $w = [System.Collections.ArrayList]@() # Working collection

    function swapme{
        param(
            [int]$a,
            [int]$b
        )
        [string]$t = $w[$a]
        [string]$s = $o[$a]

        $w[$a] = $w[$b]
        $o[$a] = $o[$b]
        $w[$b] = $t
        $o[$b] = $s
    }

    function sortme { # Simple Bubble Sort algorithm
        [bool]$swapped = $true

        while($swapped){
            $swapped = $false
            for([int]$i = 0; $i -lt ($w.Count - 1); $i++){
                if($w[$i] -gt $w[$i+1]){
                    swapme -a $i -b ($i+1)
                    $swapped = $true
                }
            }
        }
    }

    $reader = [System.IO.File]::OpenText($path)
    try {
        while (($line = $reader.ReadLine()) -ne $null)
        {
            $t = $o.Add($line)
        }
    }
    finally {
        $reader.Close()
    }

    for($i=0; $i -lt 7; $i++) {
        $t = $h.Add($o[$i])
    }
    $o.RemoveRange(0,7)

    $e = $o.IndexOf("     ")
    $n = $o.Count - $e
    for($i=$e; $i -le $o.Count; $i++) {
        $t = $f.Add($o[$i])
    }
    $o.RemoveRange($e,$n)

    for($i = 0; $i -lt $o.Count; $i++) {
        $p = ($o[$i].Substring(0, 15)).trim().Split('.')
        for($j = 0; $j -lt 4; $j++){
            $p[$j] = $p[$j].Padleft(3,'0')
        }
        $t = $w.Add($p[0] + '.' + $p[1] + '.' + $p[2] + '.' + $p[3])
    }

    sortme

    for([int]$i = $h.Count - 1; $i -ge 0; $i--){
        $o.Insert(0, $h[$i])
    }

    for([int]$i = 0; $i -lt $f.Count; $i++){
        $t = $o.Add($f[$i])
    }

    $o | Out-File $path

    Rename-Item -Path $path -NewName $path.Replace("output", "Sorted") -Force
}

$null = Register-EngineEvent -SourceIdentifier Process_Result -Action $syncHash.PostPocess

# IP address validation
Function Test-IPAddress {
    param (
        [string]$IP
    )

    if(($ip -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") -and ($IP -as [IPAddress] -as [Bool])) {
        return $true
    } else {
        return $false
    }
}

# Subnet mask validation
function CheckSubnetMask ($SubnetMask)
{
	$IsValid = $true
	$MaskParts = @()
	$MaskParts +=$SubnetMask.split(".")

	if ($MaskParts.count -ne 4) {$IsValid =$false}
	
	if ($IsValid)
	{
		[reflection.assembly]::LoadWithPartialName("'Microsoft.VisualBasic") | Out-Null
		foreach ($item in $MaskParts)
		{
			if (!([Microsoft.VisualBasic.Information]::isnumeric($item))) {$IsValid = $false}
		}
	}
	
	if ($IsValid)
	{
		foreach ($item in $MaskParts)
		{
			$item = [int]$item
			if ($item -lt 0 -or $item -gt 255) {$IsValid = $false}
		}
	}
	
	if ($IsValid)
	{
		foreach ($item in $MaskParts)
		{
			$binary = [Convert]::ToString($item,2)
			if ($binary.length -lt 8)
			{
				do {
				$binary = "0$binary"
				} while ($binary.length -lt 8)
			}
			$strFullBinary = $strFullBinary+$binary
		}
		if ($strFullBinary.contains("01")) {$IsValid = $false}
		if ($IsValid)
		{
			$strFullBinary = $strFullBinary.replace("10", "1.0")
			if ((($strFullBinary.split(".")).count -ne 2)) {$IsValid = $false}
		}
	}
	Return $IsValid
}

# Calculate IP range
function Get-IPrange{ 
    param (
        [string]$start,
        [string]$end,
        [string]$ip,
        [string]$mask,
        [int]$cidr
    )

    function ConvertToINT64 () {
        param ($ip)

        $octets = $ip.split(".")
        return [int64]([int64]$octets[0]*16777216 +[int64]$octets[1]*65536 +[int64]$octets[2]*256 +[int64]$octets[3])
    }

    function ConvertToIP() {
        param ([int64]$int)

        return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
    }

    if ($ip) {$ipaddr = [Net.IPAddress]::Parse($ip)}
    if ($cidr) {$maskaddr = [Net.IPAddress]::Parse((ConvertToIP -int ([convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2)))) }  
    if ($mask) {$maskaddr = [Net.IPAddress]::Parse($mask)}  
    if ($ip) {$networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)}  
    if ($ip) {$broadcastaddr = new-object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))}  

    if ($ip) {  
        $startaddr = ConvertToINT64 -ip $networkaddr.ipaddresstostring  
        $endaddr = ConvertToINT64 -ip $broadcastaddr.ipaddresstostring  
    } else {  
        $startaddr = ConvertToINT64 -ip $start  
        $endaddr = ConvertToINT64 -ip $end  
    }  

    $temp="" | Select-Object start,end 
    $temp.start=ConvertToIP -int $startaddr 
    $temp.end=ConvertToIP -int $endaddr 
    return $temp 
}

# Make a colorful ribon for the output
$syncHash.Devider_scriptblock = {
    for($i=0;$i -lt 88;$i++) {
        if($i%2 -eq 0) {
            Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "=" -NewLine $false
        }
        if($i%2 -eq 1) {
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text "=" -NewLine $false
        }
    }
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "=" -NewLine $true
}

# Ping or ARP Scan worker thread
$syncHash.scan_scriptblock = {
    param(
        [string]$start,   # Start IP
        [string]$end,     # End IP
        [int]$threshold,  # Max number of threads
        [bool]$more,      # Fetch more info
        [bool]$arp,       # Use ARP scan
        [bool]$ARP_Clear, # Clear ARP Cache before scanning
        [int]$DelayMS     # Delay for arp ping
    )

    $StartArray = $start.Split('.')
    $EndArray = $end.Split('.')

    [int]$Oct3First = $StartArray[2] -as [int]
    [int]$Oct3Last  = $EndArray[2]   -as [int]
    [int]$Oct4First = $StartArray[3] -as [int]
    [int]$Oct4Last  = $EndArray[3]   -as [int]

    if($StartArray[0] -ne $EndArray[0]){
        $msg = "IP range too large to handle. [CIDR >= 16] or [Subnet Mask >= 255.255.0.0]"
        Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Yellow",$msg,$true
        $syncHash.ScanCompleted = $true
        return
    }

    if($StartArray[1] -ne $EndArray[1]){
        $msg = "IP range too large to handle. [CIDR >= 16] or [Subnet Mask >= 255.255.0.0]"
        Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Yellow",$msg,$true
        $syncHash.ScanCompleted = $true
        return
    }

    $Time = [System.Diagnostics.Stopwatch]::StartNew()

    $syncHash.mutex.WaitOne()
    $syncHash.Count = 0
    $syncHash.mutex.ReleaseMutex()
    
    # Calculate IP address set based on IP range
    # In case of 16 <= CIDR < 24
    if($StartArray[2] -ne $EndArray[2]){
        if($Oct4First -eq 0){
            $Oct4First++
        }

        if($Oct4Last -eq 255){
            $Oct4Last--
        }

        $IPAddresses = $Oct3First..$Oct3Last | ForEach-Object {
            $t = $_
            $Oct4First..$Oct4Last | ForEach-Object {
                $StartArray[0]+'.'+$StartArray[1]+'.'+$t+'.'+$_
            }
        }
    } elseif(($StartArray[2] -eq $EndArray[2]) -and ($StartArray[3] -ne $EndArray[3])){ # In case of CIDR >= 24
        if($Oct4First -eq 0){
            $Oct4First++
        }

        if($Oct4Last -eq 255){
            $Oct4Last--
        }

        $IPAddresses = $Oct4First..$Oct4Last | ForEach-Object {$StartArray[0]+'.'+$StartArray[1]+'.'+$StartArray[2]+'.'+$_}
    }

    $msg = "IP"
    $msg = $msg.PadRight(17,' ') + "Hostname"

    if($more){
        $msg = $msg.PadRight(49,' ') + "Logon-User"
        $msg = $msg.PadRight(69,' ') + "SerialNumber"
        if($arp) { $msg = $msg.PadRight(83,' ') + "MAC-Address" }
    } else {
        if($arp) { $msg = $msg.PadRight(64,' ') + "MAC-Address" }
    }
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Yellow",$msg,$true

    if($arp){
        if($ARP_Clear) {
            arp -d # Clear ARP cache
        }

        $ArpScriptBlock = { # Thread to send out UDP requests. When the IP is not in local arp cache, Windows will send arp request broadcast, then the local arp cache is built
            $ASCIIEncoding = New-Object System.Text.ASCIIEncoding
            $Bytes = $ASCIIEncoding.GetBytes("a")
            $UDP = New-Object System.Net.Sockets.Udpclient

            $UDP.Connect($_,1)
            [void]$UDP.Send($Bytes,$Bytes.length)

            if ($DelayMS) {
                [System.Threading.Thread]::Sleep($DelayMS) # set to 0 when your network is fast, other wise set it higher ( 0 - 9 ms)
            }
        }
        $IPAddresses | Invoke-Parallel -ThrottleLimit $threshold -ProgressActivity "UDP Pinging Progress" -ScriptBlock $ArpScriptBlock

        $Hosts = arp -a # Dos command for listing local arp cache

        $Hosts = $Hosts | Where-Object {$_ -match "dynamic"} | ForEach-Object {($_.trim() -replace " {1,}",",") | ConvertFrom-Csv -Header "IP","MACAddress"}
        $Hosts = $Hosts | Where-Object {$_.IP -in $IPAddresses}
    }

    if($arp){
        $ips = $Hosts # for arp scan, we only query the live nodes
    } else {
        $ips = $IPAddresses # for ICMP scan, we test all IPs
    }

    $ips | Invoke-Parallel -ThrottleLimit $threshold -ProgressActivity "Scanning Progress" -ScriptBlock { # test/query worker thread
        [bool]$test  = $false
        [string]$msg = ""
        [string]$cn  = ""
        [string]$ip  = ""
        [string]$mac = ""
        
        if($arp){
            $test = $true
            $ip = $_.IP
            $mac = $_.MACAddress
        } else {
            $ip = $_
            $test = [bool](Test-Connection -BufferSize 32 -Count 3 -ComputerName $ip -ErrorAction SilentlyContinue)
        }

        if($test){ # for arp, all nodes are alive. for ICMP, Test-Connection return value will tell you if it is alive
            $syncHash.mutex.WaitOne()
            $syncHash.Count = $syncHash.Count + 1
            $syncHash.mutex.ReleaseMutex()

            $hsEntry = [System.Net.Dns]::GetHostEntry($ip)  # reverse DNS lookup
                
            if($hsEntry){
                if($more){
                    $cn = (($hsEntry.HostName).Split('.'))[0]
                } else {
                    $cn = $hsEntry.HostName
                }
            } else {
                $cn = "..."
            }
                
            $msg = $ip.PadRight(17,' ') + $cn

            Remove-Variable -Name 'ip'

            if($more){
                $a = query user /server:$cn # Query current logon user
                if($a){
                    $b = ((($a[1]) -replace '^>', '') -replace '\s{2,}', ',').Trim() | ForEach-Object {
                        if ($_.Split(',').Count -eq 5) {
                            Write-Output ($_ -replace '(^[^,]+)', '$1,')
                        } else {
                            Write-Output $_
                        }
                    }
                    $c = ($b.split(','))[0]
                } else {
                    $c = "..."
                }
                $msg = $msg.PadRight(49,' ') + $c
                
                # WMI remote query serial number, works only when RPC is running on the target
                $sn = (Get-WmiObject -ComputerName $cn -class win32_bios).SerialNumber
                if($sn){
                    $msg = $msg.PadRight(69,' ') + $sn                    } 
                else {
                    $msg = $msg.PadRight(69,' ') + "..."
                }

                if($arp){
                    $msg = $msg.PadRight(83,' ') + $mac
                }
            } else {
                if($arp){
                    $msg = $msg.PadRight(64,' ') + $mac
                }
            }
            # we need to limit local function call as less as possible
            $objHash = @{
                font    = "Courier New"
                size    = "20"
                color   = "MediumSpringGreen"
                msg     = $msg
                newline = $true
            }
            $syncHash.Q.Enqueue($objHash)
            Remove-Variable -Name "objHash"
            Remove-Variable -Name "mac"
        }
    }

    # total alive nodes
    if($arp){
        $total = $Hosts.Count
    } else {
        $total = ($Oct4Last - $Oct4First + 1) * ($Oct3Last - $Oct3First + 1)
    }

    $msg = "Total "
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White","     ",$true
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $msg = $total.ToString()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Orange",$msg,$false

    $msg = " IP(s) scanned in ["
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $currenttime = $Time.Elapsed

    $d = ($currenttime.days).ToString()
    $h = ($currenttime.hours).ToString()
    $m = ($currenttime.minutes).ToString()
    $s = ($currenttime.seconds).ToString()
    $t = ($currenttime.Milliseconds).ToString()
    $msg = $d + ":" + $h + ":" + $m + ":" + $s + ":" + $t
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Orange",$msg,$false

    $msg = "],  Total "
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
    $msg = ($syncHash.Count).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = " node(s) alive."
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$true

    $msg = "===== Scanning network " + $start +" --- " + $end + " completed ====="
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","YellowGreen",$msg,$true

    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Black"," ",$true
    
    $syncHash.mutex.WaitOne()
    $syncHash.Count = 0
    $syncHash.mutex.ReleaseMutex()

    $Time.Stop()
    Remove-Variable -Name "Time"
    
    $syncHash.ScanCompleted = $true
}

# Handle Scan Button click event
$syncHash.GUI.BTN_Scan.Add_Click({
    $syncHash.Gui.rtb_Output.Document.Blocks.Clear()

    [int]$delay = 0

    # Threshold validation
    [int]$threshold = 32
    if([string]::IsNullOrEmpty($syncHash.Gui.TB_Threshold.text)){
        $syncHash.Gui.TB_Threshold.text = "32"
        $threshold = 32
    } else {
        $threshold = ($syncHash.GUI.TB_Threshold.text) -as [int]
    }
    if($threshold -gt 128) {
        $threshold = 128
        $syncHash.Gui.TB_Threshold.text = "128"
    }
    if($threshold -lt 1) {
        $threshold = 1
        $syncHash.Gui.TB_Threshold.text = "1"
    }

    if($syncHash.GUI.CB_ARP.isChecked){
        if([string]::IsNullOrEmpty($syncHash.Gui.TB_Delay.text)){
            $syncHash.Gui.TB_Delay.text = "0"
        }

        $delay = $syncHash.Gui.TB_Delay.text -as [int]
    }

    if([string]::IsNullOrEmpty($syncHash.Gui.TB_IPAddress.text)){
        $msg = "Please provide any IP within the target network."
        Show-Result -Font "Courier New" -Size "20" -Color "Red" -Text $msg -NewLine $true
        return
    }

    if(!(Test-IPAddress($syncHash.Gui.TB_IPAddress.text))){
        $msg = "Illegal IP address detected."
        Show-Result -Font "Courier New" -Size "20" -Color "Red" -Text $msg -NewLine $true
        return
    }

    [string]$ip = $syncHash.GUI.TB_IPAddress.text

    if($syncHash.GUI.RB_Mask.IsChecked){
        if([string]::IsNullOrEmpty($syncHash.Gui.TB_NetMask.text)){
            $msg = "Please provide the network mask."
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
            return
        }

        if(!(CheckSubnetMask($syncHash.Gui.TB_NetMask.text))) {
            $msg = "Illegal subnet mask detected."
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
            return
        }

        if(!($syncHash.Gui.TB_NetMask.text.SubString(0,8) -eq '255.255.')){
            $msg = "IP range too large to handle. [CIDR >= 16] or [Subnet Mask >= 255.255.0.0]"
            Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text $msg -NewLine $true
            return
        }

        $mask = ($syncHash.GUI.TB_NetMask.text)

        $range = Get-IPrange -ip $ip -mask $mask

        Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "--------------------------" -NewLine $true

        $msg = "Start IP = " + $range.Start
        Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

        $msg = "End IP   = " + $range.end
        Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true
    }

    if($syncHash.GUI.RB_CIDR.IsChecked){
        if([string]::IsNullOrEmpty($syncHash.Gui.TB_CIDR.text)){
            $msg = "Please provide CIDR."
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
            return
        }
        $cidr = $syncHash.GUI.TB_CIDR.text -as [int]
        if($cidr -lt 16 -or $cidr -gt 31){
            $msg = "IP range too large to handle. [CIDR >= 16] or [Subnet Mask >= 255.255.0.0]"
            Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text $msg -NewLine $true
            return
        }
        $range = Get-IPrange -ip $ip -cidr $cidr

        Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "--------------------------" -NewLine $true

        $msg = "Start IP = " + $range.Start
        Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

        $msg = "End IP   = "+$range.end
        Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true
    }

    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "--------------------------" -NewLine $true

    if($syncHash.Gui.CB_ARP.IsChecked) {
        $msg = "[ARP] "
    } else {
        $msg = "[ICMP] "
    }
    Show-Result -Font "Courier New" -Size "18" -Color "Lime" -Text $msg -NewLine $false
    $msg = "Creating worker threads with Runspacepool capacity $threshold ..."
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    Invoke-Command $syncHash.Devider_scriptblock -ErrorAction SilentlyContinue

    # Disable wedgets
    $syncHash.Gui.TB_IPAddress.IsEnabled = $false
    $syncHash.Gui.TB_NetMask.IsEnabled   = $false
    $syncHash.Gui.TB_CIDR.IsEnabled      = $false
    $syncHash.Gui.TB_Threshold.IsEnabled = $false
    $syncHash.Gui.RB_Mask.IsEnabled      = $false
    $syncHash.Gui.RB_CIDR.IsEnabled      = $false
    $syncHash.Gui.CB_More.IsEnabled      = $false
    $syncHash.Gui.CB_ARP.IsEnabled       = $false
    $syncHash.Gui.BTN_Scan.IsEnabled     = $false
    $syncHash.Gui.BTN_About.IsEnabled    = $false
    $syncHash.Gui.BTN_Exit.IsEnabled     = $false
    $syncHash.Gui.TB_Delay.IsEnabled     = $false
    $syncHash.Gui.CB_CC.IsEnabled        = $false

    # create the extra Powershell session and add the script block to execute
    $Session = [PowerShell]::Create().AddScript($syncHash.scan_scriptblock).AddArgument($range.Start).AddArgument($range.end).AddArgument($threshold).AddArgument($syncHash.GUI.cb_More.IsChecked).AddArgument($syncHash.Gui.CB_ARP.IsChecked).AddArgument($syncHash.GUI.CB_CC.IsChecked).AddArgument($delay)

    # execute the code in this session
    $Session.RunspacePool = $RunspacePool
    $Handle = $Session.BeginInvoke()
    $syncHash.Jobs.Add([PSCustomObject]@{
        'Session' = $Session
        'Handle' = $Handle
    })

    $syncHash.Gui.PB.IsIndeterminate = $true # start progressbar animation
})

# Handle ? button press
$syncHash.Gui.BTN_About.add_click({
    $copyright = [char]169
    [int]$i = 0
    [bool]$nl = $false

    for($i=0;$i -lt 11; $i++){
        if($i -eq 10) {$nl = $true} else {$nl = $false}
        Show-Result -Font "Courier New" -Size "30" -Color "Yellow" -Text "$emoji_box_h" -NewLine $nl
    }

    Show-Result -Font "Courier New" -Size "30" -Color "Cyan" -Text "PSScanner" -NewLine $true
    

    for($i=0;$i -lt 11; $i++){
        if($i -eq 10) {$nl = $true} else {$nl = $false}
        Show-Result -Font "Courier New" -Size "30" -Color "Yellow" -Text "$emoji_box_h" -NewLine $nl
    }

    Show-Result -Font "Courier New" -Size "20" -Color "Lime" -Text "$copyright David Wang, 2021 - V1.0" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "           " -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "Required module: PSParallel" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "LightGreen" -Text " (By Staffan Gustafsson)" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "LightBlue" -Text " https://github.com/powercode/PSParallel" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "Required account type: " -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Pink" -Text "Elevated domain admin" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "           " -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Magenta" -Text "ESC" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text " to clear output when focused" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Chartreuse" -Text "  Auto-save result to C:\PSScanner" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "  Manual-save" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Magenta" -Text " F12" -NewLine $true

    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "           " -NewLine $true

    for($i=0;$i -lt 66; $i++){
        if($i -eq 65) {$nl = $true} else {$nl = $false}
        if($i % 2 -eq 0) {$color = "Lime"} else {$color = "Red"}
        Show-Result -Font "Courier New" -Size "30" -Color $color -Text "$emoji_box_h" -NewLine $nl
    }

    Show-Result -Font "Courier New" -Size "20" -Color "Lime" -Text "The MIT License (MIT)" -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Cyan" -Text "Copyright (c) 2021, David Wang" -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Cyan" -Text "                 " -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'associated documentation files (the "Software"), to deal in the Software without restriction,' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'subject to the following conditions:' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text '                 ' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'The above copyright notice and this permission notice shall be included in all copies or substantial' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text 'portions of the Software.' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "LightGreen" -Text '                 ' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Yellow" -Text 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Yellow" -Text 'LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Yellow" -Text 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Yellow" -Text 'WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE' -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Yellow" -Text 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' -NewLine $true

    for($i=0;$i -lt 66; $i++){
        if($i -eq 65) {$nl = $true} else {$nl = $false}
        if($i % 2 -eq 0) {$color = "Lime"} else {$color = "Red"}
        Show-Result -Font "Courier New" -Size "30" -Color $color -Text "$emoji_box_h" -NewLine $nl
    }
})

# Set target focused when app starts
$syncHash.Gui.TB_IPAddress.Template.FindName("PART_EditableTextBox", $syncHash.Gui.TB_IPAddress)

# Entering main message loop
$syncHash.window.ShowDialog() | Out-Null