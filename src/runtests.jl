using SafetyAndPlanningModule
using Base.Test

#create test geometries
test_triangle=triangle(10.0u"mm",20.0u"mm","Triangle");

test_rectangle=rectangle(20.0u"mm",10.0u"mm","Rectangle");

test_hexagon=hexagon(10.0u"mm",20.0u"mm","Hexagon");

#geometry that works
check_coor(mouse_adapter)

#geometry that doesn't work
check_coor(circle(30.0u"mm","Triangle"))
#or
check_coor(circle(30.0u"m","Circle"))

@test 1 == 1
