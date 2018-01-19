task :fill_news_logs, [:file_name] => :environment do |t, args|
  f = File.open args[:file_name]
  while (str = f.gets)
    matches = /^([\d\.]+) .* .* \[(.*)\] \"(.*)\" \d+ \d+ \".*\" \"(.*)\"/.match(str)
    if matches
      matches3 = /^.*\/submit_news.*viewer_id=(\d+).*/.match matches[3]
      if matches3
        dt = DateTime.strptime(matches[2], "%d/%b/%Y:%H:%M:%S %z")
        p matches[1] + ' ' + dt.to_s + ' ' + matches3[1] + ' ' + matches[4]
        puts str
        nr = NewsRequest.new(
          vk_id: matches3[1].to_i,
          browser: matches[4],
          ip_address: matches[1],
        )
        nr.created_at = dt
        nr.save(touch: false)
      end
    end
  end
end