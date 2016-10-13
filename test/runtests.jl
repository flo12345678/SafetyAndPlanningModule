using SafetyAndPlanningModule
using Base.Test

# one geomtery that works
geo=geometry(100.0,100.0,"Circle")
coords=coordinates(1000.0, 600.0, 200.0)
check_coor(geo,coords)

# one geomtery that fails
# geo=geometry(50.0,50.0,"Rectangle")
# coords=coordinates(1000.0, 200.0, 5.0)
# check_coor(geo,coords)


@test 1 == 1
