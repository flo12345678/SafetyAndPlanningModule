module SafetyAndPlanningModule

using PyPlot
using Unitful #allow SI units to be used + manipulations

export check_coor
export geometry,coordinates,circle,rectangle,hexagon,triangle
export scanner_rad,clearance,x_min_robot,x_max_robot,mouse_adapter,delta_probe

const scanner_rad=60.0;
const clearance=5.0;
const x_min_robot=-200.0;
const x_max_robot=50.0;

abstract geometry

immutable circle<:geometry
  diameter::typeof(1.0u"mm")
  geotype::String

  circle(diameter,geotype) = geotype != "Circle" ? error("Wrong geometry type") : new(diameter,geotype)
end

immutable rectangle<:geometry
  width::typeof(1.0u"mm")
  height::typeof(1.0u"mm")
  geotype::String

  rectangle(width,height,geotype) = geotype != "Rectangle" ? error("Wrong geometry type") : new(width,height,geotype)
end

immutable hexagon<:geometry
  width::typeof(1.0u"mm")
  height::typeof(1.0u"mm")
  geotype::String

  hexagon(width,height,geotype) = geotype != "Hexagon" ? error("Wrong geometry type") : new(width,height,geotype)
end

immutable triangle<:geometry
  width::typeof(1.0u"mm")
  height::typeof(1.0u"mm")
  geotype::String

  triangle(width,height,geotype) = geotype != "Triangle" ? error("Wrong geometry type") : new(width,height,geotype)
end

#Create given test geometies
mouse_adapter=circle(50.0u"mm","Circle");

delta_probe=circle(10.0u"mm","Circle");

# immutable movePositions
# #unit::eigentlich all units für Dimension Length
#
# end
#
# # receiveCoil Scanner, spule wird in Scanner hineingelegt und verkleinert Bore Diameter
# immutable scannerGeo
#
# end


# function check_coor(scanner::scannerGeo, geo::geometry, coords::Array{Tuple{typeof(0.0u"mm"),typeof(0.0u"mm"),typeof(0.0u"mm")}}; showfig=false)
#
# end

@doc "check_coor(geometry) is used to check if the chosen test coordinates are inside the allowed range
      of the roboter movement. If invalid points exist a list with all points will be presented
      to the user. The first column states whether the test point is valid (1.0) or not (0.0).
      Test coordinates have to be written inside Test_Coordinates.txt file. Only the following test
      geometries will be accepted: Circle, Rectangle, Hexagon and Triangle. The positions of the test
      objects will be plotted, according to the respective test coordinates."->

function check_coor(geo::geometry)
  #get test coordinates from .txt file
  coords=readdlm("Test_Coordinates.txt",skipstart=3);
  iteration=size(coords)[1];

  #initialize error vectors
  error_string=Array(Any,(iteration,1));
  error_x=Array(Float64,(iteration,1));
  error_y=Array(Float64,(iteration,1));
  error_z=Array(Float64,(iteration,1));

