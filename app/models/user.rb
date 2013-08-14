class User < ActiveRecord::Base
  attr_accessible :login, :money, :uid, :access_token, :avathar
  attr_accessor :password
  before_create :hash_password
  has_many :games
  has_many :challenges, class_name: "Game", foreign_key: :co_player_id
  has_many :pending_games, class_name: "Game", foreign_key: :last_player_id

  def authenticate?(password)
    Digest::SHA1.hexdigest("#{password}&&#{password_salt}") == password_hash
  end

  def bets
    games.find_all_by_winner_id(nil)
  end

  def accepted_challenges
    challenges.find_all_by_winner_id(nil)
  end

  def can_play(game)
    [game.user, game.co_player].include?(self) && game.last_player != self
  end

  def opponent_in(game)
    self == game.user ? game.co_player : game.user
  end

  def gain_prize(game)
    partner = opponent_in(game)
    self.money = self.money.to_i + game.bet.to_i
    self.save
    partner.money = partner.money.to_i - game.bet.to_i
    partner.save
  end

  def logged_in?
    !self.new_record?
  end

  protected
    def hash_password
      self.remember_token = SecureRandom.base64
      self.password_salt = Digest::SHA1.hexdigest("#{login}&#{Time.now}")
      self.password_hash = Digest::SHA1.hexdigest("#{password}&&#{password_salt}")
    end
end
