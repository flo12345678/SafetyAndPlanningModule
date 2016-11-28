@doc "check_coor(scannergeo,geometry,coord_array;plotresults) is used to check if the chosen test coordinates are inside the allowed range
      of the roboter movement. If invalid points exist a list with all points will be presented
      to the user. Only the following test geometry types will be accepted: circle, rectangle, hexagon and triangle.
      The positions of the test objects will be plotted if at least one coordinate is invalid and plotresults=true."->

function check_coor(scanner::scannergeo,geo::geometry,coords::Array{typeof(1.0u"mm"),2};plotresults=false)
  #initialize iteration variable
  iteration=size(coords)[1];

  #initialize error vectors
  error_string=Array(Any,(iteration,1));
  error_x=Array(Any,(iteration,1));
  error_y=Array(Any,(iteration,1));
  error_z=Array(Any,(iteration,1));

  #initialize scanner radius
  scanner_rad=scanner.diameter/2;

for i=1:iteration

  x_i=coords[i];

  y_i=coords[iteration+i];

  z_i=coords[2*iteration+i];


  if x_i>x_max_robot
     delta_x_max=x_i-x_max_robot;
     error_string[i]="INVALID";
     error_x[i]=ustrip(delta_x_max);

  elseif x_i<x_min_robot
         delta_x_min=x_min_robot-x_i;
         error_string[i]="INVALID"
         error_x[i]=ustrip(delta_x_min);

  else
    error_string[i]="VALID";
    error_x[i]=0.0;

  end #if check x coordinate

  if typeof(geo)==circle
     #check distances
     delta=scanner_rad-sqrt(y_i^2+z_i^2)-geo.diameter/2;
     delta_y=(abs(y_i)+geo.diameter/2*sin(atan(abs(y_i/z_i))))-scanner_rad*sin(atan(abs(y_i/z_i)));
     delta_z=(abs(z_i)+geo.diameter/2*cos(atan(abs(y_i/z_i))))-scanner_rad*cos(atan(abs(y_i/z_i)));

     if delta>clearance
        error_string[i]="VALID";
        error_y[i]=0.0;
        error_z[i]=0.0;

     else
        error_string[i]="INVALID";
        error_y[i]=ustrip(delta_y);
        error_z[i]=ustrip(delta_z);

     end #if clearance

  elseif typeof(geo)==rectangle
         #check distances
         delta_y=(abs(y_i)+geo.width/2)-scanner_rad*sin(atan((abs(y_i)+geo.width/2)/(abs(z_i)+geo.height/2)));
         delta_z=(abs(z_i)+geo.height/2)-scanner_rad*cos(atan((abs(y_i)+geo.width/2)/(abs(z_i)+geo.height/2)));

         if clearance>delta_y && clearance>delta_z
            error_string[i]="VALID";
            error_y[i]=0.0;
            error_z[i]=0.0;

         else
            error_string[i]="INVALID";
            error_y[i]=ustrip(delta_y);
            error_z[i]=ustrip(delta_z);

         end #if clearance

  elseif typeof(geo)==hexagon
         #approximate hexagon by circle
         if geo.width>geo.height
            hex_radius=geo.width/2;
         else
            hex_radius=geo.height/2;
         end

         #check distances
         delta=scanner_rad-sqrt(y_i^2+z_i^2)-hex_radius;
         delta_y=(abs(y_i)+hex_radius*sin(atan(abs(y_i/z_i))))-scanner_rad*sin(atan(abs(y_i/z_i)));
         delta_z=(abs(z_i)+hex_radius*cos(atan(abs(y_i/z_i))))-scanner_rad*cos(atan(abs(y_i/z_i)));

         if delta>clearance
            error_string[i]="VALID";
            error_y[i]=0.0;
            error_z[i]=0.0;

         else
            error_string[i]="INVALID";
            error_y[i]=ustrip(delta_y);
            error_z[i]=ustrip(delta_z);

         end #if clearance

  elseif typeof(geo)==triangle
         #following code only for symmetric triangles / center of gravity = center of plug adapter
         perimeter=sqrt(geo.width^2/4+geo.height^2)/(2*sin(atan(2*geo.height/geo.width)));

         #define new z coordinate, since center of gravity is not equal to center of perimeter circle
         z_new=z_i+((2/3)*geo.height-perimeter);

         delta=scanner_rad-sqrt(y_i^2+z_new^2)-perimeter;
         delta_y=(abs(y_i)+perimeter*sin(atan(abs(y_i/z_new))))-scanner_rad*sin(atan(abs(y_i/z_new)));
         delta_z=(abs(z_new)+perimeter*cos(atan(abs(y_i/z_new))))-scanner_rad*cos(atan(abs(y_i/z_new)));

         if delta>clearance
            error_string[i]="VALID";
            error_y[i]=0.0;
            error_z[i]=0.0;

         else
            error_string[i]="INVALID";
            error_y[i]=ustrip(delta_y);
            error_z[i]=ustrip(delta_z);

         end #if clearance

  else
     println("Chosen geometry not known.\nChoose a given geometry.")

  end #if

