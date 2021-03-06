class V3::CardsController < V3::BaseController
  before_action :set_card, only: [:show, :update, :destroy]

  # GET /v3/cards
  def index
    @cards = Card.all
    if stale?(@cards)
      render json: @cards
    end
  end

  # GET /v3/cards/1
  def show
    if stale?(@card)
      render json: @card
    end
  end

  # POST /v3/cards
  def create
    @card = Card.new(card_params)

    if @card.save
      render json: @card,
             status: :created,
             location: v3_card_url(@card)
    else
      respond_with_validation_error @card
    end
  end

  # PATCH/PUT /v3/cards/1
  def update
    if @card.update(card_params)
      render json: @card
    else
      respond_with_validation_error @card
    end
  end

  # DELETE /v3/cards/1
  def destroy
    @card.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_card
    @card = Card.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def card_params
    params
      .require(:card)
      .permit(:list_id, :creator_id, :assignee_id, :title, :description, :archived)
  end
end
