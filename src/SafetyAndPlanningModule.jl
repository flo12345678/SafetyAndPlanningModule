module SafetyAndPlanningModule

using PyPlot
using Unitful #allow SI units to be used + manipulations

export check_coor,create_data,convert2unit,volume_patches,plot_patches
export geometry,circle,rectangle,hexagon,triangle,wanted_volume,amplitude,gradient_scan
export scanner_reg,scanner_small,clearance,x_min_robot,x_max_robot,mouse_adapter,delta_sample

const clearance=5.0u"mm";
const x_min_robot=-200.0u"mm";
const x_max_robot=50.0u"mm";

abstract geometry

immutable circle<:geometry
  diameter::typeof(1.0u"mm")
  name::String
end

immutable rectangle<:geometry
  width::typeof(1.0u"mm")
  height::typeof(1.0u"mm")
  name::String
end

immutable hexagon<:geometry
  width::typeof(1.0u"mm")
  height::typeof(1.0u"mm")
  name::String
end

immutable triangle<:geometry
  width::typeof(1.0u"mm")
  height::typeof(1.0u"mm")
  name::String
end

immutable scannergeo
  diameter::typeof(1.0u"mm")
  name::String
end

type wanted_volume
     x_dim::typeof(1.0u"mm")
     y_dim::typeof(1.0u"mm")
     z_dim::typeof(1.0u"mm")
end

type amplitude
     amp_x::typeof(1.0u"mT")
     amp_y::typeof(1.0u"mT")
     amp_z::typeof(1.0u"mT")
end

type gradient_scan
     strength::typeof(1.0u"T/m")
end

#create given test geometries
mouse_adapter=circle(50.0u"mm","Mouse adapter");

delta_sample=circle(10.0u"mm","Delta sample");

#create given scanner diameter
scanner_reg=scannergeo(120.0u"mm","regular scanner diameter");

scanner_small=scannergeo(100.0u"mm","reduced scanner diameter");

include("create_data.jl")
include("convert2unit.jl")
include("check_coor.jl")
include("volume_patches.jl")
include("plot_patches.jl")

end # module
