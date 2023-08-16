class AccountInformationsController < ApplicationController
  before_action :set_account_information, only: %i[ show edit update destroy ]
  before_action :authenticate_account!
  before_action :check_account_information_access, only: [:show, :edit, :update, :destroy]
  # GET /account_informations or /account_informations.json
  
    def check_account_information_access()
  	    @account_information = AccountInformation.find(params[:id])
        unless @account_information.account_id == current_account.id
	    redirect_to main_path
        end
    end

  def index
    @account_informations = AccountInformation.all
  end

  # GET /account_informations/1 or /account_informations/1.json
  def show
  end

  # GET /account_informations/new
  def new
  if current_account.account_information.present?
    redirect_to main_path, notice: "Account information already exists."
  else
    @account_information = AccountInformation.new
  end
  end

  # GET /account_informations/1/edit
  def edit
  end

  # POST /account_informations or /account_informations.json
  def create
    @account_information = AccountInformation.new(account_information_params)
   
    respond_to do |format|
      if @account_information.save
        format.html { redirect_to account_information_url(@account_information), notice: "Account information was successfully created." }
        format.json { render :show, status: :created, location: @account_information }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_informations/1 or /account_informations/1.json
  def update
    respond_to do |format|
      if @account_information.update(account_information_params)
        format.html { redirect_to account_information_url(@account_information), notice: "Account information was successfully updated." }
        format.json { render :show, status: :ok, location: @account_information }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_informations/1 or /account_informations/1.json
  def destroy
    @account_information.destroy

    respond_to do |format|
      format.html { redirect_to account_informations_url, notice: "Account information was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_information
      @account_information = AccountInformation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_information_params
      params.fetch(:account_information, {}).permit(:first_name, :last_name, :country, :county, :city, :address, :card_number_digest, :card_name, :card_date, :card_code_digest, :account_id, :profile_picture)
    end
end
