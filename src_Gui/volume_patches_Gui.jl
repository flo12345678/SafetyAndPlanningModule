@doc "(center_coords,number_of_patches)=volumePatches(wantedVolume, gradient, amplitude; overlap,increase)
      creates coordinates of patches covering the volume, determined by gradient
      strength and amplitude. Overlap allows patches to overlap to exactly fit the
      desired volume. Increase recommends user to increase the desired volume
      such that patches exactly fit the desired volume."->
function volume_patches(volume::wanted_volume, grad::gradient_scan, amp::amplitude;overlap=false,increase=false)
#calculate size of single patch with gradient and amplitude
patch_x=ustrip(4*amp.amp_x/grad.strength);
patch_y=ustrip(4*amp.amp_y/grad.strength);
patch_z=ustrip(2*amp.amp_z/grad.strength);

vol_z=ustrip(volume.z_dim);
vol_x=ustrip(volume.x_dim);
vol_y=ustrip(volume.y_dim);

#calculate number of layers and layer redisual
res_z=(vol_z%patch_z);
if res_z>=patch_z/2-1/1000
num_lay=round(vol_z/patch_z+1/1000)-1;
else
num_lay=round(vol_z/patch_z+1/1000);
end

#calculate number of patches along x- and y-axis and layer redisuals
res_x=(vol_x%patch_x);
if res_x>=patch_x/2-1/1000
num_x=round(vol_x/patch_x+1/1000)-1;
else
num_x=round(vol_x/patch_x+1/1000);
end

res_y=(vol_y%patch_y);
if res_y>=patch_y/2-1/1000
num_y=round(vol_y/patch_y+1/1000)-1;
else
num_y=round(vol_y/patch_y+1/1000);
end
#calculate number of patches for each direction and for exact fit/recommended
#volume changes (res_x,y,z==0.0) and overlap/increase

x_max=convert(Int64,num_x);
even_x=(x_max%2);

y_max=convert(Int64,num_y);
even_y=(y_max%2);

z_max=convert(Int64,num_lay);
even_z=(z_max%2);

#calculate number of patches per layer
patches_layer=x_max*y_max;
pixel=patches_layer*z_max;

#initialize arrays for center point storage
storage=Array(Any,(pixel,1));
x_coords=Array(Any,(pixel,1));
y_coords=Array(Any,(pixel,1));
z_coords=Array(Any,(pixel,1));

if overlap==false && increase==false

  x_max=convert(Int64,num_x);
  even_x=(x_max%2);

  y_max=convert(Int64,num_y);
  even_y=(y_max%2);

  z_max=convert(Int64,num_lay);
  even_z=(z_max%2);

  #calculate number of patches per layer
  patches_layer=x_max*y_max;
  pixel=patches_layer*z_max;

  #initialize arrays for center point storage
  storage=Array(Any,(pixel,1));
  x_coords=Array(Any,(pixel,1));
  y_coords=Array(Any,(pixel,1));
  z_coords=Array(Any,(pixel,1));

   if even_x==0.0

     for k=0:z_max-1
         for j=0:y_max-1
             for i=1:x_max
                 x_coords[i+j*x_max+patches_layer*k]=(patch_x/2+patch_x*(x_max/2-1))-patch_x*(i-1)
             end #num_x
         end # num_y
     end# num_lay

   else #even_x!=0.0

       for k=0:z_max-1
           for j=0:y_max-1
               for i=1:x_max
                   x_coords[i+j*x_max+patches_layer*k]=(patch_x*(x_max-1)/2)-patch_x*(i-1)
               end #num_x
           end # num_y
       end# num_lay
   end #even

   if even_y==0.0

      for k=0:z_max-1
          for j=0:x_max-1
              for i=0:y_max-1
                  y_coords[1+i*x_max+j+patches_layer*k]=-(patch_y/2+patch_y*(y_max/2-1))+patch_y*(i)
              end #num_x
          end # num_y
      end# num_lay

    else #even_y!=0.0

      for k=0:z_max-1
          for j=0:x_max-1
              for i=0:y_max-1
                  y_coords[1+i*x_max+j+patches_layer*k]=-(patch_y*(y_max-1)/2)+patch_y*(i)
              end #num_x
          end # num_y
      end# num_lay
    end #even

   if even_z==0.0

      for k=0:z_max-1
          for i=1:patches_layer
              z_coords[i+k*patches_layer]=(patch_z/2+patch_z*(z_max/2-1))-patch_z*k
          end #num_x
      end# num_lay

    else #even_z!=0.0

      for k=0:z_max-1
          for i=1:patches_layer
              z_coords[i+k*patches_layer]=patch_z*(z_max-1)/2-patch_z*k
          end #num_x
      end# num_lay
   end #even

