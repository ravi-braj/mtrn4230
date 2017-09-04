MODULE MTRN4230_Move_Sample
    ! Data stores   (variables are persistent across tasks)
    PERS pose pose_state;  ! pos(x, y, z), orient(q1,q2,q3,q4)
    PERS speeddata speed;       ! v_tcp, v_ori, v_leax, v_reax
    PERS byte io_state{3};   ! DI10_1, DO10_1, DO10_3 (off = 0, on = 1)
    PERS byte mode;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
    PERS byte pause;         ! pause = 0 (moving), pause = 1 (paused)
    PERS bool quit;
    
    ! The Main prodedure. When you select 'PP to Main' on the FlexPendant, it will go to this procedure.
    PROC MainMove()
        
        WHILE quit = FALSE DO
            
            ! Motion commands
            IF mode = 0 THEN    ! Execute linear move
                MoveL Offs(pTableHome, pose_state.trans.x, pose_state.trans.y, pose_state.trans.z), speed, fine, tSCup;
            ELSEIF mode = 1 THEN    ! Execute joint move
                MoveJ Offs(pTableHome, pose_state.trans.x, pose_state.trans.y, pose_state.trans.z), speed, fine, tSCup;
            ENDIF
            
            ! IO commands (Vacuum)
            IF io_state{2} = 1 THEN
                TurnVacOn;
            ELSEIF io_state{2} = 0 THEN
                TurnVacOff;
            ENDIF
            
            ! IO commannds (Conveyor)
            IF io_state{3} = 1 THEN
                TurnConOnSafely;
            ELSEIF io_state{3} = 0 THEN
                TurnConOff;
            ENDIF
            
        ENDWHILE
        
    ENDPROC
    
ENDMODULE