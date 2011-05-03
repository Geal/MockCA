class CertificateController < ApplicationController
  def index
  end

  def show
    @certificate = Certificate.find(params[:id])
  end

  def new
    @certificate = Certificate.new
  end

  def new_root
    @certificate = Certificate.new
  end

  def create
    @certificate = Certificate.new(params[:certificate])

    respond_to do |format|
      if @certificate.save
        format.html { redirect_to(@certificate, :notice => 'Certificate was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def destroy
  end

end
