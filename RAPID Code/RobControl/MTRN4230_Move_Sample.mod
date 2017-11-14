MODULE MTRN4230_Move_Sample
    
    ! Data stores   (variables are persistent across tasks)
    PERS byte jog_input;

    PERS byte write_io{4};   ! DO10_1, DO10_2, DO10_3, DO10_4 (off = 0, on = 1)
    PERS byte looad;		! looad = 0, unlooad = 1
    PERS byte read_io{5};    ! DO10_1, DO10_2, DO10_3, DO10_4, DI10_1 (off = 0, on = 1)
    
    PERS pos write_position;
    PERS jointtarget write_joints;
    PERS num write_orientation;
    
    PERS pos read_position;
    PERS jointtarget read_joints;
    
    PERS speeddata speed;       ! v_tcp, v_ori, v_leax, v_reax, begun at v100
    PERS byte mode;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
    PERS byte pause;         ! pause = 0 (moving), pause = 1 (paused)
    
    PERS byte command;
    PERS byte ready;
    PERS bool quit;
    
    VAR robtarget pTarget; ! temporary variable for translational jogging
    VAR jointtarget jTarget;    ! temporary variable for joint jogging
    VAR num jogT_rate := 10; ! mm/s
    VAR num jogJ_rate := 2; ! deg/s
    
    ! The Main prodedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC main()
        
        WaitTime 1;
        StartMove;
    
        !pTarget := CRobT(\TaskRef:=T_ROB1Id, \Tool:=tSCup);  
        !pTarget.trans.z := 200;
        !MoveJ pTarget, speed, fine, tSCup;
        
        MoveAbsJ jtCalibPos, speed, fine, tSCup;
        jTarget := CJointT(\TaskRef:=T_ROB1Id);
        jTarget.robax.rax_5 := jTarget.robax.rax_5 + jogJ_rate;
        MoveAbsJ jTarget, speed, fine, tSCup;
        
        
        WHILE quit = FALSE DO
            ProcessCommands;
            
            WaitTime 0.02;
        ENDWHILE
        
    ENDPROC
    
    PROC ProcessCommands()
        waituntil ready <> 0;
            ready := 0;
            
            IF command = 1 THEN     ! Move to new position
                
                ! Motion commands
                IF mode = 0 THEN    ! Execute linear move
                    MoveL Offs(pBase, write_position.x, write_position.y, write_position.z), speed, fine, tSCup;
                ELSEIF mode = 1 THEN    ! Execute joint move
                    MoveJ Offs(pBase, write_position.x, write_position.y, write_position.z), speed, fine, tSCup;
                ENDIF
                
            ELSEIF command = 2 THEN     ! Update states
                    
                ! IO commands (Set Vaccum power)
                IF write_io{1} = 1 THEN
                    TurnVacOn;
                ELSEIF write_io{1} = 0 THEN
                    TurnVacOff;
                ENDIF
                
                ! IO commands (
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
                
            ELSEIF command = 3 THEN     ! Jog
                pTarget := CRobT(\TaskRef:=T_ROB1Id, \Tool:=tSCup);            
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
                    jTarget := CJointT(\TaskRef:=T_ROB1Id);
                    
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
                
            ELSEIF command = 4 THEN     ! Safe move to new position
                read_position := CPos (\Tool:=tSCup);
                
                ! Motion commands
                MoveJ Offs(pBase, read_position.x, read_position.y, 200), speed, fine, tSCup;
                MoveJ Offs(pBase, write_position.x, write_position.y, 200), speed, fine, tSCup;
                MoveJ Offs(pBase, write_position.x, write_position.y, write_position.z), speed, fine, tSCup;
                
            ELSEIF command = 5 THEN     ! Orient end effector
                jTarget := CJointT(\TaskRef:=T_ROB1Id);
                jTarget.robax.rax_6 := write_orientation;
                MoveAbsJ jTarget, speed, fine, tSCup;

            ELSEIF command = 6 THEN		! looad/unlooad
            	! IO commands (Change conveyor direction)
                IF looad = 1 THEN
                    ConDirTowards;
                ELSEIF looad = 0 THEN
                    ConDirAway;
                ENDIF

                TurnConOnSafely;
                WaitTime 4;
                TurnConOff;

            ENDIF
            
            ready := 1;
            command := 0;
            
            ERROR
                ready := 1;
                StartMove;
            TRYNEXT;
    ENDPROC
    
ENDMODULE