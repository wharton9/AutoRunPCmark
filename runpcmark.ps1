
#Author Wharton Wang @Lenovo
#date : sept 2022

#Please check if file exists on following paths
[string]$pmAbsolutePath  = 'C:\Program Files\Futuremark\PCMark 10\PCMark10.exe'

#****************************************************************************
#**** Please do not modify code below unless you know what you are doing ****
#****************************************************************************

Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop

#Set foreground window function
#This function is called in startpcmark
Add-Type @'
  using System;
  using System.Runtime.InteropServices;
  public class Wn {
     [DllImport("user32.dll")]
     [return: MarshalAs(UnmanagedType.Bool)]
     public static extern bool SetForegroundWindow(IntPtr hWnd);
  }
'@ -ErrorAction Stop

#quickly start pcmark
#This function is called later in the code
Function startpcmark()
{
    Start-Process -FilePath $pmAbsolutePath
    $counter = 0; $h = 0;
    while($counter++ -lt 1000 -and $h -eq 0)
    {
        sleep -m 10
        $h = (Get-Process PCMark10|where handles -gt 500).MainWindowHandle
    }
    #if it takes more than 10 seconds then display message
    if($h -eq 0){echo "Could not start pcmark it takes too long."}
    else{[void] [Wn]::SetForegroundWindow($h)}
}

#start pcmark
Start-Process -WindowStyle Minimized -FilePath $pmAbsolutePath

sleep 5

startpcmark

sleep 10
#run the express test via sending 7 times Tab key to select the RUN button
[System.Windows.Forms.SendKeys]::SendWait("{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Enter}")

#END