#store data points in storage array (tuple(x,y,z))
   for t=1:pixel
       storage[t]=(x_coords[t],y_coords[t],z_coords[t])
   end

#print dimension errors
   if res_x !=0.0 || res_y !=0.0 || res_z !=0.0
      diff_x=res_x*u"mm";
      diff_y=res_y*u"mm";
      diff_z=res_z*u"mm";

   elseif res_x ==0.0 && res_y ==0.0 && res_z ==0.0
          diff_x=0.0u"mm";
          diff_y=0.0u"mm";
          diff_z=0.0u"mm";
          display("Volume can be exactly covered by $pixel patches.")
   end
return storage,pixel,diff_x,diff_y,diff_z

elseif overlap==true

  if res_x==0.0
     x_max=convert(Int64,num_x);
     delta_x=0.0;
  else
     x_max=convert(Int64,num_x+1)
     delta_x=(patch_x-(res_x))/(x_max-1);
  end
     even_x=(x_max%2);

  if res_y==0.0
     y_max=convert(Int64,num_y);
     delta_y=0.0;
  else
     y_max=convert(Int64,num_y+1)
     delta_y=(patch_y-(res_y))/(y_max-1);
  end
     even_y=(y_max%2);

  if res_z==0.0
     z_max=convert(Int64,num_lay);
     delta_z=0.0;
  else
     z_max=convert(Int64,num_lay+1)
     delta_z=(patch_z-(res_z))/(z_max-1);
  end
     even_z=(z_max%2);

  #calculate number of patches per layer
  patches_layer=x_max*y_max;
  pixel=patches_layer*z_max;

  #initialize arrays for center point storage
  storage=Array(Any,(pixel,1));
  x_coords=Array(Any,(pixel,1));
  y_coords=Array(Any,(pixel,1));
  z_coords=Array(Any,(pixel,1));

  if even_x==0.0

     for k=0:z_max-1
         for j=0:y_max-1
             for i=1:x_max
                 x_coords[i+j*x_max+patches_layer*k]=(patch_x/2-delta_x/2)+(x_max/2-1)*(patch_x-delta_x)-(i-1)*(patch_x-delta_x)
             end #num_x (patch_x/2+patch_x*(x_max/2-1))-patch_x*(i-1)
         end # num_y
     end# num_lay

    else #even_x!=0.0

    for k=0:z_max-1
        for j=0:y_max-1
            for i=1:x_max
                x_coords[i+j*x_max+patches_layer*k]=(patch_x-delta_x)*(x_max-1)/2-(i-1)*(patch_x-delta_x)
            end #num_x
        end # num_y
    end# num_lay
    end #even

  if even_y==0.0

     for k=0:z_max-1
         for j=0:x_max-1
             for i=0:y_max-1
                 y_coords[1+i*x_max+j+patches_layer*k]=-(patch_y/2-delta_y/2)-(y_max/2-1)*(patch_y-delta_y)+(patch_y-delta_y)*(i)
             end #num_x
         end # num_y
     end# num_lay

  else #even_y !=0.0

    for k=0:z_max-1
        for j=0:x_max-1
            for i=0:y_max-1
                y_coords[1+i*x_max+j+patches_layer*k]=-(patch_y-delta_y)*(y_max-1)/2+(patch_y-delta_y)*(i)
            end #num_x
        end # num_y
    end# num_lay
  end #even

  if even_z==0.0

     for k=0:z_max-1
         for i=1:patches_layer
             z_coords[i+k*patches_layer]=((patch_z/2-delta_z/2)+(patch_z-delta_z)*(z_max/2-1))-(patch_z-delta_z)*k
         end #num_x
     end# num_lay

  else #even_z !=0.0

    for k=0:z_max-1
        for i=1:patches_layer
            z_coords[i+k*patches_layer]=(patch_z-delta_z)*(z_max-1)/2-(patch_z-delta_z)*(k)
        end #num_x
    end# num_lay
  end #even

  #store data points in storage array (tuple(x,y,z))
    for t=1:pixel
        storage[t]=(x_coords[t],y_coords[t],z_coords[t])
    end

    #print dimension errors
       if res_x !=0.0 || res_y !=0.0 || res_z !=0.0
          diff_x=delta_x*u"mm";
          diff_y=delta_y*u"mm";
          diff_z=delta_z*u"mm";
       end
    return storage,pixel,diff_x,diff_y,diff_z

