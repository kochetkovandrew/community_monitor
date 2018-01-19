class AddIpAddressToNewsRequests < ActiveRecord::Migration
  def change
    change_table :news_requests do |t|
      t.string :ip_address
    end
  end
end
