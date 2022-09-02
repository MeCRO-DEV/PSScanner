##########################################################
# PSScanner
# ---------
# Author: David Wang, Jul 2022 V2.0
# https://github.com/MeCRO-DEV/PSScanner
# Usage: PSScanner.ps1 [-ps7] [-NoTerminal]
#        Switch -ps7 indicating you are using Powershell core 7+ and you want to use 
#        the native Foreach-Object -Parallel. In this case, there is no dependeny needed
#        Switch -NoTerminal tells the script to hide the terminal window
#
##########################################################
# The MIT License (MIT)
#
# Copyright (c) 2022, David Wang
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
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###############################################################################################################
# Dependency: PSParallel (By Staffan Gustafsson)
# https://github.com/powercode/PSParallel
# The MIT License (MIT)
# 
# Copyright (c) 2015, Staffan Gustafsson
# 
###############################################################################################################
#Requires -Version 5.0

param(
    [Parameter()]
    [switch]$ps7 = $false,
    [switch]$NoTerminal = $false
)

Set-StrictMode -Version Latest

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
                <Setter Property="Background" Value="Orange"/>
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
                <Setter Property="Background" Value="Blue"/>
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
            <Style TargetType="Button" x:Key="btnOrange">
                <Setter Property="Background" Value="Cyan"/>
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
                        <Setter Property="Background" Value="Orange"/>
                        <Setter Property="Foreground" Value="#fff"/>
                    </Trigger>
                </Style.Triggers>
            </Style>
        </Window.Resources>
        <Grid Background="DarkCyan" HorizontalAlignment="Left" Width="1024">
            <StackPanel Orientation="Horizontal">
                <StackPanel Orientation="Vertical">
                    <Canvas>
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
                        <TextBox x:Name="TB_NetMask" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="206,4,0,0" VerticalAlignment="Top" Width="200" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="15" Background="LightYellow" TextAlignment="Center" ToolTip="Minimum [255.0.0.0]"/>
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
                        <TextBox x:Name="TB_CIDR" Text="24" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="408,4,0,0" VerticalAlignment="Top" Width="50" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="2" Background="LightYellow" TextAlignment="Center" ToolTip="CIDR [8-31]"/>
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
                        <TextBox x:Name="TB_Threshold" Text="128" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="460,4,0,0" VerticalAlignment="Top" Width="60" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="3" Background="LightYellow" TextAlignment="Center" ToolTip="Runspacepool capacity [1-128]"/>
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
                    </Canvas>
                    <Canvas Margin="0,34,0,0">
                        <TextBox x:Name="TB_SP" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="4,4,0,0" VerticalAlignment="Top" Width="100" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="5" Background="LightYellow" TextAlignment="Center" ToolTip="Starting Port#"/>
                        <TextBlock IsHitTestVisible="False" Text="Start Port" FontFamily="Courier New" FontSize="12" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="16,15,0,0" Foreground="DarkGray">
                            <TextBlock.Style>
                                <Style TargetType="{x:Type TextBlock}">
                                    <Setter Property="Visibility" Value="Collapsed"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding Text, ElementName=TB_SP}" Value="">
                                            <Setter Property="Visibility" Value="Visible"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                        <TextBox x:Name="TB_EP" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="104,4,0,0" VerticalAlignment="Top" Width="100" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="5" Background="LightYellow" TextAlignment="Center" ToolTip="Ending Port#"/>
                        <TextBlock IsHitTestVisible="False" Text="End Port" FontFamily="Courier New" FontSize="12" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="126,15,0,0" Foreground="DarkGray">
                            <TextBlock.Style>
                                <Style TargetType="{x:Type TextBlock}">
                                    <Setter Property="Visibility" Value="Collapsed"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding Text, ElementName=TB_EP}" Value="">
                                            <Setter Property="Visibility" Value="Visible"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                        <TextBox x:Name="TB_Sweep" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="206,4,0,0" VerticalAlignment="Top" Width="314" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="38" Background="LightYellow" TextAlignment="Left" ToolTip="Ports List, seperated by commas"/>
                        <TextBlock IsHitTestVisible="False" Text="Port sweep list" FontFamily="Courier New" FontSize="12" VerticalAlignment="Top" HorizontalAlignment="Left" Margin="220,15,0,0" Foreground="DarkGray">
                            <TextBlock.Style>
                                <Style TargetType="{x:Type TextBlock}">
                                    <Setter Property="Visibility" Value="Collapsed"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding Text, ElementName=TB_Sweep}" Value="">
                                            <Setter Property="Visibility" Value="Visible"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </Canvas>
                </StackPanel>
                <Canvas>
                    <RadioButton x:Name="RB_Mask" Content="Mask" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="24" Margin="522,10,0,0" VerticalAlignment="Top" Width="70" Foreground="Cyan" ToolTip="Use subnet mask"/>
                    <RadioButton x:Name="RB_CIDR" Content="CIDR" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="24" Margin="522,30,0,0" VerticalAlignment="Top" Width="70" Foreground="Cyan" ToolTip="Use CIDR"/>
                    <CheckBox x:Name="CB_More" Content="More" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="24" Margin="522,50,0,0"  VerticalAlignment="Top" Width="70" Foreground="Lime" ToolTip="Show logon user and serial number"/>
                    <CheckBox x:Name="CB_ARP" Content="ARP" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="24" Margin="596,10,0,0"  VerticalAlignment="Top" Width="70" Foreground="DarkOrange" ToolTip="Use ARP request"/>
                    <CheckBox x:Name="CB_CC" Content="Clear" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="24" Margin="596,30,0,0"  VerticalAlignment="Top" Width="76" Foreground="DarkOrange" ToolTip="Clear ARP cache before scanning, local admin required."/>
                    <TextBox x:Name="TB_Delay" Text="2" FontFamily="Courier New" FontSize="18" FontWeight="Bold" HorizontalAlignment="Left" Height="20" Margin="596,50,0,0" VerticalAlignment="Top" Width="76" Foreground="DarkBlue" VerticalContentAlignment="Center" MaxLength="1" Background="LightYellow" TextAlignment="Center" ToolTip="ARP Ping Delay (0-9ms)"/>
                    <CheckBox x:Name="CB_SOO" Content="Show Open&#10;Ports Only" FontFamily="Courier New" FontSize="11" HorizontalAlignment="Left" Height="24" Margin="676,10,0,0"  VerticalAlignment="Center" Width="86" Foreground="Lime" ToolTip="Show open ports only, no effect with port sweeping and IP scanning."/>
                    <Button x:Name="BTN_Scan" Content="IPScan" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="768,4,0,0" VerticalAlignment="Top" Width="90" Foreground="Blue" Style="{StaticResource btnOrange}" ToolTip="Start IP scan."/>
                    <Button x:Name="BTN_Sweep" Content="Sweep" FontFamily="Courier New" FontSize="18" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="768,38,0,0" VerticalAlignment="Top" Width="90" Foreground="Blue" Style="{StaticResource btnLime}" ToolTip="TCP sweeping, it shows open ports only."/>
                    <Button x:Name="BTN_ScanPort" Content="Scan" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="860,38,0,0" VerticalAlignment="Top" Width="60" Foreground="Blue" Style="{StaticResource btnLime}" ToolTip="Ports scan"/>
                    <Button x:Name="BTN_Exit" Content="Exit" FontFamily="Courier New" FontSize="20" FontWeight="Bold" HorizontalAlignment="Left" Height="30" Margin="860,4,0,0" VerticalAlignment="Top" Width="60" Foreground="Blue" Style="{StaticResource btnBrown}"/>
                    <Button x:Name="BTN_About" Content="" FontFamily="Courier New" FontSize="40" HorizontalAlignment="Left" Height="64" Margin="924,4,0,0" VerticalAlignment="Top" Width="64" Foreground="Yellow" Style="{StaticResource btnGreen}" ToolTip="Help"/>
                </Canvas>
            </StackPanel>
            <RichTextBox x:Name="RTB_Output" FontFamily="Courier New" FontSize="18" HorizontalAlignment="Left" Height="632" Margin="4,72,0,0" VerticalAlignment="Top" Width="1006" Background="Black" Foreground="LightGreen" IsReadOnly="true" HorizontalScrollBarVisibility="Auto" VerticalScrollBarVisibility="Visible" MaxWidth="4096">
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

if($ps7.IsPresent){
    if($PSVersionTable.PSVersion.Major -lt 7){
        Write-Host -ForegroundColor Red "Native multi-threading requires Powershell Core 7+."
        Write-Host -ForegroundColor Yellow "Script terminated."
        exit
    }
}

if($PSVersionTable.PSVersion.Major -lt 7){ # In case you are using Windows Powershell, Powershell Core 6 or earlier
    # Setup dependency for the 1st time
    if (!(Get-Module -ListAvailable -Name PSParallel)) {
        Install-Module -Name PSParallel -Scope AllUsers -Force -Confirm:$false
    }
    Import-Module PSParallel
} # Otherwise you are using Powershell Core 7 and later

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
$syncHash.Gui.CB_SOO.IsChecked    = $true
$syncHash.Gui.SB.Text = $env:USERDNSDOMAIN + '\' + $env:USERNAME + ' | ' + $env:COMPUTERNAME + ' | ' + $env:NUMBER_OF_PROCESSORS + ' CPU Core(s)'

# Test if you have local admin rignt
$user = [Security.Principal.WindowsIdentity]::GetCurrent();
$isAdmin = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if($isAdmin){
    $syncHash.Gui.SB.Foreground = "DarkGreen"
} else {
    $syncHash.Gui.SB.Foreground = "DarkBlue"
}

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

# Live Node counter, mutex protected
[int]$syncHash.Count    = 0 # Microsoft claimed that synchronized hash table is thread safe, but it's not. I have to use mutex to protect it.
[int]$syncHash.opened   = 0 # Number of opened ports
[int]$syncHash.closed   = 0 # Number of closed ports
[int]$syncHash.filtered = 0 # Number of filtered ports

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

    Unregister-Event -SourceIdentifier Process_Result -Force
})

