void main(void) { 
    
    rmSetStatusText("Starting!",0.00);

    rmSetMapSize(300,300);
    rmTerrainInitialize("great_plains\ground5_gp",0.0); 
    
    float xAxis = 0.5;
    float zAxis1 = 0.25;
    float zAxis2 = (1.0 - zAxis1);

    int TCID = rmCreateObjectDef("player TC");
    rmAddObjectDefItem(TCID, "townCenter", 1, 0);
    rmPlaceObjectDefAtLoc(TCID, 1, xAxis, zAxis1);
    rmPlaceObjectDefAtLoc(TCID, 2, xAxis, zAxis2);

    int startingUnits = rmCreateStartingUnitsObjectDef(5.0);
    rmPlaceObjectDefAtLoc(startingUnits, 1, xAxis+0.05, zAxis1+0.05);
    rmPlaceObjectDefAtLoc(startingUnits, 2, xAxis+0.05, zAxis2+0.05);
    

    rmSetStatusText("Adding Trees",0.10);
    
    // let's do 100 trees, and 10 mines
    int i = 0;
    for (i=0; <100)
    {
        int treeID = rmCreateObjectDef("tree"+i);
        rmAddObjectDefItem(treeID, "TreeGreatPlains", rmRandInt(2,3), 4.0); // 1,2
        rmPlaceObjectDefAtLoc(treeID, 0, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
    }

    rmSetStatusText("and Mines",0.20);

    for (i=0; <10)
    {
        int mineID = rmCreateObjectDef("mine"+i);
        rmAddObjectDefItem(mineID, "mine", rmRandInt(2,3), 4.0);
        rmPlaceObjectDefAtLoc(mineID, 0, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
    }

    rmSetStatusText("and Hunts",0.20);

    for (i=0; <10)
    {
        int bisonID = rmCreateObjectDef("bison"+i);
		rmAddObjectDefItem(bisonID, "bison", rmRandInt(5, 10), 5.0);
		rmSetObjectDefCreateHerd(bisonID, true);
		rmPlaceObjectDefAtLoc(bisonID, 0, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
    }
    
    rmSetStatusText("Done!",1.00);
    
}
