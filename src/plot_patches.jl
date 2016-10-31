@doc "plot_patches(data_array,wantedVolume, gradient, amplitude) plots patch
      distribution inside wanted volume."->
function plot_patches(data_array,volume::wanted_volume,grad::gradient_scan,amp::amplitude)

patch_x=ustrip(4*amp.amp_x/grad.strength);
patch_y=ustrip(4*amp.amp_y/grad.strength);
patch_z=ustrip(2*amp.amp_z/grad.strength);

x_coord=[x[1] for x in data_array];
y_coord=[x[2] for x in data_array];
z_coord=[x[3] for x in data_array];

vol_z=ustrip(volume.z_dim);
vol_x=ustrip(volume.x_dim);
vol_y=ustrip(volume.y_dim);

iteration=size(x_coord)[1];

#initialize corner point array
p_flb=Array(Any,(iteration+1,1));
p_flt=Array(Any,(iteration+1,1));
p_frt=Array(Any,(iteration+1,1));
p_frb=Array(Any,(iteration+1,1));
p_blb=Array(Any,(iteration+1,1));
p_blt=Array(Any,(iteration+1,1));
p_brt=Array(Any,(iteration+1,1));
p_brb=Array(Any,(iteration+1,1));

#determine corner points of patch geometry
for i=1:iteration
#front left bottom
p_flb[i]=[y_coord[i]-patch_y/2 x_coord[i]-patch_x/2 z_coord[i]-patch_z/2];
p_flb[iteration+1]=[-vol_y/2 -vol_x/2 -vol_z/2];
#front left top
p_flt[i]=[y_coord[i]-patch_y/2 x_coord[i]-patch_x/2 z_coord[i]+patch_z/2]
p_flt[iteration+1]=[-vol_y/2 -vol_x/2 vol_z/2]
#front right top
p_frt[i]=[y_coord[i]+patch_y/2 x_coord[i]-patch_x/2 z_coord[i]+patch_z/2]
p_frt[iteration+1]=[vol_y/2 -vol_x/2 vol_z/2]
#front right bottom
p_frb[i]=[y_coord[i]+patch_y/2 x_coord[i]-patch_x/2 z_coord[i]-patch_z/2]
p_frb[iteration+1]=[vol_y/2 -vol_x/2 -vol_z/2]
#back left bottom
p_blb[i]=[y_coord[i]-patch_y/2 x_coord[i]+patch_x/2 z_coord[i]-patch_z/2]
p_blb[iteration+1]=[-vol_y/2 vol_x/2 -vol_z/2]
#back left top
p_blt[i]=[y_coord[i]-patch_y/2 x_coord[i]+patch_x/2 z_coord[i]+patch_z/2]
p_blt[iteration+1]=[-vol_y/2 vol_x/2 vol_z/2]
#back right top
p_brt[i]=[y_coord[i]+patch_y/2 x_coord[i]+patch_x/2 z_coord[i]+patch_z/2]
p_brt[iteration+1]=[vol_y/2 vol_x/2 vol_z/2]
#back right bottom
p_brb[i]=[y_coord[i]+patch_y/2 x_coord[i]+patch_x/2 z_coord[i]-patch_z/2]
p_brb[iteration+1]=[vol_y/2 vol_x/2 -vol_z/2]
end

