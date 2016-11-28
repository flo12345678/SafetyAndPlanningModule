@doc "correct_points is used to correct the invalid data points from check_coor function."->

function correct_points(geo::geometry)
  array=Array(Any,1);

  read_array=readdlm("Points_checked.txt",skipstart=1);
  rep=size(read_array)[1];

  xc=Array(Any,(rep,1));
  xerr=Array(Any,(rep,1));
  xcorrect=Array(Any,(rep,1));
  yc=Array(Any,(rep,1));
  yerr=Array(Any,(rep,1));
  ycorrect=Array(Any,(rep,1));
  zc=Array(Any,(rep,1));
  zerr=Array(Any,(rep,1));
  zcorrect=Array(Any,(rep,1));

  kosc=Array(Any,(rep,1));

  for i=1:rep

  xc[i]=read_array[rep+i];
  yc[i]=read_array[3*rep+i];
  zc[i]=read_array[5*rep+i];

  xerr[i]=read_array[7*rep+i];
  yerr[i]=read_array[8*rep+i];
  zerr[i]=read_array[9*rep+i];

  xcorrect[i]=(xc[i]-round(xerr[i]));

  if yc[i]<0
  ycorrect[i]=(yc[i]+round(yerr[i])+5);
  else
  ycorrect[i]=(yc[i]-round(yerr[i])-5);
  end

  if zc[i]<0
  zcorrect[i]=(zc[i]+round(zerr[i])+5);
  else
  zcorrect[i]=(zc[i]-round(zerr[i])-5);
  end

  kosc[i]=(xcorrect[i],ycorrect[i],zcorrect[i]);
  end

  if typeof(geo)==circle
     volume_x=maximum(xcorrect)+abs(minimum(xcorrect));
     volume_y=maximum(ycorrect)+abs(minimum(ycorrect))+ustrip(geo.diameter);
     volume_z=maximum(zcorrect)+abs(minimum(zcorrect))+ustrip(geo.diameter);
  else
     volume_x=maximum(xcorrect)+abs(minimum(xcorrect));
     volume_y=maximum(ycorrect)+abs(minimum(ycorrect))+ustrip(geo.width);
     volume_z=maximum(zcorrect)+abs(minimum(zcorrect))+ustrip(geo.height);
  end

  display("Tested volume dimensions: $volume_x mm x $volume_y mm x $volume_z mm");

  array[1]=convert2unit(kosc,u"mm");
end
