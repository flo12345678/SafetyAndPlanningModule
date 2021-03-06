@doc "convert2unit(data_array,unit) converts the data array (tuples) without units to
      an array with length units."->
function convert2unit{U}(data_array, unit::Unitful.Units{U ,Unitful.Dimensions{(Unitful.Dimension{:Length}(1//1),)}})
         #create single coordinate vectors from data array and add the desired unit
         x_coord=[x[1] for x in data_array]*unit;
         y_coord=[x[2] for x in data_array]*unit;
         z_coord=[x[3] for x in data_array]*unit;
         #combine single vectors to array
         coord_array=hcat(x_coord,y_coord,z_coord);
end
