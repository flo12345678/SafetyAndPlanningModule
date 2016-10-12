module SafetyAndPlanningModule

using PyPlot
#include("")
export check_coor
export geometry,coordinates
export scanner_rad,clearance,x_min_robot,x_max_robot

const scanner_rad=600.0;
const clearance=5.0;
const x_min_robot=-200.0;
const x_max_robot=50.0;

x=Vector(0:0.1:2.0);

testobjects=["Circle","Rectangle","Hexagon","Triangle"];

type geometry
  width::Float64
  height::Float64
  name::String
end

type coordinates
  x::Float64
  y::Float64
  z::Float64
end

println("Given test geometries are: $testobjects")
println("Use check_coor(geo,coo) to see if your chosen coordinates are inside the allowed range.")
println("Input arguments are: geometry(width,height,test geometry) and coordinates(x,y,z).")

function check_coor(geo::geometry,coo::coordinates)

  if coo.x>x_max_robot
     delta_x_max=coo.x-x_max_robot;
     println("Chosen x coordinate exceeds range ($delta_x_max too big).")
  elseif coo.x<x_min_robot
         delta_x_min=x_min_robot-coo.x;
         println("Chosen x coordinate exceeds range ($delta_x_min too small).")
  else
    println("Chosen x coordinate is safe.")
  end #if check x coordinate

  if geo.name=="Circle"

     #check distances
     delta=scanner_rad-sqrt(coo.y^2+coo.z^2)-geo.width/2;
     delta_y=(abs(coo.y)+geo.width*sin(atan(abs(coo.y/coo.z))))-scanner_rad*sin(atan(abs(coo.y/coo.z)));
     delta_z=(abs(coo.z)+geo.width*cos(atan(abs(coo.y/coo.z))))-scanner_rad*cos(atan(abs(coo.y/coo.z)));

     if delta>clearance
        println("Chosen y and z coordinates are safe.")
     else
        println("You exceeded the y coordinate range by $(delta_y).")
        println("You exceeded the z coordinate range by $(delta_z).")
     end #if clearance

     #plot results
     figure("Plot results",figsize=(10,10));
     p=plot(scanner_rad*cos(x*pi),scanner_rad*sin(x*pi),geo.width/2*cos(x*pi)+coo.y,geo.width/2*sin(x*pi)+coo.z)
     PyPlot.xlabel("y [mm]");
     PyPlot.ylabel("z [mm]");
     PyPlot.title("Test geometry position");
     display(p);

  elseif geo.name=="Rectangle"

         #check distances
         delta_y=(abs(coo.y)+geo.width/2)-scanner_rad*sin(atan((abs(coo.y)+geo.width/2)/(abs(coo.z)+geo.height/2)));
         delta_z=(abs(coo.z)+geo.height/2)-scanner_rad*cos(atan((abs(coo.y)+geo.width/2)/(abs(coo.z)+geo.height/2)));

         if clearance>delta_y&&delta_z
            println("Chosen y and z coordinates are safe.")
         else
            println("You exceeded the y coordinate range by $(delta_y).")
            println("You exceeded the z coordinate range by $(delta_z).")
         end #if clearance

  elseif geo.name=="Hexagon"
         #approximate hexagon by circle
         if geo.width>geo.height
            radius=geo.width/2;
         else
            radius=geo.height/2;
         end

         #check distances
         delta=scanner_rad-sqrt(coo.y^2+coo.z^2)-radius;
         delta_y=(abs(coo.y)+radius*sin(atan(abs(coo.y/coo.z))))-scanner_rad*sin(atan(abs(coo.y/coo.z)));
         delta_z=(abs(coo.z)+radius*cos(atan(abs(coo.y/coo.z))))-scanner_rad*cos(atan(abs(coo.y/coo.z)));

         if delta>clearance
            println("Chosen y and z coordinates are safe.")
         else
            println("You exceeded the y coordinate range by $(delta_y).")
            println("You exceeded the z coordinate range by $(delta_z).")
         end #if clearance

  elseif geo.name=="Triangle"
         #needs to be fixed for any type of triangle
         #calculate center of triangle perimeter -> use coordinates to substitute radius*... term

         #following code only for symmetric triangles / center of gravity = center of plug adapter
         perimeter=sqrt(geo.width^2/4+geo.height^2)/(sin(arctan(2*geo.height/geo.width)));

         if geo.height/3>(geo.height-perimeter)
            z_new=coo.z+((2/3)*geo.height-perimeter);
         else
            z_new=coo.z-((4/3)*geo.height-perimeter);
         end

         delta=scanner_rad-sqrt(coo.y^2+z_new^2)-perimeter;
         delta_y=(abs(coo.y)+perimeter*sin(atan(abs(coo.y/z_new))))-scanner_rad*sin(atan(abs(coo.y/z_new)));
         delta_z=(abs(z_new)+perimeter*cos(atan(abs(coo.y/z_new))))-scanner_rad*cos(atan(abs(coo.y/z_new)));

         if delta>clearance
            println("Chosen y and z coordinates are safe.")
         else
            println("You exceeded the y coordinate range by $(delta_y).")
            println("You exceeded the z coordinate range by $(delta_z).")
         end #if clearance

  else
     println("Chosen geometry not known.\nChoose a given geometry.")

  end #if

end #function

end # module
