class CertificateController < ApplicationController
  def index
  end

  def show
  end

  def new
    @certificate = Certificate.new
  end

  def create
    certificate = Certificate.new
  end

  def destroy
  end

end
