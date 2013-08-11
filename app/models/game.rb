class Game < ActiveRecord::Base
  attr_accessible :co_player_id, :height, :last_player_id, :user_id, :width, :bet, :co_player_score, :user_score, :finished
  belongs_to :user
  belongs_to :co_player, class_name: 'User'
  belongs_to :winner, class_name: 'User'
  belongs_to :last_player, class_name: 'User'
  has_many :blocks, :order => 'id ASC'
  after_create :create_blocks

  def begun?
    user && co_player
  end

  def block_at(i, j=nil)
    @blocks ||= blocks
    if j
      return @blocks[i * width + j] if i < height && j < width
    else
      return @blocks[(i * width)..(i * width + width - 1)]
    end
  end

  def mark_available(user, block)
    @marked = []
    @checklist = [block] + block.connected_blocks
    while @checklist.count > 0 do
      b = @checklist.pop
      next_block = b.mark_if_available(user)
      if next_block
        @marked.push b
        @checklist.push next_block if next_block.class.name == "Block"
      end
    end
    return @marked
  end

  def checklist(block, boundary)
    ([:left, :right].include?(boundary) ? [block.left_block, block.right_block] : [block.up_block, block.down_block] ).compact
  end

  def score(u, points)
    if user == u
      self.user_score = user_score.to_i + points
    else
      self.co_player_score = co_player_score.to_i + points
    end
    self.save
  end

  def who_won
    return winner if winner
    if (width * height) == co_player_score.to_i + user_score.to_i
      if co_player_score != user_score
        winner = co_player_score.to_i > user_score.to_i ? co_player : user
        self.winner_id = winner.id
        winner.gain_prize(self)
      end
      self.finished = true
      self.save
      return winner
    end
  end

  protected
    def create_blocks
      (width * height).times do
        Block.create game_id: id
      end
    end
end
