class CompositeController < ApplicationController
  def new
    @composite=Composite.new
    @birthplace=Birthplace.all
    @birthplace2=Birthplace.all
  end

  def create
    @pageintro=Page.where('name=?','introduction').first
    @pagehouse=Page.where('name=?','houses').first
    @pageasp=Page.where('name=?','aspects').first
    @birth=Birth.new(composite_params)
    @birthplace=Birthplace.find(composite_params[:city])
    @birth=adjust_time(@birth,@birthplace)
    out=eph(@birth,@birthplace)
    long=long(out)
    hc=hc(out)
    date2=DateTime.civil_from_format(:utc,composite2_params["date2(1i)"].to_i,composite2_params["date2(2i)"].to_i,composite2_params["date2(3i)"].to_i,composite2_params["date2(4i)"].to_i,composite2_params["date2(5i)"].to_i)
    @birth2=Birth.new(:date=>date2,:name=>composite2_params[:name2])
    @birthplace2=Birthplace.find(composite2_params[:city2])
    out2=eph(@birth2,@birthplace2)
    long2=long(out2)
    hc2=hc(out2)
    long3=[]
    hc3=[]
  #  hc3=getcompositecusps(hc,hc2)
    (0..14).each do |i|
      if long2[i].to_f<long[i].to_f
	long2[i]=long2[i].to_f+360.0
      end
      long3[i]=((long[i].to_f-long2[i].to_f)/2.0)+long2[i].to_f
      if long3[i]>360
	long3[i]=long3[i]-360
      end
    end
    (0..11).each do |i|
      if hc2[i].to_f<hc[i].to_f
	hc2[i]=hc2[i].to_f+360.0
      end
      hc3[i]=((hc[i].to_f-hc2[i].to_f)/2.0)+hc2[i].to_f
      if hc3[i]>360
	hc3[i]=hc3[i]-360
      end
    end
    @long=long
    @long2=long2
    @long3=long3
    @hc3=hc3
    houses=gethouses(long3,hc3)
    @houses=houses
    name=Digest::SHA1.hexdigest(Time.now.to_s)
    @image="#{name}.jpg"
    create_image(@image,long3,houses,hc3)
    name2=Digest::SHA2.hexdigest(Time.now.to_s)
    @image2="#{name2}.jpg"
    aspects=create_aspect_grid(@image2,long3,hc3)
    planetnames=["Sun","Moon","Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"]
    @planets=[]
    (0..9).each do |i|
      if long[i].to_f>360
 	long[i]=long[i]-380
      end
      if long2[i].to_f>360
	long2[i]=long2[i]-360
      end
      p=Planet.new
      p.name=planetnames[i]
      p.longitude=convert_longitude(long[i])
      p.longitude2=convert_longitude(long2[i])
      p.house=houses[i]
      p.longitude3=convert_longitude(long3[i])
      @planets.push(p)
    end
    @planethouses=[]
    (0..9).each do |i|
      ph=Planethouse.where("planetno=? AND houseno=?",i,@planets[i].house).first
      if ph!=nil
        @planethouses.push(ph)
      end
    end
    @aspecttexts=findaspecttext(long3)
  end

  def composite_params
    params.require(:composite).permit(:name,:date,:city)
  end

  def composite2_params
    params.require(:composite).permit(:name2,:date2,:city2)
  end
end
