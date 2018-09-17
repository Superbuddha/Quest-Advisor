require_relative("../db/sql_runner")

class Visit

  attr_reader :id
  attr_accessor :user_id, :location_id, :review

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @user_id = options['user_id'].to_i
    @location_id = options['location_id'].to_i
    @review = options['review']
  end

  def save()
    sql = "INSERT INTO visits
    (
      user_id,
      location_id,
      review
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@user_id, @location_id, @review]
    visit = SqlRunner.run( sql,values ).first
    @id = visit['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM visits"
    visit_data = SqlRunner.run(sql)
    return visits.map_items (visit_data)
  end

  def self.delete_all()
    sql = "DELETE FROM visits"
    SqlRunner.run(sql)
  end

  def location()
    sql = "SELECT * FROM locations WHERE id =$1"
    values [@location_id]
    location = SqlRunner.run(sql, values).first
    return Location.new(location)
  end

  def user()
    sql = "SELECT * FROM users WHERE id = $1"
    values [user_id]
    user = SqlRunner. run(sql, values).first
    return User.new(user)
  end

  def self.map_items(visit_data)
    result = visit_data.map {|visit| Visit.new ( visit )}
    return result
  end
end
