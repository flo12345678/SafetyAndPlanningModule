using Gtk.ShortNames
using Graphics
using PyPlot
using Unitful

win = @Window("Safety and Planning Module");
f6= @Frame("Manual Testcoordinates [mm]");
f2= @Frame("Gradient strength [T/m]");
f3= @Frame("Volume patches functions");
f4= @Frame("Test volume dimensions [mm]");
f5= @Frame("Excitation field amplitude [mT]");
f7= @Frame("Scanner diameter");
f8= @Frame("Volume patches results");
f9= @Frame("Check points functions");
f10= @Frame("Test geometry");
f11= @Frame("Type of test points");
f12= @Frame("Test point functions");
f13= @Frame("ERROR MESSAGE");
f14= @Frame("STATUS MESSAGE");

hbox = @Box(:v);
hbox2= @Box(:h);
hbox3= @Box(:h);
hbox4= @Box(:h);
hbox5= @Box(:v);
hbox6= @Box(:h);
hbox7= @Box(:v);

    g6 = @Grid();
    g12 = @Grid();
    coordsx = @Entry();
    setproperty!(coordsx, :text, "X");
    coordsy = @Entry();
    setproperty!(coordsy, :text, "Y");
    coordsz = @Entry();
    setproperty!(coordsz, :text, "Z");
    next_button = @Button("Next point");
    coord_button = @Button("Create data");
    clear_button = @Button("Clear all data");

    g6[1,1] = coordsx;
    g6[1,2] = coordsy;
    g6[1,3] = coordsz;

    g12[1,1] = next_button;
    g12[1,2] = coord_button;
    g12[1,3] = clear_button;

    g2 = @Grid();
    g4 = @Grid();
    g5 = @Grid();

    volx = @Entry();
    setproperty!(volx, :text, "X");
    voly = @Entry();
    setproperty!(voly, :text, "Y");
    volz = @Entry();
    setproperty!(volz, :text, "Z");

    ampx = @Entry();
    setproperty!(ampx, :text, "X");
    ampy = @Entry();
    setproperty!(ampy, :text, "Y");
    ampz = @Entry();
    setproperty!(ampz, :text, "Z");

    grad= @Entry();
    setproperty!(grad, :text, "");

    g4[1,1] = volx;
    g4[1,2] = voly;
    g4[1,3] = volz;

    g5[1,1] = ampx;
    g5[1,2] = ampy;
    g5[1,3] = ampz;

    g2[2,2] = grad;

    g3 = @Grid();
    g8 = @Grid();
    g9 = @Grid();

    check_coo = @Button("EXECUTE");
    plot_check= @Button("EXECUTE");
    vol_pat = @Button("EXECUTE");
    increase= @Button("EXECUTE");
    overlap= @Button("EXECUTE");

    err_x = @Entry();
    setproperty!(err_x, :text, "");
    err_y = @Entry();
    setproperty!(err_y, :text, "");
    err_z = @Entry();
    setproperty!(err_z, :text, "");
    pix = @Entry();
    setproperty!(pix, :text, "");

    combopatch = @ComboBoxText();
    choicespatch = ["Volume patches (standard)", "Volume patches overlap", "Volume patches increase"];
    for cpatch in choicespatch
      push!(combopatch, cpatch);
    end

    combocheck = @ComboBoxText();
    choicescheck = ["Check test points", "Check test points (incl. plot)"];
    for ccheck in choicescheck
      push!(combocheck, ccheck);
    end

    g3[1,1] = combopatch;
    g3[1,2] = vol_pat;
    g3[1,2] = overlap;
    g3[1,2] = increase;

    g8[1,1] = err_x;
    g8[1,2] = err_y;
    g8[1,3] = err_z;
    g8[1,4] = pix;

    g9[1,1] = combocheck;
    g9[1,2] = check_coo;
    g9[1,2] = plot_check;

    g7= @Grid();
    g10= @Grid();
    g11= @Grid();

    combo2 = @ComboBoxText();
    choices2 = ["Regular scanner diameter", "Reduced scanner diameter", "Define new"];
    for c2 in choices2
      push!(combo2, c2);
    end

    scannerdiameter = @Entry();
    setproperty!(scannerdiameter, :text, "Diameter");

    scannername = @Entry();
    setproperty!(scannername, :text, "Name");

    combo3 = @ComboBoxText();
    choices3 = ["Delta sample", "Mouse adapter", "Define new"];
    for c3 in choices3
      push!(combo3, c3);
    end

    combo4 = @ComboBoxText();
    choices4 = ["Circle", "Rectangle","Hexagon","Triangle"];
    for c4 in choices4
      push!(combo4, c4);
    end

    geowidth = @Entry();
    setproperty!(geowidth, :text, "Width");

    geoheight = @Entry();
    setproperty!(geoheight, :text, "Heigth");

    geoname = @Entry();
    setproperty!(geoname, :text, "Name");

    combo1 = @ComboBoxText();
    choices = ["Manual test points", "Patch test points"];
    for c in choices
      push!(combo1, c);
    end

    g7[1,1] = combo2;
    g7[1,2] = scannerdiameter;
    g7[1,3] = scannername;
    g10[1,4] = combo3;
    g10[1,5] = combo4;
    g10[1,6] = geowidth;
    g10[1,7] = geoheight;
    g10[1,8] = geoname;
    g11[1,9] = combo1;

    g13= @Grid();

    warning1 = @Button("SOME POINTS EXCEEDED THE ALLOWED RANGE!");
    warning2 = @Button("Please adjust invalid points!");
    warning3 = @Button("Results have been saved to .txt-file!");
    warning4 = @Button("RETURN");
    warning5 = @Button("UPLOAD CORRECTED DATA POINTS")

    g13[1,1] = warning1;
    g13[1,2] = warning2;
    g13[1,3] = warning3;
    g13[1,4] = warning4;
    g13[1,5] = warning5;

    g14= @Grid();

    safe1 = @Button("ALL POINTS ARE INSIDE THE ALLOWED RANGE!");
    safe2 = @Button("Results have been saved to .txt-file!");
    safe3 = @Button("OK");

    g14[1,1] = safe1;
    g14[1,2] = safe2;
    g14[1,3] = safe3;

    g=[g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14];
    f=[f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14];

    for i=1:13
        setproperty!(g[i], :column_homogeneous, true);
        setproperty!(g[i], :column_spacing, 20);
        push!(f[i],g[i]);
    end

    push!(hbox6,f6,f12);
    push!(hbox,hbox6);
    push!(hbox2,f4,f5,f2);
    push!(hbox,hbox2);
    push!(hbox4,f3,f8,f9);
    push!(hbox,hbox4);
    push!(hbox5,f7,f10,f11);
    push!(hbox3,hbox5,hbox);
    push!(hbox7,hbox3,f13,f14);
    push!(win,hbox7);

    showall(win)

    data_array=[];
    array=Array(Any,1);
    idex=[-1];
    scanneruse=Array(Any,1);
    geom=Array(Any,1);

    const clearance=2.5u"mm";
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

    immutable wanted_volume
         x_dim::typeof(1.0u"mm")
         y_dim::typeof(1.0u"mm")
         z_dim::typeof(1.0u"mm")
    end

    immutable amplitude
         amp_x::typeof(1.0u"mT")
         amp_y::typeof(1.0u"mT")
         amp_z::typeof(1.0u"mT")
    end

    immutable gradient_scan
         strength::typeof(1.0u"T/m")
    end

    include("create_data.jl");
    include("convert2unit.jl");
    include("check_coor_Gui.jl");
    include("volume_patches_Gui.jl");
    include("plot_patches.jl");


    visible(scannerdiameter,false);
    visible(scannername,false);
    visible(geoheight,false);
    visible(geowidth,false);
    visible(geoname,false);
    visible(combo4,false);
    visible(vol_pat,false);
    visible(overlap,false);
    visible(increase,false);
    visible(check_coo,false);
    visible(plot_check,false);
    visible(hbox,false);
    visible(f3,false);
    visible(f8,false);
    visible(f9,false);
    visible(f13,false);
    visible(f14,false);

    id_combobox1 = signal_connect(combo1, "changed") do widget
        # this works
        index = getproperty(widget,:active,Int32);

        if index==0
           visible(hbox2,false);
           visible(hbox6,true);
           visible(hbox,true);
           visible(f8,false);
           visible(f3,false);
        else
          visible(hbox2,true);
          visible(hbox6,false);
          visible(hbox,true);
          visible(f3,true);
        end
    end

    id_comboboxpatch = signal_connect(combopatch, "changed") do widget
        # this works
        index = getproperty(widget,:active,Int32);
        visible(f9,false);
        if index==0
           visible(vol_pat,true);
           visible(overlap,false);
           visible(increase,false);
        elseif index ==1
          visible(vol_pat,false);
          visible(overlap,true);
          visible(increase,false);
        elseif index ==2
          visible(vol_pat,false);
          visible(overlap,false);
          visible(increase,true);
        end
    end

    id_comboboxcheck = signal_connect(combocheck, "changed") do widget
        # this works
        index = getproperty(widget,:active,Int32);

        if index==0
           visible(check_coo,true);
           visible(plot_check,false);
        elseif index ==1
          visible(check_coo,false);
          visible(plot_check,true);
        end
    end

    id = signal_connect(next_button, "clicked") do widget
         x=parse(Float64,getproperty(coordsx,:text,String));
         y=parse(Float64,getproperty(coordsy,:text,String));
         z=parse(Float64,getproperty(coordsz,:text,String));
         kos=(x,y,z);
         push!(data_array,kos);
         setproperty!(coordsx, :text, "X");
         setproperty!(coordsy, :text, "Y");
         setproperty!(coordsz, :text, "Z");
    end

    id2 = signal_connect(coord_button, "clicked") do widget

          x=parse(Float64,getproperty(coordsx,:text,String));
          y=parse(Float64,getproperty(coordsy,:text,String));
          z=parse(Float64,getproperty(coordsz,:text,String));
          kos=(x,y,z);
          push!(data_array,kos);
          setproperty!(coordsx, :text, "------");
          setproperty!(coordsy, :text, "------");
          setproperty!(coordsz, :text, "------");
          array[1]=convert2unit(data_array,u"mm");
          display(array[1]);
          visible(f9,true);
          return array
    end

    id3 = signal_connect(clear_button, "clicked") do widget
          array=[];
          setproperty!(coordsx, :text, "cleared");
          setproperty!(coordsy, :text, "cleared");
          setproperty!(coordsz, :text, "cleared");
          display(array);
          display("Test points cleared!");
          visible(f9,false);
    end

    id_combobox2 = signal_connect(combo2, "changed") do widget
        # this works
        index = getproperty(widget,:active,Int32);

        if index==2
           visible(scannerdiameter,true);
           visible(scannername,true);
        elseif index==1
           visible(scannerdiameter,false);
           visible(scannername,false);
           scanneruse[1]=scannergeo(100.0u"mm","reduced scanner diameter");
        elseif index==0
           visible(scannerdiameter,false);
           visible(scannername,false);
           scanneruse[1]=scannergeo(120.0u"mm","regular scanner diameter");
        end
        return scanneruse
    end

    id_combobox3 = signal_connect(combo3, "changed") do widget
        # this works
        index1 = getproperty(widget,:active,Int32);

        if index1==2
           visible(combo4,true);
        elseif index1==1
           visible(combo4,false);
           visible(geowidth,false);
           visible(geoheight,false);
           visible(geoname,false);
           geom[1]=circle(50.0u"mm","Mouse adapter");
           idex[1]=-1;
        elseif index1==0
           visible(combo4,false);
           visible(geowidth,false);
           visible(geoheight,false);
           visible(geoname,false);
           geom[1]=circle(10.0u"mm","Delta sample");
           idex[1]=-1;
        end
        return geom,idex
    end

    id_combobox4 = signal_connect(combo4, "changed") do widget
        # this works
        dex = getproperty(widget,:active,Int32);

        if dex==0
           visible(geowidth,true);
           setproperty!(geowidth,:text,"Diameter");
           visible(geoheight,false);
           visible(geoname,true);
        elseif dex==1
           visible(geowidth,true);
           setproperty!(geowidth,:text,"Width");
           visible(geoheight,true);
           visible(geoname,true);
        elseif dex==2
          visible(geowidth,true);
          setproperty!(geowidth,:text,"Width");
          visible(geoheight,true);
          visible(geoname,true);
        elseif dex==3
          visible(geowidth,true);
          setproperty!(geowidth,:text,"Width");
          visible(geoheight,true);
          visible(geoname,true);
        end
        idex[1]=dex;
        return idex;
    end

    id6 = signal_connect(vol_pat, "clicked") do widget
          close("all");

          vol1=parse(Float64,getproperty(volx,:text,String));
          vol2=parse(Float64,getproperty(voly,:text,String));
          vol3=parse(Float64,getproperty(volz,:text,String));
          volum=wanted_volume(vol1*1.0u"mm",vol2*1.0u"mm",vol3*1.0u"mm");

          amp1=parse(Float64,getproperty(ampx,:text,String));
          amp2=parse(Float64,getproperty(ampy,:text,String));
          amp3=parse(Float64,getproperty(ampz,:text,String));
          amplitu=amplitude(amp1*1.0u"mT",amp2*1.0u"mT",amp3*1.0u"mT");

          gradient=parse(Float64,getproperty(grad,:text,String));
          gradi=gradient_scan(gradient*1.0u"T/m")

          storage,pixel,diff_x,diff_y,diff_z=volume_patches(volum, gradi, amplitu)
          setproperty!(err_x, :text, "Not covered x-dim: $diff_x");
          setproperty!(err_y, :text, "Not covered y-dim: $diff_y");
          setproperty!(err_z, :text, "Not covered z-dim: $diff_z");
          setproperty!(pix, :text, "Number of patches: $pixel");
          visible(f8,true);
          visible(f9,true);
          plot_patches(storage,volum, gradi, amplitu)
          da_array=convert2unit(storage,u"mm")
          array[1]=da_array;
          return array,da_array

    end

    id7 = signal_connect(overlap, "clicked") do widget
          close("all");

          vol1=parse(Float64,getproperty(volx,:text,String));
          vol2=parse(Float64,getproperty(voly,:text,String));
          vol3=parse(Float64,getproperty(volz,:text,String));
          volum=wanted_volume(vol1*1.0u"mm",vol2*1.0u"mm",vol3*1.0u"mm");

          amp1=parse(Float64,getproperty(ampx,:text,String));
          amp2=parse(Float64,getproperty(ampy,:text,String));
          amp3=parse(Float64,getproperty(ampz,:text,String));
          amplitu=amplitude(amp1*1.0u"mT",amp2*1.0u"mT",amp3*1.0u"mT");

          gradient=parse(Float64,getproperty(grad,:text,String));
          gradi=gradient_scan(gradient*1.0u"T/m")

          storage,pixel,diff_x,diff_y,diff_z=volume_patches(volum, gradi, amplitu,overlap=true)
          setproperty!(err_x, :text, "Overlap in x-dim: $diff_x");
          setproperty!(err_y, :text, "Overlap in y-dim: $diff_y");
          setproperty!(err_z, :text, "Overlap in z-dim: $diff_z");
          setproperty!(pix, :text, "Number of patches: $pixel");
          visible(f8,true);
          visible(f9,true);
          plot_patches(storage,volum, gradi, amplitu)
          da_array=convert2unit(storage,u"mm")
          array[1]=da_array;
          return array,da_array

    end

    id8 = signal_connect(increase, "clicked") do widget
          close("all");

          vol1=parse(Float64,getproperty(volx,:text,String));
          vol2=parse(Float64,getproperty(voly,:text,String));
          vol3=parse(Float64,getproperty(volz,:text,String));
          volum=wanted_volume(vol1*1.0u"mm",vol2*1.0u"mm",vol3*1.0u"mm");

          amp1=parse(Float64,getproperty(ampx,:text,String));
          amp2=parse(Float64,getproperty(ampy,:text,String));
          amp3=parse(Float64,getproperty(ampz,:text,String));
          amplitu=amplitude(amp1*1.0u"mT",amp2*1.0u"mT",amp3*1.0u"mT");

          gradient=parse(Float64,getproperty(grad,:text,String));
          gradi=gradient_scan(gradient*1.0u"T/m")

          storage,pixel,diff_x,diff_y,diff_z=volume_patches(volum, gradi, amplitu,increase=true)
          setproperty!(err_x, :text, "Volume x-dim: $diff_x");
          setproperty!(err_y, :text, "Volume y-dim: $diff_y");
          setproperty!(err_z, :text, "Volume z-dim: $diff_z");

          visible(f8,true);
          visible(f9,true);
          delta=0.01u"mm";

          volum2=wanted_volume(diff_x+delta,diff_y+delta,diff_z+delta);
          storage2,pixel2=volume_patches(volum2, gradi, amplitu,increase=false,overlap=false);
          setproperty!(pix, :text, "Number of patches: $pixel2");
          plot_patches(storage2,volum2, gradi, amplitu)
          da_array=convert2unit(storage2,u"mm")
          array[1]=da_array;
          return array,da_array

    end

    id4 = signal_connect(check_coo, "clicked") do widget

      if getproperty(scannerdiameter,:text,String)!="Diameter"
         scannerdia=(parse(Float64,getproperty(scannerdiameter,:text,String)))*1.0u"mm";
         scannerna=getproperty(scannerdiameter,:text,String);
         scan=scannergeo(scannerdia,scannerna);
         scanneruse[1]=scan;
      end

      if idex[1]!=-1;
      if idex[1]==0
         diam=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         na=getproperty(geoname,:text,String);
         geom[1]=circle(diam,na);
      elseif idex[1]==1
         wid=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         hei=(parse(Float64,getproperty(geoheight,:text,String)))*1.0u"mm"
         na=getproperty(geoname,:text,String);
         geom[1]=rectangle(wid,hei,na);
      elseif idex[1]==2
         wid=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         hei=(parse(Float64,getproperty(geoheight,:text,String)))*1.0u"mm"
         na=getproperty(geoname,:text,String);
         geom[1]=hexagon(wid,hei,na);
      elseif idex[1]==3
         wid=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         hei=(parse(Float64,getproperty(geoheight,:text,String)))*1.0u"mm"
         na=getproperty(geoname,:text,String);
         geom[1]=triangle(wid,hei,na);
      end
      end
         result=check_coor(scanneruse[1],geom[1],array[1];plotresults=false);
         return result,geom[1]
    end

    id5 = signal_connect(plot_check, "clicked") do widget
      close("all");

      if getproperty(scannerdiameter,:text,String)!="Diameter"
         scannerdia=(parse(Float64,getproperty(scannerdiameter,:text,String)))*1.0u"mm";
         scannerna=getproperty(scannerdiameter,:text,String);
         scan=scannergeo(scannerdia,scannerna);
         scanneruse[1]=scan;
      end

      if idex!=[]
      if idex[1]==0
         diam=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         na=getproperty(geoname,:text,String);
         geom[1]=circle(diam,na);
      elseif idex[1]==1
         wid=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         hei=(parse(Float64,getproperty(geoheight,:text,String)))*1.0u"mm"
         na=getproperty(geoname,:text,String);
         geom[1]=rectangle(wid,hei,na);
      elseif idex[1]==2
         wid=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         hei=(parse(Float64,getproperty(geoheight,:text,String)))*1.0u"mm"
         na=getproperty(geoname,:text,String);
         geom[1]=hexagon(wid,hei,na);
      elseif idex[1]==3
         wid=(parse(Float64,getproperty(geowidth,:text,String)))*1.0u"mm";
         hei=(parse(Float64,getproperty(geoheight,:text,String)))*1.0u"mm"
         na=getproperty(geoname,:text,String);
         geom[1]=triangle(wid,hei,na);
      end
      end
         result=check_coor(scanneruse[1],geom[1],array[1];plotresults=true);
         return result,geom[1]
   end

   id9 = signal_connect(warning4, "clicked") do widget
     close("all");
     visible(hbox3,true);
     visible(f13,false);
     visible(f14,false);
     visible(f8,false);
     visible(f9,false);
   end

   id11 = signal_connect(safe3, "clicked") do widget
     close("all");
     visible(hbox3,true);
     visible(f13,false);
     visible(f14,false);
   end

   id10 = signal_connect(warning5, "clicked") do widget
     close("all");
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

     if typeof(geom[1])==circle
        volume_xma=maximum(xcorrect);
        volume_xmi=minimum(xcorrect);
        volume_yma=maximum(ycorrect)+ustrip(geom[1].diameter)/2;
        volume_ymi=minimum(ycorrect)-ustrip(geom[1].diameter)/2;
        volume_zma=maximum(zcorrect)+ustrip(geom[1].diameter)/2;
        volume_zmi=minimum(zcorrect)-ustrip(geom[1].diameter)/2;

     else

       volume_xma=maximum(xcorrect);
       volume_xmi=minimum(xcorrect);
       volume_yma=maximum(ycorrect)+ustrip(geom[1].width)/2;
       volume_ymi=minimum(ycorrect)-ustrip(geom[1].width)/2;
       volume_zma=maximum(zcorrect)+ustrip(geom[1].height)/2;
       volume_zmi=minimum(zcorrect)-ustrip(geom[1].height)/2;
     end

     setproperty!(err_x, :text, "x-dim(min): $volume_xmi mm, x-dim(max): $volume_xma mm");
     setproperty!(err_y, :text, "y-dim(min): $volume_ymi mm, y-dim(max): $volume_yma mm");
     setproperty!(err_z, :text, "z-dim(min): $volume_zmi mm, z-dim(max): $volume_zma mm");

     array[1]=convert2unit(kosc,u"mm");
     visible(hbox3,true);
     visible(f13,false);
     visible(f14,false);
     return array,kosc
   end
