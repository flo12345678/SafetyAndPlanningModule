using SafetyAndPlanningModule
using Base.Test

#geometries that work
check_coor(mouse_adapter,origin)
check_coor(delta_probe,origin)
check_coor(test_triangle,origin)
check_coor(test_rectangle,origin)

# geometries that fail
coords=coordinates(300.0, 100.0, 100.0)
check_coor(mouse_adapter,coords)
check_coor(delta_probe,coords)
check_coor(test_triangle,coords)
check_coor(test_rectangle,coords)


@test 1 == 1