end #for iteration

  #create coordinate table with errors
  table=hcat(error_string,coords,error_x,error_y,error_z);
  #table headlines
  headline=["Status" "x" "y" "z" "delta_x" "delta_y" "delta_z"];
  #create final table
  coord_table=vcat(headline,table);
  #create array for comparision with error_string
  error_comp=Array(Any,(iteration,1));

  for i=1:iteration
      error_comp[i]="VALID";
  end

  if error_comp==error_string
     visible(f14,true);
     visible(hbox3,false);
     writedlm("Points_checked.txt",coord_table);
     return coord_table,error_string,error_comp;
  else
     #plot results
     while plotresults==true
     iteration=size(coords)[1];

     for i = 1:iteration

     y_i=coords[iteration+i];
     z_i=coords[2*iteration+i];

     t=linspace(0,2,200);

     x_scanner=ustrip(scanner_rad)*cos(t*pi);
     y_scanner=ustrip(scanner_rad)*sin(t*pi);

     if typeof(geo)==circle
       if error_string[i]=="INVALID"
       x_geometry=ustrip(geo.diameter/2)*cos(t*pi)+ustrip(y_i);
       y_geometry=ustrip(geo.diameter/2)*sin(t*pi)+ustrip(z_i);

       figure("Plot results - $(geo.name) position - Set $i");
       p=plot(x_scanner,y_scanner,x_geometry,y_geometry);
       PyPlot.xlabel("y [mm]");
       PyPlot.ylabel("z [mm]");
       axis(:equal);
       display(p);
       end

     elseif typeof(geo)==rectangle
       if error_string[i]=="INVALID"
       #Create rectangle corner points
       #point bottom left
       p_bl=ustrip([y_i-geo.width/2, z_i-geo.height/2]);
       #point upper left
       p_ul=ustrip([y_i-geo.width/2, z_i+geo.height/2]);
       #point upper right
       p_ur=ustrip([y_i+geo.width/2, z_i+geo.height/2]);
       #point bottom right
       p_br=ustrip([y_i+geo.width/2, z_i-geo.height/2]);

       figure("Plot results - $(geo.name) positions - Set $i");
       p=plot(x_scanner,y_scanner,[p_bl[1],p_ul[1]],[p_bl[2],p_ul[2]],[p_ul[1],p_ur[1]],[p_ul[2],p_ur[2]],
              [p_ur[1],p_br[1]],[p_ur[2],p_br[2]],[p_br[1],p_bl[1]],[p_br[2],p_bl[2]],color="blue");
       PyPlot.xlabel("y [mm]");
       PyPlot.ylabel("z [mm]");
       axis(:equal);
       display(p);
       end

     elseif typeof(geo)==hexagon
       if error_string[i]=="INVALID"

       if geo.width>geo.height
          hex_radius=geo.width/2;
       else
          hex_radius=geo.height/2;
       end

       x_geometry=ustrip(hex_radius)*cos(t*pi)+ustrip(y_i);
       y_geometry=ustrip(hex_radius)*sin(t*pi)+ustrip(z_i);

       if geo.width>geo.height
          #Create hexagon corner points (tips are left and right)
          #point left
          p_l=ustrip([y_i-geo.width/2, z_i]);
          #point top left
          p_tl=ustrip([y_i-geo.width/4, z_i+geo.height/2]);
          #point top right
          p_tr=ustrip([y_i+geo.width/4, z_i+geo.height/2]);
          #point right
          p_r=ustrip([y_i+geo.width/2, z_i]);
          #point bottom right
          p_br=ustrip([y_i+geo.width/4, z_i-geo.height/2]);
          #point bottom left
          p_bl=ustrip([y_i-geo.width/4, z_i-geo.height/2]);

          figure("Plot results - $(geo.name) positions - Set $i");
          p=plot(x_scanner,y_scanner,x_geometry,y_geometry,[p_l[1],p_tl[1]],[p_l[2],p_tl[2]],
                 [p_tl[1],p_tr[1]],[p_tl[2],p_tr[2]],[p_tr[1],p_r[1]],[p_tr[2],p_r[2]],
                 [p_r[1],p_br[1]],[p_r[2],p_br[2]],[p_br[1],p_bl[1]],[p_br[2],p_bl[2]],
                 [p_bl[1],p_l[1]],[p_bl[2],p_l[2]],color="blue");
          PyPlot.xlabel("y [mm]");
          PyPlot.ylabel("z [mm]");
          axis(:equal);
          display(p);

       else
          #Create hexagon corner points (tips are on top and at bottom)
          #point left bottom
          p_lb=ustrip([y_i-geo.width/2, z_i-geo.height/4]);
          #point left top
          p_lt=ustrip([y_i-geo.width/2, z_i+geo.height/4]);
          #point top
          p_t=ustrip([y_i, z_i+geo.height/2]);
          #point right top
          p_rt=ustrip([y_i+geo.width/2, z_i+geo.height/4]);
          #point right bottom
          p_rb=ustrip([y_i+geo.width/2, z_i-geo.height/4]);
          #point bottom
          p_b=ustrip([y_i, z_i-geo.height/2]);

          figure("Plot results - $(geo.name) positions - Set $i");
          p=plot(x_scanner,y_scanner,x_geometry,y_geometry,[p_lb[1],p_lt[1]],[p_lb[2],p_lt[2]],
                 [p_lt[1],p_t[1]],[p_lt[2],p_t[2]],[p_t[1],p_rt[1]],[p_t[2],p_rt[2]],
                 [p_rt[1],p_rb[1]],[p_rt[2],p_rb[2]],[p_rb[1],p_b[1]],[p_rb[2],p_b[2]],
                 [p_b[1],p_lb[1]],[p_b[2],p_lb[2]],color="blue");
          PyPlot.xlabel("y [mm]");
          PyPlot.ylabel("z [mm]");
          axis(:equal);
          display(p);
       end
       end

     elseif typeof(geo)==triangle
       if error_string[i]=="INVALID"
       perimeter=sqrt(geo.width^2/4+geo.height^2)/(2*sin(atan(2*geo.height/geo.width)));

       z_new=z_i+((2/3)*geo.height-perimeter);

       x_geometry=ustrip(perimeter)*cos(t*pi)+ustrip(y_i);
       y_geometry=ustrip(perimeter)*sin(t*pi)+ustrip(z_new);

       #Create triangle corner points
       #point bottom left
       p_bl=ustrip([y_i-geo.width/2, z_i-geo.height/3]);
       #upper point
       p_u=ustrip([y_i, z_i+2/3*geo.height]);
       #point bottom right
       p_br=ustrip([y_i+geo.width/2, z_i-geo.height/3]);

       figure("Plot results - $(geo.name) positions - Set $i");
       p=plot(x_scanner,y_scanner,x_geometry,y_geometry,[p_bl[1],p_u[1]],[p_bl[2],p_u[2]],
              [p_u[1],p_br[1]],[p_u[2],p_br[2]],[p_br[1],p_bl[1]],[p_br[2],p_bl[2]],color="blue");
       PyPlot.xlabel("y [mm]");
       PyPlot.ylabel("z [mm]");
       axis(:equal);
       display(p);
       end #if error_string
     end #for
     end #if cases
     plotresults=false;
   end #while
     display(coord_table);
     writedlm("Points_checked.txt",coord_table);
     display("Used geometry: $(geo.name)")
     display("Used scanner diameter: $(scanner.name)")
     if error_string!=error_comp
        visible(f13,true);
        visible(hbox3,false);
     end

  end

end #function