# Clean up the runspaces when exiting the GUI
$syncHash.Window.add_closed({
    foreach($Job in $syncHash.Jobs)
    {
        if ($Job.handle.IsCompleted -eq $true)
        {
            $Job.Session.EndInvoke($Job.Handle)
        }
        $RunspacePool.Close()
        $RunspacePool.Dispose()
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

# Start port input validation
$syncHash.Gui.TB_SP.Add_TextChanged({
    if ($this.Text -match '[^0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# End port input validation
$syncHash.Gui.TB_EP.Add_TextChanged({
    if ($this.Text -match '[^0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# Port sweep list input validation
$syncHash.Gui.TB_Sweep.Add_TextChanged({
    if ($this.Text -match '[^0-9,]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^0-9,]',''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})

# Hot key events handling
$handler_keypress = {
    [string]$key = ($_.key).ToString()
    if($key -match "Escape"){ # ESC to clear output window
        $syncHash.Gui.rtb_Output.Document.Blocks.Clear()
    }
}
$syncHash.Window.add_KeyDown($handler_keypress)

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
            if($objHash.msg -match "completed"){ # When IP scanning completed, save the result to a file located in c:\PSScanner
                if(!(Test-Path -Path "C:\PSScanner")) {
                    New-Item -Path "C:\PSScanner" -type directory -Force -ErrorAction Ignore -WarningAction Ignore -InformationAction Ignore | Out-Null
                }
                $range   = New-Object System.Windows.Documents.TextRange($syncHash.Gui.RTB_Output.Document.ContentStart, $syncHash.Gui.RTB_Output.Document.ContentEnd)
                $dt = Get-Date -Format "MM-dd-yyyy-HH-mm-ss"
                $path = "c:\PSScanner\" + '(' + $dt + ')' + '-output.txt'
                $fStream = [System.IO.FileStream]::New($path, [System.IO.FileMode]::Create)
                $range.Save($fStream, [System.Windows.DataFormats]::Text)
                $fStream.Close()
                New-Event -SourceIdentifier Process_Result -MessageData @($path, $syncHash, $false)
            }
            if($objHash.msg -match "finished"){ # When port scanning completed, save the result to a file located in c:\PSScanner
                if(!(Test-Path -Path "C:\PSScanner")) {
                    New-Item -Path "C:\PSScanner" -type directory -Force -ErrorAction Ignore -WarningAction Ignore -InformationAction Ignore | Out-Null
                }
                $range   = New-Object System.Windows.Documents.TextRange($syncHash.Gui.RTB_Output.Document.ContentStart, $syncHash.Gui.RTB_Output.Document.ContentEnd)
                $dt = Get-Date -Format "MM-dd-yyyy-HH-mm-ss"
                $path = "c:\PSScanner\" + '(' + $dt + ')' + '-output.txt'
                $fStream = [System.IO.FileStream]::New($path, [System.IO.FileMode]::Create)
                $range.Save($fStream, [System.Windows.DataFormats]::Text)
                $fStream.Close()
                New-Event -SourceIdentifier Process_Result -MessageData @($path, $syncHash, $true)
            }
        }
    }
}

# Show result from middle thread($syncHash.scan_scriptblock). This function is NOT reentrant, so it CANNOT be called by worker threads.
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

# Setup event handler to sort the output file
$syncHash.PostPocess = {
    [bool]$isPortScan = $event.messagedata[2]
    [string]$path = $event.messagedata[0]
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

    if(!$isPortScan){
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

    if(!$isPortScan){
        $objHash = @{
            font    = "Courier New"
            size    = "20"
            color   = "Lime"
            msg     = "Done"
            newline = $true
        }

        $event.MessageData[1].Q.Enqueue($objHash)
    }

    # Update UI, enable all widgets
    if($event.messagedata[1].Gui.RB_CIDR.isChecked){
        $event.messagedata[1].Gui.TB_CIDR.IsEnabled      = $true
        $event.messagedata[1].Gui.TB_NetMask.IsEnabled   = $false
    } else {
        $event.messagedata[1].Gui.TB_CIDR.IsEnabled      = $false
        $event.messagedata[1].Gui.TB_NetMask.IsEnabled   = $true
    }
    $event.messagedata[1].Gui.TB_IPAddress.IsEnabled = $true
    $event.messagedata[1].Gui.TB_Threshold.IsEnabled = $true
    $event.messagedata[1].Gui.RB_Mask.IsEnabled      = $true
    $event.messagedata[1].Gui.RB_CIDR.IsEnabled      = $true
    $event.messagedata[1].Gui.CB_More.IsEnabled      = $true
    $event.messagedata[1].Gui.CB_ARP.IsEnabled       = $true
    $event.messagedata[1].Gui.BTN_Scan.IsEnabled     = $true
    $event.messagedata[1].Gui.BTN_About.IsEnabled    = $true
    $event.messagedata[1].Gui.BTN_Exit.IsEnabled     = $true
    $event.messagedata[1].Gui.TB_SP.IsEnabled        = $true
    $event.messagedata[1].Gui.TB_EP.IsEnabled        = $true
    $event.messagedata[1].Gui.CB_SOO.IsEnabled       = $true
    $event.messagedata[1].Gui.BTN_ScanPort.IsEnabled = $true
    $event.messagedata[1].Gui.BTN_Sweep.IsEnabled = $true
    $event.messagedata[1].Gui.TB_Sweep.IsEnabled     = $true
    if($event.messagedata[1].Gui.CB_ARP.isChecked){
        $event.messagedata[1].Gui.TB_Delay.IsEnabled = $true
        $event.messagedata[1].Gui.CB_CC.IsEnabled    = $true
    } else {
        $event.messagedata[1].Gui.TB_Delay.IsEnabled = $false
        $event.messagedata[1].Gui.CB_CC.IsEnabled    = $false
    }
    $event.messagedata[1].Gui.PB.IsIndeterminate = $false
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
    [string]$strFullBinary = ""
    [bool]$IsValid = $true
	$MaskParts = @()
	$MaskParts +=$SubnetMask.split(".")

	if ($MaskParts.count -ne 4) {$IsValid =$false}
	
	if ($IsValid)
	{
		foreach ($item in $MaskParts)
		{
			if (!($item -match "^[\d\.]+$")) {$IsValid = $false}
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
				$binary = $binary.PadLeft(8,'0')
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
    for([int]$i=0;$i -lt 88;$i++) {
        if($i%2 -eq 0) {
            Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "=" -NewLine $false
        }
        if($i%2 -eq 1) {
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text "=" -NewLine $false
        }
    }
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "=" -NewLine $true
}

# Ping or ARP Scan middle thread, it will fork the worker threads.
$syncHash.scan_scriptblock = {
    param(
        [string]$start,   # Start IP
        [string]$end,     # End IP
        [int]$threshold,  # Max number of threads
        [bool]$more,      # Fetch more info
        [bool]$arp,       # Use ARP scan
        [bool]$ARP_Clear, # Clear ARP Cache before scanning
        [int]$DelayMS,    # Delay for arp ping
        [bool]$ps7        # Use native PS7+ multi-threading
    )

    $StartArray = $start.Split('.')
    $EndArray = $end.Split('.')

    [int]$Oct2First = $StartArray[1] -as [int]
    [int]$Oct2Last  = $EndArray[1]   -as [int]
    [int]$Oct3First = $StartArray[2] -as [int]
    [int]$Oct3Last  = $EndArray[2]   -as [int]
    [int]$Oct4First = $StartArray[3] -as [int]
    [int]$Oct4Last  = $EndArray[3]   -as [int]
    [string]$msg    = ""

    [System.Diagnostics.Stopwatch]$Time = [System.Diagnostics.Stopwatch]::StartNew()

    $syncHash.mutex.WaitOne()
        $syncHash.Count = 0
    $syncHash.mutex.ReleaseMutex()

    # Calculate IP address set based on IP range
    # In case of 8 <= CIDR < 16
    if(($StartArray[0] -eq $EndArray[0]) -and ($StartArray[1] -ne $EndArray[1])){
        if($Oct4First -eq 0){
            $Oct4First++
        }

        if($Oct4Last -eq 255){
            $Oct4Last--
        }

        $IPAddresses = $Oct2First..$Oct2Last | ForEach-Object { # This will be absolutely slow (3 layers of nested loop)
            $y = $_
            $Oct3First..$Oct3Last | ForEach-Object {
                $t = $_
                $Oct4First..$Oct4Last | ForEach-Object {
                    $StartArray[0]+'.'+$y+'.'+$t+'.'+$_
                }
            }
        }
    }
    # In case of 16 <= CIDR < 24
    if(($StartArray[0] -eq $EndArray[0]) -and ($StartArray[1] -eq $EndArray[1]) -and ($StartArray[2] -ne $EndArray[2])){
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
    }
    # In case of CIDR >= 24
    if(($StartArray[0] -eq $EndArray[0]) -and ($StartArray[1] -eq $EndArray[1]) -and ($StartArray[2] -eq $EndArray[2]) -and ($StartArray[3] -ne $EndArray[3])){ 
        if($Oct4First -eq 0){
            $Oct4First++
        }

        if($Oct4Last -eq 255){
            $Oct4Last--
        }

        $IPAddresses = $Oct4First..$Oct4Last | ForEach-Object {$StartArray[0]+'.'+$StartArray[1]+'.'+$StartArray[2]+'.'+$_}
    }

    # in case there is only 1 IP
    if(($IPAddresses.GetType().name) -eq "String"){
        $IPAddresses = @($IPAddresses)
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

        # UDP probing worker thread
        $ArpScriptBlock = { # Thread to send out UDP requests. When the IP is not in local arp cache, OS will send arp request broadcast, then the local arp cache is built.
            $ASCIIEncoding = New-Object System.Text.ASCIIEncoding
            $Bytes = $ASCIIEncoding.GetBytes("a")
            $UDP = New-Object System.Net.Sockets.Udpclient

            $UDP.Connect($_,1)
            [void]$UDP.Send($Bytes,$Bytes.length)

            if ($DelayMS) {
                [System.Threading.Thread]::Sleep($DelayMS) # set to 0 when your network is fast, otherwise set it higher ( 0 - 9 ms)
            }
        }

        # I feel really stupid here. Please don't blame on me to duplicate the code, but I have no choice
        # I can't pass any parameters into the thread, so not able to dertermin if the -ps7 switch is given
        # inside the thread
        # Forking worker threads using PSParallel or ForEach-Object -Parallel
        if($ps7){
            $IPAddresses | ForEach-Object -ThrottleLimit $threshold -Parallel { # Thread to send out UDP requests. When the IP is not in local arp cache, OS will send arp request broadcast, then the local arp cache is built.
                [int]$delay = $Using:DelayMS
                $ASCIIEncoding = New-Object System.Text.ASCIIEncoding
                $Bytes = $ASCIIEncoding.GetBytes("a")
                $UDP = New-Object System.Net.Sockets.Udpclient
    
                $UDP.Connect($_,1)
                [void]$UDP.Send($Bytes,$Bytes.length)

                if ($delay) {
                    [System.Threading.Thread]::Sleep($delay) # set to 0 when your network is fast, otherwise set it higher ( 0 - 9 ms)
                }
            }
        } else {
             # UDP probing worker threads
            $IPAddresses | Invoke-Parallel -ThrottleLimit $threshold -ProgressActivity "UDP Pinging Progress" -ScriptBlock $ArpScriptBlock            
        }

        $Hosts = arp -a # Dos command for listing local arp cache

        $Hosts = $Hosts | Where-Object {$_ -match "dynamic"} | ForEach-Object {($_.trim() -replace " {1,}",",") | ConvertFrom-Csv -Header "IP","MACAddress"}
        $Hosts = $Hosts | Where-Object {$_.IP -in $IPAddresses}
    }

    if($arp){
        $ips = $Hosts # for arp scan, we only query the live nodes
    } else {
        $ips = $IPAddresses # for ICMP scan, we test all IPs
    }

    $IPScanner = { # test/query worker threads
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
            $test = [bool](Test-Connection -BufferSize 32 -Count 3 -ComputerName $ip -Quiet -ErrorAction SilentlyContinue)
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

    # I feel really stupid here. Please don't blame on me to duplicate the code, but I have no choice
    # I can't pass any parameters into the thread, so not able to dertermin if the -ps7 switch is given
    # inside the thread
    # Forking worker threads using PSParallel or ForEach-Object -Parallel
    if($ps7){
        $ips | ForEach-Object -ThrottleLimit $threshold -Parallel { # test/query worker threads
            [bool]$test  = $false
            [string]$msg = ""
            [string]$cn  = ""
            [string]$ip  = ""
            [string]$mac = ""

            $sync = $Using:syncHash
    
            if($Using:arp){
                $test = $true
                $ip = $_.IP
                $mac = $_.MACAddress
            } else {
                $ip = $_
                $test = [bool](Test-Connection -BufferSize 32 -Count 3 -ComputerName $ip -Quiet -ErrorAction SilentlyContinue)
            }
    
            if($test){ # for arp, all nodes are alive. for ICMP, Test-Connection return value will tell you if it is alive
                $sync.mutex.WaitOne()
                    $sync.Count = $sync.Count + 1
                $sync.mutex.ReleaseMutex()
    
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
    
                    if($Using:arp){
                        $msg = $msg.PadRight(83,' ') + $mac
                    }
                } else {
                    if($Using:arp){
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
                $sync.Q.Enqueue($objHash)
                Remove-Variable -Name "objHash"
                Remove-Variable -Name "mac"
            }
        }
    } else {
        $ips | Invoke-Parallel -ThrottleLimit $threshold -ProgressActivity "IP Scanning Progress" -ScriptBlock $IPScanner
    }

    # total alive nodes
    if($arp){
        if($Hosts){
            if(($Hosts.GetType().name) -eq "PSCustomObject"){ # in case of there is only 1 IP
                $total = 1
            } else { # in case of there are more than 1 IP
                $total = $Hosts.Count
            }
        } else { # in case there is no IP
            $total = 0
        }
    } else {
        $total = ($Oct4Last - $Oct4First + 1) * ($Oct3Last - $Oct3First + 1) * ($Oct2Last - $Oct2First + 1)
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
    $msg = $d + ":" + $h + ":" + $m + ":" + $s + "." + $t
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Orange",$msg,$false

    $msg = "],  Total "
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
    $msg = ($syncHash.Count).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = " node(s) alive."
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$true

    if($ps7){
        $w = "(Native)"
    } else {
        $w = "(Module)"
    }
    $msg = "===== Scanning network " + $start +" --- " + $end + " completed $w ====="
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","YellowGreen",$msg,$true

    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Black"," ",$true
    
    $syncHash.mutex.WaitOne()
    $syncHash.Count = 0
    $syncHash.mutex.ReleaseMutex()

    $Time.Stop()
    Remove-Variable -Name "Time"

    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Cyan","Saving data, please ",$false
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Yellow","DO NOT",$false
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Cyan"," close the application until it's done ... ",$false
}

# Handle Scan Button click event
$syncHash.GUI.BTN_Scan.Add_Click({
    [int]$delay = 0

    $syncHash.Gui.rtb_Output.Document.Blocks.Clear() # Clear output window

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

    if(!(Test-IPAddress($syncHash.Gui.TB_IPAddress.text))){ # IP Address validation
        $msg = "Illegal IP address detected."
        Show-Result -Font "Courier New" -Size "20" -Color "Red" -Text $msg -NewLine $true
        return
    }

    [string]$ip = $syncHash.GUI.TB_IPAddress.text

    if($syncHash.GUI.RB_Mask.IsChecked){ # Subnet mask validation
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

        if(!($syncHash.Gui.TB_NetMask.text.SubString(0,4) -eq '255.')){
            $msg = "IP range too large to handle. [CIDR >= 8] or [Subnet Mask >= 255.0.0.0]"
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

    if($syncHash.GUI.RB_CIDR.IsChecked){ # CIDR validation
        if([string]::IsNullOrEmpty($syncHash.Gui.TB_CIDR.text)){
            $msg = "Please provide CIDR."
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
            return
        }
        $cidr = $syncHash.GUI.TB_CIDR.text -as [int]
        if($cidr -lt 8 -or $cidr -gt 31){
            $msg = "IP range too large to handle. [CIDR >= 8] or [Subnet Mask >= 255.0.0.0]"
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
    if($ps7){
        $w = "(Native)"
    } else {
        $w = "(Module)"
    }
    $msg = "Creating worker threads with Runspacepool capacity $threshold $w ..."
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    Invoke-Command $syncHash.Devider_scriptblock -ErrorAction SilentlyContinue # Draw a colorful ribon

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
    $syncHash.Gui.TB_SP.IsEnabled        = $false
    $syncHash.Gui.TB_EP.IsEnabled        = $false
    $syncHash.Gui.CB_SOO.IsEnabled       = $false
    $syncHash.Gui.BTN_ScanPort.IsEnabled = $false
    $syncHash.Gui.BTN_Sweep.IsEnabled = $false
    $syncHash.Gui.TB_Sweep.IsEnabled     = $false

    # create an extra Powershell session and add the script block to execute
    $Session = [PowerShell]::Create().AddScript($syncHash.scan_scriptblock).AddArgument($range.Start).AddArgument($range.end).AddArgument($threshold).AddArgument($syncHash.GUI.cb_More.IsChecked).AddArgument($syncHash.Gui.CB_ARP.IsChecked).AddArgument($syncHash.GUI.CB_CC.IsChecked).AddArgument($delay).AddArgument($ps7.IsPresent)

    # execute the code in this session
    $Session.RunspacePool = $RunspacePool
    $Handle = $Session.BeginInvoke()
    $syncHash.Jobs.Add([PSCustomObject]@{
        'Session' = $Session
        'Handle' = $Handle
    })

    $syncHash.Gui.PB.IsIndeterminate = $true # start progressbar animation
})

# Show help and license info
Function about{
    $copyright = [char]169
    [int]$i = 0
    [bool]$nl = $false

    $syncHash.Gui.rtb_Output.Document.Blocks.Clear() # Clear output window

    $Image64 = "iVBORw0KGgoAAAANSUhEUgAAAaYAAABbCAIAAAC3aLYnAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABTpSURBVHhe7Z19bxxXFcab2N61Y7uJ07qN4wbU8uaEpvTFtRunSWkSKoPEHyDxIggKVDSiIEGLhCoqJGReBAK1EqigVsqf+Qr9CP4q/Rw8M2f27Jl77tyX2R3j9ZxHR9bJfXnmzu7Ob+6dndk8YjKZTCaTyWQymUwmk8lkMplMJpPJZDKZTKYTrNOnTzclp06dogTiPNA+kBwHK5PJ1HfNz883JaAJAyXQLCU5DlYGPpOp72IKaEAwVlojhhPuvvH0M1de2Xvp9jcQz17bW998CoXtrMpBtRmVyWTquzQXJFDakQXJ5Zd3d/e/5Y1X9r/pTdAl4Dn5qEwmU9/FOJA0aQcUSghhOpow15SQ57RGBXF3k8nUU+mFreRCFmI0trzhpVs4gXnrUenEZDL1XYwD0KQFUDSknGhiWWJCIbfYOjGZTH0X44Bhlw4+glETpGRc3bs+XFrijpzMDwaoivKOgzu2SHinTCZTT8ULW4k5TgL4GA6HxKAApBaGiylWMkEXdGziHcVgOOT26Um5f4Y8k8mUM62jJDwXWzl7jpqlWOmERrL86DnpqbeYbkUJ5yaTqdeSLOA8wBFNH04Srai9LNEJdydnCmeLqA04aCuTydR3AQdMhCg+hktLGnNMn3Qr6hhoo614Q05C1wcTrezpC5PJVEhyoQkfWy/veKFDbbh7itX8wsKi76sMSgJWzqYpubKzK9vIxGtlMpn6LsaBpgYlL92+E+YdO0StwknUSo8Bf1+8dSfRymQy9V0aFk5yecczv0NQG0mWqJU34e6JVnowSObm5lAVtrKFrcnUd2kuOIn3+h234e5Q1Cqc5FrpUZ1ZWaGqsJXJZOq7ssjCVaCJBkq7pIXVQnljoDM8VIWtTCZT3+UFCiVh3nESQExKMomVMzwEVXmtbGFrMvVd+mcFOAnzjoGiyZKV5Fpd+sdHmx9+cnq4xCWSdxQoDFiZTKa+S3NBP09GKIFKRk2KOU6yrIh3CCRUgu48PI7AE2kmk6nv8iKG2CEnelTFhIKyaCUT8sy1krzDX1lFhjJkLSe2sDWZ+i7vwpao4eVdCpuiCdlmWQV4R6PioVJydW+ParWVyWTquxwuSHbo+R0hhnINlJQk1yrMO0qWVlZowDx4FGqrbrU92Npe3r+7dv/h+sHhxoPDS59+JgMl6/cPlreq1nnaursM2wewrXleKkoert2/OxjZYgxFVP9KVtf+JtNxkcMFRoZkh2QTJxooKUmuVXR+x7kcMyVUxe0nWNgO7j/ckCCYMB48TAbf9jLo6XRvihpkD9eSNtG1v8l0rKQXtowMCpRIsmgkpSTcPdfK4V0RH3xMVV4rDWvtma/BfXe+No2IIqOAkeqVEw8OgnOxrv1NpmOrJmQgGCuQRkxWkmvl8u6DjylZ/OKXmqycwSPhKkra6O66c6hPLR4uV5twNdg/mMqkcn2/MnTUtb/JdIwlWeMgAzSRQJkkybVyeEdVVAL2Bawcasuqlgvb7pD32aWDu9VGhCadfInYuL9dmQp17W8yHWM5C1smBQVV5dJKJ9w90crLO6oC76iqyYpGznuhzfOVtbBdJwps3V13vgfwhrs2xGJTtZkkXKR27W8yzYQIB5IUiJWzZ6k2BVKBRLIpxSrAO3Q/vbDAyKNCx2H13FpgotdeaVe+aghLmR7W1raJPNo4uEtbGUTBWkdS1/4m0yyIcUCY4KBCByiJiWScZtPzN24+d+OmLOFE805byVrtgITGryd6bNVOW/HrX/WF3vZafKI3Rl7iXFKvJQMdZeOu/U2mWZBc2BIgOFDIjPCSJZpIxEgr8tftw/M7SqCFJ56kZtqBEpjLiZ6smkAJyHC+hE1AHs8KE3hahv8bj4bpmxhP1/4m0ywJOLj88i4xgmJhuNgElMQEkJKYk8kLr9966fVbsgRyeEcJVWmrqtk//8MlMllaXqa9IPBd3tnhqgkUXxW6F+YSFrajhWHikrP5S14PXuUUrGt/v7a2l+8feG5v/rS8vXk/735mrLKLe7yb3ap2qdoelDeNizvGD+UX0IP9gzX3jsXDjYOsO8mPYBOFiq0cyK2MrDJfZLzCntvRx59qvJvYiqxKv730WIlwQIzgaKJVYsLdS1jFrRzeyRKv1cXf/5lqmzyxC3qix93bKM4vFwEJE6vqAEidgpUxutCmJK+74dASg+na3xUO9fqx0RiH1bc9zSqvJ0bn12UkHIHEzaaxVe/gFjDtVskIs/4INlEJZ5Sk28gjbxadllSvUZTIa76rqekceWzFC1uiAwcVNrFJluhEsomTQHvNO1Sd+96PikJxP4pjRe1liUwk72h3ijFNgLz9h+rNdsJd5SVMrKqPS+JVNhEgxfgJsKi69pcqYOe6xcL/HUjJTadlPPxr7QJD8W+fir7YqCr3hL4h8Qg2IVROuFSXQGiGgmKR76YocAoMfn6C4zy2AgsIEJIRmiPrP7xHbNJVTJMSLHHMcaJ5x92L+1HKW1KQN3UEGb3mvDsUclRtlHNVrlLGrDB51amjZBO5NKtr/0o45lMOIV+4B2TiLT7ecAGabnW4nn7HYm0rR7AJoZYvTu1kkH8WbIwZRB6xQALi6t51L0eYTVwik6J29DQYxIiRzRae+hw5sJVMZGN0pyqE14qqmgaDveCJHoKqWithYegctHHKCEROgKQqwheAuvYvlLV21iFPGI2Tu8Pigl18ilRbak2+7/4QPDqCTbACM1+8R8XPPQRYxoYTvln1mDXkgSYEFMmIxaUzVOtwhBBz/sdvcolMaFJGua5FcuH9v5AD00omsjGPimqp0PH0duRE8g5BhS2fvsj+rja3/ZSOmdqlcamu/RNXasEYcarpaHzAIItOn08s8pJwFnp9Yi9ym6i92rOjjaefYToAFlSoORJADAiFKgTTCpLN5PyOSqi9l3ecBBa2F95+lxx0FZKNZ8Z7hCgHVdlmK+X2ugph5bV2p8oTDju6XmV06x/jXXFjc3j2gRjN8vz4kHPA6OHqXmGY9gMnZdRfhyPYRPi8IrkTQN74RDuth6yTvmY5jrryyh6hIXAhD0kTYkCT5d3rVMtkcZqhStONShDSih2QUO3q9g6VSM/BhYuoggOXyAR/aY8o2LOFproKKOdK6lPS9Vm3O/+YszgkQrOzUTPfrTDON8jRGaVeD6bt/kbxjc32IKlxbZJeqOtNBPe6xp1Qy5rnFE6E7tllVgQ6vHT7G+ACLwYZH1Qyv7BAJRIxgAg1LhB16tT6b96Ttc/feA1VL7x+i60075A89vNfoZCXw/BBF3R87sZNucXH334XOUpoi17P7dtvUC1VwYr+ieB5a6uF7RSnSFiduYfKSFOcJngnet34x9aYNfqkzT7EF5EbxU0n7ukhuiMt5qEIQY0WX1V1vYnI6zzeZSwyVK2I2ulq4o/EjC5pgQb8BfKYdwwIRszi0hKVONii2rLmkSfeeV8uQp979Qaq5P3GBdrUDBHIY08ayQtfL5H36mtFo9EWgTzeohye9Ny+8wbtAnKyQs5B7fE3Wymr2qRwZyuuYvhIjto5f6zp+8eOGeeQaByAl9ENiu6F5zhMOLZlr/g7rl/hTjcxMZtGkYNRRPG+NE1IZ3V+x3r2WpuFLchCcIFWX3nVqXUSVDnEhKgEIa1kR6pdfdGzsF24uIkqOHAJJWSFf/LuILg2V2kLlmAclhezKr+gJrgzQ0QD8qCp+kdfGXeB6T3GwnfJuorPuPWqNuHYrr9iaSyoqctNTOETWEVt2NFpKUOt/h1xqwddjpuAg/XNp7yAcBKJGCYUIQaJF0AyIX6hDSZ3PL9DaCtIb9HxvPD+X8iBSyDu/rmvbNG+0H5RYf7CNmlV+8BzB3zx31wUN3bkfjjSfq8lGM3Ig6bmH516eOZutYMn/GTVdnGj7MGheogqEt6NOm1UZFw1K0NNJLvcxNSmeLWTQZuZ7EkRU4B5h4T+H1gHMRAh5vwP7kk2caIB5CQMKQIZJRd+/ydt5WxRljhVCC4pxjRykLzDX5RwswwlrGo904o0ie923Y9X6oNE/qgO+279o/OU+kGerNRHAvzRalVbX6PF26t3vMtNxOeDKeFeVInPHFu+fbMj4EAC4tnrr2rEgCaEmM2GHyWm2se+V71d2gEJ3apCV/0QJaM8VpRoqMmEquRXH9JK7g6CO2YpYU3hmVYkyfkoe45VqDz+cydlZNWxf+68JkUtHyoQcfJWtdHXudUZN752mflLdWERDiQgkMgqTtZ+9FP+jgJyaIXywKRMJ9wdcqwoIajBk0tkQlVr3y/ec23l3Z3MhW3CqtaPkqi0c2AdkXULFfkcvb+OrJNB4KGCIh5gCRx/mk1vMWGck65qO91EdD7Y6ozb51Ut5F3Y4i9KHMRAoIn8WpYKZUKQeuzb3+WSpgRWxCbI2+z8T94K8A5ivHqtAruTqg5XtZ6PcvC8moKYMqqj6//gryP9xQlToFqURSdH+vST8A7mLjndl7HbTUQbt0FeFzP02RNwIAGB0IghrBRQA/UaHixDecpEjwlVwsoPPuIdbUg70FYQTVZNu5Ou+Cej3TkW8h69oc9ZIpJGJ+eu/ROO8yL0Fse//7HBQIxcPRiBLHqRQTM94R2sTWcSrmO4059uN9HJdCwf6ydPhIPLL+/KmdGwvBePScFA2fznf1MmeoHZGXxeeP0WgnIqdJqRQ3QrGAk7SCsMXvLuyu4uVeUsbBMmMm1Pho2f+4afe0s4TorgT2rX/qnIQ5Q/BFB2KZautV7EspjViIzxt0NNKhPewdpJK7c91PEmUl5nPbfFG8o/Y6Uei055r9uuXWZETAGQgnlHiaSJBArhZnBujUtkMvzyZZ6CcZVjRf5OR07QMcA7sir8m/9rR7kXSGRVklLv5BhPVbIU/NiVt26MTt0ZX62Kj37X/mmHbiQIoLEjsJrFpByo9blJ4rx1TISUTSDEO34Em0h6nYtHeuhVoh/7rNfKASdetC2unFZdTq4CpGCsQIyb8BRs5fpr3jZs9bUbNxGUOw7c8dHb+7Jq82//oioqgRWZU04Jt5d7gb+yKib5wFNKtFhZpH7002P8KyOluvaHEhZ04SAQxKlR3MWd8U1uaQuOu+VNkYHUKuilOIJNFEqkaiAYuLlWbT7YM6MmUqyurYEmGijzo/9WcWFQnVfHVaPk3O19agNInb/3Fkr8ViI5953vU3v8Xb5WPWMLDR97nK0oCczvoLX1dbkXCK6KLWxbfcIUDqKaLpL0lZeu/QvF77QIBM+OJz+k61G8F1kz0PLAztqXI9pEpQnfyole55P6JYZc2OKvJAWCqjStGEBc4k0kpKixtoK4mfYcnD0rq4oorRBeKyQ0cs07TprU8uOVj7yMa2HhaHpaq2v/Um0nenL6MFXklYdo5puISVAWv4oTwBFsonp5CuX1FTF+nVt+sE8q8kiMA8k7BBV6yULcAYm4xJtUkBpxihMHc1Wivp912kgr76jwF8PmvUAiq4JqefiJayUZCt+GlhDu/fSOuvYvlf2K6cczJ5zFjKM6PjOHhNNV3nQVHDmCTZQvDSv/BFb/b4+O9IM9G2IcACJEChkOUDhZ/PIWkWiweUm3YR4hgQhSfsyNEmrvWBW1I8ZJ3jW1x4Al7/CXqyAelVfZh99h8fNnVed8tXzqK/k/o+jav1TkFmKOB40TxugBSd+3BCY7NTpnvIlEyQygVOvxI9iEq+KtdFp6w/tzW23m4/6rGSdDzsIWIl5wUKFDFkqYPotffc6pokQihvPV3evrv37viXfef3R3j0q85pQwE8fgG+Vzyyu6fYB3nIQUeZod5fhUFb8XEFjx5QrHc/H/mT4szd0tFmAtf6Fgbb8tXrv2pxdN/7YCvVbFj2JW7RpV3lThdK/6Vi2g7eX7tTbFsL10xv76/7vbIooXodhZ+faF2pd7Qb8QUbUudASb0Co3ipZOd95c6O0LDriMYgzVZzv7tzBmUYwDgImQwdRAaGpwwkhauXKVSqQVYy7gEE7GjBPzO0p0e4d33pGbTKa+i3HAhCJeUAAfmAqiUOODEsbQxb//W1uV3GsPvvP33hrP7+rgk80g5yf/ENqTR2IymXoqXthKNhEywviQCWMIf1EirTiR7VM8KUH3GvIaeIeEPHnAV/fcVXM5KEOeyWSq44AYIfFBCVd5EwmmU3NzVNjUnjxliUyqkczNrVy7SfmTv/sjr2dTeMfmvFPF7hnvTCYTJFnA+WA4bOKIhhQlSy/ujMH34SfzZ/1PpEWT0yuPFg4jKxTyqLzt9ThPl7XcxmBnMpkqAQdNQHE4gr9c5U3IijjFk7LNP/yVagMdORn3Au9K5MnapiQ8ThoV5bGnL0wmUz8kuSCBIjlCCf1vZw50IO5OVkQuuRql5Mmf/WJw8Sk0Q8f5xx9f/+VvdRuGHVmVrp4tIhmeOeMMD39lG+4urUwmU9/FONBkcYCC0G0kUKQVwUtDLZBs/uMjr5VOFhN4p61MJlPf5QUKJ85vzzFZJE04b7I6/4N7Icx98PHaj99EsxQrTvSoMFTu7rWyha3J1HdpLujkys6uJAsnqOLuUIpVIEm38g5mbm4u0cpkMvVdXrLI5MVbdxzEUEyIOU7gk2jljIESDC/RymQy9V2aC94E0yjJGo4zq6uJtOJk+84b27ff4BLuXsKq0Uo/X0GJd37ntbKFrcnUd+mfFQgkZ1aWiTU6ZLNogvagFZVINmlIceJgjpPh0hK3SbQymUx9l+aCThgiRBzJHU5Qm2JFXZCUjGpkEyVsrhPUcvcUK5PJZAoBQieEFeIOh0Oi1bW1dCuSppX+PXfNu0QrTmxhazL1XVkLW9CEgeJ9Is1JzqysUOOwlawdLi56rWSinyfzWjUlJpOp70ohBWNFIubqtesaSYFk8wtfnF9YoO5IPn/5ClU5zZoS7++jcMJ5YC9MJlPfFQAEJxIomiwptOLEGykdc0elE1vYmkx9V2BhK2mSApQArbwRaO8kciu5o9KJyWTquwKAYKxAiYjxYqspmjCHCGylxagoMZlMfVcAEKBJFlCc5PLOjpd3Acxd2d2VDt6k9ahsYWsy9V1TXNgGkmNlZTKZ+i7NBQmUdmTh5FhZmUymvosnepImnHNtVnLMrUwmk8lkMplMJpPJZDKZTCaTyWQymUwmkylFjzzyP8jNXJizL7TnAAAAAElFTkSuQmCC"
    $Image = [System.Convert]::FromBase64String($Image64)
    [System.Windows.Forms.Clipboard]::SetImage($Image)
    

    Show-Result -Font "Courier New" -Size "10" -Color "Yellow" -Text "     " -NewLine $true
    Show-Result -Font "Courier New" -Size "10" -Color "Yellow" -Text "     " -NewLine $true

    $syncHash.Gui.RTB_Output.ScrollToEnd()
    $syncHash.Gui.RTB_Output.Paste()

    Show-Result -Font "Courier New" -Size "20" -Color "Lime" -Text "$copyright David Wang, 2022 - V2.0" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "           " -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "Required module: PSParallel" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "LightGreen" -Text " (By Staffan Gustafsson)" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "LightBlue" -Text " https://github.com/powercode/PSParallel" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "Minimum Powershell Version : " -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text "5.0" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text " | Current Powershell Version : " -NewLine $false
    $ver = $PSVersionTable.PSVersion.ToString()
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $ver -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "Required account type: " -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Pink" -Text "Domain admin for more information on each alive node" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Pink" -Text "                       Local admin for ARP scan" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "Main features        : " -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text "IP Scan(ICMP/ARP), Port Scan/Sweep(TCP handshake)" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Magenta" -Text "ESC" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text " to clear output window" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Chartreuse" -Text "  Auto-save sorted result to C:\PSScanner" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Magenta" -Text "Switch -ps7" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "  to use native method for multi-threading on Powershell Core 7+" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Magenta" -Text "Switch -NoTerminal" -NewLine $false
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "  To hide terminal window." -NewLine $true

    for($i=0;$i -lt 65; $i++){
        if($i -eq 64) {$nl = $true} else {$nl = $false}
        if($i % 2 -eq 0) {$color = "Lime"} else {$color = "Red"}
        Show-Result -Font "Courier New" -Size "30" -Color $color -Text "$emoji_box_h" -NewLine $nl
    }

    Show-Result -Font "Courier New" -Size "20" -Color "Lime" -Text "The MIT License (MIT)" -NewLine $true
    Show-Result -Font "Courier New" -Size "16" -Color "Cyan" -Text "Copyright $copyright 2022, David Wang" -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "Cyan" -Text "                 " -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'associated documentation files (the "Software"), to deal in the Software without restriction,' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'subject to the following conditions:' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text '                 ' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'The above copyright notice and this permission notice shall be included in all copies or substantial' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text 'portions of the Software.' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "LightGreen" -Text '                 ' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "Yellow" -Text 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "Yellow" -Text 'LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "Yellow" -Text 'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "Yellow" -Text 'WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE' -NewLine $true
    Show-Result -Font "Courier New" -Size "14" -Color "Yellow" -Text 'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' -NewLine $true
}

# Handle ? button press
$syncHash.Gui.BTN_About.add_click({
    about
})

# Performing port scan is a different thread
$syncHash.PortScan_scriptblock = {
    param(
        [string]$cn,       # Target IP/name
        [int]$start_port,  # Start port
        [int]$end_port,    # End port
        [int]$threshold,   # Thread pool size
        [bool]$openOnly,   # Show open ports only
        [bool]$ps7         # Use native PS7+ multi-threading
    )

    $syncHash.mutex.WaitOne()
        $syncHash.opened = 0
        $syncHash.closed = 0
        $syncHash.filtered = 0
    $syncHash.mutex.ReleaseMutex()

    $Time = [System.Diagnostics.Stopwatch]::StartNew()

    # Port scan worker thread
    $TcpScan = {
        $tcpSocket = new-Object system.Net.Sockets.TcpClient
        $handshake = $tcpSocket.ConnectAsync($cn,$_)   
        $msg = $_.tostring().PadRight(10)
        $msg = "          " + $msg
        $result = ""

        for($i=0; $i -lt 10; $i++) {
            if ($handshake.isCompleted) { break; }
            Start-Sleep -milliseconds 1000
          }
        $tcpSocket.Close();

        $emoji_check  = [char]::ConvertFromUtf32(0x02714) # ✔
        $emoji_close  = [char]::ConvertFromUtf32(0x026D4) # ⛔

        if ($handshake.isFaulted -and ($handshake.Exception.InnerException -match "actively refused")) {
            $result = $emoji_close
            $syncHash.mutex.WaitOne()
                $syncHash.closed += 1
            $syncHash.mutex.ReleaseMutex()
        } elseif ($handshake.Status -eq "RanToCompletion") {
            $result = $emoji_check
            $syncHash.mutex.WaitOne()
                $syncHash.opened += 1
            $syncHash.mutex.ReleaseMutex()
        }

        $msg += $result
        [bool]$show = $false

        if($openOnly){
            if($result -eq $emoji_check){
                $show = $true
            }
        } else {
            if($result -eq $emoji_check -or $result -eq $emoji_close){
                $show = $true
            }
        }
        if($show){
            $objHash = @{
                font    = "Courier New"
                size    = "20"
                color   = "MediumSpringGreen"
                msg     = $msg
                newline = $true
            }
            $syncHash.Q.Enqueue($objHash)
            Remove-Variable -Name "objHash"
        }
    }

    # I feel really stupid here. Please don't blame on me to duplicate the code, but I have no choice
    # I can't pass any parameters into the thread, so not able to dertermin if the -ps7 switch is given
    # inside the thread
    if($ps7){
        $start_port .. $end_port | ForEach-Object -ThrottleLimit $threshold -Parallel {
            $sync = $Using:syncHash

            $tcpSocket = new-Object system.Net.Sockets.TcpClient
            $handshake = $tcpSocket.ConnectAsync($Using:cn,$_)   
            $msg = $_.tostring().PadRight(10)
            $msg = "          " + $msg
            $result = ""

            for($i=0; $i -lt 10; $i++) {
                if ($handshake.isCompleted) { break; }
                Start-Sleep -milliseconds 1000
            }
            $tcpSocket.Close();

            $emoji_check  = [char]::ConvertFromUtf32(0x02714) # ✔
            $emoji_close  = [char]::ConvertFromUtf32(0x026D4) # ⛔

            if ($handshake.isFaulted -and ($handshake.Exception.InnerException -match "actively refused")) {
                $result = $emoji_close
                $sync.mutex.WaitOne()
                    $sync.closed += 1
                $sync.mutex.ReleaseMutex()
            } elseif ($handshake.Status -eq "RanToCompletion") {
                $result = $emoji_check
                $sync.mutex.WaitOne()
                    $sync.opened += 1
                $sync.mutex.ReleaseMutex()
            }

            $msg += $result
            [bool]$show = $false

            if($Using:openOnly){
                if($result -eq $emoji_check){
                    $show = $true
                }
            } else {
                if($result -eq $emoji_check -or $result -eq $emoji_close){
                    $show = $true
                }
            }
            if($show){
                $objHash = @{
                    font    = "Courier New"
                    size    = "20"
                    color   = "MediumSpringGreen"
                    msg     = $msg
                    newline = $true
                }
                $sync.Q.Enqueue($objHash)
                Remove-Variable -Name "objHash"
            }
        }
    } else {
        $start_port .. $end_port | Invoke-Parallel -ThrottleLimit $threshold -ProgressActivity "TCP Port Scanning Progress" -ScriptBlock $TcpScan
    }

    $msg = "Total "
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White","     ",$true
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $msg = ($end_port - $start_port + 1).ToString()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Orange",$msg,$false

    $msg = " port(s) scanned in ["
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $currenttime = $Time.Elapsed

    $d = ($currenttime.days).ToString()
    $h = ($currenttime.hours).ToString()
    $m = ($currenttime.minutes).ToString()
    $s = ($currenttime.seconds).ToString()
    $t = ($currenttime.Milliseconds).ToString()
    $msg = $d + ":" + $h + ":" + $m + ":" + $s + ":" + $t
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Orange",$msg,$false
    $msg = "], Opened("
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
        $msg = ($syncHash.opened).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = ") Closed("
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
        $msg = ($syncHash.closed).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = ") Filtered("
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
        $msg = ($end_port - $start_port + 1 - $syncHash.opened - $syncHash.closed).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = ")"
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$true

    if($ps7){
        $w = "(Native)"
    } else {
        $w = "(Module)"
    }
    $msg = "===== Scanning TCP port range " + $start_port +" --- " + $end_port + " Finished $w ====="
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","YellowGreen",$msg,$true

    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Black"," ",$true

    $syncHash.mutex.WaitOne()
        $syncHash.opened = 0
        $syncHash.closed = 0
        $syncHash.filtered = 0
    $syncHash.mutex.ReleaseMutex()

    $Time.Stop()
    Remove-Variable -Name "Time"
}

# Handle ScanPort Button click event
$syncHash.GUI.BTN_ScanPort.Add_Click({
    [int]$threshold = 50
    [int]$sp = 0
    [int]$ep = 0

    $syncHash.Gui.rtb_Output.Document.Blocks.Clear()

    if([string]::IsNullOrEmpty($syncHash.Gui.TB_Threshold.text)){
        $syncHash.Gui.TB_Threshold.text = "50"
        $threshold = 50
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

    if([string]::IsNullOrEmpty($syncHash.Gui.TB_SP.text)){
        $msg = "Starting port missing..."
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    if([string]::IsNullOrEmpty($syncHash.Gui.TB_EP.text)){
        $msg = "Ending port missing..."
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    $sp = ($syncHash.Gui.TB_SP.text) -as [int]
    $ep = ($syncHash.Gui.TB_EP.text) -as [int]

    if($sp -gt 65535 -or $ep -gt 65535) {
        $msg = "Port number should be 1-65535"
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    if($sp -gt $ep){
        $msg = "Wrong port range."
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    [string]$cn = $syncHash.Gui.TB_IPAddress.text

    if([string]::IsNullOrEmpty($cn)){
        $msg = "Please provide the computername or IP address of the target machine."
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    Show-Result -Font "Courier New" -Size "20" -Color "Lime" -Text "Port Scanning" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "----------------------------------------------------" -NewLine $true

    $msg = "Start Port = " + $syncHash.Gui.TB_SP.text
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    $msg = "End Port   = " + $syncHash.Gui.TB_EP.text
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    $msg = "Target     = " + $cn
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    if($ps7){
        $w = "(Native)"
    } else {
        $w = "(Module)"
    }
    $msg = "Creating worker threads with threshold $threshold $w ..."
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    Invoke-Command $syncHash.Devider_scriptblock

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
    $syncHash.Gui.TB_SP.IsEnabled        = $false
    $syncHash.Gui.TB_EP.IsEnabled        = $false
    $syncHash.Gui.CB_SOO.IsEnabled       = $false
    $syncHash.Gui.BTN_ScanPort.IsEnabled = $false
    $syncHash.Gui.BTN_Sweep.IsEnabled = $false
    $syncHash.Gui.TB_Sweep.IsEnabled     = $false

    # create the extra Powershell session and add the script block to execute
    $Session = [PowerShell]::Create().AddScript($syncHash.PortScan_scriptblock).AddArgument($cn).AddArgument($sp).AddArgument($ep).AddArgument($threshold).AddArgument($syncHash.GUI.CB_SOO.IsChecked).AddArgument($ps7.IsPresent)

    # execute the code in this session
    $Session.RunspacePool = $RunspacePool
    $Handle = $Session.BeginInvoke()
    $syncHash.Jobs.Add([PSCustomObject]@{
        'Session' = $Session
        'Handle' = $Handle
    })
    [System.GC]::Collect()

    # start progressbar animation
    $syncHash.Gui.PB.IsIndeterminate = $true
})

# Thread to perform the TCP sweep
$syncHash.PortSweep_scriptblock = {
    param(
        [string]$start,   # Start IP
        [string]$end,     # End IP
        [int]$threshold,  # Max number of threads
        [int[]]$ports,    # Port list
        [bool]$ps7        # Use native PS7+ multi-threading
    )

    $StartArray = $start.Split('.')
    $EndArray = $end.Split('.')

    [int]$Oct2First = $StartArray[1] -as [int]
    [int]$Oct2Last  = $EndArray[1]   -as [int]
    [int]$Oct3First = $StartArray[2] -as [int]
    [int]$Oct3Last  = $EndArray[2]   -as [int]
    [int]$Oct4First = $StartArray[3] -as [int]
    [int]$Oct4Last  = $EndArray[3]   -as [int]
    [string]$msg    = ""

    [System.Diagnostics.Stopwatch]$Time = [System.Diagnostics.Stopwatch]::StartNew()

    $syncHash.mutex.WaitOne()
    $syncHash.Count = 0
    $syncHash.mutex.ReleaseMutex()

    # Calculate IP address set based on IP range
    # In case of 8 <= CIDR < 16
    if(($StartArray[0] -eq $EndArray[0]) -and ($StartArray[1] -ne $EndArray[1])){
        if($Oct4First -eq 0){
            $Oct4First++
        }

        if($Oct4Last -eq 255){
            $Oct4Last--
        }

        $IPAddresses = $Oct2First..$Oct2Last | ForEach-Object { # This will be absolutely slow (3 layers of nested loop)
            $y = $_
            $Oct3First..$Oct3Last | ForEach-Object {
                $t = $_
                $Oct4First..$Oct4Last | ForEach-Object {
                    $StartArray[0]+'.'+$y+'.'+$t+'.'+$_
                }
            }
        }
    }

    # In case of 16 <= CIDR < 24
    if(($StartArray[0] -eq $EndArray[0]) -and ($StartArray[1] -eq $EndArray[1]) -and ($StartArray[2] -ne $EndArray[2])){
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
    }

    # In case of CIDR >= 24
    if(($StartArray[0] -eq $EndArray[0]) -and ($StartArray[1] -eq $EndArray[1]) -and ($StartArray[2] -eq $EndArray[2]) -and ($StartArray[3] -ne $EndArray[3])){ 
        if($Oct4First -eq 0){
            $Oct4First++
        }

        if($Oct4Last -eq 255){
            $Oct4Last--
        }

        $IPAddresses = $Oct4First..$Oct4Last | ForEach-Object {$StartArray[0]+'.'+$StartArray[1]+'.'+$StartArray[2]+'.'+$_}
    }

    # in case there is only 1 IP
    if(($IPAddresses.GetType().name) -eq "String"){
        $IPAddresses = @($IPAddresses)
    }

    # Building target object
    $targets = @()
    $IPAddresses | ForEach-Object {
        for($i=0; $i -lt $ports.Count; $i++){
            $item = [PSCustomObject]@{
                'ip'   = $_
                'port' = $ports[$i]
            }
            $targets += $item
        }
    }

    # TCP sweep work thread
    $PortSweep = {
        # We use TCP handshake to determine if the port is open
        $tcpSocket = new-Object system.Net.Sockets.TcpClient
        $handshake = $tcpSocket.ConnectAsync($_.ip,$_.port)   
        $msg = $_.ip.PadRight(16) + " :" + $_.port.tostring().PadRight(10)
        $result = ""

        for($i=0; $i -lt 10; $i++) {
            if ($handshake.isCompleted) { break; }
            Start-Sleep -milliseconds 1000
          }
        $tcpSocket.Close();

        $emoji_check  = [char]::ConvertFromUtf32(0x02714) # ✔
        $emoji_close  = [char]::ConvertFromUtf32(0x026D4) # ⛔

        # Actively refuse = RST "The port is not filtered and no process listening on that port"
        # No response = The prot is filteres as connection time out and there is no response from the target
        if ($handshake.isFaulted -and ($handshake.Exception.InnerException -match "actively refused")) {
            $result = $emoji_close
            $syncHash.mutex.WaitOne()
                $syncHash.closed += 1
            $syncHash.mutex.ReleaseMutex()
        } elseif ($handshake.Status -eq "RanToCompletion") {
            $result = $emoji_check
            $syncHash.mutex.WaitOne()
                $syncHash.opened += 1
            $syncHash.mutex.ReleaseMutex()
        }

        $msg += $result

        if($result -eq $emoji_check){
            $objHash = @{
                font    = "Courier New"
                size    = "20"
                color   = "MediumSpringGreen"
                msg     = $msg
                newline = $true
            }
            $syncHash.Q.Enqueue($objHash)
            Remove-Variable -Name "objHash"
        }
    }

    # I feel really stupid here. Please don't blame on me to duplicate the code, but I have no choice
    # I can't pass any parameters into the thread, so not able to dertermin if the -ps7 switch is given
    # inside the thread
    # Forking worker threads using PSParallel
    if($ps7){
        $targets | ForEach-Object -ThrottleLimit $threshold -Parallel {
            $sync = $Using:syncHash
            # We use TCP handshake to determine if the port is open
            $tcpSocket = new-Object system.Net.Sockets.TcpClient
            $handshake = $tcpSocket.ConnectAsync($_.ip,$_.port)   
            $msg = $_.ip.PadRight(16) + " :" + $_.port.tostring().PadRight(10)
            $result = ""
    
            for($i=0; $i -lt 10; $i++) {
                if ($handshake.isCompleted) { break; }
                Start-Sleep -milliseconds 1000
              }
            $tcpSocket.Close();
    
            $emoji_check  = [char]::ConvertFromUtf32(0x02714) # ✔
            $emoji_close  = [char]::ConvertFromUtf32(0x026D4) # ⛔
    
            # Actively refuse = RST "The port is not filtered and no process listening on that port"
            # No response = The prot is filteres as connection time out and there is no response from the target
            if ($handshake.isFaulted -and ($handshake.Exception.InnerException -match "actively refused")) {
                $result = $emoji_close
                $sync.mutex.WaitOne()
                    $sync.closed += 1
                $sync.mutex.ReleaseMutex()
            } elseif ($handshake.Status -eq "RanToCompletion") {
                $result = $emoji_check
                $sync.mutex.WaitOne()
                    $sync.opened += 1
                $sync.mutex.ReleaseMutex()
            }
    
            $msg += $result
    
            if($result -eq $emoji_check){
                $objHash = @{
                    font    = "Courier New"
                    size    = "20"
                    color   = "MediumSpringGreen"
                    msg     = $msg
                    newline = $true
                }
                $sync.Q.Enqueue($objHash)
                Remove-Variable -Name "objHash"
            }
        }
    } else {
        $targets | Invoke-Parallel -ThrottleLimit $threshold -ProgressActivity "Sweeping Progress" -ScriptBlock $PortSweep
    }
    
    # Display the scan summary
    $msg = "Total "
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White","     ",$true
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $msg = $IPAddresses.Count.ToString()
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
    $msg = "]. Ports Opened("
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
        $msg = ($syncHash.opened).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = "), Closed("
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$false

    $syncHash.mutex.WaitOne()
        $msg = ($syncHash.closed).ToString()
    $syncHash.mutex.ReleaseMutex()
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","Magenta",$msg,$false

    $msg = ")"
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","White",$msg,$true

    if($ps7){
        $w = "(Native)"
    } else {
        $w = "(Module)"
    }
    $msg = "===== Port Sweeping Completed $w ====="
    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","20","YellowGreen",$msg,$true

    Invoke-Command $syncHash.outputFromThread_scriptblock -ArgumentList "Courier New","18","Black"," ",$true

    $syncHash.mutex.WaitOne()
        $syncHash.opened = 0
        $syncHash.closed = 0
        $syncHash.filtered = 0
    $syncHash.mutex.ReleaseMutex()

    $Time.Stop()

    $tcpSocket.Dispose()
    $handshake.Dispose()

    Remove-Variable -Name "Time"
    Remove-Variable -Name "IPAddresses"
    Remove-Variable -Name "targets"
    Remove-Variable -Name "StartArray"
    Remove-Variable -Name "EndArray"
    Remove-Variable -Name "tcpSocket"
    Remove-Variable -Name "handshake"
}

# Handle Sweep Button click event
$syncHash.GUI.BTN_Sweep.Add_Click({
    [int]$threshold = 50

    $syncHash.Gui.rtb_Output.Document.Blocks.Clear()

    # Threshold input validation
    if([string]::IsNullOrEmpty($syncHash.Gui.TB_Threshold.text)){
        $syncHash.Gui.TB_Threshold.text = "50"
        $threshold = 50
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

    [string]$cn = $syncHash.Gui.TB_IPAddress.text

    if([string]::IsNullOrEmpty($cn)){
        $msg = "Please provide the computername or IP address of the target machine."
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    # Get the port list
    if([string]::IsNullOrEmpty($syncHash.Gui.TB_Sweep.text)){
        $msg = "Please provide a list of ports to sweep, seperated with comma."
        Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
        return
    }

    # Remove all duplidated commas
    $syncHash.Gui.TB_Sweep.text = $syncHash.Gui.TB_Sweep.text -replace ",+" , ","

    # If the last character is comma, remove it
    if($syncHash.Gui.TB_Sweep.text[$syncHash.Gui.TB_Sweep.text.length - 1] -eq ","){
        $syncHash.Gui.TB_Sweep.text = $syncHash.Gui.TB_Sweep.text.Substring(0, $syncHash.Gui.TB_Sweep.text.Length - 1)
    }

    # Generate integer port list
    $temp= $syncHash.Gui.TB_Sweep.text.Split(",")
    $ports = foreach($number in $temp) { # Port list
        if($number -ne $null -and $number -ne 0 -and $number -ne ""){
            try {
                [int]::parse($number)
            }
            catch {
                Invoke-Expression -Command $number;
            }
        }
    }

    # Validate all ports
    for($i=0; $i -lt $ports.Count; $i++){
        if($ports[$i] -lt 0 -or $ports[$i] -gt 65535){
            $msg = "Illegal port number detected [0-65535]."
            Show-Result -Font "Courier New" -Size "20" -Color "Red" -Text $msg -NewLine $true
            return
        }
    }

    # Get start/end IP
    if(!(Test-IPAddress($syncHash.Gui.TB_IPAddress.text))){ # IP Address validation
        $msg = "Illegal IP address detected."
        Show-Result -Font "Courier New" -Size "20" -Color "Red" -Text $msg -NewLine $true
        return
    }

    [string]$ip = $syncHash.GUI.TB_IPAddress.text

    # Net mask is selected
    if($syncHash.GUI.RB_Mask.IsChecked){ # Subnet mask validation
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

        if(!($syncHash.Gui.TB_NetMask.text.SubString(0,4) -eq '255.')){
            $msg = "IP range too large to handle. [CIDR >= 8] or [Subnet Mask >= 255.0.0.0]"
            Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text $msg -NewLine $true
            return
        }

        $mask = ($syncHash.GUI.TB_NetMask.text)

        $range = Get-IPrange -ip $ip -mask $mask
    }

    # CIDR is selected
    if($syncHash.GUI.RB_CIDR.IsChecked){ # CIDR validation
        if([string]::IsNullOrEmpty($syncHash.Gui.TB_CIDR.text)){
            $msg = "Please provide CIDR."
            Show-Result -Font "Courier New" -Size "18" -Color "Red" -Text $msg -NewLine $true
            return
        }
        $cidr = $syncHash.GUI.TB_CIDR.text -as [int]
        if($cidr -lt 8 -or $cidr -gt 31){
            $msg = "IP range too large to handle. [CIDR >= 8] or [Subnet Mask >= 255.0.0.0]"
            Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text $msg -NewLine $true
            return
        }
        $range = Get-IPrange -ip $ip -cidr $cidr
    }

    Show-Result -Font "Courier New" -Size "20" -Color "Lime" -Text "Port Sweeping" -NewLine $true
    Show-Result -Font "Courier New" -Size "18" -Color "Yellow" -Text "----------------------------------------------------" -NewLine $true

    # Remove spaces
    $syncHash.Gui.TB_Sweep.text = $syncHash.Gui.TB_Sweep.text -replace " ", ""
    $msg = "Port List : " + $syncHash.Gui.TB_Sweep.Text
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    $msg = "Start IP  : " + $range.Start
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    $msg = "End IP    : " + $range.end
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    if($ps7.IsPresent){
        $w = "(Native)"
    } else {
        $w = "(Module)"
    }
    $msg = "Creating worker threads with threshold $threshold $w ..."
    Show-Result -Font "Courier New" -Size "18" -Color "Cyan" -Text $msg -NewLine $true

    Invoke-Command $syncHash.Devider_scriptblock

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
    $syncHash.Gui.TB_SP.IsEnabled        = $false
    $syncHash.Gui.TB_EP.IsEnabled        = $false
    $syncHash.Gui.CB_SOO.IsEnabled       = $false
    $syncHash.Gui.BTN_ScanPort.IsEnabled = $false
    $syncHash.Gui.BTN_Sweep.IsEnabled = $false
    $syncHash.Gui.TB_Sweep.IsEnabled     = $false

    # create the extra Powershell session and add the script block to execute
    $Session = [PowerShell]::Create().AddScript($syncHash.PortSweep_scriptblock).AddArgument($range.Start).AddArgument($range.end).AddArgument($threshold).AddArgument($ports).AddArgument($ps7.IsPresent)
    # execute the code in this session
    $Session.RunspacePool = $RunspacePool
    $Handle = $Session.BeginInvoke()
    $syncHash.Jobs.Add([PSCustomObject]@{
        'Session' = $Session
        'Handle' = $Handle
    })
    [System.GC]::Collect()

    # start progressbar animation
    $syncHash.Gui.PB.IsIndeterminate = $true
})
# Set IPAddress focused when script starts
$syncHash.Gui.TB_IPAddress.Template.FindName("PART_EditableTextBox", $syncHash.Gui.TB_IPAddress)

$icon64 = "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/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAIAAAAAAAAAAAAAAAIAAAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAAgAAAAAAAAAAAAAAAgAAAAP8CAgL/AQEB/wAAAP8AAAD/AAAA/wEBAf8AAAD/AAAA/wAAAP8AAAD/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AgIC/wAAAP8AAAD/AAAA/wEBAf8CAgL/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wAAAP8CAgL/AQEB/wAAAP8AAAD/AQEB/wICAv8AAAD/AAAA/wAAAP8CAgL/AQEB/wAAAP8AAAD/AAAA/wEBAf8AAAD/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wEBAf8CAgL/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wAAAP8CAgL/AQEB/wAAAP8AAAD/AQEB/wICAv8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8AAAD/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wEBAf8CAgL/AAAA/wAAAP8AAAD/AQEB/wEBAf8AAAD/AAAA/wAAAP8CAgL/AQEB/wAAAP8AAAD/AQEB/wICAv8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQGAAAAAAAAAAAAAAACAAAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8BAQH/AQEB/wEBAf8BAQH/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8BAQH/AQEB/wEBAf8BAQH/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8BAQH/AQEB/wEBAf8BAQH/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wEBAYAAAAAAAAAAAAAAAIAAAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wQEBP8CAgL/AAAA/wAAAP8CAgL/BAQE/wEBAf8AAAD/AAAA/wMDA/8EBAT/AAAA/wAAAP8AAAD/BAQE/wICAv8AAAD/AAAA/wEBAf8EBAT/AQEB/wAAAP8AAAD/AwMD/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wQEBP8CAgL/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wMDA/8EBAT/AAAA/wAAAP8AAAD/BAQE/wMDA/8AAAD/AAAA/wEBAf8EBAT/AQEB/wAAAP8AAAD/AgIC/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wQEBP8DAwP/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/BAQE/wMDA/8AAAD/AAAA/wEBAf8EBAT/AgIC/wAAAP8AAAD/AAAAgAAAAAAAAAAAAgICgAICAv8AAAD/AAAA/wEBAf8DAwP/AgIC/wAAAP8BAQH/AQEB/wMDA/8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8DAwP/AAAA/wAAAP8BAQH/AwMD/wICAv8AAAD/AQEB/wEBAf8DAwP/AQEB/wAAAP8BAQH/AgIC/wMDA/8AAAD/AAAA/wEBAf8DAwP/AgIC/wAAAP8BAQH/AQEB/wMDA/8CAgL/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8DAwP/AAAA/wAAAP8BAQH/AwMD/wICAv8AAAD/AQEB/wEBAf8DAwP/AgIC/wAAAP8BAQH/AgIC/wMDA/8BAQH/AAAA/wEBAf8CAgL/AwMD/wAAAP8BAQH/AQEB/wMDA/8CAgL/AAAA/wAAAP8AAAD/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8DAwP/AQEB/wAAAP8BAQH/AgIC/wMDA/8AAAD/AQEB/wEBAf8DAwP/AgIC/wAAAP8BAQH/AgIC/wMDA/8BAQH/AAAA/wEBAf8CAgL/AwMD/wAAAP8AAACAAAAAAAAAAAACAgKAAgIC/wEBAf8AAAD/AAAA/wMDA/8DAwP/AQEB/wAAAP8AAAD/AwMD/wICAv8BAQH/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wEBAf8AAAD/AgIC/wMDA/8BAQH/AAAA/wAAAP8DAwP/AwMD/wEBAf8AAAD/AAAA/wMDA/8CAgL/AQEB/wAAAP8BAQH/AwMD/wEBAf8BAQH/AAAA/wICAv8DAwP/AQEB/wAAAP8BAQH/Dg4L/w4OC/8ODgv/Dg4L/w8OC/8PDwz/Dw4L/w4OC/8ODgv/Dw8L/w8PDP8PDwz/Dw4L/w4OC/8ODgv/EA8M/xIRDv8PDgv/Dg4L/w4OC/8REA3/EREN/w4OC/8ODgv/Dw4L/xIRDv8ODgv/CwsI/wEBAf8BAQH/AwMD/wEBAf8BAQH/AAAA/wICAv8DAwP/AQEB/wAAAP8AAAD/AwMD/wICAv8BAQH/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wEBAf8AAAD/AQEB/wMDA/8BAQH/AQEB/wAAAP8CAgL/AwMD/wEBAf8AAAD/AAAA/wMDA/8CAgL/AQEB/wAAAP8BAQH/AwMD/wEBAf8BAQH/AAAA/wICAv8DAwP/AAAA/wAAAIAAAAAAAAAAAAAAAIAAAAD/BAQE/wMDA/8AAAD/AAAA/wEBAf8EBAT/AQEB/wAAAP8AAAD/AgIC/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8DAwP/BAQE/wAAAP8AAAD/AAAA/wQEBP8DAwP/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/BAQE/wMDA/8AAAD/AAAA/wEBAf8EBAT/AgIC/wMDA/82Nin/QD8x/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0FAMf83Nyr/AwMD/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wEBAf8EBAT/AgIC/wAAAP8AAAD/AgIC/wQEBP8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wAAAP8CAgL/AgICgAAAAAAAAAAAAAAAgAAAAP8BAQH/AgIC/wMDA/8AAAD/AAAA/wEBAf8CAgL/AgIC/wAAAP8BAQH/AQEB/wMDA/8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8DAwP/AAAA/wAAAP8BAQH/AgIC/wICAv8AAAD/AQEB/wEBAf8DAwP/AQEB/wAAAP8BAQH/AgIC/wMDA/8kIxv/Ly4j/zAvJP8vLiT/MC8k/0NBMv9GRTX/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9JSDj/Skg3/0pIN/9KSDf/SUg4/0lIOP9KSDf/R0U1/0NCMv8wLyT/Ly4j/y8uI/8wLyT/JSQc/wMDA/8BAQH/AAAA/wEBAf8CAgL/AwMD/wAAAP8BAQH/AQEB/wICAv8CAgL/AAAA/wAAAP8AAAD/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8DAwP/AQEB/wAAAP8BAQH/AgIC/wMDA/8AAAD/AQEB/wEBAf8CAgL/AgIC/wAAAP8BAQH/AgIC/wMDA/8BAQH/AAAA/wEBAf8BAQGAAAAAAAAAAAAAAACAAAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8AAAD/BAQE/wICAv8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wQEBP8BAQH/AAAA/wAAAP8DAwP/AwMD/wAAAP8AAAD/AAAA/wQEBP8EBAT/BQUE/wUFBP8HBgX/CQkI/zo4K/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9KSDf/SUg4/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/86OCv/CQkI/wcGBf8FBQT/BQUE/wQEBP8EBAT/AAAA/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wQEBP8BAQH/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wAAAIAAAAAAAAAAAAICAoACAgL/AAAA/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wEBAf8EBAT/AgIC/wAAAP8AAAD/AAAA/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/yAgGf9JSDj/Skg3/0pIN/9KSDf/SUg4/0lIOP9KSDf/Skg3/0pIN/9JSDj/Skg4/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9KSDf/SUg4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/wICAv8CAgL/AgIC/wAAAP8BAQH/AgIC/wICAv8BAQH/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AgIC/wkJB/8dHBX/NjQo/0JAMv9KSDf/Skg3/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/SEc2/zIxJf8vLiP/LSwi/y0sIv8tLCP/Ly0j/y0sIv8tLCL/LSwi/x4dF/8VFBD/AwMC/wICAf8BAQH/AAAA/wICAf8DAwP/FxYR/yAfF/8tLCL/Li0j/y4tI/8tLCL/LSwi/y0sIv8vLSP/Ly4k/zAvJP9IRjb/SUg4/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0FBMv81NCj/HBwW/wgIBv8CAgH/AgIC/wICAv8BAQH/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wEBAf8AAAD/AQEB/wICAv8CAgL/AQEB/wAAAP8CAgL/AgIC/wICAv8AAAD/AAAA/wICAv8CAgL/AQEB/wAAAP8AAACAAAAAAAAAAAACAgKAAgIC/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8GBgX/GBcS/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9GRDT/DAwK/wYGBf8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8DAwP/AwMD/wAAAP8AAAD/AAAA/wQEBP8GBgb/CAgH/0ZENP9KSDf/SUg4/0pIN/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9KSDf/SUg4/0lIOP9KSDf/Skg3/0pIN/9JSDj/FRUQ/wMDAv8AAAD/AwMD/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8DAwP/BAQE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/wEBAf8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/BAQD/wQEA/8EBAP/EA4L/yEfGP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9HRjX/R0U1/0ZENP8dHBb/BAQE/wAAAP8AAAD/AAAA/wQEBP8CAgL/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAAgAAAAAAAAAAAAgICgAICAv8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wQEBP8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/BgYG/xgXE/9KSDf/Skg3/0pIN/9JSDj/Skg3/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/RkQ0/wgHBf8FBAP/AQEB/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wAAAP8EBAT/BgYF/wgHBf9GRDT/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/xgXEv8GBgX/AAAA/wAAAP8AAAD/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wQEBP8AAAD/AAAA/wAAAP8EBAT/AgIC/wAAAP8AAAD/AQEB/wQEBP8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8BAQGAAAAAAAAAAAABAQGAAQEB/wICAv8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8BAQH/AAAA/wAAAP8AAAD/AgIC/wICAv8CAgL/AAAA/wAAAP8CAgL/AgIC/wICAv8AAAD/AQEB/wICAv8CAgL/AQEB/wAAAP8DAwP/DQwK/ygnHv8/Pi//Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9IRjX/KCcd/yYlHP8lJBv/JCMb/yQjG/8kIxv/IB8Z/xgYE/8EBAP/AQEB/wAAAP8CAgL/AgIC/wICAv8AAAD/AQEB/wICAv8CAgL/AgIC/wMDAv8YFxL/IB8Z/yQjG/8kIxv/JCMb/yYlHf8nJh3/KCce/0hGNf9KSDf/SUg4/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/z89L/8mJRz/DAwJ/wMDA/8CAgL/AQEB/wAAAP8CAgL/AgIC/wICAv8AAAD/AQEB/wICAv8CAgL/AQEB/wAAAP8BAQH/AgIC/wICAv8BAQH/AAAA/wICAv8CAgL/AgIC/wAAAP8BAQH/AgIC/wICAv8CAgL/AAAA/wAAAP8BAQH/AQEB/wEBAYAAAAAAAAAAAAAAAIAAAAD/BAQE/wMDA/8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wQEBP8BAQH/AAAA/wAAAP8DAwP/BAQE/wAAAP8AAAD/AAAA/wQEBP8DAwP/AAAA/wAAAP8BAQH/BAQE/zQzJ/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9KSDf/SUg4/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/8+PS//Ly4k/wkJB/8DAwL/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wQEBP8FBQT/BgYE/y4tI/8+PS//SUg4/0pIN/9KSDf/Skg3/0pIOP9JSDj/Skg3/0pIN/9KSDf/SUg4/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/MzIm/wAAAP8AAAD/AQEB/wQEBP8CAgL/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wAAAP8BAQH/AQEBgAAAAAAAAAAAAAAAgAAAAP8AAAD/AgIC/wQEBP8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/BgYF/wkJB/8FBQT/LCsh/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/SUg4/0lHN/9IRjb/RUMz/0RDNP9EQzT/RUMz/0VDM/9FQzP/REM0/0RDM/9FQzP/RUMz/0VDNP9EQzT/SEY2/0lHNv9KSDf/SUg4/0lIOP9KSDf/Skg3/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/8sKyH/BQUE/wUFBP8FBQT/BAQE/wEBAf8AAAD/AAAA/wICAv8DAwP/AAAA/wAAAP8AAAD/AwMD/wICAv8AAAD/AAAA/wEBAf8EBAT/AQEB/wAAAP8AAAD/AgIC/wQEBP8AAAD/AAAA/wAAAP8DAwP/AwMD/wAAAP8AAAD/AQEB/wQEBP8BAQH/AAAA/wAAAP8AAACAAAAAAAAAAAABAQGAAQEB/wAAAP8BAQH/AwMD/wICAv8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8DAwP/AQEB/wAAAP8AAAD/AgIC/wICAv8BAQH/AQEB/wAAAP8DAwP/AgIC/wEBAf8AAAD/AQEB/wMDA/8CAgL/AQEB/wAAAP8CAgL/AgIC/wEBAf8bGhT/Ly4j/y4uJP86OSz/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9KSDf/Skg3/0pIN/9JSDj/Skg3/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9JSDj/SUg4/0pIN/9KSDf/Skg3/0lIOP9KSDf/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/0lIOP9JSDj/Skg3/0pIN/9KSDf/SUg4/0pIN/9KSDf/Skg3/zs5LP8vLiP/Ly4j/xsaFP8AAAD/AAAA/wEBAf8DAwP/AQEB/wAAAP8AAAD/AgIC/wICAv8BAQH/AQEB/wAAAP8CAgL/AgIC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/wICAv8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8AAAD/AgIC/wQEBP8BAQH/AAAA/wAAAP8DAwP/AwMD/wAAAP8AAAD/AAAA/wQEBP8CAgL/AAAA/wAAAP8CAgL/BAQE/wEBAf8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8AAAD/BAQE/wICAv8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/FRQP/yAgGP8zMSX/OTcq/z07Lf89Oy3/ODcq/zMyJ/8cGxX/EREN/wAAAP8DAwP/AwMD/wAAAP8AAAD/AAAA/wQEBP8CAgL/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wICAv8DAwP/AAAA/wAAAP8AAAD/BAQE/wICAv8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8AAAD/AQEB/wQEBP8BAQH/AAAA/wAAAP8CAgL/AwMD/wAAAP8AAAD/AAAA/wQEBP8CAgL/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wICAv8DAwP/AAAA/wAAAIAAAAAAAAAAAAAAAIAAAAD/BAQE/wMDA/8AAAD/AAAA/wEBAf8EBAT/AQEB/wAAAP8AAAD/AgIC/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8DAwP/BAQE/wAAAP8AAAD/AAAA/wQEBP8DAwP/AAAA/wAAAP8BAQH/BAQE/wEBAf8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/BAQE/wMDA/8AAAD/AAAA/wEBAf8EBAT/AgIC/wAAAP8AAAD/AgIC/wQEBP8AAAD/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wQEBP8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AAAA/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wEBAf8EBAT/AgIC/wAAAP8AAAD/AgIC/wQEBP8BAQH/AAAA/wAAAP8BAQH/AQEB/wEBAf8AAAD/AAAA/wAAAP8CAgL/BAQE/wAAAP8AAAD/AAAA/wMDA/8DAwP/AAAA/wAAAP8BAQH/BAQE/wICAv8AAAD/AAAA/wICAv8EBAT/AQEB/wAAAP8AAAD/AwMD/wMDA/8AAAD/AAAA/wAAAP8CAgL/AgICgAAAAAAAAAAAAAAAgAAAAP8CAgL/AgIC/wEBAf8AAAD/AAAA/wICAv8BAQH/AQEB/wAAAP8BAQH/AgIC/wEBAf8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8CAgL/AQEB/wAAAP8AAAD/AgIC/wICAv8BAQH/AAAA/wAAAP8CAgL/AQEB/wEBAf8AAAD/AQEB/wICAv8BAQH/AQEB/wAAAP8CAgL/AgIC/wEBAf8AAAD/AAAA/wICAv8BAQH/AQEB/wAAAP8BAQH/AgIC/wEBAf8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8CAgL/AQEB/wAAAP8AAAD/AgIC/wICAv8BAQH/AAAA/wAAAP8CAgL/AQEB/wEBAf8AAAD/AQEB/wICAv8BAQH/AQEB/wAAAP8BAQH/AgIC/wEBAf8AAAD/AAAA/wICAv8BAQH/AQEB/wAAAP8BAQH/AgIC/wEBAf8BAQH/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AAAA/wEBAf8CAgL/AQEB/wAAAP8AAAD/AQEB/wICAv8BAQH/AAAA/wAAAP8CAgL/AQEB/wEBAf8AAAD/AQEB/wICAv8BAQH/AQEB/wAAAP8BAQH/AgIC/wEBAf8AAAD/AAAA/wEBAf8BAQGAAAAAAAAAAAAAAACAAAAA/wAAAP8BAQH/AgIC/wAAAP8AAAD/AAAA/wEBAf8CAgL/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8AAAD/AAAA/wAAAP8BAQH/AgIC/wAAAP8AAAD/AAAA/wICAv8BAQH/AAAA/wAAAP8BAQH/AgIC/wEBAf8AAAD/AAAA/wEBAf8CAgL/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8BAQH/AAAA/wAAAP8BAQH/AgIC/wAAAP8AAAD/AAAA/wICAv8BAQH/AAAA/wAAAP8BAQH/AgIC/wEBAf8AAAD/AAAA/wEBAf8CAgL/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wAAAP8BAQH/AQEB/wAAAP8AAAD/AQEB/wICAv8BAQH/AAAA/wAAAP8BAQH/AgIC/wAAAP8AAAD/AAAA/wICAv8BAQH/AAAA/wAAAP8AAAD/AgIC/wEBAf8AAAD/AAAA/wAAAIAAAAAAgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAGAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAAAAAAAEoAAAAQAAAAIAAAAABACAAAAAAAABAAADDDgAAww4AAAAAAAAAAAAAAAAAQAAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAAQAAAAEAAAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wEBAf8AAAD/AAAA/wAAAP8AAAD/AQEB/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wEBAf8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AQEB/wAAAP8BAQH/AAAA/wAAAP8AAAD/AAAA/wEBAf8AAAD/AQEB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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKAAAADAAAABgAAAAAQAgAAAAAAAAJAAAww4AAMMOAAAAAAAAAAAAAAAAAHAAAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAAcAAAAHABAQH/AAAA/wEBAf8AAAD/AQEB/wAAAP8BAQH/AAAA/wEBAf8BAQH/AQEB/wEBAf8AAAD/AQEB/wAAAP8BAQH/AAAA/wEBAf8AAAD/AQEB/wAAAP8AAAD/AQEB/wEBAf8BAQH/AAAA/wEBAf8AAAD/AQEB/wEBAf8BAQH/AQEB/wAAAP8BAQH/AAAA/wEBAf8AAAD/AQEB/wAAAP8BAQH/AQEB/wEBAf8BAQH/AAAA/wEBAf8AAAD/AQEBcAEBAXABAQH/AgIC/wEBAf8CAgL/AAAA/wAAAP8AAAD/AQEB/wEBAf8BAQH/AgIC/wEBAf8CAgL/AQEB/wICAv8BAQH/AQEB/wMDAv8GBgX/BgYF/wUFBP8GBgX/BgYE/wcHBv8GBgX/BwcG/wYGBf8GBgX/AgIC/wEBAf8CAgL/AQEB/wICAv8AAAD/AQEB/wAAAP8BAQH/AQEB/wICAv8BAQH/AQEB/wEBAf8BAQH/AgIC/wEBAf8CAgL/AAAA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"
$icon = [System.Convert]::FromBase64String($icon64)

# Setup window icon
$syncHash.window.add_Loaded({
    $syncHash.window.Icon = $icon
})

# Entering main message loop
if(!$NoTerminal) {
    $syncHash.window.ShowDialog() | Out-Null
} else {
    if ($host.name -ne "ConsoleHost")
    {
        $null = $syncHash.window.Dispatcher.InvokeAsync{$syncHash.Window.ShowDialog()}.Wait()
    } else {
        $windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
        $asyncwindow = Add-Type -MemberDefinition $windowcode -Name Win32ShowWindowAsync -Namespace Win32Functions -PassThru
        $null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
 
        $app = New-Object -TypeName Windows.Application
        $app.Run($syncHash.Window)
    }
}