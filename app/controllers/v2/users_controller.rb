class V2::UsersController < V2::BaseController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /v2/users
  def index
    page_number = params.dig(:page, :number) || 1
    page_size = params.dig(:page, :size) || User.default_per_page
    @users = User.page(page_number).per(page_size)
    if stale?(@users)
      render json: @users, include: [], meta: pagination_meta(@users)
    end
  end

  # GET /v2/users/1
  def show
    if stale?(@user)
      render json: @user, include: [:active_boards]
    end
  end

  # POST /v2/users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user,
             status: :created,
             location: v2_user_url(@user)
    else
      respond_with_validation_error @user
    end
  end

  # PATCH/PUT /v2/users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      respond_with_validation_error @user
    end
  end

  # DELETE /v2/users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params
      .require(:user)
      .permit(:email, :password, :password_confirmation, :admin)
  end
end
