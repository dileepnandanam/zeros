class Block < ActiveRecord::Base
  attr_accessible :game_id, :e, :n, :owner_id, :s, :w, :x, :y
  belongs_to :game
  belongs_to :owner, class_name: 'User'
  def mark(element)
    if element.class.name == 'User'
      self.owner_id = element.id
    else
      self.n = true if element == :up
      self.e = true if element == :right
      self.w = true if element == :left
      self.s = true if element == :down
    end
    self.save
  end

  def left
    w || left_block && left_block.e
  end

  def right
    e || right_block && right_block.w
  end

  def up
    n || up_block && up_block.s
  end

  def down
    s || down_block && down_block.n
  end

  def left_block
    x, y = my_pos
    return nil if y == 0
    @game.block_at x, (y - 1)
  end

  def right_block
    x, y = my_pos
    return nil if y == @game.width - 1
    @game.block_at x, (y + 1)
  end

  def up_block
    x, y = my_pos
    return nil if x == 0
    @game.block_at (x - 1), y
  end

  def down_block
    x, y = my_pos
    return nil if x == @game.height - 1
    @game.block_at (x + 1), y
  end

  def my_pos
    @game ||= game
    @blocks ||= @game.blocks
    index = @blocks.index self
    [(index / game.width), (index % game.width)]
  end

  def mark_if_available(user)
    return false if owner_id
    boundaries = [:left, :right, :up, :down]
    marks = [left, right, up, down]
    if marks.compact.count == 3
      markable =  boundaries[marks.index(nil)]
      send :mark, markable
      send :mark, user
      return send "#{markable}_block".to_sym
    elsif marks.compact.count == 4
      send :mark, user
      return false
    end
  end

  def claim(user)
    return false if owner
    boundaries = [:left, :right, :up, :down]
    marks = [left, right, up, down]
    if marks.compact.count == 4 
      mark(user)
      return true
    end
  end

  def connected_blocks
    [left_block, right_block, up_block, down_block].compact
  end
end
