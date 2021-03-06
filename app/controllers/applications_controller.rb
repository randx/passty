class ApplicationsController < ApplicationController
  before_filter :migrate_old_passwords
  before_action :set_application, only: [:show, :edit, :update, :destroy]

  # GET /applications
  # GET /applications.json
  def index
    @applications = current_user.applications
    @applications = @applications.search(params[:search]) if params[:search].present?

    @sort = params[:sort]

    @applications = case @sort
                    when 'newest'
                      @applications.reorder('applications.created_at DESC')
                    when 'oldest'
                      @applications.reorder('applications.created_at ASC')
                    else
                      @applications.reorder('applications.title ASC')
                    end

    @applications = @applications.page(params[:page] || 0).per(40)
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @passwords = @application.passwords
  end

  # GET /applications/new
  def new
    @application = current_user.applications.new
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = current_user.applications.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to @application, notice: 'Application was successfully created.' }
        format.json { render action: 'show', status: :created, location: @application }
      else
        format.html { render action: 'new' }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to @application, notice: 'Application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_application
    @application = current_user.applications.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def application_params
    params.require(:application).permit(:title, :url, :description)
  end
end
