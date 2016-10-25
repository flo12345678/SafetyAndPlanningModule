@doc "convert2unit(data_array,unit) converts the data array (tuples) without units to
      an array with length units."->
function convert2unit(data_array,unit::Unitful.Length)
         x_coord=[x[1] for x in data_array]*unit;
         y_coord=[x[2] for x in data_array]*unit;
         z_coord=[x[3] for x in data_array]*unit;
         coord_array=hcat(x_coord,y_coord,z_coord);
end
