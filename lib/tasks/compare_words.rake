task compare_words: :environment do
  communities = Community.where(screen_name: ['spida_net', 'vichnet']).all
  user_vk_ids = communities.collect do |community|
    community.posts.collect do |post|
      post.post_comments.collect {|comment| comment.user_vk_id}
    end
  end
  user_vk_ids.flatten!.sort!.uniq!
  user_words = {}
  user_vk_ids.each do |user_vk_id|
    user = Member.find_by_vk_id user_vk_id
    if user
      words = user.post_comments.all.collect{|comment| comment.raw['text'].gsub(/\[.+\]/, '').scan(/[А-Яа-я]+/)}.flatten.collect{|word| word.downcase}.group_by(&:itself).transform_values(&:count).map{|key, value| [key, value]}.sort{|a, b| a[1] <=> b[1]}
      count = words.inject(0){|sum, word| sum + word[1] }
      user_words[user_vk_id] = Hash[words.collect{|word| [word[0], word[1]*1.0/count]}]
    end
  end
  decls = {}
  words_m = user_words[246924206].collect{|word, freq| word}
  user_words.each do |id, words|
    if id != 246924206
      decl = 0.0
      # compare words
      words_both = words_m + words.collect{|word, freq| word}
      words_both.each do |word|
        freq1 = user_words[246924206][word] || 0.0
        freq2 = words[word] || 0.0
        decl += (freq1 - freq2)**2
      end
      decls[id] = decl
    end
  end
  decls_array = decls.collect{|a,b| [a,b]}.sort{|a,b| b[1]<=>a[1]}
  fjson = File.open(Rails.root.join('applog', 'compare_words.json'), 'w')
  fyaml = File.open(Rails.root.join('applog', 'compare_words.yaml'), 'w')
  fjson.puts decls_array.to_json
  fyaml.puts decls_array.to_yaml

end