elseif increase==true

  if res_x==0.0
     x_max=convert(Int64,num_x);
  else
     x_max=convert(Int64,num_x+1)
  end
     even_x=(x_max%2);

  if res_y==0.0
     y_max=convert(Int64,num_y);
  else
     y_max=convert(Int64,num_y+1)
  end
     even_y=(y_max%2);

  if res_z==0.0
     z_max=convert(Int64,num_lay);
  else
     z_max=convert(Int64,num_lay+1)
  end
     even_z=(z_max%2);

  #calculate number of patches per layer
  patches_layer=x_max*y_max;
  pixel=patches_layer*z_max;

  #initialize arrays for center point storage
  storage=Array(Any,(pixel,1));
  x_coords=Array(Any,(pixel,1));
  y_coords=Array(Any,(pixel,1));
  z_coords=Array(Any,(pixel,1));

   if even_x==0.0

     for k=0:z_max-1
         for j=0:y_max-1
             for i=1:x_max
                 x_coords[i+j*x_max+patches_layer*k]=(patch_x/2+patch_x*(x_max/2-1))-patch_x*(i-1)
             end #num_x
         end # num_y
     end# num_lay

   else #even_x!=0.0

     for k=0:z_max-1
         for j=0:y_max-1
             for i=1:x_max
                 x_coords[i+j*x_max+patches_layer*k]=(patch_x*(x_max-1)/2)-patch_x*(i-1)
             end #num_x
         end # num_y
     end# num_lay
  end #even

  if even_y==0.0

     for k=0:z_max-1
         for j=0:x_max-1
             for i=0:y_max-1
                 y_coords[1+i*x_max+j+patches_layer*k]=-(patch_y/2+patch_y*(y_max/2-1))+patch_y*(i)
             end #num_x
         end # num_y
     end# num_lay

   else #even_y!=0.0

     for k=0:z_max-1
         for j=0:y_max-1
             for i=0:x_max-1
                 y_coords[1+i*x_max+j+patches_layer*k]=-(patch_y*(y_max-1)/2)+patch_y*(i)
             end #num_x
         end # num_y
     end# num_lay
  end #even

  if even_z==0.0

     for k=0:z_max-1
         for i=1:patches_layer
             z_coords[i+k*patches_layer]=(patch_z/2+patch_z*(z_max/2-1))-patch_z*k
         end #num_x
     end# num_lay

   else #even_z!=0.0

     for k=0:z_max-1
         for i=1:patches_layer
             z_coords[i+k*patches_layer]=patch_z*(z_max-1)/2-patch_z*k
         end #num_x
     end# num_lay
  end #even

#store data points in storage array (tuple(x,y,z))
  for t=1:pixel
      storage[t]=(x_coords[t],y_coords[t],z_coords[t])
  end

  #print dimension errors
     if res_x !=0.0 || res_y !=0.0 || res_z !=0.0
        diff_x=((patch_x-res_x)+vol_x)*u"mm";
        diff_y=((patch_y-res_y)+vol_y)*u"mm";
        diff_z=((patch_z-res_z)+vol_z)*u"mm";
     end
  return storage,pixel,diff_x,diff_y,diff_z

end #no overlap,increase

end #function
