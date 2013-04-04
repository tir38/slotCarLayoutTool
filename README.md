Welcome to my Slotcar Track Layout Tool
========

This is a MATLAB function to help you build new slot car tracks.  

To Use:
=
1. Lanuch the function from the MATLAB command window:  
	slotCarTrackLayout
2. At this point a blank figure appears. It may be best to resize the command window to show command window and figure at the same time. 

3. Add some track, one piece at a time by selecting an option from the *main menu* (you'll have to hit enter after each selection):

    1 = straight  
    2 = left turn, tighter radius  
    3 = right turn, tighter radius  
    4 = left turn, larger radius  
    5 = right turn, larger radius

4. If you make a mistake, you can remove the last piece by entering '6' in the *main menu*.

5. You can insert a piece anywhere in the middle by entering '7' in the *main menu* and selecting the point on the map you want to insert. The insert point will become green. Here you can choose to insert any piece by pressing (1-5) in the *insert/delete menu*.

1. Or you can delete any piece in the middle. Again enter '7' in the *main menu* and select the piece you want to delete. Then press '6' in the *insert/delete menu* to delete the piece.  It is important to remember that the piece to be deleted will be the one which PRECEDES the green insert points...

1. If you enter the *insert/delete menu* and want to return to the *main menu* you can do so by pressing '7'.

1. You can also rotate the entire track by pressing '8' from the *main menu*. You will then be asked to enter a new heading. This is absolute heading and not a rotation. However, it will display your current heading for reference.

7. Keep adding/deleting/editing track until you are finished. At any time you can save your track to a .png by pressing '9' in the *main menu*.

8. At any time, you can exit the function by pressing '10'.


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

    scaleFactor     = 32; % scale factor for the model cars and track (1:32)
    
Updates:
=
I don't know that I will spend much time updating this. If you would like to contribute, just fork and send me a pull request.

