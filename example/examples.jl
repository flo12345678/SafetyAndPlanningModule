using SafetyAndPlanningModule
using Unitful
close("all")

s = scanner_reg;
g = mouse_adapter;

pos=Array{Tuple{Float64,Float64,Float64},1}(5)
pos[1]=(3.0,2.0,4.0)
pos[2]=(4.0,2.0,4.0)
pos[3]=(2.0,7.0,4.0)
pos[4]=(3.0,2.0,5.0)
pos[5]=(2.0,9.0, 200.0)

p_mm=convert2unit(pos, u"mm");
#p_cm=convert2unit(pos, u"cm");

table=check_coor(s, g, p_mm, plotresults=false)
#check_coor(s, g, p_cm, plotresults=true)


#########
v = wanted_volume(200.0u"mm",110u"mm",51.0u"mm");
a = amplitude(14.0u"mT",14.0u"mT",14.0u"mT");
grad = gradient_scan(1.5u"T/m");

storage,pixel = volume_patches(v,grad,a,overlap=false,increase=false)

plot_patches(storage,v,grad,a)

patches_mm=convert2unit(storage, u"mm");

table=check_coor(s,g,patches_mm)
