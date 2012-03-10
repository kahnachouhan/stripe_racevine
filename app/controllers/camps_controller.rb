class CampsController < ApplicationController
  
  before_filter :admin_required
  
# GET /camps
  # GET /camps.xml
  def index
    @camps = Camp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @camps }
    end
  end

  # GET /camps/1
  # GET /camps/1.xml
  def show
    @camp = Camp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @camp }
    end
  end

  # GET /camps/new
  # GET /camps/new.xml
  def new
    @camp = Camp.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @camp }
    end
  end

  # GET /camps/1/edit
  def edit
    @camp = Camp.find(params[:id])
  end

  # POST /camps
  # POST /camps.xml
  def create
    @camp = Camp.new
    @camp.save(:validate => false)
    begin
     response = Stripe::Plan.create( :amount => params[:camp][:cost].to_i * 100, :interval => 'month', :name => params[:camp][:name] , :currency => 'usd', :id => @camp.id )
     if @camp.update_attributes(params[:camp])
       redirect_to(@camp, :notice => 'Camp was successfully created.')
     else
       render :action => "edit"
     end
    rescue Exception => e
      @camp.destroy
      @camp = Camp.new(params[:camp])
      @camp.errors[:base] << "Exception #{e.class}: #{e.message}"
      render :action => "new"
    end
  end

  # PUT /camps/1
  # PUT /camps/1.xml
  def update
    @camp = Camp.find(params[:id])
    begin
     if @camp.valid?
      camp = Stripe::Plan.retrieve(@camp.id.to_s)
      camp.delete
      Stripe::Plan.create( :amount => params[:camp][:cost].to_i * 100, :interval => 'month', :name => params[:camp][:name] , :currency => 'usd', :id => @camp.id )
      if @camp.update_attributes(params[:camp])
        redirect_to(@camp, :notice => 'Camp was successfully updated.')
      else
        render :action => "edit"
      end
     end	
    rescue Exception => e
      @camp.errors[:base] << "Exception #{e.class}: #{e.message}"
      render :action => "edit"
    end
  end

  # DELETE /camps/1
  # DELETE /camps/1.xml
  def destroy
    @camp = Camp.find(params[:id])
    begin
      camp = Stripe::Plan.retrieve(@camp.id.to_s) 
      camp.delete
      if @camp.destroy
       redirect_to(camps_url, :notice => 'Camp was successfully destroyed.')
      else
       redirect_to(camps_url)
      end
    rescue Exception => e
      @camp.errors[:base] << "Exception #{e.class}: #{e.message}"
      redirect_to(camps_url)
    end
  end

end
