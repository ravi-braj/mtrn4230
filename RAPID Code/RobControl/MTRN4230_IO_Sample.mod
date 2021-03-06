MODULE MTRN4230_IO_Sample
    
    PROC TurnVacOn()
        
        ! Set VacRun on.
        SetDO DO10_1, 1;
        
    ENDPROC
    
    PROC TurnVacOff()
        
        ! Set VacRun off.
        SetDO DO10_1, 0;
        
    ENDPROC
    
    PROC TurnConOnSafely()
        
        ! An example of how an IF statement is structured.
        ! DI10_1 is 'ConStat', and will only be equal to 1 if the conveyor is on and ready to run.
        ! If it is ready to run, we will run it, if not, we will set it off so that we can fix it.
        IF DI10_1 = 1 THEN
            SetDO DO10_3, 1;
        ELSE
            SetDO DO10_3, 0;
        ENDIF
        
    ENDPROC
    
    PROC TurnVacSolOn()
        SetDO DO10_2, 1;
        
    ENDPROC
    
    PROC TurnVacSolOff()
        SetDO DO10_2, 0;
    ENDPROC
    
    PROC TurnConOff()
        SetDO DO10_3, 0;
    ENDPROC
    
    PROC ConDirTowards()
        SetDO DO10_4, 1;
    ENDPROC
    
    PROC ConDirAway()
        SetDO DO10_4, 0;
    ENDPROC
ENDMODULE