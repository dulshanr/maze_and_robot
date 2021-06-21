/*MAZEGAME SHOULD BE ANIMATED 
 *Mazeboard seen by the robot
 * Author: Dulshan Ratnayake
 * Creation date: 12/3/2020
 */
MACHINE
    MazeBoard
SETS
    VALIDITY = {Path,Wall};
    STATUS_REASON = {WithInBoundary,OutOfBoundary,WallPresent,ClearPath}

CONSTANTS
    maze,COLUMNS_ROWS,ROWS,COLUMNS,totalSpace,wallSpace,exit,y_max,y_min,x_max,x_min,north_anti_range,xx,yy,south_anti_range,west_anti_range,east_anti_range

PROPERTIES
    ROWS <: NAT1 & ROWS = 1..5 &
    COLUMNS <: NAT1 & COLUMNS = 1..7 &
    COLUMNS_ROWS : COLUMNS<->ROWS & 
    wallSpace :COLUMNS_ROWS <-> VALIDITY &
     //Wall Location
    wallSpace = {(1|->3|->Wall),(2|->1|->Wall),(2|->3|->Wall),(2|->5|->Wall),(3|->3|->Wall),(4|->2|->Wall),
     (4|->3|->Wall),(4|->4|->Wall),(6|->1|->Wall),(6|->2|->Wall),(6|->4|->Wall),(7|->4|->Wall)} &

    totalSpace :COLUMNS_ROWS <-> VALIDITY &
    totalSpace = COLUMNS * ROWS * {Path} &

     //exit
     exit : COLUMNS_ROWS & exit = (1|->5) & exit /: dom(wallSpace) &
    //Boundary of Maze Board
    y_max : NAT1 & y_max = max(ROWS) &
    y_min : NAT1 & y_min = min(ROWS) &
    x_max : NAT1 & x_max = max(COLUMNS) &
    x_min : NAT1 & x_min = min(COLUMNS) &
     //Total Function of the maze
    maze:COLUMNS_ROWS --> VALIDITY & 
     //Relational Override
    maze = totalSpace <+ wallSpace &
    xx : NAT1 & xx = 1 & yy : NAT1 & yy = 2 & 
     //additional sets to ensure clear path
    north_anti_range <: COLUMNS_ROWS & north_anti_range = {xx,yy| xx: COLUMNS & yy:ROWS & ((xx),(yy+1)):dom(maze |>{Wall}) & (xx,yy)/: dom(maze |>{Wall})} \/{xx,yy|xx: COLUMNS & yy:ROWS & yy=max(ROWS)} &

    south_anti_range <: COLUMNS_ROWS & south_anti_range = {xx,yy| xx: COLUMNS & yy:ROWS & ((xx),(yy-1)):dom(maze |>{Wall}) & (xx,yy)/: dom(maze |>{Wall})} \/{xx,yy|xx: COLUMNS & yy:ROWS & yy=min(ROWS)} &

    west_anti_range <: COLUMNS_ROWS & west_anti_range = {xx,yy| xx: COLUMNS & yy:ROWS & ((xx-1),(yy)):dom(maze |>{Wall}) & (xx,yy)/: dom(maze |>{Wall})} \/{xx,yy|xx: COLUMNS & yy:ROWS & xx=min(COLUMNS)} &

    east_anti_range <: COLUMNS_ROWS & east_anti_range = {xx,yy| xx: COLUMNS & yy:ROWS & ((xx+1),(yy)):dom(maze |>{Wall}) & (xx,yy)/: dom(maze |>{Wall})} \/{xx,yy|xx: COLUMNS & yy:ROWS & xx=max(COLUMNS)}


END