for i=1:iteration

  x_i=coords[i];
  y_i=coords[iteration+i];
  z_i=coords[2*iteration+i];

  if x_i>x_max_robot
     delta_x_max=x_i-x_max_robot;
     error_string[i]="INVALID";
     error_x[i]=delta_x_max;
     #println("Chosen x coordinate exceeds range ($delta_x_max too big).")
  elseif x_i<x_min_robot
         delta_x_min=x_min_robot-x_i;
         error_string[i]="INVALID"
         error_x[i]=delta_x_min;
         #println("Chosen x coordinate exceeds range ($delta_x_min too small).")
  else
    error_string[i]="VALID";
    error_x[i]=0.0;
    #println("Chosen x coordinate is safe.")
  end #if check x coordinate

  if geo.geotype=="Circle"  # geo==typeof(circle) wäre typ sicher
     #remove units for calculations
     diameter=ustrip(geo.diameter);
     #check distances
     delta=scanner_rad-sqrt(y_i^2+z_i^2)-diameter/2;
     delta_y=(abs(y_i)+diameter/2*sin(atan(abs(y_i/z_i))))-scanner_rad*sin(atan(abs(y_i/z_i)));
     delta_z=(abs(z_i)+diameter/2*cos(atan(abs(y_i/z_i))))-scanner_rad*cos(atan(abs(y_i/z_i)));

     if delta>clearance
        error_string[i]="VALID";
        error_y[i]=0.0;
        error_z[i]=0.0;
        #println("Chosen y and z coordinates are safe.")
     else
        error_string[i]="INVALID";
        error_y[i]=delta_y;
        error_z[i]=delta_z;
        #println("You exceeded the y coordinate range by $(delta_y).")
        #println("You exceeded the z coordinate range by $(delta_z).")
     end #if clearance

     #plot results
     t=linspace(0,2,200);

     x_scanner=scanner_rad*cos(t*pi);
     y_scanner=scanner_rad*sin(t*pi);

     x_geometry=diameter/2*cos(t*pi)+y_i;
     y_geometry=diameter/2*sin(t*pi)+z_i;

     figure("Plot results - Test geometry position - Set $i");
     p=plot(x_scanner,y_scanner,x_geometry,y_geometry);
     PyPlot.xlabel("y [mm]");
     PyPlot.ylabel("z [mm]");
     axis(:equal);
     display(p);

  elseif geo.geotype=="Rectangle"
         #remove units for calculations
         width=ustrip(geo.width);
         height=ustrip(geo.height);
         #check distances
         delta_y=(abs(y_i)+width/2)-scanner_rad*sin(atan((abs(y_i)+width/2)/(abs(z_i)+height/2)));
         delta_z=(abs(z_i)+height/2)-scanner_rad*cos(atan((abs(y_i)+width/2)/(abs(z_i)+height/2)));

         if clearance>delta_y && clearance>delta_z
            error_string[i]="VALID";
            error_y[i]=0.0;
            error_z[i]=0.0;
            #println("Chosen y and z coordinates are safe.")
         else
            error_string[i]="INVALID";
            error_y[i]=delta_y;
            error_z[i]=delta_z;
            #println("You exceeded the y coordinate range by $(delta_y).")
            #println("You exceeded the z coordinate range by $(delta_z).")
         end #if clearance

         #Plot results
         #Create rectangle corner points
         #point bottom left
         p_bl=[y_i-width/2, z_i-height/2];
         #point upper left
         p_ul=[y_i-width/2, z_i+height/2];
         #point upper right
         p_ur=[y_i+width/2, z_i+height/2];
         #point bottom right
         p_br=[y_i+width/2, z_i-height/2];

         #Scanner circle
         t=linspace(0,2,200);

         x_scanner=scanner_rad*cos(t*pi);
         y_scanner=scanner_rad*sin(t*pi);

         figure("Plot results - Test geometry positions - Set $i");
         p=plot(x_scanner,y_scanner,[p_bl[1],p_ul[1]],[p_bl[2],p_ul[2]],[p_ul[1],p_ur[1]],[p_ul[2],p_ur[2]],
                [p_ur[1],p_br[1]],[p_ur[2],p_br[2]],[p_br[1],p_bl[1]],[p_br[2],p_bl[2]]);
         PyPlot.xlabel("y [mm]");
         PyPlot.ylabel("z [mm]");
         axis(:equal);
         display(p);

  elseif geo.geotype=="Hexagon"
         #remove units for calculations
         width=ustrip(geo.width);
         height=ustrip(geo.height);

         #approximate hexagon by circle
         if width>height
            radius=width/2;
         else
            radius=height/2;
         end

         #check distances
         delta=scanner_rad-sqrt(y_i^2+z_i^2)-radius;
         delta_y=(abs(y_i)+radius*sin(atan(abs(y_i/z_i))))-scanner_rad*sin(atan(abs(y_i/z_i)));
         delta_z=(abs(z_i)+radius*cos(atan(abs(y_i/z_i))))-scanner_rad*cos(atan(abs(y_i/z_i)));

         if delta>clearance
            error_string[i]="VALID";
            error_y[i]=0.0;
            error_z[i]=0.0;
            #println("Chosen y and z coordinates are safe.")
         else
            error_string[i]="INVALID";
            error_y[i]=delta_y;
            error_z[i]=delta_z;
            #println("You exceeded the y coordinate range by $(delta_y).")
            #println("You exceeded the z coordinate range by $(delta_z).")
         end #if clearance

         #plot results
         t=linspace(0,2,200);

         x_scanner=scanner_rad*cos(t*pi);
         y_scanner=scanner_rad*sin(t*pi);

         x_geometry=radius*cos(t*pi)+y_i;
         y_geometry=radius*sin(t*pi)+z_i;

         if width>height
            #Create hexagon corner points (tips are left and right)
            #point left
            p_l=[y_i-width/2, z_i];
            #point top left
            p_tl=[y_i-width/4, z_i+height/2];
            #point top right
            p_tr=[y_i+width/4, z_i+height/2];
            #point right
            p_r=[y_i+width/2, z_i];
            #point bottom right
            p_br=[y_i+width/4, z_i-height/2];
            #point bottom left
            p_bl=[y_i-width/4, z_i-height/2];

            figure("Plot results - Test geometry positions - Set $i");
            p=plot(x_scanner,y_scanner,x_geometry,y_geometry,[p_l[1],p_tl[1]],[p_l[2],p_tl[2]],
                   [p_tl[1],p_tr[1]],[p_tl[2],p_tr[2]],[p_tr[1],p_r[1]],[p_tr[2],p_r[2]],
                   [p_r[1],p_br[1]],[p_r[2],p_br[2]],[p_br[1],p_bl[1]],[p_br[2],p_bl[2]],
                   [p_bl[1],p_l[1]],[p_bl[2],p_l[2]]);
            PyPlot.xlabel("y [mm]");
            PyPlot.ylabel("z [mm]");
            axis(:equal);
            display(p);

         else
            #Create hexagon corner points (tips are on top and at bottom)
            #point left bottom
            p_lb=[y_i-width/2, z_i-height/4];
            #point left top
            p_lt=[y_i-width/2, z_i+height/4];
            #point top
            p_t=[y_i, z_i+height/2];
            #point right top
            p_rt=[y_i+width/2, z_i+height/4];
            #point right bottom
            p_rb=[y_i+width/2, z_i-height/4];
            #point bottom
            p_b=[y_i, z_i-height/2];

            figure("Plot results - Test geometry positions - Set $i");
            p=plot(x_scanner,y_scanner,x_geometry,y_geometry,[p_lb[1],p_lt[1]],[p_lb[2],p_lt[2]],
                   [p_lt[1],p_t[1]],[p_lt[2],p_t[2]],[p_t[1],p_rt[1]],[p_t[2],p_rt[2]],
                   [p_rt[1],p_rb[1]],[p_rt[2],p_rb[2]],[p_rb[1],p_b[1]],[p_rb[2],p_b[2]],
                   [p_b[1],p_lb[1]],[p_b[2],p_lb[2]]);
            PyPlot.xlabel("y [mm]");
            PyPlot.ylabel("z [mm]");
            axis(:equal);
            display(p);
         end

  elseif geo.geotype=="Triangle"
         #remove units for calculations
         width=ustrip(geo.width);
         height=ustrip(geo.height);
         #following code only for symmetric triangles / center of gravity = center of plug adapter
         perimeter=sqrt(width^2/4+height^2)/(2*sin(atan(2*height/width)));

         #define new z coordinate, since center of gravity is not equal to center of perimeter circle
         z_new=z_i+((2/3)*height-perimeter);

         delta=scanner_rad-sqrt(y_i^2+z_new^2)-perimeter;
         delta_y=(abs(y_i)+perimeter*sin(atan(abs(y_i/z_new))))-scanner_rad*sin(atan(abs(y_i/z_new)));
         delta_z=(abs(z_new)+perimeter*cos(atan(abs(y_i/z_new))))-scanner_rad*cos(atan(abs(y_i/z_new)));

         if delta>clearance
            error_string[i]="VALID";
            error_y[i]=0.0;
            error_z[i]=0.0;
            #println("Chosen y and z coordinates are safe.")
         else
            error_string[i]="INVALID";
            error_y[i]=delta_y;
            error_z[i]=delta_z;
            #println("You exceeded the y coordinate range by $(delta_y).")
            #println("You exceeded the z coordinate range by $(delta_z).")
         end #if clearance

         #plot results
         t=linspace(0,2,200);

         x_scanner=scanner_rad*cos(t*pi);
         y_scanner=scanner_rad*sin(t*pi);

         x_geometry=perimeter*cos(t*pi)+y_i;
         y_geometry=perimeter*sin(t*pi)+z_new;

         #Create triangle corner points
         #point bottom left
         p_bl=[y_i-width/2, z_i-height/3];
         #upper point
         p_u=[y_i, z_i+2/3*height];
         #point bottom right
         p_br=[y_i+width/2, z_i-height/3];

         figure("Plot results - Test geometry positions - Set $i");
         p=plot(x_scanner,y_scanner,x_geometry,y_geometry,[p_bl[1],p_u[1]],[p_bl[2],p_u[2]],
                [p_u[1],p_br[1]],[p_u[2],p_br[2]],[p_br[1],p_bl[1]],[p_br[2],p_bl[2]]);
         PyPlot.xlabel("y [mm]");
         PyPlot.ylabel("z [mm]");
         axis(:equal);
         display(p);

  else
     println("Chosen geometry not known.\nChoose a given geometry.")

  end #if

end #for iteration
  table=hcat(error_string,coords,error_x,error_y,error_z);
  #table headline
  headline=["Status" "x" "y" "z" "delta_x" "delta_y" "delta_z"];
  #create final table
  coord_table=vcat(headline,table);
  #create array for comparision with error_string
  error_comp=Array(Any,(iteration,1));
  for i=1:iteration
      error_comp[i]="VALID";
  end

  if error_comp==error_string
     display("All coordinates are safe!");
  else
     display(coord_table);
     error("Some coordinates exceeded their range!");
  end

end #function

end # module