for i=1:iteration
figure("Plot patches");
a1=plot3D([p_flb[i][1],p_flt[i][1]],[p_flb[i][2],p_flt[i][2]],[p_flb[i][3],p_flt[i][3]],color="blue");
a2=plot3D([p_flt[i][1],p_frt[i][1]],[p_flt[i][2],p_frt[i][2]],[p_flt[i][3],p_frt[i][3]],color="blue");
a3=plot3D([p_frt[i][1],p_frb[i][1]],[p_frt[i][2],p_frb[i][2]],[p_frt[i][3],p_frb[i][3]],color="blue");
a4=plot3D([p_frb[i][1],p_flb[i][1]],[p_frb[i][2],p_flb[i][2]],[p_frb[i][3],p_flb[i][3]],color="blue");
a5=plot3D([p_blb[i][1],p_blt[i][1]],[p_blb[i][2],p_blt[i][2]],[p_blb[i][3],p_blt[i][3]],color="blue");
a6=plot3D([p_blt[i][1],p_brt[i][1]],[p_blt[i][2],p_brt[i][2]],[p_blt[i][3],p_brt[i][3]],color="blue");
a7=plot3D([p_brt[i][1],p_brb[i][1]],[p_brt[i][2],p_brb[i][2]],[p_brt[i][3],p_brb[i][3]],color="blue");
a8=plot3D([p_brb[i][1],p_blb[i][1]],[p_brb[i][2],p_blb[i][2]],[p_brb[i][3],p_blb[i][3]],color="blue");
a9=plot3D([p_flb[i][1],p_blb[i][1]],[p_flb[i][2],p_blb[i][2]],[p_flb[i][3],p_blb[i][3]],color="blue");
a10=plot3D([p_flt[i][1],p_blt[i][1]],[p_flt[i][2],p_blt[i][2]],[p_flt[i][3],p_blt[i][3]],color="blue");
a11=plot3D([p_frt[i][1],p_brt[i][1]],[p_frt[i][2],p_brt[i][2]],[p_frt[i][3],p_brt[i][3]],color="blue");
a12=plot3D([p_frb[i][1],p_brb[i][1]],[p_frb[i][2],p_brb[i][2]],[p_frb[i][3],p_brb[i][3]],color="blue");

PyPlot.xlabel("y [mm]");
PyPlot.ylabel("x [mm]");
PyPlot.zlabel("z [mm]");
axis(:equal);

end

#plot wanted volume in different color
a13=plot3D([p_flb[iteration+1][1],p_flt[iteration+1][1]],[p_flb[iteration+1][2],p_flt[iteration+1][2]],[p_flb[iteration+1][3],p_flt[iteration+1][3]],color="red");
a14=plot3D([p_flt[iteration+1][1],p_frt[iteration+1][1]],[p_flt[iteration+1][2],p_frt[iteration+1][2]],[p_flt[iteration+1][3],p_frt[iteration+1][3]],color="red");
a15=plot3D([p_frt[iteration+1][1],p_frb[iteration+1][1]],[p_frt[iteration+1][2],p_frb[iteration+1][2]],[p_frt[iteration+1][3],p_frb[iteration+1][3]],color="red");
a16=plot3D([p_frb[iteration+1][1],p_flb[iteration+1][1]],[p_frb[iteration+1][2],p_flb[iteration+1][2]],[p_frb[iteration+1][3],p_flb[iteration+1][3]],color="red");
a17=plot3D([p_blb[iteration+1][1],p_blt[iteration+1][1]],[p_blb[iteration+1][2],p_blt[iteration+1][2]],[p_blb[iteration+1][3],p_blt[iteration+1][3]],color="red");
a18=plot3D([p_blt[iteration+1][1],p_brt[iteration+1][1]],[p_blt[iteration+1][2],p_brt[iteration+1][2]],[p_blt[iteration+1][3],p_brt[iteration+1][3]],color="red");
a19=plot3D([p_brt[iteration+1][1],p_brb[iteration+1][1]],[p_brt[iteration+1][2],p_brb[iteration+1][2]],[p_brt[iteration+1][3],p_brb[iteration+1][3]],color="red");
a20=plot3D([p_brb[iteration+1][1],p_blb[iteration+1][1]],[p_brb[iteration+1][2],p_blb[iteration+1][2]],[p_brb[iteration+1][3],p_blb[iteration+1][3]],color="red");
a21=plot3D([p_flb[iteration+1][1],p_blb[iteration+1][1]],[p_flb[iteration+1][2],p_blb[iteration+1][2]],[p_flb[iteration+1][3],p_blb[iteration+1][3]],color="red");
a22=plot3D([p_flt[iteration+1][1],p_blt[iteration+1][1]],[p_flt[iteration+1][2],p_blt[iteration+1][2]],[p_flt[iteration+1][3],p_blt[iteration+1][3]],color="red");
a23=plot3D([p_frt[iteration+1][1],p_brt[iteration+1][1]],[p_frt[iteration+1][2],p_brt[iteration+1][2]],[p_frt[iteration+1][3],p_brt[iteration+1][3]],color="red");
a24=plot3D([p_frb[iteration+1][1],p_brb[iteration+1][1]],[p_frb[iteration+1][2],p_brb[iteration+1][2]],[p_frb[iteration+1][3],p_brb[iteration+1][3]],color="red");

end #function
