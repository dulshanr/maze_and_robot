/*THIS MACHINE SHOULD BE ANIMATED  
 *Main Machine to play the game
 * Author: Dulshan Ratnayake
 * Creation date: 12/3/2020
 */
MACHINE
    //This is the main controller
    MazeGame
INCLUDES
    Robot,MazeBoard
PROMOTES
    foundExit,hasVisitedSquare,getRobotRoute,getPosition

INVARIANT
    currentLocation : dom(maze|>{Path})
    
DEFINITIONS
    withInMaze(x,y) == ((y >= y_min) & (y <=y_max) & (x >= x_min) & (x <=x_max ));

    ANIMATION_FUNCTION == ({row,column,img_index | (row):ROWS & column:COLUMNS & 

(IF(maze(column|->6-row) = Wall)
    THEN
        img_index =1 //wall
    ELSE
            IF((6-row)=prj2(COLUMNS,ROWS)(exit) & column=prj1(COLUMNS,ROWS)(exit)) //in exit box
            THEN
		            IF(currentLocation = exit)
		            THEN
		                img_index = 3 //robot in exit
		            ELSE
		                img_index = 4
		            END		
	          ELSE //not in exit
		            IF((6-row)=prj2(COLUMNS,ROWS)(currentLocation) & column=prj1(COLUMNS,ROWS)(currentLocation))
		            THEN
                      img_index =5 //normal_path
		            ELSE
		                img_index = 2
		            END

	          END


      END)
});
ANIMATION_IMG1 == "images_cw/wall.png";
ANIMATION_IMG2 == "images_cw/path.png";
ANIMATION_IMG3 == "images_cw/robot_exit.png";
ANIMATION_IMG4 == "images_cw/exit.png";
ANIMATION_IMG5 == "images_cw/robot.png";



OPERATIONS
    //navigate north
    status,status_reason <-- navigateNorth =
        PRE
            status : STATUS &
            status_reason : STATUS_REASON
        THEN
            IF (withInMaze(prj1(COLUMNS,ROWS)(currentLocation),prj2(COLUMNS,ROWS)(currentLocation)+1))
                        THEN
                            IF(maze(prj1(COLUMNS,ROWS)(currentLocation)|->(prj2(COLUMNS,ROWS)(currentLocation)+1))/= Wall)
                            THEN
                                moveNorth(currentLocation)||
                                status_reason := ClearPath ||
                                status := MovedNorth
                            ELSE
                                status := MovedNorth_Failed ||
                                status_reason := WallPresent
                            END
                         ELSE
                                status := MovedNorth_Failed ||
                                status_reason := OutOfBoundary
                         END
        END  
;
    //navigate south
    status,status_reason <-- navigateSouth =
        PRE
            status : STATUS &
            status_reason : STATUS_REASON
        THEN
            IF (withInMaze(prj1(COLUMNS,ROWS)(currentLocation),prj2(COLUMNS,ROWS)(currentLocation)-1))
                        THEN
                            IF(maze(prj1(COLUMNS,ROWS)(currentLocation)|->(prj2(COLUMNS,ROWS)(currentLocation)-1))/= Wall)
                            THEN
                                moveSouth(currentLocation)||
                                status_reason := ClearPath ||
                                status := MovedSouth
                            ELSE
                                status := MovedSouth_Failed ||
                                status_reason := WallPresent
                            END
                         ELSE
                                status := MovedSouth_Failed ||
                                status_reason := OutOfBoundary
                         END
        END 
    ;
    //navigate west
    status,status_reason <-- navigateWest =
        PRE
            status : STATUS &
            status_reason : STATUS_REASON
        THEN
            IF (withInMaze(prj1(COLUMNS,ROWS)(currentLocation)-1,prj2(COLUMNS,ROWS)(currentLocation)))
                        THEN
                            IF(maze(prj1(COLUMNS,ROWS)(currentLocation)-1|->(prj2(COLUMNS,ROWS)(currentLocation)))/= Wall)
                            THEN
                                moveWest(currentLocation)||
                                status_reason := ClearPath ||
                                status := MovedWest
                            ELSE
                                status := MovedWest_Failed ||
                                status_reason := WallPresent
                            END
                         ELSE
                                status := MovedWest_Failed ||
                                status_reason := OutOfBoundary
                         END
        END 
        
    ;
    //navigate east
    status,status_reason <-- navigateEast =
        PRE
            status : STATUS &
            status_reason : STATUS_REASON
        THEN
            IF (withInMaze(prj1(COLUMNS,ROWS)(currentLocation)+1,prj2(COLUMNS,ROWS)(currentLocation)))
                        THEN
                            IF(maze(prj1(COLUMNS,ROWS)(currentLocation)+1|->(prj2(COLUMNS,ROWS)(currentLocation)))/= Wall)
                            THEN
                                moveEast(currentLocation)||
                                status_reason := ClearPath ||
                                status := MovedEast
                            ELSE
                                status := MovedEast_Failed ||
                                status_reason := WallPresent
                            END
                         ELSE
                                status := MovedEast_Failed ||
                                status_reason := OutOfBoundary
                         END
        END
        ;
//teleport robot
    report,report_status <-- teleport_robot (target_location) =
        PRE
            target_location : COLUMNS_ROWS & report : STATUS &
            report_status : STATUS_REASON
        THEN
            IF(withInMaze(prj1(COLUMNS,ROWS)(target_location),prj2(COLUMNS,ROWS)(target_location)))
            THEN
                IF(maze(target_location)/= Wall)
                THEN
                    teleport(target_location,currentLocation) ||
                    report := Teleported ||
                    report_status := ClearPath
                ELSE
                    report := Teleported_Failed ||
                    report_status := WallPresent
                END
            ELSE
                report := Teleported_Failed ||
                report_status := OutOfBoundary
            END
        END
        

END