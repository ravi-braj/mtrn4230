MODULE MTRN4230_Move_Sample
!      Module Function: This is the primary command execution module for the RobControl Task. It waits to receive a command from the RobComms task
!      and then proceeds to execute that command. The following commands may be set with the respective IDs:
!      
!      Commands: 1 = Move robot to position, 2 = Write to robot IOs, 3 = Jog a given robot axis
!      Once a command has been begun, it is reset to 0 to mark its execution. The program then waits for any other command than 0.
!
!      The motion and io control processes are separated from the communications task to allow parallel processing to occur, and to separate
!      motion errors from communication errors. IE TCP connection and error status may be maintained separate from control.
!
!      Last Modified: 14/09/2017
!      Status: Working
    
    ! Data stores (persistent across tasks) (not directly compatible with UnpackRawBytes so use tmpf, tmpb to update variables)
    !jog command ID 
    PERS byte jog_input := 0; ! +x=1,-x=2,+y=3,-y=4,+z=5,-z=6,+j1=7,-j1=8,+j2=9,-j2=10,+j3=11,-j3=12,+j4=13,-j4=14,+j5=15,-j5=16,+j6=17,-j6=18

    ! IO Variables
    ! DO10_1 = VacPower, DO10_2 = VacSolenoid, DO10_3 = ConveyorPower, DO10_4 = ConveyorDirection, DI10_1 = ConveyorState
    ! VEN = PressToEnable, VES = EmergenccyStop, VGS = LightCurtain, VMAN = ManualMode, VMB = MotorOnButton, VML = MotorOnLight
    PERS byte write_io{4};   ! DO10_1, DO10_2, DO10_3, DO10_4 (off = 0, on = 1)
    PERS byte read_io{5};    ! DO10_1, DO10_2, DO10_3, DO10_4, DI10_1 (off = 0, on = 1)
    PERS byte read_switches{6};    ! VEN, VES, VGS, VMAN, VMB, VML (off = 0, on = 1)
    
    ! Pose state output variables
    PERS pos write_position; ! x,y,z translational pose input from MATLAB
    PERS jointtarget write_joints; ! j1,j2,j3,j4,j5,j6 joint pose from MATLAB
    
    ! Pose state input variables
    PERS pos read_position; ! x,y,z translational pose tracker sending to MATLAB
    PERS jointtarget read_joints;    ! j1,j2,j3,j4,j5,j6 pose tracker sending to MATLAB
    
    ! Motion control variables
    PERS speeddata speed;       ! v_tcp, v_ori, v_leax, v_reax (MATLAB sets v_tcp)
    PERS byte mode;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
    PERS byte pause;         ! pause = 0 (motion enabled), pause = 1 (motion halted)
    
    ! Communication variables
    PERS byte errorMsg{1};   ! Error flag sent to MATLAB when a command is successfully executed (TCP acknowledgement)
    PERS byte command; ! MATLAB output command ID (move to position, write to IOs, 
    PERS bool quit; ! Main loop exit flag
    
    ! The Main prodedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC main()
        
        VAR robtarget pTarget; ! temporary variable for translational jogging
        VAR jointtarget jTarget;    ! temporary variable for joint jogging
        VAR num jogT_rate := 10; ! Translational jog amount in mm per MATLAB call
        VAR num jogJ_rate := 2; ! Joint jog amount in deg per MATLAB call
        
        WaitTime 1; ! Short pause to allow RobComms Task to Setup
    
        MoveAbsJ jtCalibPos, speed, fine, tSCup;    ! Execute robot move to calibration pose (resets previous errors in position)
        jTarget := CJointT(\TaskRef:=RobControlId); ! Read current joint angles
        jTarget.robax.rax_5 := jTarget.robax.rax_5 + jogJ_rate; ! Jog joint 5 slightly to exit singularity
        MoveAbsJ jTarget, speed, fine, tSCup;   ! Execute jog command
        
        WHILE quit = FALSE DO
            
            waituntil command <> 0; ! Wait until command does not equal 0 (IE command has been set by RobComms Task)
            
            IF command = 1 THEN     ! Move to new position
                
                ! Motion commands
                IF mode = 0 THEN    ! Execute linear move
                    MoveL Offs(pTableHome, write_position.x, write_position.y, write_position.z), speed, fine, tSCup;
                ELSEIF mode = 1 THEN    ! Execute joint move
                    MoveJ Offs(pTableHome, write_position.x, write_position.y, write_position.z), speed, fine, tSCup;
                ENDIF
                
                command := 0;   ! Reset commmand variable to signal command has begun
                
            ELSEIF command = 2 THEN     ! Update states
                    
                ! IO commands (Set Vaccum power)
                IF write_io{1} = 1 THEN
                    TurnVacOn;
                ELSEIF write_io{1} = 0 THEN
                    TurnVacOff;
                ENDIF
                
                ! IO commands (Set Vaccum solenoid)
                IF write_io{2} = 1 THEN
                    TurnVacSolOn;
                ELSEIF write_io{2} = 0 THEN
                    TurnVacSolOff;
                ENDIF
                
                ! IO commands (Conveyor)
                IF write_io{3} = 1 THEN
                    TurnConOnSafely;
                ELSEIF write_io{3} = 0 THEN
                    TurnConOff;
                ENDIF
                
                ! IO commands (Change conveyor direction)
                IF write_io{4} = 1 THEN
                    ConDirTowards;
                ELSEIF write_io{4} = 0 THEN
                    ConDirAway;
                ENDIF
                
                command := 0;   ! Reset commmand variable to signal command has begun
                
            ELSEIF command = 3 THEN     ! Jog
                pTarget := CRobT(\TaskRef:=RobControlId, \Tool:=tSCup);            
                IF jog_input < 7 THEN   ! Jog position
    
                    IF jog_input = 1 THEN   ! x+
                        pTarget.trans.x := pTarget.trans.x + jogT_rate;
                        MoveL pTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 2 THEN   ! x-
                        pTarget.trans.x := pTarget.trans.x - jogT_rate;
                        MoveL pTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 3 THEN   ! y+
                        pTarget.trans.y := pTarget.trans.y + jogT_rate;
                        MoveL pTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 4 THEN   ! y-
                        pTarget.trans.y := pTarget.trans.y - jogT_rate;
                        MoveL pTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 5 THEN   ! z+
                        pTarget.trans.z := pTarget.trans.z + jogT_rate;
                        MoveL pTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 6 THEN   ! z-
                        pTarget.trans.z := pTarget.trans.z - jogT_rate;
                        MoveL pTarget, speed, fine, tSCup;
                    ENDIF
                ELSE       ! Jog joints
                    jTarget := CJointT(\TaskRef:=RobControlId);
                    
                    IF jog_input = 7 THEN   ! j1+
                        jTarget.robax.rax_1 := jTarget.robax.rax_1 + jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 8 THEN   ! j1-
                        jTarget.robax.rax_1 := jTarget.robax.rax_1 - jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 9 THEN   ! j2+
                        jTarget.robax.rax_2 := jTarget.robax.rax_2 + jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 10 THEN   ! j2-
                        jTarget.robax.rax_2 := jTarget.robax.rax_2 - jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 11 THEN   ! j3+
                        jTarget.robax.rax_3 := jTarget.robax.rax_3 + jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 12 THEN   ! j3-
                        jTarget.robax.rax_3 := jTarget.robax.rax_3 - jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 13 THEN   ! j4+
                        jTarget.robax.rax_4 := jTarget.robax.rax_4 + jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 14 THEN   ! j4-
                        jTarget.robax.rax_4 := jTarget.robax.rax_4 - jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 15 THEN   ! j5+
                        jTarget.robax.rax_5 := jTarget.robax.rax_5 + jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 16 THEN   ! j5-
                        jTarget.robax.rax_5 := jTarget.robax.rax_5 - jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 17 THEN   ! j6+
                        jTarget.robax.rax_6 := jTarget.robax.rax_6 + jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ELSEIF jog_input = 18 THEN   ! j6-
                        jTarget.robax.rax_6 := jTarget.robax.rax_6 - jogJ_rate;
                        MoveAbsJ jTarget, speed, fine, tSCup;
                    ENDIF
                ENDIF
                
                command := 0;   ! Reset commmand variable to signal command has begun
                
            ENDIF
            
            WaitTime 0.02;   ! Short pause to allow commands to process
        ENDWHILE
        
        MoveAbsJ jtCalibPos, speed, fine, tSCup;    ! Execute robot move to calibration pose before ending program
        
    ENDPROC
    
ENDMODULE