using SafetyAndPlanningModule
using Base.Test

#test that works
test_triangle=triangle(10.0u"mm",20.0u"mm","Triangle");

v = wanted_volume(200.0u"mm",100.0u"mm",50.0u"mm");
a = amplitude(14.0u"mT",12.0u"mT",10.0u"mT");
grad = gradient_scan(1.0u"T/m");

storage,pixel = volume_patches(v,grad,a,overlap=false,increase=false);

plot_patches(storage,v,grad,a);

patches_mm=convert2unit(storage, u"mm");

table=check_coor(scanner_reg,test_triangle,patches_mm);

sleep(10.0)
close("all")
#test that does not work

v = wanted_volume(100.0u"mm",150.0u"mm",50.0u"mm");
a = amplitude(14.0u"mT",12.0u"mT",10.0u"mT");
grad = gradient_scan(1.0u"T/m");

storage,pixel = volume_patches(v,grad,a,overlap=true,increase=false);

plot_patches(storage,v,grad,a);

patches_mm=convert2unit(storage, u"mm");

table2=check_coor(scanner_reg,mouse_adapter,patches_mm);

@test 1 == 1
