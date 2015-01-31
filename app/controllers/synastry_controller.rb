class SynastryController < ApplicationController
  def new
    @synastry=Synastry.new
    @birthplace=Birthplace.all
    @birthplace2=Birthplace.all
  end

  def create
    @birth=Birth.new(synastry_params)
    @birthplace=Birthplace.find(synastry_params[:city])
    @birth=adjust_time(@birth,@birthplace)
    @out=eph(@birth,@birthplace)
    @long=long(@out)
    @speed=speed(@out)
    @house=house(@out)
    @hc=hc(@out)
    @birth2=Birth.new(:date=>parse_datetime_params(synastry2_params,:date2),:name=>synastry2_params[:name2])
    @birthplace2=Birthplace.find(synastry2_params[:city2])
    @birth2=adjust_time(@birth2,@birthplace2)
    @out2=eph(@birth2,@birthplace2)
    @long2=long(@out2)
    @hc2=hc(@out2)
    name=Digest::SHA1.hexdigest(Time.now.to_s)
    @image="#{name}.jpg"
    create_image(@image,@long,@house,@hc,"synastry",@long2,@hc2)
  end

  def synastry_params
    params.require(:synastry).permit(:name,:date,:city)
  end

  def synastry2_params
    params.require(:synastry).permit(:name2,:date2,:city2)
  end
end
