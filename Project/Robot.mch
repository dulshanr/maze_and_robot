/*MAZEGAME SHOULD BE ANIMATED  
 *Robot
 * Author: Dulshan Ratnayake
 * Creation date: 12/3/2020
 */
MACHINE
    Robot
SEES
    MazeBoard
SETS
    STATUS = {MovedNorth,MovedSouth,MovedEast,MovedWest,Teleported,
    MovedNorth_Failed,MovedSouth_Failed,MovedEast_Failed,MovedWest_Failed,Teleported_Failed};
    YES_NO = {Yes,No}
	    
VARIABLES
    //location of the robot
    currentLocation,robotRoute


INVARIANT
    currentLocation : COLUMNS_ROWS & currentLocation /: (dom(maze |>{Wall})) &
    robotRoute : seq(dom(maze |>{Path}))

INITIALISATION 
    currentLocation := (1|->1) ||
    robotRoute :=[]

OPERATIONS


    moveNorth(present_location) =
                PRE
                    present_location : COLUMNS_ROWS & present_location : (dom(maze |>{Path})) & present_location /: north_anti_range 
                THEN
                    robotRoute := present_location -> robotRoute ||                          
                    currentLocation := (prj1(COLUMNS,ROWS)(present_location)|->(prj2(COLUMNS,ROWS)(present_location)+1))                            
                END
                
;
    moveSouth(present_location) =
                PRE
                    present_location : COLUMNS_ROWS & present_location : (dom(maze |>{Path})) & present_location /: south_anti_range
                THEN
                    robotRoute := present_location -> robotRoute ||                           
                    currentLocation := (prj1(COLUMNS,ROWS)(present_location)|->(prj2(COLUMNS,ROWS)(present_location)-1))
                             
                END
                
;
    moveWest(present_location) =
                PRE
                    present_location : COLUMNS_ROWS & present_location : (dom(maze |>{Path})) & present_location /: west_anti_range
                THEN
                    robotRoute := present_location -> robotRoute ||                           
                    currentLocation := (prj1(COLUMNS,ROWS)(present_location)-1|->(prj2(COLUMNS,ROWS)(present_location)))
                             
                END
                
;
    moveEast(present_location) =
                PRE
                    present_location : COLUMNS_ROWS & present_location : (dom(maze |>{Path})) & present_location /: east_anti_range
                THEN
                    robotRoute := present_location -> robotRoute ||                                                
                    currentLocation := (prj1(COLUMNS,ROWS)(present_location)+1|->(prj2(COLUMNS,ROWS)(present_location)))
                        
                END
                
;

    teleport (location,present_location) =
        PRE
             present_location : COLUMNS_ROWS & present_location : (dom(maze |>{Path})) & location : COLUMNS_ROWS & location : (dom(maze |>{Path}))
        THEN
            robotRoute := present_location -> robotRoute ||                                                
            currentLocation := location                         
        END
        ;
    

    //found exit

    exit_report<--foundExit =
        PRE
                    exit_report : YES_NO
        THEN
            IF (currentLocation=exit)
            THEN
                exit_report := Yes
            ELSE
                exit_report := No
            END
        END
    ;
    //has visited square and the number of times(additional work)

    visited_report,visited_times <-- hasVisitedSquare(cordinates) =
        PRE
            visited_report : YES_NO &
            cordinates : dom(maze |>{Path}) 
            
        THEN
            IF(cordinates : ran(robotRoute))
            THEN       
                visited_report := Yes ||
                visited_times := card(dom(robotRoute |>{cordinates}))             
            ELSE
                visited_report := No||
                visited_times := 0
            END    
        END
    
    ;
    //get route visited by robot

    route <-- getRobotRoute =
        BEGIN
            route := robotRoute 
        END
    ;
        
    //get current position of robot
    position <-- getPosition =
        BEGIN
            position := currentLocation
        END        
    
    
END

