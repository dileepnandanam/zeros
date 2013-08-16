class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def dashboard
    @sample_games = Game.find :all, limit: 5, conditions: ['co_player_id is null and user_id <> ?', current_user.id]
    @games = current_user.accepted_challenges + current_user.games 
    @current_games = @games.find_all{|g| g.co_player_id.present? && !g.finished?}
    @my_challenges = @games.find_all{|g| g.co_player_id.blank?}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {current_games: @current_games, my_challenges: @my_challenges} }
    end
  end

  def index
    @sample_games = Game.find :all, limit: 5, conditions:{ co_player_id: nil }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sample_games }
    end
  end

  def search
    @games = Game.find(
      :all,
      conditions: ['co_player_id is null and user_id <> ? and bet between ? and ?', current_user.id, params[:from].to_i, params[:to].to_i]
    )
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  def join
    @game = Game.find(params[:id])
    respond_to do |format|
      if @game.join(current_user)
        format.html { redirect_to @game, notice: 'play.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { redirect_to games_dashboard_path, notice: 'play.' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    winner = @game.who_won
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: {money: current_user.money.to_i, lost: @game.winner && @game.winner != current_user, won: winner == current_user, my_round: @game.last_player != current_user, blocks:@game.blocks.map{|b| {id: b.id, owner: b.owner ? b.owner.login : nil , left: b.left, right: b.right, up: b.up, down: b.down}} }}
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])
    @game.user_id = current_user.id

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def play
    block = Block.find params[:block]
    boundary = params[:boundary].to_sym
    @game = block.game
    co_player = current_user == @game.user ? @game.co_player : @game.user
    respond_to do |format|
      if (current_user.can_play @game) && !(block.send boundary)
        @game.update_attribute :last_player_id, current_user.id
        @changed = []
        block.mark(boundary)
        got = ([block] + block.connected_blocks).find{|b| b.claim(current_user)}
        puts got.to_json
        if got
          @changed.push got
          @changed = [got] + @game.mark_available(current_user, got)
          @game.score(current_user,@changed.count)
          @changed += @changed[-1].connected_blocks
          @game.update_attribute :last_player_id, co_player.id
        end
        @changed = @changed.map{|b| {id: b.id, owner: b.owner ? b.owner.login : nil , left: b.left, right: b.right, up: b.up, down: b.down}}
        format.json { render json: @changed.to_json, status: :ok }
      else
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
