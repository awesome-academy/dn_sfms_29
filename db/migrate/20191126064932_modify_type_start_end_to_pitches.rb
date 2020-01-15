class ModifyTypeStartEndToPitches < ActiveRecord::Migration[6.0]
  def change
    change_column :pitches, :start_time, :time
    change_column :pitches, :end_time, :time
  end
end
