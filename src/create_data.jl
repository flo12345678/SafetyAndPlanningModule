@doc "create_data(coords) is used to create an array of test coordinate tuples."->
function create_data(coords::Array{Tuple{Float64,Float64,Float64}})
         rows=size(coords)[1];
         data_array=Array{Tuple{Float64,Float64,Float64}}(rows)
         for i=1:rows
           data_array[i]=coords[i];
         end
         return data_array
end
