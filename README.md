Welcome to my Slotcar Track Layout Tool
========

This is a MATLAB function to help you build new slot car tracks.  

To Use:
=
1. Lanuch the function from the MATLAB command window:  
	slotCarTrackLayout
2. At this point a blank figure appears. It may be best to resize the command window to show command window and figure at the same time. 
3. Select your first track piece and type a number into the command window:  
    1 = straight  
    2 = left turn, tighter radius  
    3 = right turn, tighter radius  
    4 = left turn, larger radius  
    5 = right turn, larger radius  

4. If you make a mistake, you can remove the last piece by entering '6'.
5. Keep adding track until you are finished. At any time you can save your track to a .png by pressing '7'
6. At any time, you can exit the function by pressing '8'.


Notes:
=
Currently I have this setup for my Riggen brand track. If you want to change this function for your track type, you can update the slotCarTrackLayout.m file as shown:

    % user-set track parameters
    laneSpacing     = 3.5; % inches, distance between left and right lanes
    straightLength  = 12.0; % inches

    tightDiameter   = 28-(laneSpacing*2); % inches, turn diameter
    tightSegments   = 6; % number of segments that create 360 degrees turn

    wideDiameter    = 42-(laneSpacing*2); % inches, turn diameter
    wideSegments    = 12; % number of segments that create 360 degree turn
    
Updates:
=
I don't know that I will spend much time updating this. If you would like to contribute, just fork and send me a pull request.

