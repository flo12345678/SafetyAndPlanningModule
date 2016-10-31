using SafetyAndPlanningModule
using Unitful
close("all")

pos=Array{Tuple{Float64,Float64,Float64},1}(5)
pos[1]=(3.0,2.0,4.0)
pos[2]=(4.0,2.0,4.0)
pos[3]=(2.0,7.0,4.0)
pos[4]=(3.0,2.0,5.0)
pos[5]=(2.0,9.0,10.0)

p_mm=convert2unit(pos, u"mm");
#p_cm=convert2unit(pos, u"cm");

display(p_mm);

table=check_coor(scanner_reg,mouse_adapter,p_mm,plotresults=true)
#check_coor(s, g, p_cm, plotresults=true)
sleep(10.0)
close("all")
#########
v = wanted_volume(200.0u"mm",100.0u"mm",50.0u"mm");
a = amplitude(14.0u"mT",12.0u"mT",8.0u"mT");
grad = gradient_scan(1.2u"T/m");

storage,pixel = volume_patches(v,grad,a,overlap=true,increase=false)

plot_patches(storage,v,grad,a)

patches_mm=convert2unit(storage, u"mm");

table2=check_coor(scanner_reg,mouse_adapter,patches_mm)
